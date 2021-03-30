
	opt	d-,o+ ; optimisation

	bsr	set_supervisor_mode
	bsr	set_screen
	bsr 	set_screen_buffers

main_loop
		move.w	#$25,-(sp) ;wait for vbl
		trap		#14
		addq.l	#2,sp

		move.l	otherybuffer,d0 			;swap the screen y buffers
		move.l	currentybuffer,otherybuffer		
		move.l	d0,currentybuffer		

		move.l	other,d0 			;swap the screen buffers
		move.l	current,other		
		move.l	d0,current

		lsr.w   	#8,d0							;move it directly into screen hardware registers.
		move.l 	d0,$ffff8200.w

		bsr 	clear
		bsr	precalc3d

;	bsr	rotate_project_points
	bsr 	rotation_points
	bsr	draw_lines	


		cmp.b 	#$39,$fffffc02.w	;Space key been pressed yet
		bne	main_loop


	move.w	screen_resolution,-(sp) ;close program and restore screen address and resolution
	move.l	logical_screen,-(sp)
	move.l	physical_screen,-(sp)
	move.w	#5,-(sp)
	trap		#14
	lea		12(sp),sp

	movem.l	palette_store,d0-7 ;restore the palette
	movem.l	d0-7,$ff8240

	move.l	stack,-(sp) ;user mode
	move.w	#$20,-(sp)
	trap		#1
	addq.l	#6,sp

	clr.w		-(sp) ;terminate
	trap		#1

set_screen:
	move.w	#2,-(sp) ;store the current screen state
 	trap		#14
	addq.l	#2,sp
	move.l	d0,physical_screen
	move.w	#3,-(sp)
	trap		#14
	addq.l	#2,sp
	move.l	d0,logical_screen
	move.w	#4,-(sp)
	trap		#14
	addq.l	#2,sp
	move.w	d0,screen_resolution

	movem.l	$ff8240,d0-7 ;also store the palette
	movem.l	d0-7,palette_store

	lea 	screenbuffer2+256,a0 ;set the ST to low resolution and own screen buffer
	move.l 	a0,d0
	and.l 	#$ffffff00,d0
	move.l 	d0,other

	lea	 screenbuffer1+256,a0 ;set the ST to low resolution and own screen buffer
	move.l 	a0,d0
	and.l 	#$ffffff00,d0
	move.l 	d0,current

	clr.w		-(sp)
	move.l	d0,-(sp)
	move.l	(sp),-(sp)
	move.w	#5,-(sp)		;make the resolution and screen address changes
	trap		#14
	lea		12(sp),sp

	movem.l	palette,d0-7 ;new palette
	movem.l	d0-7,$ff8240

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
	moveq.l 	#200,d0
.screen_buffer1
		move.l 	a3,(a1)+
		lea 	160(a3),a3
		dbf	d0,.screen_buffer1

	lea	screenyposbuffer2,a2 ; ybuffer2 memory address
	move.l 	a2,otherybuffer ; store ybuffer2 address
	move.l 	other,a4 ; move current address
	moveq.l 	#200,d0
.screen_buffer2
		move.l 	a4,(a2)+
		lea 	160(a4),a4
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
	move.l 	#$FF0000FFFF0000FF,d0
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
	move.l 	(a7),a7 					; screen

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
;	clear_block 510
;	clear_block 520
;	clear_block 530
;	clear_block 540
;	clear_block 550
;	clear_block 560
;	clear_block 570
	stack_pointer_restore
	rts


line:
	move.l 	currentybuffer,a0	; address of screenybuffer
	lea 	COL01,a3

	cmp.w d2,d7 	; is vs le ve?
	bcc.s .vp 		; yes
.vn: 				; vs is gt ve
	cmp.w d1,d0	; is hs le he?
	bcc line_np 	; yes
	bra.s line_nn	; hs is gt he
.vp:				; vs is le ve
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
	addq.w 	#1,d0 ;;
	swap 	d7
	beq.s	.line_hs
		divu.w 	d0,d7 	; divide ydiff by xdiff ; source / dest
.line_hs:
	lsl.w 		#2,d3			; ver end *4
	move.l 	(a0,d3.w),a1 		; a1 = screen
	lsl.w 		#2,d2			; ver start *4
	move.l 	(a0,d2.w),a0 		; a0 = screen

	lsl.w 		#4,d1
	move.w 	d1,a5
	lsl.w 		#4,d4
	move.w 	d4,a4			; hor end *16

	lsr.w 	#1,d0
	moveq.w 	#0,d1

.line_hloop
	add.w 	d7,d1	; add hor frac to hor count
	bcc.s	.line_hnext
		lea	 160(a0),a0	; next ver
		lea	 -160(a1),a1	; next ver

