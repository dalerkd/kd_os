#!/bin/sh

shopt -s expand_aliases

bximage -mode=create -q hd60M.img -hd=50M

echo "Compiling use gcc ld..."
#gcc -c -o src/kernel/main.o  src/kernel/main.c -m32
#ld src/kernel/main.o -Ttext 0xc0001500 -e main -o src/kernel/kernel.bin
nasm -I src/include/ -o src/mbr.bin 	src/mbr.S
nasm -I src/include/ -o src/loader.bin 	src/loader.S

echo "Write mbr,loader ,kernel 2 disk"
dd if=src/mbr.bin of=hd60M.img bs=512 count=1 conv=notrunc
dd if=src/loader.bin of=hd60M.img bs=512 count=4 seek=2 conv=notrunc
#dd if=src/kernel/kernel.bin of=hd60M.img bs=512 count=200 seek=9 conv=notrunc

echo "Starting Bochs"
rm ./hd60M.img.lock
bochs -f bochsrc_unix.bxrc
