store_and_install_screen_setup:
	move.w	#2,-(sp) 		;store the current screen state
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

	movem.l	$ff8240,d0-7 		;store the palette
	movem.l	d0-7,palette_store

	move.l 	#screenbuffer2+256,d0 	;low resolution and own screen buffer
	and.l 	#$ffffff00,d0
	move.l 	d0,other

	move.l 	#screenbuffer1+256,d0 	;low resolution and own screen buffer
	and.l 	#$ffffff00,d0
	move.l 	d0,current

	clr.w	-(sp)
	move.l	d0,-(sp)
	move.l	(sp),-(sp)
	move.w	#5,-(sp)			;make the resolution and screen address changes
	trap	#14
	lea	12(sp),sp

	movem.l	palette,d0-7 		;new palette
	movem.l	d0-7,$ff8240

	rts

SETUP_SCREEN_BUFFER:
	MOVE.W	#200,D0
.SCREEN_BUFFER	MOVE.L 	A2,(A1)+
		LEA 	160(A2),A2
		DBF	D0,.SCREEN_BUFFER
	RTS
	
setup_screen_buffers:
	LEA	screenyposbuffer1,A1 	; ybuffer1 memory address
	MOVE.L 	current,A2 		; move current address
	JSR	SETUP_SCREEN_BUFFER

	LEA	screenyposbuffer2,A1 	; ybuffer2 memory address
	MOVE.L 	other,A2 		; move current address
	JSR	SETUP_SCREEN_BUFFER

	rts

clear:	stack_pointer_store
	move.l 	#$12345678,d0
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
;	clear_block 510
;	clear_block 520
;	clear_block 530
;	clear_block 540
;	clear_block 550
;	clear_block 560
;	clear_block 570
	stack_pointer_restore
	rts