.line_hnext
	lea	 16(a5),a5	; next hor
	lea	 -16(a4),a4	; next hor

	movem.l 	(a3,a5.w),d2/d5/d6/a6; get and and 2 ors
	movem.l 	(a0,a6.w),d3/d4	; get screen
	and.l 	d2,d3	; 
	or.l 		d5,d3		; 	
	and.l 	d2,d4	; 
	or.l 		d6,d4		; 
	movem.l 	d3/d4,(a0,a6.w)	; put screen

	movem.l 	(a3,a4.w),d2/d5/d6/a6; get and and 2 ors
	movem.l 	(a1,a6.w),d3/d4	; get screen
	and.l 	d2,d3	; 
	or.l 		d5,d3		; 	
	and.l 	d2,d4	; 
	or.l 		d6,d4		; 
	movem.l 	d3/d4,(a1,a6.w)	; put screen

	dbeq		d0,.line_hloop
	rts
	
.line_v_pp:
	addq.w 	#1,d7
	swap 	d0
	beq.s 	.line_vs
		divu.w 	d7,d0 	; divide ydiff by xdiff ; source / dest
.line_vs:
	lsl.w 		#2,d2			; ver *4
	move.l 	(a0,d2.w),a0 		; a0 = screen

	lsl.w 		#4,d1			; hor *16
	move.w 	d1,a5

	movem.l 	(a3,a5.w),d2/d5/d6/a6	; get and and 2 ors
	moveq.w 	#0,d1

.line_vloop
	add.w 	d0,d1	; add hor frac to hor count
	bcc.s 	.line_vnext
		lea 	16(a5),a5	; next hor
		movem.l 	(a3,a5.w),d2/d5/d6/a6; get and and 2 ors

.line_vnext
	movem.l 	(a0,a6.w),d3/d4	; get screen
	and.l 	d2,d3	; 
	or.l 		d5,d3		; 	
	and.l 	d2,d4	; 
	or.l 		d6,d4		; 
	movem.l 	d3/d4,(a0,a6.w)	; put screen

	lea 	160(a0),a0	; next ver
	dbeq		d7,.line_vloop
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
	addq.w 	#1,d1 ;;
	swap 	d7
	beq.s 	.line_hs
		divu.w 	d1,d7 	; divide ydiff by xdiff ; source / dest
.line_hs:
	lsl.w 		#2,d2			; ver end *4
	move.l 	(a0,d2.w),a1 		; a1 = screen
	lsl.w 		#2,d3			; ver start *4
	move.l 	(a0,d3.w),a0 		; a0 = screen

	lsl.w 		#4,d0
	move.w 	d0,a5
	lsl.w 		#4,d4
	move.w 	d4,a4			; hor end *16

	lsr.w 	#1,d1
	moveq.w 	#0,d0

.line_hloop
	add.w 	d7,d0	; add hor frac to hor count
	bcc.s 	.line_hnext
		lea 	-160(a0),a0	; next ver
		lea 	160(a1),a1	; next ver

.line_hnext
	lea 	16(a5),a5	; next hor
	lea 	-16(a4),a4	; next hor

	movem.l 	(a3,a5.w),d2/d5/d6/a6; get and and 2 ors
	movem.l 	(a0,a6.w),d3/d4	; get screen
	and.l 	d2,d3	; 
	or.l 		d5,d3		; 	
	and.l 	d2,d4	; 
	or.l 		d6,d4		; 
	movem.l 	d3/d4,(a0,a6.w)	; put screen

	movem.l 	(a3,a4.w),d2/d5/d6/a6; get and and 2 ors
	movem.l 	(a1,a6.w),d3/d4	; get screen
	and.l 	d2,d3	; 
	or.l 		d5,d3		; 	
	and.l 	d2,d4	; 
	or.l 		d6,d4		; 
	movem.l 	d3/d4,(a1,a6.w)	; put screen

	dbeq		d1,.line_hloop
	rts
	
.line_v_pn:
	addq.w 	#1,d7 ;;
	swap 	d1
	beq.s 	.line_vs
		divu.w 	d7,d1 	; divide ydiff by xdiff ; source / dest
.line_vs:
	lsl.w 		#2,d3			; ver *4
	move.l 	(a0,d3.w),a0 		; a0 = screen

	lsl.w 		#4,d0			; hor *16
	move.w 	d0,a5

	movem.l 	(a3,a5.w),d2/d5/d6/a6	; get and and 2 ors
	moveq.w 	#0,d0

.line_vloop
	add.w 	d1,d0	; add hor frac to hor count
	bcc.s 	.line_vnext
		lea 	16(a5),a5	; next hor
		movem.l 	(a3,a5.w),d2/d5/d6/a6; get and and 2 ors

.line_vnext
	movem.l 	(a0,a6.w),d3/d4	; get screen
	and.l 	d2,d3	; 
	or.l 		d5,d3		; 	
	and.l 	d2,d4	; 
	or.l 		d6,d4		; 
	movem.l 	d3/d4,(a0,a6.w)	; put screen

	lea 	-160(a0),a0	; next ver
	dbeq		d7,.line_vloop
	rts
	

