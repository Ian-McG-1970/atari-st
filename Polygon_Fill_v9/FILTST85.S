; CODE

	include "macro_v1.s"

	clr.l	-(sp) ;supervisor mode
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,stack

	bsr	store_and_install_screen_setup
	bsr 	setup_screen_buffers

main_loop
		move.w	#$25,-(sp) ;wait for vbl
		trap	#14
		addq.l	#2,sp

		move.l	otherybuffer,d0 			;swap the screen y buffers
		move.l	currentybuffer,otherybuffer		
		move.l	d0,currentybuffer		

		move.l	other,d0 			;swap the screen buffers
		move.l	current,other		
		move.l	d0,current

		lsr.w   #8,d0							;move it directly into screen hardware registers.
		move.l  d0,$ffff8200.w

		bsr 	clear

		moveq.l #2,d7
		bsr 	movement

		move.w 	temp_colour,d6
		addq.w 	#1,d6
		move.w 	d6,temp_colour

		moveq.l 	#2,d7
		lsr.w 	#8,d6
		and.w 	#15,d6
		bsr 	fill

		cmp.b	#$39,$fffffc02.w	;Space key been pressed yet
		bne	main_loop


	move.w	screen_resolution,-(sp) ;close program and restore screen address and resolution
	move.l	logical_screen,-(sp)
	move.l	physical_screen,-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp

	movem.l	palette_store,d0-7 ;restore the palette
	movem.l	d0-7,$ff8240

	move.l	stack,-(sp) ;user mode
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp

	clr.w	-(sp) ;terminate
	trap	#1

	include "screen_v2.s"
	include "fill_v2.s"


movement:
	lea 	pointlist,a0
	lea	dirlist,a1
 
.moveloop
		movem.w 	(a0),d0-d1
 		movem.w 	(a1),d2-d3
		add.w 	d2,d0
		add.w 	d3,d1
		movem.w 	d0-d1,(a0)

		cmp.w 	#0,d0
		bne 	.testxl
			neg.w 	d2
.testxl
		cmp.w 	#0,d1
		bne 	.testyl
			neg.w 	d3
.testyl
 		cmp 	#199,d0
 		bne 	.testxr
			neg.w 	d2
.testxr
 		cmp 	#319,d1
		bne 	.testyr
			neg.w 	d3
.testyr
		movem.w 	d2-d3,(a1)
 
		lea 	4(a0),a0
 		lea 	4(a1),a1
 	dbra 	d7,.moveloop

	rts

; DATA

currentybuffer 		dc.l 	screenyposbuffer1
otherybuffer 		dc.l 	screenyposbuffer2

palette	dc.w $FFF,$000,$444,$999,$F00,$0F0,$00F,$440,$404,$044,$990,$909,$099,$FF0,$F0F,$0FF

	include "fill_tab_v1.s"
	include "line_tab_v1.s"

temp_colour dc.w 0

pointlist: 
 dc.w 20,10,10,310,190,219,0,0,0,0
; dc.l 192,178,188,132,22,41,0,0,0,0
; dc.l 190,180,190,130,20,39,0,0,0,0

dirlist: 
 dc.w +1,-1,+1,-1,+1,-1,+1,-1,+1,-1,+1,-1
; dc.l -1,1,1,-1,-1,-1,0,0,0,0

section bss

screenbuffer1 ds.l 8192+256
screenbuffer2 ds.l 8192+256
screenyposbuffer1 ds.l 202
screenyposbuffer2 ds.l 202

linetable:
	ds.l 400 ; line[0].left (addr0) / line[0].right (addr4) / line[1].left (addr8) / line[1].right (addr12)

physical_screen		ds.l	1
logical_screen		ds.l	1
the_stack_pointer 	ds.l 	1
stack			ds.l	1
current			ds.l	1
other			ds.l	1

palette_store		ds.w	16
screen_resolution		ds.w	1

end_of_program


; Draw_Object (object, pos, rotate)
; get points
; rotate
; translate
; perspective
; get faces
;  get face count
;  get face colour
;  build list of points from perspective points

;		moveq.L	#8-1,d7			; points
;		lea	objectpointlist,a0	; point list
;		moveq.L	#12-1,d1 ; #12-1,d1			;  #12-1
;		lea	objectlinelist,a1		; line list
;		bsr	draw_object


