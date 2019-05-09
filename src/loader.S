%include "boot.inc"
section loader vstart=LOADER_BASE_ADDR
	LOADER_STACK_TOP equ LOADER_BASE_ADDR;����ģʽջ �� ʵģʽ һ��
	
	jmp Loader_Start
;-------------------------------------------------------------------------
;����gdt�����ڲ���������

;--------------gdt ����������----------------------------------------
;--------------------------------------------------------------------
;31-24	23	22	21	20	19-16	15	14-13	12	11-8	7-0 :��32λ	|
;�λ�ַ	G	D/B	L	AVL	�ν���	P	DPL		S	TYPE	�λ�ַ		|
;31-24					19-16							23-16		|
;--------------------------------------------------------------------
;			31-16						15-0				:��32λ	|	
;		�λ�ַ 15-0					�ν���15-0						|
;--------------------------------------------------------------------	
	GDT_BASE:	dd 	0x00000000
				dd	0x00000000
				
				; ��Χ�� �λ�ַ: 0x0 �ν�����: 0xFFFF_FFFF
	CODE_DESC:	dd	0x0000FFFF		;���ֽ�	
				dd	DESC_CODE_HIGH4 ;���ֽ�
				
				; ջ�� �� ���ݶ������ں�
	STACK_DESC:	dd	0x0000FFFF
				dd	DESC_DATA_HIGH4 
				
				; ��Χ�� �λ�ַ: 0xB8000, �ν�����limit=(0xbffff-0xb80000)/4k=0x7
	VEDEO_DESC:	dd	0x80000007
				dd	DESC_VIDEO_HIGH4
				
	GDT_SIZE	equ $-GDT_BASE	;��λ���ֽ�
	GDT_LIMIT	equ GDT_SIZE-1
	
	times 60 dq 0	;Ԥ��60����������λ��

	;����ѡ����,���� װ�ص�����
	;0x123456789abc_TI(1)_RPL(2)
	SELECTOR_CODE	equ (0x0001<<3) + TI_GDT + RPL0
	SELECTOR_DATA	equ	(0x0002<<3) + TI_GDT + RPL0
	SELECTOR_VIDEO	equ	(0x0003<<3)	+ TI_GDT + RPL0
	
	gdt_ptr	dw GDT_LIMIT
			dd GDT_BASE
	
	

;-------------ʵģʽ��ӡ---------------------
PrintInRealMode:
	; ֱ�Ӳ����Դ� ������ ,������, ǰ����,������1 MBR
	mov ax,0xb800
	mov gs,ax   ;gs��Ҳ�ǿ���Ѱַ�Դ��...
	
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
	;----׼�����뱣��ģʽ
	; ��A20
	; ����GDT
	; cr0 pe λ ��1
	
	;----��A20
	in al,0x92			;����ԭ����
	or al,0000_0010B
	out 0x92,al			;д��
	;----����GDT
	lgdt [gdt_ptr] ;��gdt_ptrָ�������ȡ����..
	
	;----cr0 0λ��1
	mov eax, cr0
	or eax,0x00000001
	mov cr0, eax
	jmp dword SELECTOR_CODE:Protect_Mode_Start	;ˢ����ˮ�� ������cs��... ...
	;----�����Ǳ�������
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
;-------------����ģʽ��ӡ------------------
PrintInProtectMode:
	;���������Լ���Ƶ�ѭ������
	;RealMode:This a new world!
	
	mov eax, real_string
	mov ebx, 160  ;�� 80 * 25ģʽ ,���� 160���ǵ�2��
	mov ecx, STRING_LEN ;loop����
video_loop:	
	mov edx, [eax]
	mov byte [gs:ebx],dl;
	add ebx,1
	add eax,1
	dec ecx
	jnz video_loop
	ret
	
;78�ֽ� �����û���
;real_string db "R\0e\0a\0l\0M\0o\0d\0e\0:\0T\0h\0i\0s\0 \0a\0 \0n\0e\0w\0 \0w\0o\0r\0l\0d\0!\0"

real_string db 'P r o t e c t e   M o d e   S t a r t : ) '
STRING_LEN equ $-real_string