rotate_project_points:
	moveq.l #7,d7
	lea	objectpointlist,a0
	move.l 	#0,d3
	move.l 	#0,d4
	move.l 	#100+256,d5

	lea	projectedpointlist,a1
	move.l	#99,a6
	move.l	#159,a5
.rotate_point:
		movem.l 	(a0)+,d0/d1/d2
		add.l		d3,d0	; x+x offset
		add.l 	d4,d1	; y+y offset
		add.l		d5,d2	; z+z offset +256
		lsl.l		#8,d0	; x*256
		lsl.l		#8,d1	; y*256
		divs		d2,d0	; x/ z
		divs		d2,d1	; y / z

		add.w	a5,d0	; screen middle
		add.w 	a6,d1	; screen middle
		movem.w	d0/d1,(a1)

		lea 	4(a1),a1	; next
		dbeq		d7,.rotate_point
	rts


draw_lines:
	moveq.l	#11,d7 
	lea	projectedpointlist,a1
	lea	objectlinelist,a0

.draw_line:
		movem.w	(a0)+,d5/d6
		movem.l 	d7/a0/a1,-(sp)	; put on stack
		lsl.w 		#2,d5
		movem.w	(a1,d5.w),d1/d2
		lsl.w 		#2,d6
		movem.w	(a1,d6.w),d7/d0
		bsr 	line
		movem.l 	(sp)+,d7/a0/a1 ; get off stack
		dbeq		d7,.draw_line
	rts

clip_left: ; d0=sx / d1=ex / d2=sy / d3=ey / d4=line
	move.w d1,d5
	sub.w d0,d1 	; xd = xe - xs
	sub.w d2,d3 	; yd = ye - ys
	sub.w d5,d4 	; scale = xe - line

	muls d5,d4
	divs d3,d4 	; y = xd * scale / yd
	add.w d3,d4	; d4 = 
	rts


precalc3d:
	addq.w	#2,otheta
	cmp.w	#360,otheta
	bne.s	.ok1
		clr.w		otheta
.ok1:
	addq.w	#1,ophi
	cmp.w	#360,ophi
	bne.s	.ok2
		clr.w		ophi
.ok2:
	addq.w	#2,ogamma
	cmp.w	#360,ogamma
	bne.s	.ok3
		clr.w		ogamma
.ok3:	

	lea	sintable,a5

	move.w	otheta,d1
	add.w	d1,d1
	move.w	0(a5,d1.w),stheta
	add.w	#722,d1
	move.w	0(a5,d1.w),ctheta

	move.w	ophi,d1
	add.w	d1,d1
	move.w	0(a5,d1.w),sphi
	add.w	#722,d1
	move.w	0(a5,d1.w),cphi

	move.w	ogamma,d1
	add.w	d1,d1
	move.w	0(a5,d1.w),sgamma
	add.w	#722,d1
	move.w	0(a5,d1.w),cgamma

	lea	stheta,a0		; sin theta
	lea	ctheta,a1		; cos theta 
	lea	sphi,a2		; sin phi
	lea	cphi,a3		; cos phi
	lea	sgamma,a4	; sin gamma
	lea	cgamma,a5	; cos gamma

	lea	precalculs,a6

.x_x0:
	move.w	(a3),d0 	; cos phi
	muls		(a5),d0	; cos gamma
	lsl.l		#2,d0
	swap	d0
	move.w	d0,(a6)+

.y_x0:
	move.w	(a3),d0	; cos phi
	muls		(a4),d0	; sin gamma
	neg.l		d0
	lsl.l		#2,d0
	swap	d0
	move.w	d0,(a6)+

.z_x0:
	move.w	(a2),(a6)+	; sin phi

.x_y0:
	move.w	(a1),d0	; cos theta
	muls		(a4),d0	; sin gamma
	move.w	(a0),d1	; sin theta
	muls		(a2),d1	; sin phi
	lsl.l		#2,d1
	swap	d1
	muls		(a5),d1	; cos gamma
	add.l		d1,d0
	lsl.l		#2,d0
	swap	d0
	move.w	d0,(a6)+

.y_y0:
	move.w	(a1),d0	; cos theta
	muls		(a5),d0	; cos gamma
	move.w	(a0),d1	; sin theta
	muls		(a2),d1	; sin phi
	lsl.l		#2,d1
	swap	d1
	muls		(a4),d1	; sin gamma
	sub.l		d1,d0
	lsl.l		#2,d0
	swap	d0
	move.w	d0,(a6)+

.z_y0:
	move.w	(a0),d0	; sin theta
	muls		(a3),d0	; cos phi
	neg.l		d0
	lsl.l		#2,d0
	swap	d0
	move.w	d0,(a6)+

.x_z0:
	move.w	(a0),d0	; sin theta
	muls		(a4),d0	; sin gamma
	move.w	(a1),d1	; cos theta
	muls		(a2),d1	; sin phi
	lsl.l		#2,d1
	swap	d1
	muls		(a5),d1	; cos gamma
	sub.l		d1,d0
	lsl.l		#2,d0
	swap	d0
	move.w	d0,(a6)+