; a0 = point list
; a1 = line list
; d7 = point count
; d1 = line count
	
;draw_object:
;	movem.l	d1/a1,-(sp)	; put line details on stack
	
;	lea	rotated_point,a1		; store rotated point
;	lea	perspective_point,a2	; store perspective point
;	lea	point_clip_code,a3	; store point clip code

;	moveq.L	#0,d6 ; and clip code
;	moveq.L	#31,d1 ; or clip code
	
			
;rotate_point:
;	movem.w 	(a0)+,d0/d1/d2	; get point
;	bsr	RotatePoint	; do rotation
;	AddOffsets		; add offsets
;	movem.w	d3/d4/d5,(a1)	; store rotated point

;	tst.w	d5		; if z is positive
;	bpl.s	.rotate_point_front
;			moveq.L	#BEHIND_CC,d5		;  set clip code to behind
;			bra.s	.rotate_point_behind	
;.rotate_point_front:
;	bsr	PerspectivePoint	; do perspective
;	movem.w	d3/d4,(a2)	; store perspective
;	bsr	CalcClipCode	; calc clip code	

;.rotate_point_behind:
;	move.b	d5,(a3)+		; store clipcode

;	and.b	d5,d1	; object and clip code
;	or.b	d5,d6	; object or clip code

;	lea	8(a1),a1
;	lea	4(a2),a2
;	dbf	d7,rotate_point

;	movem.l (sp)+,d7/a0 ; get line details off stack
	
;	tst.b	d1			; if and_object_clip_code ne 0 all off one side so exit
;	bne.s	.off_screen

;	lea	perspective_point,a1
 
;	tst.b	d6			; if or_object_clip_code eq 0 all on screen so no clip needed
;	bne.s	.draw_clipped_object

;.draw_lines_whole:
;.draw_line_whole:
;		movem.w	(a0)+,d5/d6
;		movem.l 	d7/a0/a1,-(sp)	; put on stack
;		lsl.w 	#2,d5
;		movem.w	(a1,d5.w),d1/d2
;		lsl.w 	#2,d6
;		movem.w	(a1,d6.w),d7/d0
;		bsr 	line
;		movem.l 	(sp)+,d7/a0/a1 ; get off stack
;	dbf	d7,.draw_line_whole
;.off_screen:
;	rts

; RotatePoint
;	move.w	d0,d3
;	move.w	d1,d4
;	move.w	d2,d5

;	bsr	RotateX
;	bsr	RotateY
;	bsr	RotateZ

;	rts

;AddOffsets	MACRO
;	add.w	zoffset,d5
;	add.w	xoffset,d4
;	add.w	yoffset,d3	
;	ENDM

; PerspectivePoint
;;;;	swap	d5 ; needed for gt 32767 z
;;;;	clr.w	d5
;;;;	swap	d5
;	ext.l	d5
;	add.w	#FOCUS_Z,d5
;	ext.l	d3
;	lsl.l	#FOCUS_XY,d3
;	ext.l	d4
;	lsl.l	#FOCUS_XY,d4
;	divs	d5,d3
;	divs	d5,d4
;	add.w	#SCREEN_HOR_MIDDLE,d3 ; screen middle 
;	add.w	#SCREEN_VER_MIDDLE,d4 ; screen middle 
;	rts

; CalcClipCode
;	moveq.L	#0,d5	; clear clipcodes
;	tst.w	d4
;	bpl.s	.right_test
;		moveq.L	#TOP_CC,d5
;		bra.s	.hor_test_end
;.right_test:
;	cmp.w	#BOTTOM_EDGE,d4
;	ble.s	.hor_test_end
;		moveq.L	#BOTTOM_CC,d5
;.hor_test_end:
;	tst.w	d3
;	bpl.s 	.bottom_test
;		or.b	#LEFT_CC,d5
;		rts
;.bottom_test:
;	cmp.w	#RIGHT_EDGE,d3
;	ble.s	.ver_test_end
;		or.b	#RIGHT_CC,d5
;.ver_test_end:
;	rts

;	include "line_tab_v1.s"