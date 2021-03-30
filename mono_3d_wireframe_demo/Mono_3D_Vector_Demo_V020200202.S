
SCREEN_HOR_MIDDLE EQU 320
SCREEN_VER_MIDDLE EQU 200
TOP_CC		EQU 1
BOTTOM_CC	EQU 2
LEFT_CC 		EQU 4
RIGHT_CC		EQU 8
BEHIND_CC 	EQU 16
TOP_BIT_CC	EQU 0
BOTTOM_BIT_CC	EQU 1
LEFT_BIT_CC 	EQU 2
RIGHT_BIT_CC	EQU 3
BEHIND_BIT_CC	EQU 4
TOP_EDGE		EQU 0
BOTTOM_EDGE	EQU 397
LEFT_EDGE	EQU 0
RIGHT_EDGE	EQU 637
FOCUS_Z		EQU 256
FOCUS_XY		EQU 8 ; SHIFTED FOCUS_Z
CLIP_Z		EQU 0

; lsl.w #1,d0	add.w d0,d0	1 add is quicker than a shift.

	opt	d-,o+ ; optimisation

	bsr	set_supervisor_mode
	bsr	set_screen
	bsr 	set_screen_buffers

main_loop
		move.w	#$25,-(sp) 	;wait for vbl
		trap	#14
		addq.l	#2,sp

		move.l	otherybuffer,d0 	;swap the screen y buffers
		move.l	currentybuffer,otherybuffer		
		move.l	d0,currentybuffer		

		move.l	other,d0 	;swap the screen buffers
		move.l	current,other		
		move.l	d0,current

		lsr.w   	#8,d0		;move it directly into screen hardware registers.
		move.l 	d0,$ffff8200.w

		bsr 	clear
		bsr	build_rotation_matrix
		
		moveq.w	#8-1,d7			; points
		lea	objectpointlist,a0	; point list
		moveq.w	#12-1,d1 ; #12-1,d1			;  #12-1
		lea	objectlinelist,a1		; line list
		bsr	draw_object

		bsr 	keyboard
	
		move.b	exit,d0
		beq	main_loop

	move.w	screen_resolution,-(sp) ;close program and restore screen address and resolution
	move.l	logical_screen,-(sp)
	move.l	physical_screen,-(sp)
	move.w	#5,-(sp)
	trap		#14
	lea		12(sp),sp

	move.l	stack,-(sp) ;user mode
	move.w	#$20,-(sp)
	trap		#1
	addq.l	#6,sp

	clr.w		-(sp) ;terminate
	trap		#1

set_screen:
	move.w	#2,-(sp) ;store the current screen state
 	trap	#14
	addq.l	#2,sp
	move.l	d0,physical_screen
	move.w	#3,-(sp)
	trap	#14
	addq.l	#2,sp
	move.l	d0,logical_screen
	move.w	#4,-(sp)
	trap	#14
	addq.l	#2,sp
	move.w	d0,screen_resolution

	lea 	screenbuffer2+256,a0 ;set the ST to low resolution and own screen buffer
	move.l 	a0,d0
	and.l 	#$ffffff00,d0
	move.l 	d0,other

	lea	 screenbuffer1+256,a0 ;set the ST to low resolution and own screen buffer
	move.l 	a0,d0
	and.l 	#$ffffff00,d0
	move.l 	d0,current

	rts
	
set_supervisor_mode
		clr.l		-(sp) ;supervisor mode
		move.w	#$20,-(sp)
		trap		#1
		addq.l	#6,sp
		move.l	d0,stack
	rts

set_screen_buffers:
	lea	screenyposbuffer1,a1 ; ybuffer1 memory address
	move.l 	a1,currentybuffer ; store ybuffer1 address 
	move.l 	current,a3 ; move current address
	move.l 	#400,d0
.screen_buffer1
		move.l 	a3,(a1)+
		lea 	80(a3),a3
		dbf	d0,.screen_buffer1

	lea	screenyposbuffer2,a2 ; ybuffer2 memory address
	move.l 	a2,otherybuffer ; store ybuffer2 address
	move.l 	other,a4 ; move current address
	move.l 	#400,d0
.screen_buffer2
		move.l 	a4,(a2)+
		lea 	80(a4),a4
		dbf	d0,.screen_buffer2
	rts

clear_block	MACRO
		movem.l d0-d7/a0-a6,(\1)*60(a7)
		movem.l d0-d7/a0-a6,(\1+1)*60(a7)
		movem.l d0-d7/a0-a6,(\1+2)*60(a7)
		movem.l d0-d7/a0-a6,(\1+3)*60(a7)
		movem.l d0-d7/a0-a6,(\1+4)*60(a7)
		movem.l d0-d7/a0-a6,(\1+5)*60(a7)
		movem.l d0-d7/a0-a6,(\1+6)*60(a7)
		movem.l d0-d7/a0-a6,(\1+7)*60(a7)
		movem.l d0-d7/a0-a6,(\1+8)*60(a7)
		movem.l d0-d7/a0-a6,(\1+9)*60(a7)
 	ENDM

stack_pointer_store_usp MACRO
	move.w 	#$2700,sr 							; disable interrupts
	move.l 	usp,a0
	move.l 	a0,-(sp) 							; store usp
	move.l 	sp,the_stack_pointer 	; store sp
	ENDM

stack_pointer_restore_usp MACRO
	move.l 	the_stack_pointer,sp 	; restore sp
	move.l 	(sp)+,a0
	move.l 	a0,usp		 							; restore usp
	move.	w #$2300,sr 							; enable interrupts
	ENDM

stack_pointer_store MACRO
	move.w 	#$2700,sr 							; disable interrupts
	move.l 	sp,the_stack_pointer 	; store sp
	ENDM

stack_pointer_restore MACRO
	move.l 	the_stack_pointer,sp 	; restore sp
	move.w 	#$2300,sr 							; enable interrupts
	ENDM

