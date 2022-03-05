# Hailstone Sequence (Collatz Conjecture)

This program generates the hailstone sequence. This was the first semi-complicated program I had ever written in assembly.

Assembled and linked using:

    nasm hailstone.nasm -g -f elf32 -Wall -o hailstone.o
    ld hailstone.o -m elf_i386 -o hailstone