#!/usr/bin/python3

from sys import stdout, stderr

stderr.write("Byte count: ")
#stdout.buffer.write(b"".join((i % 256).to_bytes(1, 'little') for i in range(int(input()))))
#stdout.buffer.write(b"".join((i % 2).to_bytes(1, 'little') for i in range(int(input()))))
#stdout.buffer.write(b"".join((i % 4).to_bytes(1, 'little') for i in range(int(input()))))
stdout.buffer.write(b"".join((255 - (i % 4)).to_bytes(1, 'little') for i in range(int(input()))))
#stdout.buffer.write(b"".join((0x80 + (i % 2)).to_bytes(1, 'little') for i in range(int(input()))))
