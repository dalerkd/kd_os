%include "boot.inc"
section loader vstart=LOADER_BASE_ADDR

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
	jmp $