;主引导程序
%include "boot.inc"

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
	
	; 调用loader读取函数
	mov eax,LOADER_START_SECTOR
	mov bx,LOADER_BASE_ADDR
	mov cx,4
	call rd_disk_m_16
	
	jmp LOADER_BASE_ADDR
	
	;func: 16位下硬盘读取函数
rd_disk_m_16:
	;1. 设置读取的扇区数
	mov esi,eax
	mov di, cx
	mov al, cl
	mov dx, 0x1f2
	out dx,al
	
	mov eax,esi
	;2. 将LBA地址 存入
	
	mov dx,0x1f3
	out dx,al
	
	mov cl,8
	shr eax,cl
	mov dx,0x1f4
	
	shr eax,cl
	mov dx,0x1f5
	out dx,al
	
	shr eax,cl
	and al,0x0f
	or al,0xe0	;7-4位:1110:LBA模式
	mov dx,0x1f6
	out dx,al
	
	;3. 写入读命令
	mov dx,0x1f7
	mov al,0x20
	out dx,al
	
	;4. 检测硬盘状态
.not_ready:
	nop
	in al,dx
	and al,0x88
	cmp al,0x08
	jnz .not_ready
	
	;5. 从0x1f0端口读数据
	mov ax,di
	mov dx,256 
	mul dx
	mov cx,ax
	;扇区512字节=256个word: 所以  获取di*256次数据
	mov dx,0x1f0
.go_on_ready:
	in ax,dx
	mov[bx],ax
	add bx,2
	loop .go_on_ready
	ret
	
	
	message db "Hello MBR I know you? 2019:4:30"
	
	times 510-($-$$) db 0
	
	db 0x55,0xaa
	
	
	
	