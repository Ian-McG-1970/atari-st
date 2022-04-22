fill_left_right	MACRO
		lsl.w 	#3,d0 		; *16 *2
		lea 	(a7,d0.w),a2 	; colour left table
		movem.l 	(a2),d3/d6 	; get and into d3/d4 - 8 bytes
		lea 	(a5,d0.w),a2 	; colour left table
		movem.l 	(a3),d0/d2 	; get screen in d0-d1
		and.l 	d3,d0
		and.l 	d6,d2
		movem.l 	(a2),d3/d6 	; get or into d3/d4 - 8 bytes
		or.l 	d3,d0
		or.l 	d6,d2
		movem.l 	d0/d2,(a3)  	; put screen

		move.w 	(a6,d1.w),d3 	; right hor pos
		lea 	(a1,d3.w),a3 	; left screen = ver pos + 2 right byte hor pos
		lsl.w 	#3,d1 		; *16 *2
		lea 	8(a7,d1.w),a2 	; colour right table
		movem.l 	(a2),d3/d6 	; get and into d3/d4 - 8 bytes
		lea 	8(a5,d1.w),a2 	; colour right table
		movem.l 	(a3),d0/d2 	; get screen in d0-d1
		and.l 	d3,d0
		and.l 	d6,d2
		movem.l 	(a2),d3/d6 	; get or into d3/d4 - 8 bytes
		or.l 	d3,d0
		or.l 	d6,d2
		movem.l 	d0/d2,(a3) 	; put screen
		ENDM

fill_next_line	MACRO
		lea 	8(a0),a0 	; next points
		lea 	160(a1),a1 	; next screen line
		swap 	d1 		; get count from hi
		dbeq 	d1,line_next 	; dec line count
		ENDM

fill_slope	MACRO
		move.l 	d2,\1(a2)	; store ypos at xpos - move.l 	d1,\1(a2)
		add.l 	d5,d2 		; add slope - add.l 	d3,d1
		ENDM

d4d2d5d3		MACRO
		move.l 	d4,d2 	; colour
		move.l 	d5,d3 	; colour
		ENDM

d4d6d5d7		MACRO
		move.l 	d4,d6 	; colour
		move.l 	d5,d7 	; colour
		ENDM

d4d0d5d1 	MACRO	
		move.l	d4,d0 	; colour
		move.l 	d5,d1 	; colour
		ENDM

d4a2d5a4		MACRO	
		move.l 	d4,a2 	; colour
		move.l 	d5,a4 	; colour
		ENDM

clear_block	MACRO
		movem.l	d0-d7/a0-a6,(\1)*60(a7)
		movem.l 	d0-d7/a0-a6,(\1+1)*60(a7)
		movem.l 	d0-d7/a0-a6,(\1+2)*60(a7)
		movem.l 	d0-d7/a0-a6,(\1+3)*60(a7)
		movem.l 	d0-d7/a0-a6,(\1+4)*60(a7)
		movem.l 	d0-d7/a0-a6,(\1+5)*60(a7)
		movem.l 	d0-d7/a0-a6,(\1+6)*60(a7)
		movem.l 	d0-d7/a0-a6,(\1+7)*60(a7)
		movem.l 	d0-d7/a0-a6,(\1+8)*60(a7)
		movem.l 	d0-d7/a0-a6,(\1+9)*60(a7)
		ENDM

stack_pointer_store_usp	MACRO
			move.w 	#$2700,sr 		; disable interrupts
			move.l 	usp,a0
			move.l 	a0,-(sp) 		; store usp
			move.l 	sp,the_stack_pointer 	; store sp
			ENDM

stack_pointer_restore_usp 	MACRO
			move.l 	the_stack_pointer,sp 	; restore sp
			move.l 	(sp)+,a0
			move.l 	a0,usp		 	; restore usp
			move.w 	#$2300,sr 		; enable interrupts
			ENDM

stack_pointer_store 	MACRO
			move.w 	#$2700,sr 		; disable interrupts
			move.l 	sp,the_stack_pointer 	; store sp
			ENDM

stack_pointer_restore 	MACRO
			move.l 	the_stack_pointer,sp 	; restore sp
			move.w 	#$2300,sr 		; enable interrupts
			ENDM