clear:
	stack_pointer_store
	moveq.l	#0,d0
	move.l 	d0,d1
	move.l 	d0,d2
	move.l 	d0,d3
	move.l 	d0,d4
	move.l 	d0,d5
	move.l 	d0,d6
	move.l 	d0,d7
	move.l 	d0,a0
	move.l 	d0,a1
	move.l 	d0,a2
	move.l 	d0,a3
	move.l 	d0,a4
	move.l 	d0,a5
	move.l 	d0,a6

	move.l 	currentybuffer,a7	; address of screenybuffer
	move.l 	(a7),a7 		; screen

	clear_block 0
	clear_block 10
	clear_block 20
	clear_block 30
	clear_block 40
	clear_block 50
	clear_block 60
	clear_block 70
	clear_block 80
	clear_block 90
	clear_block 100
	clear_block 110
	clear_block 120
	clear_block 130
	clear_block 140
	clear_block 150
	clear_block 160
	clear_block 170
	clear_block 180
	clear_block 190
	clear_block 200
	clear_block 210
	clear_block 220
	clear_block 230
	clear_block 240
	clear_block 250
	clear_block 260
	clear_block 270
	clear_block 280
	clear_block 290
	clear_block 300
	clear_block 310
	clear_block 320
	clear_block 330
	clear_block 340
	clear_block 350
	clear_block 360
	clear_block 370
	clear_block 380
	clear_block 390
	clear_block 400
	clear_block 410
	clear_block 420
	clear_block 430
	clear_block 440
	clear_block 450
	clear_block 460
	clear_block 470
	clear_block 480
	clear_block 490
	clear_block 500
	clear_block 510
	clear_block 520
	clear_block 530
;	clear_block 540
;	clear_block 550
;	clear_block 560
;	clear_block 570
	stack_pointer_restore
	rts


keyboard:
	cmp.b 	#31,$fffffc02.w	
	bne.s	.kb_0
		addq.w	#7,zoffset
.kb_0
	cmp.b 	#32,$fffffc02.w	
	bne.s	.kb_1
		subq.w	#7,zoffset
.kb_1
	cmp.b 	#33,$fffffc02.w	
	bne.s	.kb_2
		addq.w	#7,xoffset
.kb_2
	cmp.b 	#34,$fffffc02.w	
	bne.s	.kb_3
		subq.w	#7,xoffset
.kb_3
	cmp.b 	#35,$fffffc02.w	
	bne.s	.kb_4
		addq.w	#7,yoffset
.kb_4
	cmp.b 	#36,$fffffc02.w	
	bne.s	.kb_5
		subq.w	#7,yoffset
.kb_5
	cmp.b 	#57,$fffffc02.w
	bne.s	.kb_6
		addq.b	#1,exit
.kb_6
 rts
 

line:
	move.l 	currentybuffer,a0	; address of screenybuffer
	lea 	COL02,a3
	lea 	COL03,a6

;	addq.w #1,d2
;	addq.w #1,d7
;	addq.w #1,d0
;	addq.w #1,d1

	cmp.w d2,d7 	; is vs le ve?
	bcc.s .vp 	; yes
.vn: 			; vs is gt ve
	cmp.w d1,d0	; is hs le he?
	bcc line_np 	; yes
	bra.s line_nn	; hs is gt he
.vp:			; vs is le ve
	cmp.w d1,d0 	; is hs le he?
	bcc.s line_pp 	; yes
	bra line_pn	; hs is gt heo


line_nn:
	exg 	d0,d1
	exg 	d2,d7
	
line_pp:
	move.w 	d0,d4
	move.w 	d7,d3
	sub.w 	d1,d0 	; d0=xend - d1=xstart =d0
	sub.w 	d2,d7 	; d1=yend - d7=ystart =d7

	cmp.w 	d0,d7
	bcc.s	.line_v_pp


.line_h_pp:
	addq.w 	#1,d0
	swap 	d7
	beq.s	.line_hs
		divu.w 	d0,d7 	; divide ydiff by xdiff ; source / dest
.line_hs:
	lsl.w 	#2,d3			; ver end *4
	move.l 	(a0,d3.w),a1 		; a1 = screen
	lsl.w 	#2,d2			; ver start *4
	move.l 	(a0,d2.w),a0 		; a0 = screen

	add.w 	d1,d1 ; hor start *2 - change
	move.w 	d1,a5
	add.w 	d4,d4 ; hor end *2 - change
	move.w 	d4,a4

	lsr.w 	#1,d0
;	moveq.w #0,d1

.line_hloop
	add.w 	d7,d1		; add hor frac to hor count
	bcc.s	.line_hnext
		lea	 80(a0),a0	; next ver
		lea	 -80(a1),a1	; next ver

.line_hnext
	lea	2(a5),a5	; next hor
	lea	-2(a4),a4	; next hor

	move.w 	(a6,a5.w),d3	; get screen loc
	move.w 	(a3,a5.w),d2	; get or
	or.w 	d2,(a0,d3.w)	; or screen

	move.w 	(a6,a4.w),d3
	move.w 	(a3,a4.w),d2
	or.w 	d2,(a1,d3.w)
	
	dbra	d0,.line_hloop
	rts

	
.line_v_pp:
	addq.w 	#1,d7
	swap 	d0
	beq.s 	.line_vs
		divu.w 	d7,d0 	; divide ydiff by xdiff ; source / dest
.line_vs:
	lsl.w 	#2,d3		; ver end *4
	move.l 	(a0,d3.w),a1 	; a1 = screen
	lsl.w 	#2,d2		; ver start *4
	move.l 	(a0,d2.w),a0 	; a0 = screen

	add.w 	d1,d1 	; hor start *2 - change
	move.w 	d1,a5
	add.w 	d4,d4 	; hor end *2 - change
	move.w 	d4,a4

	move.w 	(a6,a5.w),d3	; get screen loc
	move.w 	(a3,a5.w),d2	; get or
	move.w 	(a6,a4.w),d5
	move.w 	(a3,a4.w),d4

	lsr.w 	#1,d7
;	moveq.w #0,d1

.line_vloop
	add.w 	d0,d1	; add hor frac to hor count
	bcc.s 	.line_vnext
		lea	2(a5),a5	; next hor
		lea	-2(a4),a4	; next hor
		move.w 	(a6,a5.w),d3	; get screen loc
		move.w 	(a3,a5.w),d2	; get or
		move.w 	(a6,a4.w),d5
		move.w 	(a3,a4.w),d4

.line_vnext
	or.w 	d2,(a0,d3.w)	; or screen
	or.w 	d4,(a1,d5.w)

	lea	80(a0),a0	; next ver
	lea	 -80(a1),a1	; next ver

	dbra	d7,.line_vloop
	rts


line_np:
	exg 	d0,d1
	exg 	d2,d7
	
line_pn:
	move.w 	d1,d4
	move.w 	d7,d3
	sub.w 	d0,d1 	; d0=xend - d1=xstart =d0
	sub.w 	d2,d7 	; d1=yend - d7=ystart =d7

	cmp.w 	d1,d7
	bcc.s 	.line_v_pn

