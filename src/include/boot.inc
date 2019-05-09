;boot的配置文件
;--------------loader位置
LOADER_BASE_ADDR 	equ 0x900
LOADER_START_SECTOR equ 0x2

;--------------gdt 描述符属性----------------------------------------
;--------------------------------------------------------------------
;31-24	23	22	21	20	19-16	15	14-13	12	11-8	7-0 :高32位	|
;段基址	G	D/B	L	AVL	段界限	P	DPL		S	TYPE	段基址		|
;31-24					19-16							23-16		|
;--------------------------------------------------------------------
;			31-16						15-0				:低32位	|	
;		段基址 15-0					段界限15-0						|
;--------------------------------------------------------------------
DESC_G_4K	equ 		1000_0000000000_0000000000b  ;4K对齐
DESC_D_32	equ			 100_0000000000_0000000000b  ;代码段 32位操作数
DESC_L		equ			  00_0000000000_0000000000b  ;64位标识
DESC_AVL	equ			   0_0000000000_0000000000b  ;此位没有意义,给操作系统用的

DESC_LIMIT_CODE2 equ	     1111000000_0000000000b  ;段界限是0xFFFFF,其高位 1111
DESC_LIMIT_DATA2 equ	DESC_LIMIT_CODE2
DESC_LIMIT_VIDEO2 equ	     0000000000_0000000000b  ;显存段, 原书中的内容似乎错位了一个字节
DESC_P		equ			         100000_0000000000b  ;段是否存在

DESC_DPL_0 equ			          00000_0000000000b	 ;R0
DESC_DPL_3 equ			          11000_0000000000b	 ;R3

DESC_S_CODE equ			            100_0000000000b	 ;对于CPU来说是数据吗还是CPU的结构:答案是数据
DESC_S_DATA equ	DESC_S_CODE
DESC_S_sys	equ			            000_0000000000b	 ;

DESC_TYPE_CODE equ		             10_0000000000b	 ;4位:x1,e0,w0,a0=可执行,非一致,不可读,清已访问
DESC_TYPE_DATA equ	                 00_1000000000b	 ;x0,e0,w1,a0=不可执行,向上扩展,可写,清已访问

DESC_BASE_ADDRESS2	equ	0x0B	;第2个段基址 23-16

; 代码段:高32位
DESC_CODE_HIGH4  equ  (0x00 <<24)+ DESC_G_4K+ DESC_D_32+ \
	DESC_L+ DESC_AVL+ DESC_LIMIT_CODE2 + \
	DESC_P+ DESC_DPL_0+ DESC_S_CODE + \
	DESC_TYPE_CODE+ 0x00

; 数据段和栈段:高32位
DESC_DATA_HIGH4	 equ  (0x00 <<24)+ DESC_G_4K+ DESC_D_32+ \
	DESC_L+	DESC_AVL+ DESC_LIMIT_DATA2 + \
	DESC_P+ DESC_DPL_0+ DESC_S_DATA + \
	DESC_TYPE_DATA+ 0x00

; 显存段:高32位
DESC_VIDEO_HIGH4 equ (0x00 <<24)+ DESC_G_4K+ DESC_D_32+ \
	DESC_L+ DESC_AVL+ DESC_LIMIT_VIDEO2+ \
	DESC_P+ DESC_DPL_0 + DESC_S_DATA + \
	DESC_TYPE_DATA+ DESC_BASE_ADDRESS2		;这是原书中不对的地方

;----------------------选择子属性---------------------------
RPL0	equ		00b
RPL3	equ		11b
TI_GDT	equ		000b
TI_LDT	equ		100b

; 一处勘误: 这是原书中不对的地方,即 显存段的 段基址23-16部分未被初始
;DESC_BASE_ADDRESS2 这个在原书中写成0了.而在Github整理的代码里,将该 数据和 DESC_LIMIT_VIDEO2合并在一起了
;现在他们不应该合并在一起,虽然效果是一样的.



