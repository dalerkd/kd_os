%include "boot.inc"
section loader vstart=LOADER_BASE_ADDR
	LOADER_STACK_TOP equ LOADER_BASE_ADDR;保护模式栈 和 实模式 一致
	
	jmp Loader_Start
;-------------------------------------------------------------------------
;构建gdt及其内部的描述符

;--------------gdt 描述符属性----------------------------------------
;--------------------------------------------------------------------
;31-24	23	22	21	20	19-16	15	14-13	12	11-8	7-0 :高32位	|
;段基址	G	D/B	L	AVL	段界限	P	DPL		S	TYPE	段基址		|
;31-24					19-16							23-16		|
;--------------------------------------------------------------------
;			31-16						15-0				:低32位	|	
;		段基址 15-0					段界限15-0						|
;--------------------------------------------------------------------	
	GDT_BASE:	dd 	0x00000000
				dd	0x00000000
				
				; 范围是 段基址: 0x0 段界限是: 0xFFFF_FFFF
	CODE_DESC:	dd	0x0000FFFF		;低字节	
				dd	DESC_CODE_HIGH4 ;高字节
				
				; 栈段 和 数据段做了融合
	STACK_DESC:	dd	0x0000FFFF
				dd	DESC_DATA_HIGH4 
				
				; 范围是 段基址: 0xB8000, 段界限是limit=(0xbffff-0xb80000)/4k=0x7
	VEDEO_DESC:	dd	0x80000007
				dd	DESC_VIDEO_HIGH4
				
	GDT_SIZE	equ $-GDT_BASE	;单位是字节
	GDT_LIMIT	equ GDT_SIZE-1
	
	times 60 dq 0	;预留60个描述符的位置

	;定义选择子,用于 装载到段中
	;0x123456789abc_TI(1)_RPL(2)
	SELECTOR_CODE	equ (0x0001<<3) + TI_GDT + RPL0
	SELECTOR_DATA	equ	(0x0002<<3) + TI_GDT + RPL0
	SELECTOR_VIDEO	equ	(0x0003<<3)	+ TI_GDT + RPL0
	
	gdt_ptr	dw GDT_LIMIT
			dd GDT_BASE
	
	

;-------------实模式打印---------------------
PrintInRealMode:
	; 直接操作显存 来打字 ,背景绿, 前景红,跳动的1 MBR
	mov ax,0xb800
	mov gs,ax   ;gs段也是可以寻址显存的...
	
	mov byte [gs:0x10],'2'
	mov byte [gs:0x11],0xA4
	
	mov byte [gs:0x12],' '
	mov byte [gs:0x13],0xA4
	
	mov byte [gs:0x14],'L'
	mov byte [gs:0x15],0xA4
	
	mov byte [gs:0x16],'O'
	mov byte [gs:0x17],0xA4
	
	mov byte [gs:0x18],'A'
	mov byte [gs:0x19],0xA4
	
	mov byte [gs:0x1A],'D'
	mov byte [gs:0x1B],0xA4
	
	mov byte [gs:0x1C],'E'
	mov byte [gs:0x1D],0xA4
	
	mov byte [gs:0x1E],'R'
	mov byte [gs:0x1F],0xA4
	
	ret
;---------------------Start------------------
Loader_Start:
	
	call PrintInRealMode
	;----准备进入保护模式
	; 打开A20
	; 加载GDT
	; cr0 pe 位 置1
	
	;----打开A20
	in al,0x92			;读出原数据
	or al,0000_0010B
	out 0x92,al			;写入
	;----加载GDT
	lgdt [gdt_ptr] ;将gdt_ptr指向的数据取过来..
	
	;----cr0 0位置1
	mov eax, cr0
	or eax,0x00000001
	mov cr0, eax
	jmp dword SELECTOR_CODE:Protect_Mode_Start	;刷新流水线 并设置cs段... ...
	;----以下是保护世界
[bits 32]
Protect_Mode_Start:
	mov ax, SELECTOR_DATA
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov esp, LOADER_STACK_TOP
	mov ax, SELECTOR_VIDEO
	mov gs, ax

	call PrintInProtectMode
	jmp $
;-------------保护模式打印------------------
PrintInProtectMode:
	;下面是我自己设计的循环打字
	;RealMode:This a new world!
	
	mov eax, real_string
	mov ebx, 160  ;第 80 * 25模式 ,所以 160处是第2行
	mov ecx, STRING_LEN ;loop次数
video_loop:	
	mov edx, [eax]
	mov byte [gs:ebx],dl;
	add ebx,1
	add eax,1
	dec ecx
	jnz video_loop
	ret
	
;78字节 还是用汇编吧
;real_string db "R\0e\0a\0l\0M\0o\0d\0e\0:\0T\0h\0i\0s\0 \0a\0 \0n\0e\0w\0 \0w\0o\0r\0l\0d\0!\0"

real_string db 'P r o t e c t e   M o d e   S t a r t : ) '
STRING_LEN equ $-real_string