.line_h_pn:
	addq.w 	#1,d1
	swap 	d7
	beq.s 	.line_hs
		divu.w 	d1,d7 	; divide ydiff by xdiff ; source / dest
.line_hs:
	lsl.w 	#2,d2		; ver end *4
	move.l 	(a0,d2.w),a1 	; a1 = screen
	lsl.w 	#2,d3		; ver start *4
	move.l 	(a0,d3.w),a0 	; a0 = screen

	add.w 	d0,d0
	move.w 	d0,a5
	add.w 	d4,d4
	move.w 	d4,a4		; hor end *16

	lsr.w 	#1,d1
;	moveq.w #0,d0

.line_hloop
	add.w 	d7,d0	; add hor frac to hor count
	bcc.s 	.line_hnext
		lea 	-80(a0),a0	; next ver
		lea 	80(a1),a1	; next ver

.line_hnext
	lea 	2(a5),a5	; next hor
	lea 	-2(a4),a4	; next hor

	move.w 	(a6,a5.w),d3	; get screen loc
	move.w 	(a3,a5.w),d2	; get or
	or.w 	d2,(a0,d3.w)	; or screen

	move.w 	(a6,a4.w),d3
	move.w 	(a3,a4.w),d2
	or.w 	d2,(a1,d3.w)

	dbra	d1,.line_hloop
	rts


.line_v_pn:
	addq.w 	#1,d7
	swap 	d1
	beq.s 	.line_vs
		divu.w 	d7,d1 	; divide ydiff by xdiff ; source / dest
.line_vs:
	lsl.w 	#2,d2		; ver end *4
	move.l 	(a0,d2.w),a1 	; a1 = screen
	lsl.w 	#2,d3		; ver start *4
	move.l 	(a0,d3.w),a0 	; a0 = screen

	add.w 	d0,d0
	move.w 	d0,a5
	add.w 	d4,d4
	move.w 	d4,a4		; hor end *16

	move.w 	(a6,a5.w),d3	; get screen loc
	move.w 	(a3,a5.w),d2	; get or
	move.w 	(a6,a4.w),d5
	move.w 	(a3,a4.w),d4

	lsr.w 	#1,d7
;	moveq.w #0,d0

.line_vloop
	add.w 	d1,d0	; add hor frac to hor count
	bcc.s 	.line_vnext
		lea 	2(a5),a5	; next hor
		lea 	-2(a4),a4	; next hor
		move.w 	(a6,a5.w),d3	; get screen loc
		move.w 	(a3,a5.w),d2	; get or
		move.w 	(a6,a4.w),d5
		move.w 	(a3,a4.w),d4

.line_vnext
	or.w 	d2,(a0,d3.w)	; or screen
	or.w 	d4,(a1,d5.w)

	lea 	-80(a0),a0	; next ver
	lea 	80(a1),a1	; next ver

	dbra	d7,.line_vloop
	rts


build_rotation_matrix:
;;	addq.b	#1,otheta+1
;;	addq.b	#2,ophi+1
;;	addq.b	#3,ogamma+1

	lea	sintab,a4
	lea	costab,a5

	move.w	otheta,d1
	add.w	d1,d1
	move.w	(a4,d1.w),stheta
	move.w	(a5,d1.w),ctheta

	move.w	ophi,d1
	add.w	d1,d1
	move.w	(a4,d1.w),sphi
	move.w	(a5,d1.w),cphi

	move.w	ogamma,d1
	add.w	d1,d1
	move.w	(a4,d1.w),sgamma
	move.w	(a5,d1.w),cgamma

;	lea	stheta,a0	; sin theta
;	lea	ctheta,a1	; cos theta 
;	lea	sphi,a2		; sin phi
;	lea	cphi,a3		; cos phi
;	lea	sgamma,a4	; sin gamma
;	lea	cgamma,a5	; cos gamma

 rts
	lea	precalculs,a6

.x_x0:
	move.w	(a3),d0 	; cos phi
	muls		(a5),d0	; cos gamma
	lsl.l		#2,d0
	swap	d0
	move.w	d0,(a6)+

.y_x0:
	move.w	(a3),d0		; cos phi
	muls		(a4),d0	; sin gamma
	neg.l		d0
	lsl.l		#2,d0
	swap	d0
	move.w	d0,(a6)+

.z_x0:
	move.w	(a2),(a6)+	; sin phi

.x_y0:
	move.w	(a1),d0	; cos theta
	muls	(a4),d0	; sin gamma
	move.w	(a0),d1	; sin theta
	muls	(a2),d1	; sin phi
	lsl.l	#2,d1
	swap	d1
	muls	(a5),d1	; cos gamma
	add.l	d1,d0
	lsl.l	#2,d0
	swap	d0
	move.w	d0,(a6)+

.y_y0:
	move.w	(a1),d0	; cos theta
	muls	(a5),d0	; cos gamma
	move.w	(a0),d1	; sin theta
	muls	(a2),d1	; sin phi
	lsl.l	#2,d1
	swap	d1
	muls	(a4),d1	; sin gamma
	sub.l	d1,d0
	lsl.l	#2,d0
	swap	d0
	move.w	d0,(a6)+

.z_y0:
	move.w	(a0),d0	; sin theta
	muls	(a3),d0	; cos phi
	neg.l	d0
	lsl.l	#2,d0
	swap	d0
	move.w	d0,(a6)+

.x_z0:
	move.w	(a0),d0	; sin theta
	muls	(a4),d0	; sin gamma
	move.w	(a1),d1	; cos theta
	muls	(a2),d1	; sin phi
	lsl.l	#2,d1
	swap	d1
	muls	(a5),d1	; cos gamma
	sub.l	d1,d0
	lsl.l	#2,d0
	swap	d0
	move.w	d0,(a6)+

.y_z0:
	move.w	(a0),d0	; sin theta
	muls	(a5),d0	; cos gamma
	move.w	(a1),d1	; cos theta
	muls	(a2),d1	; sin phi
	lsl.l	#2,d1
	swap	d1
	muls	(a4),d1	; sin gamma
	add.l	d1,d0
	lsl.l	#2,d0
	swap	d0
	move.w	d0,(a6)+

.z_z0:
	move.w	(a1),d0	; cos theta
	muls	(a3),d0	; cos phi
	lsl.l	#2,d0
	swap	d0
	move.w	d0,(a6)
	rts
	
