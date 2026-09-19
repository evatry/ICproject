/* ============================================================================
 *  apb_test.c - APB 外设（LED / TIMER / UART）走总线实测程序
 *
 *  编译：./build_apb_test.sh   （配 apb_startup.S + arm926.ld）
 *  地址映射（全部挂在 M_AHB_3 = 0x8000_0000 / 16M 外设窗口，经 AHB->APB 桥）
 *    0x8000_0000  APB LED
 *    0x8000_1000  APB TIMER
 *    0x8000_2000  APB UART
 *
 *  测试项：LED 读写 / TIMER 寄存器 / 单次 / 预分频 / 周期+中断 /
 *          UART 发送 / 环回收发 / 除数锁存 / 接收中断
 *  跑到最后把 0xEE 写进 LED，testbench 看到就 $finish。
 *
 *  打印全部用 ASCII，避免仿真日志里出现编码问题。
 * ==========================================================================*/

#define REG32(a) (*(volatile unsigned int *)(a))

/* ---------------- LED ---------------- */
#define LED_BASE   0x80000000u
#define LED_REG    (LED_BASE + 0x00u)

/* ---------------- TIMER ---------------- */
#define TIMER_BASE 0x80001000u
#define T_LOAD     (TIMER_BASE + 0x00u)
#define T_VALUE    (TIMER_BASE + 0x04u)
#define T_CTRL     (TIMER_BASE + 0x08u)
#define T_INTCLR   (TIMER_BASE + 0x0Cu)
#define T_RIS      (TIMER_BASE + 0x10u)
#define T_MIS      (TIMER_BASE + 0x14u)

#define T_CTRL_EN      (1u << 0)
#define T_CTRL_PERIOD  (1u << 1)
#define T_CTRL_IE      (1u << 2)
#define T_CTRL_PSC(s)  (((unsigned)(s) & 0xFFu) << 8)

/* ---------------- UART ---------------- */
#define UART_BASE  0x80002000u
#define U_RBR      (UART_BASE + 0x00u)
#define U_THR      (UART_BASE + 0x00u)
#define U_DLL      (UART_BASE + 0x00u)
#define U_IER      (UART_BASE + 0x04u)
#define U_DLM      (UART_BASE + 0x04u)
#define U_IIR      (UART_BASE + 0x08u)
#define U_FCR      (UART_BASE + 0x08u)
#define U_LCR      (UART_BASE + 0x0Cu)
#define U_LSR      (UART_BASE + 0x14u)

#define LSR_DR     (1u << 0)
#define LSR_THRE   (1u << 5)
#define LSR_TEMT   (1u << 6)

/* ============================ 小工具 ============================ */

void *memcpy(void *dst, const void *src, unsigned n)
{
    unsigned char *d = (unsigned char *)dst;
    const unsigned char *s = (const unsigned char *)src;
    while (n--) *d++ = *s++;
    return dst;
}

void *memset(void *dst, int c, unsigned n)
{
    unsigned char *d = (unsigned char *)dst;
    while (n--) *d++ = (unsigned char)c;
    return dst;
}

static void uart_init(void)
{
    REG32(U_IER) = 0x00;             /* UART 中断先关掉，用轮询 */
    REG32(U_LCR) = 0x80;             /* DLAB=1 */
    /* 仿真里用 divisor=1 -> 50MHz/(16*1) = 3.125Mbaud，让文本尽快打完；
       真实板子上改成 27 -> 115740 baud (约 115200)。 */
    REG32(U_DLL) = 1;
    REG32(U_DLM) = 0;
    REG32(U_LCR) = 0x03;             /* 8 数据位 / 1 停止位 / 无校验 */
    REG32(U_FCR) = 0x01;
}

static void uart_putc(char c)
{
    while (!(REG32(U_LSR) & LSR_THRE)) ;
    REG32(U_THR) = (unsigned int)(unsigned char)c;
}

static void uart_puts(const char *s)
{
    while (*s) uart_putc(*s++);
}

static void uart_puthex(unsigned v)
{
    const char *h = "0123456789ABCDEF";
    int i;
    uart_puts("0x");
    for (i = 28; i >= 0; i -= 4) uart_putc(h[(v >> i) & 0xFu]);
}

static void uart_putdec(unsigned v)
{
    char buf[12];
    int i = 0;
    if (v == 0) { uart_putc('0'); return; }
    while (v && i < 11) { buf[i++] = (char)('0' + (v % 10u)); v /= 10u; }
    while (i--) uart_putc(buf[i]);
}

/* ============================ 全局 ============================ */

volatile unsigned g_fails = 0;
volatile unsigned g_timer_irq = 0;
volatile unsigned g_uart_irq = 0;
volatile unsigned g_uart_last = 0xFFFFFFFFu;

