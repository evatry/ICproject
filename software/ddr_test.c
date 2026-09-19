/* ============================================================
 *  ddr_test.c  --  基于 main.c 的 DDR3 测试程序
 *
 *  地址映射（与 ahb_axi_matrix BD 的地址分配一致）:
 *      0xFFFF0000   ROM   (16K x 32, 只读; 向量表/代码/常量)
 *      0x10000000   SRAM  (16K x 32 = 64KB; 栈 / .data / .bss)
 *      0x40000000   DDR3  (M_DDR_AXI, 当前 BD 解码 0x4000_0000~0x403F_FFFF)
 *      0x80000000   LED   (低 8 位)
 *
 *  结果指示（写 LED，仿真里 sram_led 会打印 "LED write, value = 0xXX"）:
 *      0xA5 = 全部通过
 *      0x5A = 有失败
 *  失败细节存在 SRAM 的 result[] 里，可用仿真波形/内存查看:
 *      result[0] = 0xA5 (通过) / 0x5A (失败)
 *      result[1] = 失败子测试编号
 *      result[2] = 失败时的数组下标
 *      result[3] = 期望值
 *      result[4] = 实际读回值
 * ============================================================ */

#define DDR_BASE   ((volatile unsigned int *)0x40000000)
#define LED_BASE   ((volatile unsigned int *)0x80000000)

/* 测试窗口：256 字 = 1KB，远小于 BD 解码的 4MB */
#define DDR_WORDS  256u

volatile unsigned int result[8];

void delay(unsigned int count)
{
    while (count--) {
        __asm__ volatile ("nop");
    }
}

static void record_fail(unsigned int code, unsigned int idx,
                        unsigned int exp, unsigned int got)
{
    if (result[0] == 0xA5) {          /* 只记第一个错误 */
        result[0] = 0x5A;
        result[1] = code;
        result[2] = idx;
        result[3] = exp;
        result[4] = got;
    }
}

/* ---------- 测试 1：顺序写 / 顺序读 / 比较 ---------- */
static void test_seq(void)
{
    unsigned int i, v;

    for (i = 0; i < DDR_WORDS; i++)
        DDR_BASE[i] = 0x40000000u + i;              /* 每个地址唯一数据 */

    for (i = 0; i < DDR_WORDS; i++) {
        v = DDR_BASE[i];
        if (v != 0x40000000u + i) {
            record_fail(1, i, 0x40000000u + i, v);
            return;
        }
    }
}

/* ---------- 测试 2：数据线（32 根）单独走 1 ---------- */
static void test_data_bus(void)
{
    unsigned int b, v;

    for (b = 0; b < 32u; b++)
        DDR_BASE[b] = (1u << b);                    /* 第 b 根数据线为 1 */

    for (b = 0; b < 32u; b++) {
        v = DDR_BASE[b];
        if (v != (1u << b)) {
            record_fail(2, b, (1u << b), v);
            return;
        }
    }
}

/* ---------- 测试 3：地址线（低位 2 的幂）走 1 ---------- */
static void test_addr_bus(void)
{
    unsigned int a, i, v;

    for (i = 0; i < 8u; i++)
        DDR_BASE[1u << i] = 0xADD00000u | (1u << i);

    for (i = 0; i < 8u; i++) {
        v = DDR_BASE[1u << i];
        if (v != (0xADD00000u | (1u << i))) {
            record_fail(3, 1u << i, 0xADD00000u | (1u << i), v);
            return;
        }
    }

    /* 相邻地址不能互相干扰 */
    for (a = 0; a < 16u; a++)
        DDR_BASE[a] = 0x1000u + a;
    for (a = 0; a < 16u; a++) {
        v = DDR_BASE[a];
        if (v != (0x1000u + a)) {
            record_fail(4, a, 0x1000u + a, v);
            return;
        }
    }
}

/* ---------- 测试 4：全 0 / 全 1 读写一致性 ---------- */
static void test_all_bits(void)
{
    unsigned int i, v;

    for (i = 0; i < 64u; i++) DDR_BASE[i] = 0x00000000u;
    for (i = 0; i < 64u; i++) {
        v = DDR_BASE[i];
        if (v != 0x00000000u) { record_fail(5, i, 0x00000000u, v); return; }
    }

    for (i = 0; i < 64u; i++) DDR_BASE[i] = 0xFFFFFFFFu;
    for (i = 0; i < 64u; i++) {
        v = DDR_BASE[i];
        if (v != 0xFFFFFFFFu) { record_fail(6, i, 0xFFFFFFFFu, v); return; }
    }
}

int main(void)
{
    unsigned int i;

    for (i = 0; i < 8u; i++) result[i] = 0;
    result[0] = 0xA5;                 /* 先假设通过 */

    test_seq();
    test_data_bus();
    test_addr_bus();
    test_all_bits();

    *LED_BASE = result[0];            /* 0xA5 通过 / 0x5A 失败 */

    /* 结果用 LED 慢闪，方便在板子上观察；
       延时长，2ms 仿真内基本只看到第一次写入 */
    while (1) {
        if (result[0] == 0xA5) {
            delay(0x00080000);
            *LED_BASE = 0xA5;
            delay(0x00080000);
            *LED_BASE = 0x00;
        } else {
            delay(0x00080000);
            *LED_BASE = 0x5A;
            delay(0x00080000);
            *LED_BASE = 0x00;
        }
    }

    return 0;
}