RotatePoint	MACRO
	movem.l 	(a0),d0/d1/d2
	lea	precalculs,a6

	muls	(a6)+,d0
	muls	(a6)+,d1
	muls	(a6)+,d2
	add.l	d1,d0
	add.l	d2,d0
	move.l	d0,d3	; x0

	movem.l (a0),d0/d1/d2
	muls	(a6)+,d0
	muls	(a6)+,d1
	muls	(a6)+,d2
	add.l	d1,d0
	add.l	d2,d0
	move.l	d0,d4	; y0

	movem.l (a0),d0/d1/d2
	muls	(a6)+,d0
	muls	(a6)+,d1
	muls	(a6)+,d2
	add.l	d1,d0
	add.l	d2,d0
	lsl.l	#2,d0
	swap	d0
	move.l	d0,d5	; z0

	swap	d5
	clr.w	d5
	swap	d5
;	asr.l	#6,d3
;	asr.l	#6,d4

	ENDM

RotatePoint
	move.w	d0,d3
	move.w	d1,d4
	move.w	d2,d5

	bsr	RotateX
	bsr	RotateY
	bsr	RotateZ

	rts

AddOffsets	MACRO
	add.w	zoffset,d5
	add.w	xoffset,d4
	add.w	yoffset,d3	
	ENDM

PerspectivePoint
;	swap	d5 ; needed for gt 32767 z
;	clr.w	d5
;	swap	d5
	ext.l	d5
	add.w	#FOCUS_Z,d5
	ext.l	d3
	lsl.l	#FOCUS_XY,d3
	ext.l	d4
	lsl.l	#FOCUS_XY,d4
	divs	d5,d3
	divs	d5,d4
	add.w	#SCREEN_HOR_MIDDLE,d3 ; screen middle 
	add.w	#SCREEN_VER_MIDDLE,d4 ; screen middle 
	rts

CalcClipCode
	moveq.b	#0,d5	; clear clipcodes
	tst.w	d4
	bpl.s	.right_test
		moveq.b	#TOP_CC,d5
		bra.s	.hor_test_end
.right_test:
	cmp.w	#BOTTOM_EDGE,d4
	ble.s	.hor_test_end
		moveq.b	#BOTTOM_CC,d5
.hor_test_end:
	tst.w	d3
	bpl.s 	.bottom_test
		or.b	#LEFT_CC,d5
		rts
.bottom_test:
	cmp.w	#RIGHT_EDGE,d3
	ble.s	.ver_test_end
		or.b	#RIGHT_CC,d5
.ver_test_end:
	rts
	
; a0 = point list
; a1 = line list
; d7 = point count
; d1 = line count
	
draw_object:
	movem.l	d1/a1,-(sp)	; put line details on stack
	
	lea	rotated_point,a1		; store rotated point
	lea	perspective_point,a2	; store perspective point
	lea	point_clip_code,a3	; store point clip code

	moveq.b	#0,d6 ; and clip code
	moveq.b	#31,d1 ; or clip code
	
			
rotate_point:
	movem.w 	(a0)+,d0/d1/d2	; get point
	bsr	RotatePoint	; do rotation
	AddOffsets		; add offsets
	movem.w	d3/d4/d5,(a1)	; store rotated point

	tst.w	d5		; if z is positive
	bpl.s	.rotate_point_front
			moveq.b	#BEHIND_CC,d5		;  set clip code to behind
			bra.s	.rotate_point_behind	
.rotate_point_front:
	bsr	PerspectivePoint	; do perspective
	movem.w	d3/d4,(a2)	; store perspective
	bsr	CalcClipCode	; calc clip code	

.rotate_point_behind:
	move.b	d5,(a3)+		; store clipcode

	and.b	d5,d1	; object and clip code
	or.b	d5,d6	; object or clip code

	lea	8(a1),a1
	lea	4(a2),a2
	dbf	d7,rotate_point

	movem.l (sp)+,d7/a0 ; get line details off stack
	
	tst.b	d1			; if and_object_clip_code ne 0 all off one side so exit
	bne.s	.off_screen

	lea	perspective_point,a1
 
	tst.b	d6			; if or_object_clip_code eq 0 all on screen so no clip needed
	bne.s	.draw_clipped_object

.draw_lines_whole:
.draw_line_whole:
		movem.w	(a0)+,d5/d6
		movem.l 	d7/a0/a1,-(sp)	; put on stack
		lsl.w 	#2,d5
		movem.w	(a1,d5.w),d1/d2
		lsl.w 	#2,d6
		movem.w	(a1,d6.w),d7/d0
		bsr 	line
		movem.l 	(sp)+,d7/a0/a1 ; get off stack
	dbf	d7,.draw_line_whole
.off_screen:
	rts
	
.draw_clipped_object:

	lea	rotated_point,a5		; store rotated point
	lea	point_clip_code,a3	; get point clip code

.draw_line_clipped:
		movem.w	(a0)+,d5/d6
		move.b	(a3,d5.w),d0	; start clip code
		move.b	(a3,d6.w),d1	; end clip code
		move.b	d0,d2		; backup start clip code
		and.b	d1,d2		; both points off same side?
		bne.s	.draw_line_off	; yes so next line
		movem.l 	d7/a0/a1/a5/a3,-(sp)	; put on stack		
		move.b	d0,d2		; backup start clip code
		or.b	d1,d2		; either point off?
		bne.s	.draw_line_clip	; yes so clip line

		lsl.w 	#2,d5
		movem.w	(a1,d5.w),d1/d2
		lsl.w 	#2,d6
		movem.w	(a1,d6.w),d7/d0
.draw_clip_line:
		bsr 	line
.draw_line_next:
		movem.l 	(sp)+,d7/a0/a1/a5/a3 	; get off stack
.draw_line_off:		
	dbf	d7,.draw_line_clipped
 rts
 
.draw_line_clip:
	lsl.w 	#2,d5		; store perspective points
	movem.w	(a1,d5.w),A4/A3 	; move to a3/a4
	lsl.w 	#2,d6
	movem.w	(a1,d6.w),A1/A2 	; move to a1/a2
	
	move.w	d6,a6		; backup as required for behind
	move.w	d0,D6	; store clip codes
	move.w	d1,D7

.clip_behind_test:
	or.b	D7,d0	; or clip codes
	btst.l	#BEHIND_BIT_CC,d0	; off behind
	beq.s	.clip_right_test	; no		
		bsr	LineClipBehind	; yes
		move.b	D6,d0
		and.b	D7,d0		; and start cc with end cc
		bne	.draw_line_next	; both off same side
		move.b	D6,d0
		or.b	D7,d0		; or start cc with end cc
		beq	.clip_draw_test	; all on so draw line
		move.w	D6,d0	; get clip codes
		
