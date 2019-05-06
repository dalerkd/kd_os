SECTION MBR vstart=0x7c00
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov fs,ax
	mov sp,0x7c00
	
	
	
	; 清屏
	mov ax,0x600
	mov bx,0x700
	mov cx,0
	mov dx,0x184f
	int 0x10
	
	; 获取光标位置
	mov ah,3
	mov bh,0
	int 0x10
	
	; 直接操作显存 来打字 ,背景绿, 前景红,跳动的1 MBR
	mov ax,0xb800
	mov gs,ax   ;gs段也是可以寻址显存的...
	
	mov byte [gs:0x00],'1'
	mov byte [gs:0x01],0xA4
	
	mov byte [gs:0x02],' '
	mov byte [gs:0x03],0xA4
	
	mov byte [gs:0x04],'M'
	mov byte [gs:0x05],0xA4
	
	mov byte [gs:0x06],'B'
	mov byte [gs:0x07],0xA4
	
	mov byte [gs:0x08],'R'
	mov byte [gs:0x09],0xA4
	
	
	
	jmp $
	
	message db "Hello MBR I know you? 2019:4:30"
	
	times 510-($-$$) db 0
	
	db 0x55,0xaa
	
	
	
	