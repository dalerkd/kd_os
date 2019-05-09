;����������
%include "boot.inc"

SECTION MBR vstart=0x7c00
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov fs,ax
	mov sp,0x7c00
	
	
	
	; ����
	mov ax,0x600
	mov bx,0x700
	mov cx,0
	mov dx,0x184f
	int 0x10
	
	; ��ȡ���λ��
	mov ah,3
	mov bh,0
	int 0x10
	
	; ֱ�Ӳ����Դ� ������ ,������, ǰ����,������1 MBR
	mov ax,0xb800
	mov gs,ax   ;gs��Ҳ�ǿ���Ѱַ�Դ��...
	
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
	
	; ����loader��ȡ����
	mov eax,LOADER_START_SECTOR
	mov bx,LOADER_BASE_ADDR
	mov cx,4
	call rd_disk_m_16
	
	jmp LOADER_BASE_ADDR
	
	;func: 16λ��Ӳ�̶�ȡ����
rd_disk_m_16:
	;1. ���ö�ȡ��������
	mov esi,eax
	mov di, cx
	mov dx, 0x1f2
	out dx,al
	
	mov eax,esi
	;2. ��LBA��ַ ����
	
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
	or al,0xe0	;7-4λ:1110:LBAģʽ
	mov dx,0x1f6
	out dx,al
	
	;3. д�������
	mov dx,0x1f7
	mov al,0x20
	out dx,al
	
	;4. ���Ӳ��״̬
.not_ready:
	nop
	in al,dx
	and al,0x88
	cmp al,0x08
	jnz .not_ready
	
	;5. ��0x1f0�˿ڶ�����
	mov ax,di
	mov dx,256 
	mul dx
	mov cx,ax
	;����512�ֽ�=256��word: ����  ��ȡdi*256������
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
	
	
	
	