.clip_right_test:
	or.b	D7,d0	; or clip codes
	btst.l	#RIGHT_BIT_CC,d0	; off right
	beq.s	.clip_left_test	; no		
		bsr	LineClipRight	; yes
		move.b	D6,d0
		and.b	D7,d0		; and start cc with end cc
		bne	.draw_line_next	; both off same side
		move.b	D6,d0
		or.b	D7,d0		; or start cc with end cc
		beq	.clip_draw_test	; all on so draw line
		move.w	D6,d0	; get clip codes

.clip_left_test:
	or.b	D7,d0	; or clip codes
	btst.l	#LEFT_BIT_CC,d0	; off left
	beq.s	.clip_bottom_test	; no
		bsr	LineClipLeft	; yes
		move.b	D6,d0
		and.b	D7,d0		; and start cc with end cc
		bne	.draw_line_next	; both off same side
		move.b	D6,d0
		or.b	D7,d0		; or start cc with end cc
		beq	.clip_draw_test	; all on so draw line
		move.w	D6,d0	; get clip codes

.clip_bottom_test:
	or.b	D7,d0	; or clip codes
	btst.l	#BOTTOM_BIT_CC,d0	; off bottom
	beq.s	.clip_top_test	; no		
		bsr	LineClipBottom	; yes
		move.b	D6,d0
		and.b	D7,d0		; and start cc with end cc
		bne	.draw_line_next	; both off same side
		move.b	D6,d0
		or.b	D7,d0		; or start cc with end cc
		beq	.clip_draw_test	; all on so draw line
		move.w	D6,d0	; get clip codes

.clip_top_test:
	or.b	D7,d0	; or clip codes
	btst.l	#TOP_BIT_CC,d0	; off top
	beq.s	.clip_end_test	; no
		bsr	LineClipTop	; yes
		move.b	D6,d0
		and.b	D7,d0		; and start cc with end cc
		bne	.draw_line_next	; both off same side
		move.b	D6,d0
		or.b	D7,d0		; or start cc with end cc
		beq	.clip_draw_test	; all on so draw line
	
.clip_end_test
	bra	.draw_line_next		; next line
	
.clip_draw_test:
	move.w	A3,d1
	move.w	A4,d2
	move.w	A1,d0
	move.w	A2,d7
	addq.w #1,d2
	addq.w #1,d7
	addq.w #1,d0
	addq.w #1,d1
	bra	.draw_clip_line	; draw line
  
LineClipBehind:
	add.w 	d5,d5			; get rotated points
	movem.w	(a5,d5.w),d2/d3/d4
	move.w	d2,srx
	move.w	d3,sry
	move.w	d4,srz
	
	add.w 	a6,a6
	movem.w	(a5,a6.w),d2/d3/d4
	move.w	d2,erx
	move.w	d3,ery
	move.w	d4,erz

	btst.l	#BEHIND_BIT_CC,d7	; end clip code is behind?
	beq.s	.behind_p1on_p2off ; no - bit is clear

.behind_p1off_p2on:
	move.w	srx,d0 ; z
	move.w	srz,d1 ; x
	move.w	erz,d2 ; x
	move.w	erx,d3 ; z
	bsr	ClipLeft
	move.w	d0,srx

	move.w	sry,d0 ; z
	move.w	srz,d1 ; y
	move.w	erz,d2 ; y
	move.w	ery,d3 ; z	,
	bsr	ClipLeft
	move.w	d0,sry

	moveq.l	#CLIP_Z,d5; z = 0
	move.w	sry,d4
	move.w	srx,d3	
	bsr	PerspectivePoint	; do perspective
	move.w	d3,a1		; store perspective
	move.w	d4,a2
	bsr	CalcClipCode	; calc clip code	
	move.b	D5,d7		; store clipcode
	rts
	
.behind_p1on_p2off:
 	move.w	erx,d0 ; z
	move.w	erz,d1 ; x
	move.w	srz,d2 ; x
	move.w	srx,d3	; z
	bsr	ClipLeft
	move.w	d0,erx

	move.w	ery,d0 ; z
	move.w	erz,d1 ; y
	move.w	srz,d2 ; y
	move.w	sry,d3 ; z	,
	bsr	ClipLeft
	move.w	d0,ery

	moveq.l	#CLIP_Z,d5; z = 0
	move.w	ery,d4
	move.w	erx,d3	
	bsr	PerspectivePoint	; do perspective
	move.w	d3,a3		; store perspective
	move.w	d4,a4
	bsr	CalcClipCode	; calc clip code	
	move.b	D5,d6		; store clipcode
	rts
	
LineClipRight:
	btst.l	#RIGHT_BIT_CC,d7	; end clip code is off right?
	beq.s	.right_p1on_p2off ; no - bit is clear
	
.right_p1off_p2on:
	move.w	A4,d0
	move.w	A3,d1
	move.w	A1,d2
	move.w	A2,d3	,
	move.w	#RIGHT_EDGE,d4
	bsr	ClipRight

	move.w	d0,A2
	move.w	#RIGHT_EDGE,d0
	move.w	d0,A1
	
	move.w	A2,d4
	move.w	A1,d3
	bsr	CalcClipCode
	move.w	d5,D7
	rts
	
.right_p1on_p2off:
	move.w	A2,d0
	move.w	A1,d1
	move.w	A3,d2
	move.w	A4,d3
	move.w	#RIGHT_EDGE,d4
	bsr.s	ClipRight

	move.w	d0,A4
	move.w	#RIGHT_EDGE,d0
	move.w	d0,A3

	move.w	A4,d4
	move.w	A3,d3
	bsr	CalcClipCode
	move.w	d5,D6
	rts
	
 ; d2 = xoff
 ; d1 = xon
 ; d3 = yoff
 ; d0 = yon
 
ClipRight:
	sub.w	d0,d3	; poff.y - pon.y (dv)
	sub.w	d1,d4	; rightedge - pon.x (onh)
	sub.w	d1,d2	; poff.x - pon.x (dh)
	muls.w	d4,d3
	divs.w	d2,d3
	add.w	d3,d0
	rts
	
LineClipLeft:
	btst.l	#LEFT_BIT_CC,d7	; end clip code is off left?
	beq.s	.left_p1on_p2off ; no - bit is clear
	
.left_p1off_p2on:
	move.w	A4,d0
	move.w	A3,d1
	move.w	A1,d2
	move.w	A2,d3	,
	bsr	ClipLeft

	move.w	d0,A2
	move.w	#LEFT_EDGE,A1
	
	move.w	A2,d4
	move.w	A1,d3
	bsr	CalcClipCode
	move.w	d5,D7
	rts
	