.y_z0:
	move.w	(a0),d0	; sin theta
	muls		(a5),d0	; cos gamma
	move.w	(a1),d1	; cos theta
	muls		(a2),d1	; sin phi
	lsl.l		#2,d1
	swap	d1
	muls		(a4),d1	; sin gamma
	add.l		d1,d0
	lsl.l		#2,d0
	swap	d0
	move.w	d0,(a6)+

.z_z0:
	move.w	(a1),d0	; cos theta
	muls		(a3),d0	; cos phi
	lsl.l		#2,d0
	swap	d0
	move.w	d0,(a6)
	rts

rotation_points:
	move.w	#8-1,d7
	lea	objectpointlist,a0
	lea	projectedpointlist,a1

rotate_point:
	lea	precalculs,a6
	movem.l 	(a0),d0/d1/d2

	muls		(a6)+,d0
	muls		(a6)+,d1
	muls		(a6)+,d2
	add.l		d1,d0
	add.l		d2,d0
	move.l	d0,d3	; x0

	movem.l 	(a0),d0/d1/d2
	muls		(a6)+,d0
	muls		(a6)+,d1
	muls		(a6)+,d2
	add.l		d1,d0
	add.l		d2,d0
	move.l	d0,d4	; y0

	movem.l 	(a0)+,d0/d1/d2
	muls		(a6)+,d0
	muls		(a6)+,d1
	muls		(a6)+,d2
	add.l		d1,d0
	add.l		d2,d0
	lsl.l		#2,d0
	swap	d0
	move.l	d0,d5	; z0

	swap	d5
	clr.w		d5
	swap	d5

	add.w	#200+256,d5 ; #31057,d5; 157 ;  z projection
	asr.l		#6,d3
	asr.l		#6,d4
	divs		d5,d3
	divs		d5,d4
	add.w	#160,d3 ; screen middle 160
	add.w	#100,d4 ; screen middle 100
	move.w	d3,(a1)+
	move.w	d4,(a1)+

	dbf	d7,rotate_point

	rts
	
sintable	incbin	trigotbl.bin

otheta	dc.w	0
ophi	dc.w	0
ogamma	dc.w	0

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
screen_resolution	dc.w	0
palette_store		ds.w	16
current			dc.l	0
other			dc.l	0
currentybuffer 		dc.l 0
otherybuffer 		dc.l 0

palette	dc.w $FFF,$000,$444,$999,$F00,$0F0,$00F,$440,$404,$044,$990,$909,$099,$FF0,$F0F,$FFF

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
	dc.l -80,-80,-80
	dc.l -80,-80,+80
	dc.l -80,+80,-80
	dc.l -80,+80,+80
	dc.l +80,-80,-80
	dc.l +80,-80,+80
	dc.l +80,+80,-80
	dc.l +80,+80,+80

	EVEN 4

