/* ============================================================
 *  startup.S -- ARM926EJ-S 裸机启动代码（配 arm926.ld 使用）
 *  向量表放在镜像最前面 -> 链接后落在 0xFFFF0000
 *  (soc_top 里 VINITHI=1, 复位从 0xFFFF0000 取指令)
 * ============================================================ */

    .syntax unified
    .arm

    .section .vectors, "ax"
    .global _start
_start:
    b   reset               /* 0x00 复位           */
    b   hang                /* 0x04 未定义指令      */
    b   hang                /* 0x08 SWI            */
    b   hang                /* 0x0C 预取中止        */
    b   hang                /* 0x10 数据中止        */
    nop                     /* 0x14 保留           */
    b   hang                /* 0x18 IRQ            */
    b   hang                /* 0x1C FIQ            */

    .section .text
    .global reset
reset:
    /* 进入 SVC 模式，关 IRQ/FIQ */
    mrs r0, cpsr
    bic r0, r0, #0x1f
    orr r0, r0, #0xd3
    msr cpsr_c, r0

    /* 设置栈：SRAM 顶部 */
    ldr sp, =_stack_top

    /* 拷贝 .data: ROM(LMA) -> SRAM(VMA) */
    ldr r0, =_data_lma
    ldr r1, =_data_start
    ldr r2, =_data_end
1:  cmp r1, r2
    ldrlo r3, [r0], #4
    strlo r3, [r1], #4
    blo 1b

    /* 清零 .bss */
    ldr r1, =_bss_start
    ldr r2, =_bss_end
    mov r3, #0
2:  cmp r1, r2
    strlo r3, [r1], #4
    blo 2b

    bl  main

hang:
    b   hang
