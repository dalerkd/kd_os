call dd if=src/mbr.bin of=hd60M.img bs=512 count=1 conv=notrunc
call dd if=src/loader.bin of=hd60M.img bs=512 count=4 seek=2 conv=notrunc
pause