static void check(const char *name, int ok, unsigned got)
{
    if (ok) {
        uart_puts("  [PASS] ");
        uart_puts(name);
        uart_puts("\r\n");
    } else {
        uart_puts("  [FAIL] ");
        uart_puts(name);
        uart_puts("   got=");
        uart_puthex(got);
        uart_puts("\r\n");
        g_fails++;
    }
}

/* ============================ IRQ ============================ */

void irq_dispatch(void)
{
    unsigned handled = 0u;

    if (REG32(T_RIS) & 1u) {
        REG32(T_INTCLR) = 1u;
        g_timer_irq++;
        handled = 1u;
    }

    if (!handled) {
        /* IIR[3:1] = 0b010 表示"接收数据可用" */
        if ((REG32(U_IIR) & 0x0Fu) == 0x04u) {
            g_uart_last = REG32(U_RBR) & 0xFFu;
            g_uart_irq++;
        }
    }
}

/* 环回一共就 1 个字节的 RBR，测试里打印的字符也会被自己收回来，
   所以读串口之前先等发送空闲、再把残留字节和错误标志排掉。 */
static void uart_rx_drain(void)
{
    while (!(REG32(U_LSR) & LSR_TEMT)) ;
    while (REG32(U_LSR) & LSR_DR) (void)REG32(U_RBR);
    (void)REG32(U_LSR);                    /* 读 LSR 清 OE/PE/FE */
}

/* ============================ main ============================ */

static unsigned wait_underflow(void)
{
    unsigned n = 0;
    while (!(REG32(T_RIS) & 1u)) n++;
    return n;
}