COL01:
	dc.l $7fff7fff,$80008000,$80008000,0*8
	dc.l $bfffbfff,$40004000,$40004000,0*8
	dc.l $dfffdfff,$20002000,$20002000,0*8
	dc.l $efffefff,$10001000,$10001000,0*8
	dc.l $f7fff7ff,$08000800,$08000800,0*8
	dc.l $fbfffbff,$04000400,$04000400,0*8
	dc.l $fdfffdff,$02000200,$02000200,0*8
	dc.l $fefffeff,$01000100,$01000100,0*8
	dc.l $ff7fff7f,$00800080,$00800080,0*8
	dc.l $ffbfffbf,$00400040,$00400040,0*8
	dc.l $ffdfffdf,$00200020,$00200020,0*8
	dc.l $ffefffef,$00100010,$00100010,0*8
	dc.l $fff7fff7,$00080008,$00080008,0*8
	dc.l $fffbfffb,$00040004,$00040004,0*8
	dc.l $fffdfffd,$00020002,$00020002,0*8
	dc.l $fffefffe,$00010001,$00010001,0*8

	dc.l $7fff7fff,$80008000,$80008000,1*8
	dc.l $bfffbfff,$40004000,$40004000,1*8
	dc.l $dfffdfff,$20002000,$20002000,1*8
	dc.l $efffefff,$10001000,$10001000,1*8
	dc.l $f7fff7ff,$08000800,$08000800,1*8
	dc.l $fbfffbff,$04000400,$04000400,1*8
	dc.l $fdfffdff,$02000200,$02000200,1*8
	dc.l $fefffeff,$01000100,$01000100,1*8
	dc.l $ff7fff7f,$00800080,$00800080,1*8
	dc.l $ffbfffbf,$00400040,$00400040,1*8
	dc.l $ffdfffdf,$00200020,$00200020,1*8
	dc.l $ffefffef,$00100010,$00100010,1*8
	dc.l $fff7fff7,$00080008,$00080008,1*8
	dc.l $fffbfffb,$00040004,$00040004,1*8
	dc.l $fffdfffd,$00020002,$00020002,1*8
	dc.l $fffefffe,$00010001,$00010001,1*8

	dc.l $7fff7fff,$80008000,$80008000,2*8
	dc.l $bfffbfff,$40004000,$40004000,2*8
	dc.l $dfffdfff,$20002000,$20002000,2*8
	dc.l $efffefff,$10001000,$10001000,2*8
	dc.l $f7fff7ff,$08000800,$08000800,2*8
	dc.l $fbfffbff,$04000400,$04000400,2*8
	dc.l $fdfffdff,$02000200,$02000200,2*8
	dc.l $fefffeff,$01000100,$01000100,2*8
	dc.l $ff7fff7f,$00800080,$00800080,2*8
	dc.l $ffbfffbf,$00400040,$00400040,2*8
	dc.l $ffdfffdf,$00200020,$00200020,2*8
	dc.l $ffefffef,$00100010,$00100010,2*8
	dc.l $fff7fff7,$00080008,$00080008,2*8
	dc.l $fffbfffb,$00040004,$00040004,2*8
	dc.l $fffdfffd,$00020002,$00020002,2*8
	dc.l $fffefffe,$00010001,$00010001,2*8

	dc.l $7fff7fff,$80008000,$80008000,3*8
	dc.l $bfffbfff,$40004000,$40004000,3*8
	dc.l $dfffdfff,$20002000,$20002000,3*8
	dc.l $efffefff,$10001000,$10001000,3*8
	dc.l $f7fff7ff,$08000800,$08000800,3*8
	dc.l $fbfffbff,$04000400,$04000400,3*8
	dc.l $fdfffdff,$02000200,$02000200,3*8
	dc.l $fefffeff,$01000100,$01000100,3*8
	dc.l $ff7fff7f,$00800080,$00800080,3*8
	dc.l $ffbfffbf,$00400040,$00400040,3*8
	dc.l $ffdfffdf,$00200020,$00200020,3*8
	dc.l $ffefffef,$00100010,$00100010,3*8
	dc.l $fff7fff7,$00080008,$00080008,3*8
	dc.l $fffbfffb,$00040004,$00040004,3*8
	dc.l $fffdfffd,$00020002,$00020002,3*8
	dc.l $fffefffe,$00010001,$00010001,3*8

	dc.l $7fff7fff,$80008000,$80008000,4*8
	dc.l $bfffbfff,$40004000,$40004000,4*8
	dc.l $dfffdfff,$20002000,$20002000,4*8
	dc.l $efffefff,$10001000,$10001000,4*8
	dc.l $f7fff7ff,$08000800,$08000800,4*8
	dc.l $fbfffbff,$04000400,$04000400,4*8
	dc.l $fdfffdff,$02000200,$02000200,4*8
	dc.l $fefffeff,$01000100,$01000100,4*8
	dc.l $ff7fff7f,$00800080,$00800080,4*8
	dc.l $ffbfffbf,$00400040,$00400040,4*8
	dc.l $ffdfffdf,$00200020,$00200020,4*8
	dc.l $ffefffef,$00100010,$00100010,4*8
	dc.l $fff7fff7,$00080008,$00080008,4*8
	dc.l $fffbfffb,$00040004,$00040004,4*8
	dc.l $fffdfffd,$00020002,$00020002,4*8
	dc.l $fffefffe,$00010001,$00010001,4*8

	dc.l $7fff7fff,$80008000,$80008000,5*8
	dc.l $bfffbfff,$40004000,$40004000,5*8
	dc.l $dfffdfff,$20002000,$20002000,5*8
	dc.l $efffefff,$10001000,$10001000,5*8
	dc.l $f7fff7ff,$08000800,$08000800,5*8
	dc.l $fbfffbff,$04000400,$04000400,5*8
	dc.l $fdfffdff,$02000200,$02000200,5*8
	dc.l $fefffeff,$01000100,$01000100,5*8
	dc.l $ff7fff7f,$00800080,$00800080,5*8
	dc.l $ffbfffbf,$00400040,$00400040,5*8
	dc.l $ffdfffdf,$00200020,$00200020,5*8
	dc.l $ffefffef,$00100010,$00100010,5*8
	dc.l $fff7fff7,$00080008,$00080008,5*8
	dc.l $fffbfffb,$00040004,$00040004,5*8
	dc.l $fffdfffd,$00020002,$00020002,5*8
	dc.l $fffefffe,$00010001,$00010001,5*8
	
	dc.l $7fff7fff,$80008000,$80008000,6*8
	dc.l $bfffbfff,$40004000,$40004000,6*8
	dc.l $dfffdfff,$20002000,$20002000,6*8
	dc.l $efffefff,$10001000,$10001000,6*8
	dc.l $f7fff7ff,$08000800,$08000800,6*8
	dc.l $fbfffbff,$04000400,$04000400,6*8
	dc.l $fdfffdff,$02000200,$02000200,6*8
	dc.l $fefffeff,$01000100,$01000100,6*8
	dc.l $ff7fff7f,$00800080,$00800080,6*8
	dc.l $ffbfffbf,$00400040,$00400040,6*8
	dc.l $ffdfffdf,$00200020,$00200020,6*8
	dc.l $ffefffef,$00100010,$00100010,6*8
	dc.l $fff7fff7,$00080008,$00080008,6*8
	dc.l $fffbfffb,$00040004,$00040004,6*8
	dc.l $fffdfffd,$00020002,$00020002,6*8
	dc.l $fffefffe,$00010001,$00010001,6*8

	dc.l $7fff7fff,$80008000,$80008000,7*8
	dc.l $bfffbfff,$40004000,$40004000,7*8
	dc.l $dfffdfff,$20002000,$20002000,7*8
	dc.l $efffefff,$10001000,$10001000,7*8
	dc.l $f7fff7ff,$08000800,$08000800,7*8
	dc.l $fbfffbff,$04000400,$04000400,7*8
	dc.l $fdfffdff,$02000200,$02000200,7*8
	dc.l $fefffeff,$01000100,$01000100,7*8
	dc.l $ff7fff7f,$00800080,$00800080,7*8
	dc.l $ffbfffbf,$00400040,$00400040,7*8
	dc.l $ffdfffdf,$00200020,$00200020,7*8
	dc.l $ffefffef,$00100010,$00100010,7*8
	dc.l $fff7fff7,$00080008,$00080008,7*8
	dc.l $fffbfffb,$00040004,$00040004,7*8
	dc.l $fffdfffd,$00020002,$00020002,7*8
	dc.l $fffefffe,$00010001,$00010001,7*8

	dc.l $7fff7fff,$80008000,$80008000,8*8
	dc.l $bfffbfff,$40004000,$40004000,8*8
	dc.l $dfffdfff,$20002000,$20002000,8*8
	dc.l $efffefff,$10001000,$10001000,8*8
	dc.l $f7fff7ff,$08000800,$08000800,8*8
	dc.l $fbfffbff,$04000400,$04000400,8*8
	dc.l $fdfffdff,$02000200,$02000200,8*8
	dc.l $fefffeff,$01000100,$01000100,8*8
	dc.l $ff7fff7f,$00800080,$00800080,8*8
	dc.l $ffbfffbf,$00400040,$00400040,8*8
	dc.l $ffdfffdf,$00200020,$00200020,8*8
	dc.l $ffefffef,$00100010,$00100010,8*8
	dc.l $fff7fff7,$00080008,$00080008,8*8
	dc.l $fffbfffb,$00040004,$00040004,8*8
	dc.l $fffdfffd,$00020002,$00020002,8*8
	dc.l $fffefffe,$00010001,$00010001,8*8

	dc.l $7fff7fff,$80008000,$80008000,9*8
	dc.l $bfffbfff,$40004000,$40004000,9*8
	dc.l $dfffdfff,$20002000,$20002000,9*8
	dc.l $efffefff,$10001000,$10001000,9*8
	dc.l $f7fff7ff,$08000800,$08000800,9*8
	dc.l $fbfffbff,$04000400,$04000400,9*8
	dc.l $fdfffdff,$02000200,$02000200,9*8
	dc.l $fefffeff,$01000100,$01000100,9*8
	dc.l $ff7fff7f,$00800080,$00800080,9*8
	dc.l $ffbfffbf,$00400040,$00400040,9*8
	dc.l $ffdfffdf,$00200020,$00200020,9*8
	dc.l $ffefffef,$00100010,$00100010,9*8
	dc.l $fff7fff7,$00080008,$00080008,9*8
	dc.l $fffbfffb,$00040004,$00040004,9*8
	dc.l $fffdfffd,$00020002,$00020002,9*8
	dc.l $fffefffe,$00010001,$00010001,9*8


	dc.l $7fff7fff,$80008000,$80008000,10*8
	dc.l $bfffbfff,$40004000,$40004000,10*8
	dc.l $dfffdfff,$20002000,$20002000,10*8
	dc.l $efffefff,$10001000,$10001000,10*8
	dc.l $f7fff7ff,$08000800,$08000800,10*8
	dc.l $fbfffbff,$04000400,$04000400,10*8
	dc.l $fdfffdff,$02000200,$02000200,10*8
	dc.l $fefffeff,$01000100,$01000100,10*8
	dc.l $ff7fff7f,$00800080,$00800080,10*8
	dc.l $ffbfffbf,$00400040,$00400040,10*8
	dc.l $ffdfffdf,$00200020,$00200020,10*8
	dc.l $ffefffef,$00100010,$00100010,10*8
	dc.l $fff7fff7,$00080008,$00080008,10*8
	dc.l $fffbfffb,$00040004,$00040004,10*8
	dc.l $fffdfffd,$00020002,$00020002,10*8
	dc.l $fffefffe,$00010001,$00010001,10*8

	dc.l $7fff7fff,$80008000,$80008000,11*8
	dc.l $bfffbfff,$40004000,$40004000,11*8
	dc.l $dfffdfff,$20002000,$20002000,11*8
	dc.l $efffefff,$10001000,$10001000,11*8
	dc.l $f7fff7ff,$08000800,$08000800,11*8
	dc.l $fbfffbff,$04000400,$04000400,11*8
	dc.l $fdfffdff,$02000200,$02000200,11*8
	dc.l $fefffeff,$01000100,$01000100,11*8
	dc.l $ff7fff7f,$00800080,$00800080,11*8
	dc.l $ffbfffbf,$00400040,$00400040,11*8
	dc.l $ffdfffdf,$00200020,$00200020,11*8
	dc.l $ffefffef,$00100010,$00100010,11*8
	dc.l $fff7fff7,$00080008,$00080008,11*8
	dc.l $fffbfffb,$00040004,$00040004,11*8
	dc.l $fffdfffd,$00020002,$00020002,11*8
	dc.l $fffefffe,$00010001,$00010001,11*8

	dc.l $7fff7fff,$80008000,$80008000,12*8
	dc.l $bfffbfff,$40004000,$40004000,12*8
	dc.l $dfffdfff,$20002000,$20002000,12*8
	dc.l $efffefff,$10001000,$10001000,12*8
	dc.l $f7fff7ff,$08000800,$08000800,12*8
	dc.l $fbfffbff,$04000400,$04000400,12*8
	dc.l $fdfffdff,$02000200,$02000200,12*8
	dc.l $fefffeff,$01000100,$01000100,12*8
	dc.l $ff7fff7f,$00800080,$00800080,12*8
	dc.l $ffbfffbf,$00400040,$00400040,12*8
	dc.l $ffdfffdf,$00200020,$00200020,12*8
	dc.l $ffefffef,$00100010,$00100010,12*8
	dc.l $fff7fff7,$00080008,$00080008,12*8
	dc.l $fffbfffb,$00040004,$00040004,12*8
	dc.l $fffdfffd,$00020002,$00020002,12*8
	dc.l $fffefffe,$00010001,$00010001,12*8

	dc.l $7fff7fff,$80008000,$80008000,13*8
	dc.l $bfffbfff,$40004000,$40004000,13*8
	dc.l $dfffdfff,$20002000,$20002000,13*8
	dc.l $efffefff,$10001000,$10001000,13*8
	dc.l $f7fff7ff,$08000800,$08000800,13*8
	dc.l $fbfffbff,$04000400,$04000400,13*8
	dc.l $fdfffdff,$02000200,$02000200,13*8
	dc.l $fefffeff,$01000100,$01000100,13*8
	dc.l $ff7fff7f,$00800080,$00800080,13*8
	dc.l $ffbfffbf,$00400040,$00400040,13*8
	dc.l $ffdfffdf,$00200020,$00200020,13*8
	dc.l $ffefffef,$00100010,$00100010,13*8
	dc.l $fff7fff7,$00080008,$00080008,13*8
	dc.l $fffbfffb,$00040004,$00040004,13*8
	dc.l $fffdfffd,$00020002,$00020002,13*8
	dc.l $fffefffe,$00010001,$00010001,13*8

	dc.l $7fff7fff,$80008000,$80008000,14*8
	dc.l $bfffbfff,$40004000,$40004000,14*8
	dc.l $dfffdfff,$20002000,$20002000,14*8
	dc.l $efffefff,$10001000,$10001000,14*8
	dc.l $f7fff7ff,$08000800,$08000800,14*8
	dc.l $fbfffbff,$04000400,$04000400,14*8
	dc.l $fdfffdff,$02000200,$02000200,14*8
	dc.l $fefffeff,$01000100,$01000100,14*8
	dc.l $ff7fff7f,$00800080,$00800080,14*8
	dc.l $ffbfffbf,$00400040,$00400040,14*8
	dc.l $ffdfffdf,$00200020,$00200020,14*8
	dc.l $ffefffef,$00100010,$00100010,14*8
	dc.l $fff7fff7,$00080008,$00080008,14*8
	dc.l $fffbfffb,$00040004,$00040004,14*8
	dc.l $fffdfffd,$00020002,$00020002,14*8
	dc.l $fffefffe,$00010001,$00010001,14*8

	dc.l $7fff7fff,$80008000,$80008000,15*8
	dc.l $bfffbfff,$40004000,$40004000,15*8
	dc.l $dfffdfff,$20002000,$20002000,15*8
	dc.l $efffefff,$10001000,$10001000,15*8
	dc.l $f7fff7ff,$08000800,$08000800,15*8
	dc.l $fbfffbff,$04000400,$04000400,15*8
	dc.l $fdfffdff,$02000200,$02000200,15*8
	dc.l $fefffeff,$01000100,$01000100,15*8
	dc.l $ff7fff7f,$00800080,$00800080,15*8
	dc.l $ffbfffbf,$00400040,$00400040,15*8
	dc.l $ffdfffdf,$00200020,$00200020,15*8
	dc.l $ffefffef,$00100010,$00100010,15*8
	dc.l $fff7fff7,$00080008,$00080008,15*8
	dc.l $fffbfffb,$00040004,$00040004,15*8
	dc.l $fffdfffd,$00020002,$00020002,15*8
	dc.l $fffefffe,$00010001,$00010001,15*8
	
	dc.l $7fff7fff,$80008000,$80008000,16*8
	dc.l $bfffbfff,$40004000,$40004000,16*8
	dc.l $dfffdfff,$20002000,$20002000,16*8
	dc.l $efffefff,$10001000,$10001000,16*8
	dc.l $f7fff7ff,$08000800,$08000800,16*8
	dc.l $fbfffbff,$04000400,$04000400,16*8
	dc.l $fdfffdff,$02000200,$02000200,16*8
	dc.l $fefffeff,$01000100,$01000100,16*8
	dc.l $ff7fff7f,$00800080,$00800080,16*8
	dc.l $ffbfffbf,$00400040,$00400040,16*8
	dc.l $ffdfffdf,$00200020,$00200020,16*8
	dc.l $ffefffef,$00100010,$00100010,16*8
	dc.l $fff7fff7,$00080008,$00080008,16*8
	dc.l $fffbfffb,$00040004,$00040004,16*8
	dc.l $fffdfffd,$00020002,$00020002,16*8
	dc.l $fffefffe,$00010001,$00010001,16*8

	dc.l $7fff7fff,$80008000,$80008000,17*8
	dc.l $bfffbfff,$40004000,$40004000,17*8
	dc.l $dfffdfff,$20002000,$20002000,17*8
	dc.l $efffefff,$10001000,$10001000,17*8
	dc.l $f7fff7ff,$08000800,$08000800,17*8
	dc.l $fbfffbff,$04000400,$04000400,17*8
	dc.l $fdfffdff,$02000200,$02000200,17*8
	dc.l $fefffeff,$01000100,$01000100,17*8
	dc.l $ff7fff7f,$00800080,$00800080,17*8
	dc.l $ffbfffbf,$00400040,$00400040,17*8
	dc.l $ffdfffdf,$00200020,$00200020,17*8
	dc.l $ffefffef,$00100010,$00100010,17*8
	dc.l $fff7fff7,$00080008,$00080008,17*8
	dc.l $fffbfffb,$00040004,$00040004,17*8
	dc.l $fffdfffd,$00020002,$00020002,17*8
	dc.l $fffefffe,$00010001,$00010001,17*8

	dc.l $7fff7fff,$80008000,$80008000,18*8
	dc.l $bfffbfff,$40004000,$40004000,18*8
	dc.l $dfffdfff,$20002000,$20002000,18*8
	dc.l $efffefff,$10001000,$10001000,18*8
	dc.l $f7fff7ff,$08000800,$08000800,18*8
	dc.l $fbfffbff,$04000400,$04000400,18*8
	dc.l $fdfffdff,$02000200,$02000200,18*8
	dc.l $fefffeff,$01000100,$01000100,18*8
	dc.l $ff7fff7f,$00800080,$00800080,18*8
	dc.l $ffbfffbf,$00400040,$00400040,18*8
	dc.l $ffdfffdf,$00200020,$00200020,18*8
	dc.l $ffefffef,$00100010,$00100010,18*8
	dc.l $fff7fff7,$00080008,$00080008,18*8
	dc.l $fffbfffb,$00040004,$00040004,18*8
	dc.l $fffdfffd,$00020002,$00020002,18*8
	dc.l $fffefffe,$00010001,$00010001,18*8

	dc.l $7fff7fff,$80008000,$80008000,19*8
	dc.l $bfffbfff,$40004000,$40004000,19*8
	dc.l $dfffdfff,$20002000,$20002000,19*8
	dc.l $efffefff,$10001000,$10001000,19*8
	dc.l $f7fff7ff,$08000800,$08000800,19*8
	dc.l $fbfffbff,$04000400,$04000400,19*8
	dc.l $fdfffdff,$02000200,$02000200,19*8
	dc.l $fefffeff,$01000100,$01000100,19*8
	dc.l $ff7fff7f,$00800080,$00800080,19*8
	dc.l $ffbfffbf,$00400040,$00400040,19*8
	dc.l $ffdfffdf,$00200020,$00200020,19*8
	dc.l $ffefffef,$00100010,$00100010,19*8
	dc.l $fff7fff7,$00080008,$00080008,19*8
	dc.l $fffbfffb,$00040004,$00040004,19*8
	dc.l $fffdfffd,$00020002,$00020002,19*8
	dc.l $fffefffe,$00010001,$00010001,19*8
 
screenbuffer1	ds.l 8192+256
screenbuffer2	ds.l 8192+256
screenyposbuffer1	ds.l 202
screenyposbuffer2	ds.l 202

temp_colour	dc.w 0
projectedpointlist	ds.w 100

end_of_program