.left_p1on_p2off:
	move.w	A2,d0
	move.w	A1,d1
	move.w	A3,d2
	move.w	A4,d3
	bsr.s	ClipLeft

	move.w	d0,A4
	move.w	#LEFT_EDGE,A3

	move.w	A4,d4
	move.w	A3,d3
	bsr	CalcClipCode
	move.w	d5,D6
	rts
	
 ; d2 = xoff
 ; d1 = xon
 ; d3 = yoff
 ; d0 = yon
 
ClipLeft:
	sub.w	d0,d3	; poff.y - pon.y (dv)
	sub.w	d1,d2	; poff.x - pon.x (dh)
	muls.w	d1,d3
	divs.w	d2,d3
	sub.w	d3,d0
;	addq.w 	#1,d0
	rts	

LineClipBottom:
	btst.l	#BOTTOM_BIT_CC,d7	; end clip code is off right?
	beq.s	.bottom_p1on_p2off ; no - bit is clear
	
.bottom_p1off_p2on:
	move.w	A3,d0
	move.w	A4,d1
	move.w	A2,d2
	move.w	A1,d3	,
 	move.w	#BOTTOM_EDGE,d4
	bsr	ClipRight

	move.w	d0,A1
	move.w	#BOTTOM_EDGE,A2
	
	move.w	A2,d4
	move.w	A1,d3
	bsr	CalcClipCode
	move.w	d5,D7
	rts
	
.bottom_p1on_p2off:
	move.w	A1,d0
	move.w	A2,d1
	move.w	A4,d2
	move.w	A3,d3
 	move.w	#BOTTOM_EDGE,d4
	bsr	ClipRight

	move.w	d0,A3
	move.w	#BOTTOM_EDGE,A4

	move.w	A4,d4
	move.w	A3,d3
	bsr	CalcClipCode
	move.w	d5,D6
	rts

LineClipTop:
	btst.l	#TOP_BIT_CC,d7	; end clip code is off right?
	beq.s	.top_p1on_p2off ; no - bit is clear
	
.top_p1off_p2on:
	move.w	A3,d0
	move.w	A4,d1
	move.w	A2,d2
	move.w	A1,d3	,
 	bsr	ClipLeft

	move.w	d0,A1
	move.w	#TOP_EDGE,A2
	
	move.w	A2,d4
	move.w	A1,d3
	bsr	CalcClipCode
	move.w	d5,D7
	rts
	
.top_p1on_p2off:
	move.w	A1,d0
	move.w	A2,d1
	move.w	A4,d2
	move.w	A3,d3
	bsr	ClipLeft

	move.w	d0,A3
	move.w	#TOP_EDGE,A4

	move.w	A4,d4
	move.w	A3,d3
	bsr	CalcClipCode
	move.w	d5,D6
	rts
		
plotchar
	move.l 	currentybuffer,a0
	lsl.w	#2,d6
	move.l	(a0,d6.w),a0
	move.l	#$ffffffff,d6
	move	d6,(a0)
	rts

Rotate:

;rotate around x-axis:
;	y'' = y'*cos() + z'*sin()
;	z'' = y'*sin() - z'*cos()
	
RotateX:
	move.w	d1,d4
	muls.w	ctheta,d4 ; y*cos()
	add.l	d4,d4
	swap	d4

	move.w	d2,d5
	muls.w	stheta,d5	; z*sin()
	add.l	d5,d5
	swap	d5

	muls.w 	stheta,d1	 ; y*sin()
	add.l	d1,d1
	swap	d1

	muls.w	ctheta,d2	; z*cos()
	add.l	d2,d2
	swap	d2

	add.w	d5,d4 ; y = y*cos() + z*sin()  
	sub.w	d2,d1
	move.w	d1,d5 ; z = y*sin() - z*cos()

 rts

; rotate around y-axis:
;	x'' = x'*cos() + z*sin()
;	z'' = x'*sin() - z*cos()

RotateY:
	move.w	d3,d1
	muls.w	cphi,d3 ; x*cos()
	add.l	d3,d3
	swap	d3

	move.w	d5,d2
	muls.w	sphi,d5 ; z*sin()
	add.l	d5,d5
	swap	d5

	muls.w 	sphi,d1	 ; x*sin()
	add.l	d1,d1
	swap	d1

	muls.w	cphi,d2 ; z*cos()
	add.l	d2,d2
	swap	d2

	add.w	d5,d3 ; x = x*cos() + z*sin()
	sub.w	d2,d1
	move.w	d1,d5 ; z = x*sin() - z*cos()

	rts
	
;rotate around z-axis:
;	x'' = x*cos() + y*sin()
;	y'' = x*sin() - y*cos()

RotateZ:
	move.w	d3,d1
	muls.w	cgamma,d1 ; x*cos()
	add.l	d1,d1
	swap	d1

	move.w	d4,d2
	muls.w	sgamma,d2 ; y*sin()
	add.l	d2,d2
	swap	d2

	muls.w	cgamma,d4 ; y*cos()
	add.l	d4,d4
	swap	d4

	muls.w	sgamma,d3 ; x*sin()
	add.l	d3,d3
	swap	d3

	sub.w	d4,d3	; y = x*sin() - y*cos()
	move.w	d3,d4
	add.w	d2,d1	; x = x*cos() + y*sin()
	move.w	d1,d3

	rts

	
RSX	dc.w	0,0,0
REX	dc.w	0,0,0


 include sincos2.h

otheta	dc.w	60
ophi	dc.w	120
ogamma	dc.w	180

stheta	ds.w	1
ctheta	ds.w	1
sphi	ds.w	1
cphi	ds.w	1
sgamma	ds.w	1
cgamma	ds.w	1
	
precalculs	ds.w	18
		
	even 4 	
	
the_stack_pointer 	dc.l 0
stack			dc.l	0
physical_screen		dc.l	0
logical_screen		dc.l	0
screen_resolution		dc.w	0
current			dc.l	0
other			dc.l	0
currentybuffer 		dc.l 0
otherybuffer 		dc.l 0

objectlinelist:
	dc.w	0,1
	dc.w	1,3
	dc.w	3,2
	dc.w	2,0	
	dc.w	4,5
	dc.w	5,7
	dc.w	7,6
	dc.w	6,4
	dc.w	0,4
	dc.w	1,5
	dc.w	2,6
	dc.w	3,7