int main(void)
{
    unsigned v, i, ok;

    uart_init();
    uart_puts("\r\n=========================================\r\n");
    uart_puts(" ARM926EJ-S SoC : APB LED/TIMER/UART TEST\r\n");
    uart_puts("=========================================\r\n");

    /* ---------------- 1. LED ---------------- */
    uart_puts("\r\n[1] APB LED\r\n");

    REG32(LED_REG) = 0xA5u;
    v = REG32(LED_REG) & 0xFFu;
    check("LED write 0xA5 / read back", v == 0xA5u, v);

    REG32(LED_REG) = 0x5Au;
    v = REG32(LED_REG) & 0xFFu;
    check("LED write 0x5A / read back", v == 0x5Au, v);

    /* ---------------- 2. TIMER 寄存器 ---------------- */
    uart_puts("\r\n[2] APB TIMER registers\r\n");

    REG32(T_CTRL)   = 0u;
    REG32(T_INTCLR) = 1u;
    REG32(T_LOAD)   = 100u;

    v = REG32(T_LOAD);
    check("LOAD read back = 100", v == 100u, v);

    v = REG32(T_VALUE);
    check("write LOAD while stopped preloads VALUE", v == 100u, v);

    v = REG32(T_RIS) & 1u;
    check("RIS cleared by INTCLR", v == 0u, v);

    /* ---------------- 3. TIMER 单次模式 ---------------- */
    uart_puts("\r\n[3] APB TIMER one-shot mode\r\n");

    REG32(T_LOAD) = 100u;
    REG32(T_CTRL) = T_CTRL_EN;          /* EN=1, 单次, 无中断 */
    (void)wait_underflow();

    v = REG32(T_RIS) & 1u;
    check("RIS set when counter hits 0", v == 1u, v);

    v = REG32(T_CTRL) & 1u;
    check("EN auto-cleared in one-shot mode", v == 0u, v);

    REG32(T_INTCLR) = 1u;
    v = REG32(T_RIS) & 1u;
    check("INTCLR clears RIS", v == 0u, v);

    /* ---------------- 4. TIMER 预分频 ---------------- */
    uart_puts("\r\n[4] APB TIMER prescaler\r\n");

    {
        unsigned n0, n9;

        REG32(T_CTRL)   = 0u;
        REG32(T_INTCLR) = 1u;
        REG32(T_LOAD)   = 1000u;
        REG32(T_CTRL)   = T_CTRL_EN;                    /* PRESCALE=0：每拍减 1 */
        n0 = wait_underflow();

        REG32(T_CTRL)   = 0u;
        REG32(T_INTCLR) = 1u;
        REG32(T_LOAD)   = 1000u;
        REG32(T_CTRL)   = T_CTRL_PSC(9) | T_CTRL_EN;    /* PRESCALE=9：10 拍减 1 */
        n9 = wait_underflow();

        check("prescaler makes counting slower (n9 > 5*n0)", n9 > (n0 * 5u), n9);
    }
    REG32(T_CTRL)   = 0u;
    REG32(T_INTCLR) = 1u;

    /* ---------------- 5. TIMER 周期模式 + 中断 ---------------- */
    uart_puts("\r\n[5] APB TIMER periodic mode + IRQ\r\n");

    REG32(LED_REG) = 0x11u;             /* 调试标记：进入第 5 节 */

    g_timer_irq = 0u;
    /* 周期必须明显大于中断处理程序的执行时间（这里一次处理要走
       APB 读 RIS + 写 INTCLR，几十~几百拍）。周期太短会变成中断活锁，
       主程序永远拿不到执行时间。 */
    REG32(T_LOAD) = 2000u;
    REG32(T_CTRL) = T_CTRL_PERIOD | T_CTRL_IE | T_CTRL_EN;

    i = 0u;
    while ((g_timer_irq < 3u) && (i < 20000u)) i++;

    REG32(LED_REG) = 0x22u;             /* 调试标记：退出第 5 节循环 */
    REG32(T_CTRL)   = 0u;
    REG32(T_INTCLR) = 1u;

    check("periodic mode raises >=3 timer IRQs", g_timer_irq >= 3u, g_timer_irq);

    v = REG32(T_MIS) & 1u;
    check("MIS reads 0 after stopping and clearing", v == 0u, v);

    /* ---------------- 6. UART 发送 ---------------- */
    uart_puts("\r\n[6] APB UART transmit\r\n");
    uart_puts("     this line itself comes out of the UART\r\n");

    while (!(REG32(U_LSR) & LSR_TEMT)) ;     /* 等最后一位移出去 */
    v = REG32(U_LSR);
    check("LSR.TEMT = 1 when transmitter idle", (v & LSR_TEMT) != 0u, v);

    /* ---------------- 7. UART 环回自收 ---------------- */
    uart_puts("\r\n[7] APB UART loopback (tb wires txd -> rxd)\r\n");
    {
        const char *echo = "LOOPBACK-OK";
        uart_rx_drain();                      /* 排掉前面打印时环回来的字符 */
        ok = 1u;
        for (i = 0u; echo[i] != '\0'; i++) {
            unsigned n = 0u;
            uart_putc(echo[i]);                       /* 发一个 */
            while (!(REG32(U_LSR) & LSR_DR) && (n < 5000u)) n++;
            if (!(REG32(U_LSR) & LSR_DR)) { ok = 0u; break; }
            if ((REG32(U_RBR) & 0xFFu) != (unsigned)(unsigned char)echo[i]) {
                ok = 0u;
                break;
            }
        }
        v = REG32(U_LSR) & 0x0Fu;             /* 先取样再打印 */
        check("11 chars echoed back identical", ok == 1u, i);
        check("LSR has no OE/PE/FE error", v == 0u, v);
    }

    /* ---------------- 8. UART 除数锁存 ---------------- */
    uart_puts("\r\n[8] APB UART divisor latch\r\n");
    {
        unsigned dll, dlm;
        REG32(U_LCR) = 0x80u;
        REG32(U_DLL) = 27u;
        REG32(U_DLM) = 1u;
        dll = REG32(U_DLL) & 0xFFu;
        dlm = REG32(U_DLM) & 0xFFu;
        REG32(U_DLM) = 0u;
        REG32(U_DLL) = 1u;                 /* 恢复仿真用的快速分频 */
        REG32(U_LCR) = 0x03u;
        check("DLL read back = 27", dll == 27u, dll);
        check("DLM read back = 1",  dlm == 1u,  dlm);
    }

    /* ---------------- 9. UART 接收中断 ---------------- */
    uart_puts("\r\n[9] APB UART RX interrupt\r\n");
    {
        unsigned n = 0u;

        uart_rx_drain();
        g_uart_irq  = 0u;
        g_uart_last = 0xFFFFFFFFu;

        REG32(U_IER) = 0x01u;              /* IER[0] = 接收数据可用中断 */
        uart_putc('Z');                    /* 发出去，环回后被接收 -> 中断 */

        while ((g_uart_irq == 0u) && (n < 5000u)) n++;
        REG32(U_IER) = 0x00u;

        check("UART RX interrupt fires", g_uart_irq >= 1u, g_uart_irq);
        check("UART RX interrupt data = 'Z'", g_uart_last == (unsigned)'Z', g_uart_last);
    }

    /* ---------------- 汇总 ---------------- */
    uart_puts("\r\n=========================================\r\n");
    if (g_fails == 0u) {
        uart_puts(" RESULT: ALL PASS\r\n");
    } else {
        uart_puts(" RESULT: FAILED, count = ");
        uart_putdec(g_fails);
        uart_puts("\r\n");
    }
    uart_puts("=========================================\r\n");

    /* 等最后一串字符完全移出去，再打结束标记（tb 看到就 $finish） */
    while (!(REG32(U_LSR) & LSR_TEMT)) ;
    REG32(LED_REG) = 0xEEu;

    while (1) ;
    return 0;
}
