/* ============================================================================
 *  apb_startup.S -- APB 外设测试程序的启动代码（配 arm926.ld 使用）
 *
 *  与同目录下 startup.S（DDR 测试用）的区别：
 *    * 完整的异常向量表，含 IRQ 入口
 *    * 单独的 IRQ 模式栈
 *    * 启动时清 CPSR.I，打开中断
 *
 *  符号名遵循 arm926.ld：_stack_top / _data_lma / _data_start / _data_end
 *                        / _bss_start / _bss_end
 * ==========================================================================*/

    .section .vectors, "ax"
    .code 32

    b   _start              /* 0x00 复位            */
    b   _undef_handler      /* 0x04 未定义指令      */
    b   _swi_handler        /* 0x08 软中断          */
    b   _pabort_handler     /* 0x0C 取指中止        */
    b   _dabort_handler     /* 0x10 数据中止        */
    b   _reserved_handler   /* 0x14 保留            */
    b   _irq_handler        /* 0x18 IRQ             */
    b   _fiq_handler        /* 0x1C FIQ             */

    .text
    .code 32
    .global _start

_start:
    /* ---- IRQ 模式栈（放在 SRAM 下半区，避开 SVC 栈） ---- */
    msr     cpsr_c, #0xD2
    ldr     sp, =0x1000E000

    /* ---- SVC 模式栈：arm926.ld 里的 _stack_top ---- */
    msr     cpsr_c, #0xD3
    ldr     sp, =_stack_top

    /* ---- 清 .bss ---- */
    ldr     r0, =_bss_start
    ldr     r1, =_bss_end
    mov     r2, #0
1:
    cmp     r0, r1
    strlo   r2, [r0], #4
    blo     1b

    /* ---- 拷 .data (ROM -> SRAM) ---- */
    ldr     r0, =_data_lma
    ldr     r1, =_data_start
    ldr     r2, =_data_end
2:
    cmp     r1, r2
    ldrlo   r3, [r0], #4
    strlo   r3, [r1], #4
    blo     2b

    /* ---- 打开 IRQ（清 CPSR.I） ---- */
    mrs     r0, cpsr
    bic     r0, r0, #0x80
    msr     cpsr_c, r0

    bl      main

3:  b       3b

/* ============================ 异常处理 ============================ */
_undef_handler:
_swi_handler:
_pabort_handler:
_dabort_handler:
_reserved_handler:
_fiq_handler:
    b       .

_irq_handler:
    sub     lr, lr, #4
    stmfd   sp!, {r0-r3, r12, lr}
    bl      irq_dispatch
    ldmfd   sp!, {r0-r3, r12, pc}^

    .end
