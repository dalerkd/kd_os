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
	
	; 打印字符串	
	mov ax,message
	mov bp,ax
	mov cx,0x1F ;字符长度
	mov ax,0x1301
	mov bx,0x2  ;color
	int 0x10
	
	jmp $
	
	message db "Hello MBR I know you? 2019:4:30"
	
	times 510-($-$$) db 0
	
	db 0x55,0xaa
	
	
	
	