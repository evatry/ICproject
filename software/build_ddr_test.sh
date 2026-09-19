#!/bin/bash
# ============================================================
#  build_ddr_test.sh [c源文件] [输出名]
#    编译 ddr_test.c -> memory.vh (ROM 镜像, 基址 0xFFFF0000)
#    默认同时拷贝到仿真目录 /home/ICer/work/sim_soc/memory.vh
#    (旧文件先备份成 memory.vh.led_bak)
# ============================================================
set -e
cd "$(dirname "$0")"

TC=/home/ICer/gcc-arm-none-eabi-10.3-2021.10/bin
CC=$TC/arm-none-eabi-gcc
OC=$TC/arm-none-eabi-objcopy
OD=$TC/arm-none-eabi-objdump

SRC=${1:-ddr_test.c}
OUT=${2:-ddr_test}
# 装到本仓库自己的仿真目录（原来硬编码成 /home/ICer/work/sim_soc）
SIMDIR="$(cd .. && pwd)/sim_soc"

CFLAGS="-mcpu=arm926ej-s -marm -mno-thumb-interwork -O1 -ffreestanding -fno-builtin -nostdlib -Wall -g"

echo "--- compile $SRC ---"
$CC $CFLAGS -c startup.S -o startup.o
$CC $CFLAGS -c "$SRC"    -o app.o

echo "--- link ---"
$CC -mcpu=arm926ej-s -marm -nostdlib -nostartfiles -T arm926.ld startup.o app.o -o $OUT.elf

echo "--- sections ---"
$OD -h $OUT.elf | sed -n '1,20p'

echo "--- symbols ---"
$OD -t $OUT.elf | grep -E "_start|main|_data|_bss|_stack" || true

echo "--- elf -> bin -> memory.vh ---"
$OC -O binary $OUT.elf $OUT.bin
python3 bin2vh.py $OUT.bin $OUT.memory.vh

if [ -d "$SIMDIR" ]; then
    if [ -f "$SIMDIR/memory.vh" ] && [ ! -f "$SIMDIR/memory.vh.led_bak" ]; then
        cp "$SIMDIR/memory.vh" "$SIMDIR/memory.vh.led_bak"
        echo "已备份原 memory.vh -> $SIMDIR/memory.vh.led_bak"
    fi
    cp $OUT.memory.vh "$SIMDIR/memory.vh"
    echo "已安装: $SIMDIR/memory.vh"
fi