objectpointlist:
	dc.w -80,-80,-80
	dc.w -80,-80,+80
	dc.w -80,+80,-80
	dc.w -80,+80,+80
	dc.w +80,-80,-80
	dc.w +80,-80,+80
	dc.w +80,+80,-80
	dc.w +80,+80,+80

COL02:	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001
	dc.w $8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100,$0080,$0040,$0020,$0010,$0008,$0004,$0002,$0001

COL03:
	dc.w 16/8*0,16/8*0,16/8*0,16/8*0,16/8*0,16/8*0,16/8*0,16/8*0,16/8*0,16/8*0,16/8*0,16/8*0,16/8*0,16/8*0,16/8*0,16/8*0
	dc.w 16/8*1,16/8*1,16/8*1,16/8*1,16/8*1,16/8*1,16/8*1,16/8*1,16/8*1,16/8*1,16/8*1,16/8*1,16/8*1,16/8*1,16/8*1,16/8*1
	dc.w 16/8*2,16/8*2,16/8*2,16/8*2,16/8*2,16/8*2,16/8*2,16/8*2,16/8*2,16/8*2,16/8*2,16/8*2,16/8*2,16/8*2,16/8*2,16/8*2
	dc.w 16/8*3,16/8*3,16/8*3,16/8*3,16/8*3,16/8*3,16/8*3,16/8*3,16/8*3,16/8*3,16/8*3,16/8*3,16/8*3,16/8*3,16/8*3,16/8*3
	dc.w 16/8*4,16/8*4,16/8*4,16/8*4,16/8*4,16/8*4,16/8*4,16/8*4,16/8*4,16/8*4,16/8*4,16/8*4,16/8*4,16/8*4,16/8*4,16/8*4
	dc.w 16/8*5,16/8*5,16/8*5,16/8*5,16/8*5,16/8*5,16/8*5,16/8*5,16/8*5,16/8*5,16/8*5,16/8*5,16/8*5,16/8*5,16/8*5,16/8*5
	dc.w 16/8*6,16/8*6,16/8*6,16/8*6,16/8*6,16/8*6,16/8*6,16/8*6,16/8*6,16/8*6,16/8*6,16/8*6,16/8*6,16/8*6,16/8*6,16/8*6
	dc.w 16/8*7,16/8*7,16/8*7,16/8*7,16/8*7,16/8*7,16/8*7,16/8*7,16/8*7,16/8*7,16/8*7,16/8*7,16/8*7,16/8*7,16/8*7,16/8*7
	dc.w 16/8*8,16/8*8,16/8*8,16/8*8,16/8*8,16/8*8,16/8*8,16/8*8,16/8*8,16/8*8,16/8*8,16/8*8,16/8*8,16/8*8,16/8*8,16/8*8
	dc.w 16/8*9,16/8*9,16/8*9,16/8*9,16/8*9,16/8*9,16/8*9,16/8*9,16/8*9,16/8*9,16/8*9,16/8*9,16/8*9,16/8*9,16/8*9,16/8*9
	dc.w 16/8*10,16/8*10,16/8*10,16/8*10,16/8*10,16/8*10,16/8*10,16/8*10,16/8*10,16/8*10,16/8*10,16/8*10,16/8*10,16/8*10,16/8*10,16/8*10
	dc.w 16/8*11,16/8*11,16/8*11,16/8*11,16/8*11,16/8*11,16/8*11,16/8*11,16/8*11,16/8*11,16/8*11,16/8*11,16/8*11,16/8*11,16/8*11,16/8*11
	dc.w 16/8*12,16/8*12,16/8*12,16/8*12,16/8*12,16/8*12,16/8*12,16/8*12,16/8*12,16/8*12,16/8*12,16/8*12,16/8*12,16/8*12,16/8*12,16/8*12
	dc.w 16/8*13,16/8*13,16/8*13,16/8*13,16/8*13,16/8*13,16/8*13,16/8*13,16/8*13,16/8*13,16/8*13,16/8*13,16/8*13,16/8*13,16/8*13,16/8*13
	dc.w 16/8*14,16/8*14,16/8*14,16/8*14,16/8*14,16/8*14,16/8*14,16/8*14,16/8*14,16/8*14,16/8*14,16/8*14,16/8*14,16/8*14,16/8*14,16/8*14
	dc.w 16/8*15,16/8*15,16/8*15,16/8*15,16/8*15,16/8*15,16/8*15,16/8*15,16/8*15,16/8*15,16/8*15,16/8*15,16/8*15,16/8*15,16/8*15,16/8*15
	dc.w 16/8*16,16/8*16,16/8*16,16/8*16,16/8*16,16/8*16,16/8*16,16/8*16,16/8*16,16/8*16,16/8*16,16/8*16,16/8*16,16/8*16,16/8*16,16/8*16
	dc.w 16/8*17,16/8*17,16/8*17,16/8*17,16/8*17,16/8*17,16/8*17,16/8*17,16/8*17,16/8*17,16/8*17,16/8*17,16/8*17,16/8*17,16/8*17,16/8*17
	dc.w 16/8*18,16/8*18,16/8*18,16/8*18,16/8*18,16/8*18,16/8*18,16/8*18,16/8*18,16/8*18,16/8*18,16/8*18,16/8*18,16/8*18,16/8*18,16/8*18
	dc.w 16/8*19,16/8*19,16/8*19,16/8*19,16/8*19,16/8*19,16/8*19,16/8*19,16/8*19,16/8*19,16/8*19,16/8*19,16/8*19,16/8*19,16/8*19,16/8*19
	dc.w 16/8*20,16/8*20,16/8*20,16/8*20,16/8*20,16/8*20,16/8*20,16/8*20,16/8*20,16/8*20,16/8*20,16/8*20,16/8*20,16/8*20,16/8*20,16/8*20
	dc.w 16/8*21,16/8*21,16/8*21,16/8*21,16/8*21,16/8*21,16/8*21,16/8*21,16/8*21,16/8*21,16/8*21,16/8*21,16/8*21,16/8*21,16/8*21,16/8*21
	dc.w 16/8*22,16/8*22,16/8*22,16/8*22,16/8*22,16/8*22,16/8*22,16/8*22,16/8*22,16/8*22,16/8*22,16/8*22,16/8*22,16/8*22,16/8*22,16/8*22
	dc.w 16/8*23,16/8*23,16/8*23,16/8*23,16/8*23,16/8*23,16/8*23,16/8*23,16/8*23,16/8*23,16/8*23,16/8*23,16/8*23,16/8*23,16/8*23,16/8*23
	dc.w 16/8*24,16/8*24,16/8*24,16/8*24,16/8*24,16/8*24,16/8*24,16/8*24,16/8*24,16/8*24,16/8*24,16/8*24,16/8*24,16/8*24,16/8*24,16/8*24
	dc.w 16/8*25,16/8*25,16/8*25,16/8*25,16/8*25,16/8*25,16/8*25,16/8*25,16/8*25,16/8*25,16/8*25,16/8*25,16/8*25,16/8*25,16/8*25,16/8*25
	dc.w 16/8*26,16/8*26,16/8*26,16/8*26,16/8*26,16/8*26,16/8*26,16/8*26,16/8*26,16/8*26,16/8*26,16/8*26,16/8*26,16/8*26,16/8*26,16/8*26
	dc.w 16/8*27,16/8*27,16/8*27,16/8*27,16/8*27,16/8*27,16/8*27,16/8*27,16/8*27,16/8*27,16/8*27,16/8*27,16/8*27,16/8*27,16/8*27,16/8*27
	dc.w 16/8*28,16/8*28,16/8*28,16/8*28,16/8*28,16/8*28,16/8*28,16/8*28,16/8*28,16/8*28,16/8*28,16/8*28,16/8*28,16/8*28,16/8*28,16/8*28
	dc.w 16/8*29,16/8*29,16/8*29,16/8*29,16/8*29,16/8*29,16/8*29,16/8*29,16/8*29,16/8*29,16/8*29,16/8*29,16/8*29,16/8*29,16/8*29,16/8*29
	dc.w 16/8*30,16/8*30,16/8*30,16/8*30,16/8*30,16/8*30,16/8*30,16/8*30,16/8*30,16/8*30,16/8*30,16/8*30,16/8*30,16/8*30,16/8*30,16/8*30
	dc.w 16/8*31,16/8*31,16/8*31,16/8*31,16/8*31,16/8*31,16/8*31,16/8*31,16/8*31,16/8*31,16/8*31,16/8*31,16/8*31,16/8*31,16/8*31,16/8*31
	dc.w 16/8*32,16/8*32,16/8*32,16/8*32,16/8*32,16/8*32,16/8*32,16/8*32,16/8*32,16/8*32,16/8*32,16/8*32,16/8*32,16/8*32,16/8*32,16/8*32
	dc.w 16/8*33,16/8*33,16/8*33,16/8*33,16/8*33,16/8*33,16/8*33,16/8*33,16/8*33,16/8*33,16/8*33,16/8*33,16/8*33,16/8*33,16/8*33,16/8*33
	dc.w 16/8*34,16/8*34,16/8*34,16/8*34,16/8*34,16/8*34,16/8*34,16/8*34,16/8*34,16/8*34,16/8*34,16/8*34,16/8*34,16/8*34,16/8*34,16/8*34
	dc.w 16/8*35,16/8*35,16/8*35,16/8*35,16/8*35,16/8*35,16/8*35,16/8*35,16/8*35,16/8*35,16/8*35,16/8*35,16/8*35,16/8*35,16/8*35,16/8*35
	dc.w 16/8*36,16/8*36,16/8*36,16/8*36,16/8*36,16/8*36,16/8*36,16/8*36,16/8*36,16/8*36,16/8*36,16/8*36,16/8*36,16/8*36,16/8*36,16/8*36
	dc.w 16/8*37,16/8*37,16/8*37,16/8*37,16/8*37,16/8*37,16/8*37,16/8*37,16/8*37,16/8*37,16/8*37,16/8*37,16/8*37,16/8*37,16/8*37,16/8*37
	dc.w 16/8*38,16/8*38,16/8*38,16/8*38,16/8*38,16/8*38,16/8*38,16/8*38,16/8*38,16/8*38,16/8*38,16/8*38,16/8*38,16/8*38,16/8*38,16/8*38
	dc.w 16/8*39,16/8*39,16/8*39,16/8*39,16/8*39,16/8*39,16/8*39,16/8*39,16/8*39,16/8*39,16/8*39,16/8*39,16/8*39,16/8*39,16/8*39,16/8*39

