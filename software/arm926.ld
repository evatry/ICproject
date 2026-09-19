/* ============================================================
 *  arm926.ld -- DDR 测试程序链接脚本
 *    ROM  0xFFFF0000  程序/常量 (.text/.rodata) 以及 .data 的加载地址
 *    SRAM 0x10000000  .data/.bss/栈
 * ============================================================ */
ENTRY(_start)

MEMORY
{
    ROM  (rx)  : ORIGIN = 0xFFFF0000, LENGTH = 64K
    SRAM (rwx) : ORIGIN = 0x10000000, LENGTH = 64K
}

SECTIONS
{
    .text : {
        KEEP(*(.vectors))
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
    } > ROM

    .data : {
        _data_start = .;
        *(.data*)
        . = ALIGN(4);
        _data_end = .;
    } > SRAM AT> ROM
    _data_lma = LOADADDR(.data);

    .bss (NOLOAD) : {
        _bss_start = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } > SRAM

    _stack_top = ORIGIN(SRAM) + LENGTH(SRAM) - 16;

    /DISCARD/ : {
        *(.ARM.exidx*)
        *(.ARM.attributes)
        *(.comment)
        *(.note*)
    }
}
