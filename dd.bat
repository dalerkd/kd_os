dd if=src/mbr.bin of=hd60M.img bs=512 count=1 conv=notrunc
pause
;注意这个脚本停不下来,可以直接选择关闭它?手工输入以上代码即可执行,而不是死循环.