screenbuffer1	ds.l 8192+256
screenbuffer2	ds.l 8192+256
screenyposbuffer1	ds.l 402
screenyposbuffer2	ds.l 402

rotated_point		ds.w 256*3 ; 256 rx-ry-rz points
perspective_point		ds.w 256*2 ; 256 px-py points
point_clip_code		ds.b 256		; clip codes for points list

xoffset	dc.w 10 ; v
yoffset	dc.w 80 ; h
zoffset	dc.w 100

srx	dc.w	0
sry	dc.w	0
srz	dc.w	0
erx	dc.w	0
ery	dc.w	0
erz	dc.w	0

exit	dc.b 0

end_of_program

; On each iteration around that game loop, based on the camera alpha (pitch), beta (roll), and gamma (yaw) angles, there is a heavy matrix of transform coefficients that gets calculated at $A320..$A4B1. If you have done a global search/replace on some of the math, you should be able to map that code to this calculation. Lots of zero page stuff here. Note that the alpha/beta/gamma is updated through the motion code, which you have probably discovered if you've got on to the joystick code. Note that angles in Mercenary are $000.$3FF, unlike what can be the more typical 0..359 degrees.
  ;  //  mx1= sin(gam)*sin(bet)*sin(alp) + cos(gam)*cos(alp)
   ; //  my1= -cos(bet)*sin(alp)
    ;//  mz1= sin(gam)*cos(alp) - cos(gam)*sin(bet)*sin(alp)
;
 ;   //  mx2= cos(gam)*sin(alp) - sin(gam)*sin(bet)*cos(alp)
  ;  //  my2= cos(bet)*cos(alp)
   ; //  mz2= -cos(gam)*sin(bet)*cos(alp) - sin(gam)*sin(alp)

; //  mx3 = cos(bet)*sin(gam)
 ;   //  my3 = sin(bet)
  ;  //  mz3 = cos(gam)*cos(bet)
; Then we hit the projection transformation. This is at $A767, which has some interesting matrix calculation to do: x"'=x*mx1 + y*my1 + z*mz1,  y"'=x*mx2 + y*my2 + z*mz2 and  z"'=x*mx3 + y*my3 + z*mz3. In this case x, y, z is the 3D coordinates of the vertex of the thing being drawn (e.g. object, structure, ...) while mx1, my1, mz1 is the camera 3D rotation factor calculated for the current game loop iteration. Note that here the multiplication code is rolled out i.e. included inline rather than calling the math function - a classic space/time trade-off. Yes, even the call/rets were consuming too many cycles!


