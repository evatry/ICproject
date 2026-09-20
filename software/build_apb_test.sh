#!/bin/bash
# ============================================================
#  build_apb_test.sh [c源文件] [输出名]
#    编译 apb_test.c -> apb_test.memory.vh (ROM 镜像, 基址 0xFFFF0000)
#    默认安装到 ../sim_soc/memory.vh（原文件先备份成 memory.vh.apb_bak）
#
#    用的是本目录的 apb_startup.S（带 IRQ 向量和处理程序）+ arm926.ld
#    DDR 自测程序请用 build_ddr_test.sh（它配 startup.S）
# ============================================================
set -e
cd "$(dirname "$0")"

TC=/home/ICer/gcc-arm-none-eabi-10.3-2021.10/bin
CC=$TC/arm-none-eabi-gcc
OC=$TC/arm-none-eabi-objcopy
OD=$TC/arm-none-eabi-objdump

SRC=${1:-apb_test.c}
OUT=${2:-apb_test}
SIMDIR="$(cd .. && pwd)/sim_soc"

CFLAGS="-mcpu=arm926ej-s -marm -O1 -ffreestanding -fno-builtin -nostdlib -Wall -g"

echo "--- compile ---"
$CC $CFLAGS -c apb_startup.S -o apb_startup.o
$CC $CFLAGS -c "$SRC"        -o apb_app.o

echo "--- link ---"
$CC -mcpu=arm926ej-s -marm -nostdlib -nostartfiles -T arm926.ld \
    apb_startup.o apb_app.o -o $OUT.elf

echo "--- sections ---"
$OD -h $OUT.elf | sed -n '1,14p'
$TC/arm-none-eabi-size $OUT.elf

echo "--- elf -> bin -> memory.vh ---"
$OC -O binary $OUT.elf $OUT.bin
$OD -d $OUT.elf > $OUT.dis
python3 bin2vh.py $OUT.bin $OUT.memory.vh

if [ -d "$SIMDIR" ]; then
    if [ -f "$SIMDIR/memory.vh" ] && [ ! -f "$SIMDIR/memory.vh.apb_bak" ]; then
        cp "$SIMDIR/memory.vh" "$SIMDIR/memory.vh.apb_bak"
        echo "已备份原 memory.vh -> $SIMDIR/memory.vh.apb_bak"
    fi
    cp $OUT.memory.vh "$SIMDIR/memory.vh"
    echo "已安装: $SIMDIR/memory.vh"
fi
