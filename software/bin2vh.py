#!/usr/bin/env python3
"""bin2vh.py  <input.bin> <output.vh>
把裸机二进制镜像转成 $readmemh 用的 memory.vh (32bit 小端字, 每行 4 个)"""
import sys
src, dst = sys.argv[1], sys.argv[2]
d = open(src, 'rb').read()
if len(d) % 4:
    d += b'\x00' * (4 - len(d) % 4)
words = [int.from_bytes(d[i:i+4], 'little') for i in range(0, len(d), 4)]
with open(dst, 'w') as f:
    for i in range(0, len(words), 4):
        f.write(' '.join('%08X' % w for w in words[i:i+4]) + '\n')
print('%s: %d bytes, %d words' % (dst, len(d), len(words)))
