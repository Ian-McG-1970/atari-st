	clr.l	-(sp) ;supervisor mode
	move.w	#$20,-(sp)
	trap	#1
	addq.l	#6,sp
	move.l	d0,stack

	bsr	store_and_install_screen_setup
	bsr setup_screen_buffers

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

store_and_install_screen_setup:
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

	movem.l	$ff8240,d0-7 ;also store the palette
	movem.l	d0-7,palette_store

	lea 	screenbuffer2+256,a0 ;set the ST to low resolution and own screen buffer
	move.l 	a0,d0
	and.l 	#$ffffff00,d0
	move.l 	d0,other

	lea 	screenbuffer1+256,a0 ;set the ST to low resolution and own screen buffer
	move.l 	a0,d0
	and.l 	#$ffffff00,d0
	move.l 	d0,current

	clr.w	-(sp)
	move.l	d0,-(sp)
	move.l	(sp),-(sp)
	move.w	#5,-(sp)		;make the resolution and screen address changes
	trap	#14
	lea	12(sp),sp

	movem.l	palette,d0-7 ;new palette
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
	MOVE.L 	A1,currentybuffer 	; store ybuffer1 address 
	MOVE.L 	current,A2 		; move current address
	JSR	SETUP_SCREEN_BUFFER

	LEA	screenyposbuffer2,A1 	; ybuffer2 memory address
	MOVE.L 	A1,otherybuffer 		; store ybuffer2 address
	MOVE.L 	other,A2 		; move current address
	JSR	SETUP_SCREEN_BUFFER

	rts

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

fill: 	; d7=points d6=colour
	stack_pointer_store_usp

	move.l 	#0,sp

	lea	pointlist,a0 	; point list
	move.w 	d7,d5 		; points
	lsl.w 	#2,d5 		; last point address
	movem.w	(a0),d0-d1	; copy first point
	movem.w	d0-d1,4(a0,d5.w)	; to last point   

	lea 	ColourTab,a5 					;
	lsl.w 	#2,d6 							;
	move.l 	(a5,d6.w),a5 	; get colour

	lea 	slopejumptable,a4		; pointer to slope jump table
	moveq.l	#0,d1 			; ends up holding biggest - moveq.l	#0,d5
	moveq.l	#-1,d4 			; ends up holding smallest

point_loop:	movem.w	(a0),d0/d2/d3/d5	; get xstart, ystart, xend, yend - d0/d2/d3/d5 - movem.l	(a0),d0/d1/d2/d3

		lea	linetable,a3 	; fill points table left edge
		cmp.w 	d0,d3 		; compare xstart, xend - cmp.w 	d0,d2
		beq 	point_next 	; if same ignore
		bcc 	.point_noswap	; if xstart lt xend
			exg 	d0,d3 		; swap xstart, xend - exg 	d0,d2
			exg 	d2,d5 		; swap ystart, yend - exg 	d1,d3
			lea 	4(a3),a3 	; right edge

.point_noswap:	cmp.w 	d0,d4 		; smallest xpos
		bcs 	.point_low
			move.w 	d0,d4 	; yes

.point_low:	cmp.w 	d3,d1		; biggest xpos - cmp.w 	d2,d5
		bcc 	.point_high
			move.w 	d3,d1 	; yes - move.w 	d2,d5

.point_high:	move.w 	d3,d6		; - move.w 	d2,d6
		lsl.w 	#3,d6 	 	; xend *8
		lea 	(a3,d6.w),a2 	; end position of fill points

		sub.w 	d0,d3 		; xdiff - sub.w 	d0,d2
		moveq.l 	#0,d6 		; reverse clear 
		sub.w 	d2,d5 		; ydiff - sub.w 	d1,d3
 		bcc 	.y_positive 	; not negative
 			neg.w 	d5 	; negate ydiff - neg.w 	d3
			moveq.l 	#1,d6 	; reverse set 

.y_positive:	add.w	d5,d5 	; ydiff - add.w	d3,d3
		lsl.l	#8,d5 	; ydiff - lsl.l	#8,d3
		divu.w	d3,d5 	; divide ydiff by xdiff ; source / dest - divu.w	d2,d3

		swap	d5 			; swap whole and remainder - swap	d3
		lsr.l	#8,d5			; lsr.l	#8,d3
		lsr.l	#1,d5			- lsr.l	#1,d3
		tst.w	d6 			; is reverse set
		beq 	.point_line_pos
			neg.l 	d5 		; yes - neg.l 	d3

.point_line_pos:	swap 	d2 			; swap xstart - swap 	d1
		lsl.w 	#2,d3 			; xdiff *4 - lsl.w 	#2,d2
		move.l 	(a4,d3.w),a3		; get jump pos - move.l 	(a4,d2.w),a3
		jmp 	(a3)			; do jump

fillslope200: 	fill_slope -200*8
fillslope199: 	fill_slope -199*8
fillslope198: 	fill_slope -198*8
fillslope197: 	fill_slope -197*8
fillslope196: 	fill_slope -196*8
fillslope195: 	fill_slope -195*8
fillslope194: 	fill_slope -194*8
fillslope193: 	fill_slope -193*8
fillslope192: 	fill_slope -192*8
fillslope191: 	fill_slope -191*8
fillslope190: 	fill_slope -190*8
fillslope189: 	fill_slope -189*8
fillslope188: 	fill_slope -188*8
fillslope187: 	fill_slope -187*8
fillslope186: 	fill_slope -186*8
fillslope185: 	fill_slope -185*8
fillslope184: 	fill_slope -184*8
fillslope183: 	fill_slope -183*8
fillslope182: 	fill_slope -182*8
fillslope181: 	fill_slope -181*8
fillslope180: 	fill_slope -180*8
fillslope179: 	fill_slope -179*8
fillslope178: 	fill_slope -178*8
fillslope177: 	fill_slope -177*8
fillslope176: 	fill_slope -176*8
fillslope175: 	fill_slope -175*8
fillslope174: 	fill_slope -174*8
fillslope173: 	fill_slope -173*8
fillslope172: 	fill_slope -172*8
fillslope171: 	fill_slope -171*8
fillslope170: 	fill_slope -170*8
fillslope169: 	fill_slope -169*8
fillslope168: 	fill_slope -168*8
fillslope167: 	fill_slope -167*8
fillslope166: 	fill_slope -166*8
fillslope165: 	fill_slope -165*8
fillslope164: 	fill_slope -164*8
fillslope163: 	fill_slope -163*8
fillslope162: 	fill_slope -162*8
fillslope161: 	fill_slope -161*8
fillslope160: 	fill_slope -160*8
fillslope159: 	fill_slope -159*8
fillslope158: 	fill_slope -158*8
fillslope157: 	fill_slope -157*8
fillslope156: 	fill_slope -156*8
fillslope155: 	fill_slope -155*8
fillslope154: 	fill_slope -154*8
fillslope153: 	fill_slope -153*8
fillslope152: 	fill_slope -152*8
fillslope151: 	fill_slope -151*8
fillslope150: 	fill_slope -150*8
fillslope149: 	fill_slope -149*8
fillslope148: 	fill_slope -148*8
fillslope147: 	fill_slope -147*8
fillslope146: 	fill_slope -146*8
fillslope145: 	fill_slope -145*8
fillslope144: 	fill_slope -144*8
fillslope143: 	fill_slope -143*8
fillslope142: 	fill_slope -142*8
fillslope141: 	fill_slope -141*8
fillslope140: 	fill_slope -140*8
fillslope139: 	fill_slope -139*8
fillslope138: 	fill_slope -138*8
fillslope137: 	fill_slope -137*8
fillslope136: 	fill_slope -136*8
fillslope135: 	fill_slope -135*8
fillslope134: 	fill_slope -134*8
fillslope133: 	fill_slope -133*8
fillslope132: 	fill_slope -132*8
fillslope131: 	fill_slope -131*8
fillslope130: 	fill_slope -130*8
fillslope129: 	fill_slope -129*8
fillslope128: 	fill_slope -128*8
fillslope127: 	fill_slope -127*8
fillslope126: 	fill_slope -126*8
fillslope125: 	fill_slope -125*8
fillslope124: 	fill_slope -124*8
fillslope123: 	fill_slope -123*8
fillslope122: 	fill_slope -122*8
fillslope121: 	fill_slope -121*8
fillslope120: 	fill_slope -120*8
fillslope119: 	fill_slope -119*8
fillslope118: 	fill_slope -118*8
fillslope117: 	fill_slope -117*8
fillslope116: 	fill_slope -116*8
fillslope115: 	fill_slope -115*8
fillslope114: 	fill_slope -114*8
fillslope113: 	fill_slope -113*8
fillslope112: 	fill_slope -112*8
fillslope111: 	fill_slope -111*8
fillslope110: 	fill_slope -110*8
fillslope109: 	fill_slope -109*8
fillslope108: 	fill_slope -108*8
fillslope107: 	fill_slope -107*8
fillslope106: 	fill_slope -106*8
fillslope105: 	fill_slope -105*8
fillslope104: 	fill_slope -104*8
fillslope103: 	fill_slope -103*8
fillslope102: 	fill_slope -102*8
fillslope101: 	fill_slope -101*8
fillslope100: 	fill_slope -100*8
fillslope099: 	fill_slope -99*8
fillslope098: 	fill_slope -98*8
fillslope097: 	fill_slope -97*8
fillslope096: 	fill_slope -96*8
fillslope095: 	fill_slope -95*8
fillslope094: 	fill_slope -94*8
fillslope093: 	fill_slope -93*8
fillslope092: 	fill_slope -92*8
fillslope091: 	fill_slope -91*8
fillslope090: 	fill_slope -90*8
fillslope089: 	fill_slope -89*8
fillslope088: 	fill_slope -88*8
fillslope087: 	fill_slope -87*8
fillslope086: 	fill_slope -86*8
fillslope085: 	fill_slope -85*8
fillslope084: 	fill_slope -84*8
fillslope083: 	fill_slope -83*8
fillslope082: 	fill_slope -82*8
fillslope081: 	fill_slope -81*8
fillslope080: 	fill_slope -80*8
fillslope079: 	fill_slope -79*8
fillslope078: 	fill_slope -78*8
fillslope077: 	fill_slope -77*8
fillslope076: 	fill_slope -76*8
fillslope075: 	fill_slope -75*8
fillslope074: 	fill_slope -74*8
fillslope073: 	fill_slope -73*8
fillslope072: 	fill_slope -72*8
fillslope071: 	fill_slope -71*8
fillslope070: 	fill_slope -70*8
fillslope069: 	fill_slope -69*8
fillslope068: 	fill_slope -68*8
fillslope067: 	fill_slope -67*8
fillslope066: 	fill_slope -66*8
fillslope065: 	fill_slope -65*8
fillslope064: 	fill_slope -64*8
fillslope063: 	fill_slope -63*8
fillslope062: 	fill_slope -62*8
fillslope061: 	fill_slope -61*8
fillslope060: 	fill_slope -60*8
fillslope059: 	fill_slope -59*8
fillslope058: 	fill_slope -58*8
fillslope057: 	fill_slope -57*8
fillslope056: 	fill_slope -56*8
fillslope055: 	fill_slope -55*8
fillslope054: 	fill_slope -54*8
fillslope053: 	fill_slope -53*8
fillslope052: 	fill_slope -52*8
fillslope051: 	fill_slope -51*8
fillslope050: 	fill_slope -50*8
fillslope049: 	fill_slope -49*8
fillslope048: 	fill_slope -48*8
fillslope047: 	fill_slope -47*8
fillslope046: 	fill_slope -46*8
fillslope045: 	fill_slope -45*8
fillslope044: 	fill_slope -44*8
fillslope043: 	fill_slope -43*8
fillslope042: 	fill_slope -42*8
fillslope041: 	fill_slope -41*8
fillslope040: 	fill_slope -40*8
fillslope039: 	fill_slope -39*8
fillslope038: 	fill_slope -38*8
fillslope037: 	fill_slope -37*8
fillslope036: 	fill_slope -36*8
fillslope035: 	fill_slope -35*8
fillslope034: 	fill_slope -34*8
fillslope033: 	fill_slope -33*8
fillslope032: 	fill_slope -32*8
fillslope031: 	fill_slope -31*8
fillslope030: 	fill_slope -30*8
fillslope029: 	fill_slope -29*8
fillslope028: 	fill_slope -28*8
fillslope027: 	fill_slope -27*8
fillslope026: 	fill_slope -26*8
fillslope025: 	fill_slope -25*8
fillslope024: 	fill_slope -24*8
fillslope023: 	fill_slope -23*8
fillslope022: 	fill_slope -22*8
fillslope021: 	fill_slope -21*8
fillslope020: 	fill_slope -20*8
fillslope019: 	fill_slope -19*8
fillslope018: 	fill_slope -18*8
fillslope017: 	fill_slope -17*8
fillslope016: 	fill_slope -16*8
fillslope015: 	fill_slope -15*8
fillslope014: 	fill_slope -14*8
fillslope013: 	fill_slope -13*8
fillslope012: 	fill_slope -12*8
fillslope011: 	fill_slope -11*8
fillslope010: 	fill_slope -10*8
fillslope009: 	fill_slope -9*8
fillslope008: 	fill_slope -8*8
fillslope007: 	fill_slope -7*8
fillslope006: 	fill_slope -6*8
fillslope005: 	fill_slope -5*8
fillslope004: 	fill_slope -4*8
fillslope003: 	fill_slope -3*8
fillslope002: 	fill_slope -2*8
fillslope001: 	fill_slope -1*8
fillslope000: 	fill_slope -0*8

point_next:	lea 	4(a0),a0 	; point to next points
;		dbeq 	d7,point_loop
		subq.w 	#1,d7
		bpl 	point_loop		; dbeq d7,point_loop 	; dec point count

;;	move.l	d5,d1	; biggest

	sub.w 	d4,d1 		; count=end-start
	bls 	fill_end 	; exit if same or negative ;	beq .fill_end  	; exit if same ;	bcs .fill_end 		; exit if nothing to fill

	move.l	currentybuffer,a0	; address of screenybuffer
	lsl.w	#2,d4		; start *4
	move.l	(a0,d4.w),a1 	; screen = ver pos

	lea 	linetable,a0 	; fill points table
	add.w 	d4,d4 		; start *8
	lea 	(a0,d4.w),a0 	; start position of fill points

	lea 	xmsb0,a6 	; points to xmsb table
	lea 	filljump,a4 	; 
	move.l 	a4,usp ; push to usp
	
	movem.l 	(a5),d4-d5 	; get colour in d5-d6

	lea 	AndListTab,a7 	; and table

; todo - change left right from 0-4 8-12 16-20 to 0-800 4-804 8-808 - change slope to store()+ and remove addq
	
line_next: ; ;a0=point table pos a1=screenaddress a4=jump table a5=colour(or) table a6=hor msb table a7=and table ;d7=count
		swap	d1 		; swap count into high

		move.w	(a0),d1 		; get right edge
		move.w	4(a0),d0 	; get left edge

		cmp.w 	d0,d1		; test only
		bcc 	.test_no_swap	; test only
			move.w	d0,d2
			move.w	d1,d0
			move.w	d2,d1	; need to keep hi word in d1
.test_no_swap:				; test only

		add.w 	d1,d1 		; right*2
		add.w 	d0,d0 		; left*2
		move.w 	(a6,d0.w),d2 	; left hor pos
		lea 	(a1,d2.w),a3 	; left screen = ver pos + 2 left byte hor pos

		move.l	usp,a4

		move.w	80(a4,d1.w),d3 	; 
		sub.w 	80(a4,d0.w),d3 	; right-left
		move.l 	(a4,d3.w),a2 	; get fill code address

		jmp 	(a2) 		; jump to fill code

fill_line_152:	d4d2d5d3
		d4d6d5d7
		move.l 	d2,a2
		move.l 	d3,a4
		movem.l 	d2/d3/d4/d5,136(a3)
		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,104(a3)
		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,72(a3)
  		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,40(a3)
 		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,8(a3)
		fill_left_right
	 	fill_next_line
		stack_pointer_restore_usp
	rts

fill_line_144:	d4d2d5d3
		d4d6d5d7
		move.l 	d2,a2
		move.l 	d3,a4
		movem.l 	d2/d3,136(a3)
		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,104(a3)
		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,72(a3)
  		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,40(a3)
 		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,8(a3)
		fill_left_right
fill_line_end:	fill_next_line
fill_end:	stack_pointer_restore_usp
	rts

fill_line_136:	d4d2d5d3
		d4d6d5d7
		move.l 	d2,a2
		move.l 	d3,a4
		movem.l	d2/d3/d4/d5/d6/d7/a2/a4,104(a3)
		movem.l	d2/d3/d4/d5/d6/d7/a2/a4,72(a3)
  		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,40(a3)
 		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,8(a3)
		fill_left_right
	 	fill_next_line
		stack_pointer_restore_usp
	rts

fill_line_128:	d4d2d5d3
		d4d6d5d7
		move.l 	d2,a2
		move.l 	d3,a4
		movem.l 	d2/d3/d4/d5/d6/d7,104(a3)
		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,72(a3)
  		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,40(a3)
 		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,8(a3)
		fill_left_right
	 	fill_next_line
		stack_pointer_restore_usp
	rts

fill_line_120:	d4d2d5d3
		d4d6d5d7		
		move.l 	d2,a2
		move.l 	d3,a4
		movem.l 	d2/d3/d4/d5,104(a3)
		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,72(a3)
  		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,40(a3)
 		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,8(a3)
		fill_left_right
		fill_next_line
	 	stack_pointer_restore_usp
	rts

fill_line_112:	d4d2d5d3
		d4d6d5d7
		move.l 	d2,a2
		move.l 	d3,a4
		movem.l 	d2/d3,104(a3)
		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,72(a3)
  		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,40(a3)
 		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,8(a3)
		fill_left_right
		fill_next_line
	 	stack_pointer_restore_usp
	rts
  
fill_line_104:	d4d2d5d3
		d4d6d5d7
		move.l 	d2,a2
		move.l 	d3,a4
		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,72(a3)
  		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,40(a3)
 		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,8(a3)
		fill_left_right
	 	fill_next_line
	  	stack_pointer_restore_usp
	rts

fill_line_096:	d4d2d5d3
		d4d6d5d7
		move.l 	d2,a2
		move.l 	d3,a4
		movem.l 	d2/d3/d4/d5/d6/d7,72(a3)
  		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,40(a3)
 		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,8(a3)
		fill_left_right
		fill_next_line
	 	stack_pointer_restore_usp
	rts

fill_line_088:	d4d2d5d3
		d4d6d5d7
		move.l 	d2,a2
		move.l 	d3,a4
		movem.l 	d2/d3/d4/d5,72(a3)
  		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,40(a3)
 		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,8(a3)
		fill_left_right
		fill_next_line
	 	stack_pointer_restore_usp
	rts

fill_line_080:	d4d2d5d3
		d4d6d5d7
		movem.l 	d2/d3/d4/d5/d6/d7,56(a3)
		movem.l 	d2/d3/d4/d5/d6/d7,32(a3)
		movem.l 	d2/d3/d4/d5/d6/d7,8(a3)
		fill_left_right
	 	fill_next_line
	  	stack_pointer_restore_usp

	rts

fill_line_072:	d4d2d5d3
		d4d6d5d7
		move.l 	d2,a2
		move.l 	d3,a4
  		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,40(a3)
 		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,8(a3)
		fill_left_right
		fill_next_line
	 	stack_pointer_restore_usp		
	rts

fill_line_064:	d4d2d5d3
		d4d6d5d7
		move.l 	d2,a2
		move.l 	d3,a4
  		movem.l 	d2/d3/d4/d5/d6/d7,40(a3)
 		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,8(a3)
		fill_left_right
		fill_next_line
	 	stack_pointer_restore_usp
	rts

fill_line_056:	d4d2d5d3
		d4d6d5d7
		movem.l 	d2/d3/d4/d5/d6/d7,32(a3)
		movem.l 	d2/d3/d4/d5/d6/d7,8(a3)
		fill_left_right
	 	fill_next_line
	 	stack_pointer_restore_usp

	rts

fill_line_048:	d4d2d5d3
		d4d6d5d7
		movem.l 	d2/d3/d4/d5/d6/d7,24(a3)
		movem.l 	d2/d3/d4/d5,8(a3)
		fill_left_right
		fill_next_line
	 	stack_pointer_restore_usp
	rts
  
fill_line_040:	d4d2d5d3
		d4d6d5d7
		move.l 	d2,a2
		move.l 	d3,a4
 		movem.l 	d2/d3/d4/d5/d6/d7/a2/a4,8(a3)
		fill_left_right
		fill_next_line
	 	stack_pointer_restore_usp
	rts

fill_line_032:	d4d2d5d3
		d4d6d5d7
		movem.l 	d2/d3/d4/d5/d6/d7,8(a3)
		fill_left_right
	 	fill_next_line
	  	stack_pointer_restore_usp
	rts

fill_line_024:	d4d2d5d3
		movem.l 	d2/d3/d4/d5,8(a3)
		fill_left_right
		fill_next_line
	 	stack_pointer_restore_usp
	rts

fill_line_016:	movem.l 	d4-d5,8(a3)
		fill_left_right
		fill_next_line
	 	stack_pointer_restore_usp
	rts
 
fill_line_008:	fill_left_right
		fill_next_line
	 	stack_pointer_restore_usp
	rts

fill_line_000:	lsl.w 	#3,d0 		; *16 *2
		move.l 	(a7,d0.w),d2 	; and left table
		lsl.w 	#3,d1 		; *16 *2
		move.l 	8(a7,d1.w),d3 	; and right table

		or.l 	d3,d2 		; d3 = fill
 		move.l 	d2,d3 		; 
 		not.l 	d2 		; d4 = gap

	 	move.l 	(a3),d0 		; get screen
	 	and.l 	d3,d0 		; and screen with gap to create screen gap
		move.l 	d4,d6 		; get colour
	 	and.l 	d2,d6 		; and fill with colour to create fill colour
		or.l 	d0,d6 		; or screen gap and fill colour
	 	move.l 	d6,(a3)		; write to screen

	 	move.l 	4(a3),d0
	 	and.l 	d3,d0
		move.l 	d5,d6
	 	and.l 	d2,d6
		or.l 	d0,d6
	 	move.l 	d6,4(a3)

 		fill_next_line
	 	stack_pointer_restore_usp
  	rts

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

the_stack_pointer dc.l 0
stack			dc.l	0
physical_screen		dc.l	0
logical_screen		dc.l	0
screen_resolution	dc.w	0
palette_store		ds.w	16
current			dc.l	0
other			dc.l	0
currentybuffer dc.l 0
otherybuffer dc.l 0

palette	dc.w $FFF,$000,$444,$999,$F00,$0F0,$00F,$440,$404,$044,$990,$909,$099,$FF0,$F0F,$0FF

xmsb0	dc.w 0*8,0*8,0*8,0*8,0*8,0*8,0*8,0*8,0*8,0*8,0*8,0*8,0*8,0*8,0*8,0*8
	dc.w 1*8,1*8,1*8,1*8,1*8,1*8,1*8,1*8,1*8,1*8,1*8,1*8,1*8,1*8,1*8,1*8
	dc.w 2*8,2*8,2*8,2*8,2*8,2*8,2*8,2*8,2*8,2*8,2*8,2*8,2*8,2*8,2*8,2*8
	dc.w 3*8,3*8,3*8,3*8,3*8,3*8,3*8,3*8,3*8,3*8,3*8,3*8,3*8,3*8,3*8,3*8
	dc.w 4*8,4*8,4*8,4*8,4*8,4*8,4*8,4*8,4*8,4*8,4*8,4*8,4*8,4*8,4*8,4*8
	dc.w 5*8,5*8,5*8,5*8,5*8,5*8,5*8,5*8,5*8,5*8,5*8,5*8,5*8,5*8,5*8,5*8
	dc.w 6*8,6*8,6*8,6*8,6*8,6*8,6*8,6*8,6*8,6*8,6*8,6*8,6*8,6*8,6*8,6*8
	dc.w 7*8,7*8,7*8,7*8,7*8,7*8,7*8,7*8,7*8,7*8,7*8,7*8,7*8,7*8,7*8,7*8
	dc.w 8*8,8*8,8*8,8*8,8*8,8*8,8*8,8*8,8*8,8*8,8*8,8*8,8*8,8*8,8*8,8*8
	dc.w 9*8,9*8,9*8,9*8,9*8,9*8,9*8,9*8,9*8,9*8,9*8,9*8,9*8,9*8,9*8,9*8
	dc.w 10*8,10*8,10*8,10*8,10*8,10*8,10*8,10*8,10*8,10*8,10*8,10*8,10*8,10*8,10*8,10*8
	dc.w 11*8,11*8,11*8,11*8,11*8,11*8,11*8,11*8,11*8,11*8,11*8,11*8,11*8,11*8,11*8,11*8
	dc.w 12*8,12*8,12*8,12*8,12*8,12*8,12*8,12*8,12*8,12*8,12*8,12*8,12*8,12*8,12*8,12*8
	dc.w 13*8,13*8,13*8,13*8,13*8,13*8,13*8,13*8,13*8,13*8,13*8,13*8,13*8,13*8,13*8,13*8
	dc.w 14*8,14*8,14*8,14*8,14*8,14*8,14*8,14*8,14*8,14*8,14*8,14*8,14*8,14*8,14*8,14*8
	dc.w 15*8,15*8,15*8,15*8,15*8,15*8,15*8,15*8,15*8,15*8,15*8,15*8,15*8,15*8,15*8,15*8
	dc.w 16*8,16*8,16*8,16*8,16*8,16*8,16*8,16*8,16*8,16*8,16*8,16*8,16*8,16*8,16*8,16*8
	dc.w 17*8,17*8,17*8,17*8,17*8,17*8,17*8,17*8,17*8,17*8,17*8,17*8,17*8,17*8,17*8,17*8
	dc.w 18*8,18*8,18*8,18*8,18*8,18*8,18*8,18*8,18*8,18*8,18*8,18*8,18*8,18*8,18*8,18*8
	dc.w 19*8,19*8,19*8,19*8,19*8,19*8,19*8,19*8,19*8,19*8,19*8,19*8,19*8,19*8,19*8,19*8

AndList MACRO
	dc.l $00000000,$00000000 ;l 01
	dc.l $7FFF7FFF,$7FFF7FFF ;r 01
	dc.l $80008000,$80008000 ;l 02
	dc.l $3FFF3FFF,$3FFF3FFF ;r 02
	dc.l $C000C000,$C000C000 ;l 03
	dc.l $1FFF1FFF,$1FFF1FFF ;r 03
	dc.l $E000E000,$E000E000 ;l 04
	dc.l $0FFF0FFF,$0FFF0FFF ;r 04
	dc.l $F000F000,$F000F000 ;l 05
	dc.l $07FF07FF,$07FF07FF ;r 05
	dc.l $F800F800,$F800F800 ;l 06
	dc.l $03FF03FF,$03FF03FF ;r 06
	dc.l $FC00FC00,$FC00FC00 ;l 07
	dc.l $01FF01FF,$01FF01FF ;r 07
	dc.l $FE00FE00,$FE00FE00 ;l 08
	dc.l $00FF00FF,$00FF00FF ;r 08
	dc.l $FF00FF00,$FF00FF00 ;l 09
	dc.l $007F007F,$007F007F ;r 09
	dc.l $FF80FF80,$FF80FF80 ;l 10
	dc.l $003F003F,$003F003F ;r 10
	dc.l $FFC0FFC0,$FFC0FFC0 ;l 11
	dc.l $001F001F,$001F001F ;r 11
	dc.l $FFE0FFE0,$FFE0FFE0 ;l 12
	dc.l $000F000F,$000F000F ;r 12
	dc.l $FFF0FFF0,$FFF0FFF0 ;l 13
	dc.l $00070007,$00070007 ;r 13
	dc.l $FFF8FFF8,$FFF8FFF8 ;l 14
	dc.l $00030003,$00030003 ;r 14
	dc.l $FFFCFFFC,$FFFCFFFC ;l 15
	dc.l $00010001,$00010001 ;r 15
	dc.l $FFFEFFFE,$FFFEFFFE ;l 16
	dc.l $00000000,$00000000 ;r 16
	ENDM

Colour00 MACRO
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	dc.l $00000000,$00000000
	ENDM

Colour01 MACRO
	dc.l $00000000,$0000FFFF
	dc.l $00000000,$00008000
	dc.l $00000000,$00007FFF
	dc.l $00000000,$0000C000
	dc.l $00000000,$00003FFF
	dc.l $00000000,$0000E000
	dc.l $00000000,$00001FFF
	dc.l $00000000,$0000F000
	dc.l $00000000,$00000FFF
	dc.l $00000000,$0000F800
	dc.l $00000000,$000007FF
	dc.l $00000000,$0000FC00
	dc.l $00000000,$000003FF
	dc.l $00000000,$0000FE00
	dc.l $00000000,$000001FF
	dc.l $00000000,$0000FF00
	dc.l $00000000,$000000FF
	dc.l $00000000,$0000FF80
	dc.l $00000000,$0000007F
	dc.l $00000000,$0000FFC0
	dc.l $00000000,$0000003F
	dc.l $00000000,$0000FFE0
	dc.l $00000000,$0000001F
	dc.l $00000000,$0000FFF0
	dc.l $00000000,$0000000F
	dc.l $00000000,$0000FFF8
	dc.l $00000000,$00000007
	dc.l $00000000,$0000FFFC
	dc.l $00000000,$00000003
	dc.l $00000000,$0000FFFE
	dc.l $00000000,$00000001
	dc.l $00000000,$0000FFFF
	ENDM

Colour02 MACRO
	dc.l $00000000,$FFFF0000
	dc.l $00000000,$80000000
	dc.l $00000000,$7FFF0000
	dc.l $00000000,$C0000000
	dc.l $00000000,$3FFF0000
	dc.l $00000000,$E0000000
	dc.l $00000000,$1FFF0000
	dc.l $00000000,$F0000000
	dc.l $00000000,$0FFF0000
	dc.l $00000000,$F8000000
	dc.l $00000000,$07FF0000
	dc.l $00000000,$FC000000
	dc.l $00000000,$03FF0000
	dc.l $00000000,$FE000000
	dc.l $00000000,$01FF0000
	dc.l $00000000,$FF000000
	dc.l $00000000,$00FF0000
	dc.l $00000000,$FF800000
	dc.l $00000000,$007F0000
	dc.l $00000000,$FFC00000
	dc.l $00000000,$003F0000
	dc.l $00000000,$FFE00000
	dc.l $00000000,$001F0000
	dc.l $00000000,$FFF00000
	dc.l $00000000,$000F0000
	dc.l $00000000,$FFF80000
	dc.l $00000000,$00070000
	dc.l $00000000,$FFFC0000
	dc.l $00000000,$00030000
	dc.l $00000000,$FFFE0000
	dc.l $00000000,$00010000
	dc.l $00000000,$FFFF0000
	ENDM

Colour03 MACRO
	dc.l $00000000,$FFFFFFFF
	dc.l $00000000,$80008000 
	dc.l $00000000,$7FFF7FFF
	dc.l $00000000,$C000C000
	dc.l $00000000,$3FFF3FFF
	dc.l $00000000,$E000E000
	dc.l $00000000,$1FFF1FFF
	dc.l $00000000,$F000F000
	dc.l $00000000,$0FFF0FFF
	dc.l $00000000,$F800F800
	dc.l $00000000,$07FF07FF
	dc.l $00000000,$FC00FC00
	dc.l $00000000,$03FF03FF
	dc.l $00000000,$FE00FE00
	dc.l $00000000,$01FF01FF
	dc.l $00000000,$FF00FF00
	dc.l $00000000,$00FF00FF
	dc.l $00000000,$FF80FF80
	dc.l $00000000,$007F007F
	dc.l $00000000,$FFC0FFC0
	dc.l $00000000,$003F003F
	dc.l $00000000,$FFE0FFE0
	dc.l $00000000,$001F001F
	dc.l $00000000,$FFF0FFF0
	dc.l $00000000,$000F000F
	dc.l $00000000,$FFF8FFF8
	dc.l $00000000,$00070007
	dc.l $00000000,$FFFCFFFC
	dc.l $00000000,$00030003
	dc.l $00000000,$FFFEFFFE
	dc.l $00000000,$00010001
	dc.l $00000000,$FFFFFFFF
	ENDM

Colour04 MACRO
	dc.l $0000FFFF,$00000000
	dc.l $00008000,$00000000
	dc.l $00007FFF,$00000000
	dc.l $0000C000,$00000000
	dc.l $00003FFF,$00000000
	dc.l $0000E000,$00000000
	dc.l $00001FFF,$00000000
	dc.l $0000F000,$00000000
	dc.l $00000FFF,$00000000
	dc.l $0000F800,$00000000
	dc.l $000007FF,$00000000
	dc.l $0000FC00,$00000000
	dc.l $000003FF,$00000000
	dc.l $0000FE00,$00000000
	dc.l $000001FF,$00000000
	dc.l $0000FF00,$00000000
	dc.l $000000FF,$00000000
	dc.l $0000FF80,$00000000
	dc.l $0000007F,$00000000
	dc.l $0000FFC0,$00000000
	dc.l $0000003F,$00000000
	dc.l $0000FFE0,$00000000
	dc.l $0000001F,$00000000
	dc.l $0000FFF0,$00000000
	dc.l $0000000F,$00000000
	dc.l $0000FFF8,$00000000
	dc.l $00000007,$00000000
	dc.l $0000FFFC,$00000000
	dc.l $00000003,$00000000
	dc.l $0000FFFE,$00000000
	dc.l $00000001,$00000000
	dc.l $0000FFFF,$00000000
	ENDM

Colour05 MACRO
	dc.l $0000FFFF,$0000FFFF
	dc.l $00008000,$00008000
	dc.l $00007FFF,$00007FFF
	dc.l $0000C000,$0000C000
	dc.l $00003FFF,$00003FFF
	dc.l $0000E000,$0000E000
	dc.l $00001FFF,$00001FFF
	dc.l $0000F000,$0000F000
	dc.l $00000FFF,$00000FFF
	dc.l $0000F800,$0000F800
	dc.l $000007FF,$000007FF
	dc.l $0000FC00,$0000FC00
	dc.l $000003FF,$000003FF
	dc.l $0000FE00,$0000FE00
	dc.l $000001FF,$000001FF
	dc.l $0000FF00,$0000FF00
	dc.l $000000FF,$000000FF
	dc.l $0000FF80,$0000FF80
	dc.l $0000007F,$0000007F
	dc.l $0000FFC0,$0000FFC0
	dc.l $0000003F,$0000003F
	dc.l $0000FFE0,$0000FFE0
	dc.l $0000001F,$0000001F
	dc.l $0000FFF0,$0000FFF0
	dc.l $0000000F,$0000000F
	dc.l $0000FFF8,$0000FFF8
	dc.l $00000007,$00000007
	dc.l $0000FFFC,$0000FFFC
	dc.l $00000003,$00000003
	dc.l $0000FFFE,$0000FFFE
	dc.l $00000001,$00000001
	dc.l $0000FFFF,$0000FFFF
	ENDM

Colour06 MACRO
	dc.l $0000FFFF,$FFFF0000
	dc.l $00008000,$80000000
	dc.l $00007FFF,$7FFF0000
	dc.l $0000C000,$C0000000
	dc.l $00003FFF,$3FFF0000
	dc.l $0000E000,$E0000000
	dc.l $00001FFF,$1FFF0000
	dc.l $0000F000,$F0000000
	dc.l $00000FFF,$0FFF0000
	dc.l $0000F800,$F8000000
	dc.l $000007FF,$07FF0000
	dc.l $0000FC00,$FC000000
	dc.l $000003FF,$03FF0000
	dc.l $0000FE00,$FE000000
	dc.l $000001FF,$01FF0000
	dc.l $0000FF00,$FF000000
	dc.l $000000FF,$00FF0000
	dc.l $0000FF80,$FF800000
	dc.l $0000007F,$007F0000
	dc.l $0000FFC0,$FFC00000
	dc.l $0000003F,$003F0000
	dc.l $0000FFE0,$FFE00000
	dc.l $0000001F,$001F0000
	dc.l $0000FFF0,$FFF00000
	dc.l $0000000F,$000F0000
	dc.l $0000FFF8,$FFF80000
	dc.l $00000007,$00070000
	dc.l $0000FFFC,$FFFC0000
	dc.l $00000003,$00030000
	dc.l $0000FFFE,$FFFE0000
	dc.l $00000001,$00010000
	dc.l $0000FFFF,$FFFF0000
	ENDM

Colour07 MACRO
	dc.l $0000FFFF,$FFFFFFFF
	dc.l $00008000,$80008000
	dc.l $00007FFF,$7FFF7FFF
	dc.l $0000C000,$C000C000
	dc.l $00003FFF,$3FFF3FFF
	dc.l $0000E000,$E000E000
	dc.l $00001FFF,$1FFF1FFF
	dc.l $0000F000,$F000F000
	dc.l $00000FFF,$0FFF0FFF
	dc.l $0000F800,$F800F800
	dc.l $000007FF,$07FF07FF
	dc.l $0000FC00,$FC00FC00
	dc.l $000003FF,$03FF03FF
	dc.l $0000FE00,$FE00FE00
	dc.l $000001FF,$01FF01FF
	dc.l $0000FF00,$FF00FF00
	dc.l $000000FF,$00FF00FF
	dc.l $0000FF80,$FF80FF80
	dc.l $0000007F,$007F007F
	dc.l $0000FFC0,$FFC0FFC0
	dc.l $0000003F,$003F003F
	dc.l $0000FFE0,$FFE0FFE0
	dc.l $0000001F,$001F001F
	dc.l $0000FFF0,$FFF0FFF0
	dc.l $0000000F,$000F000F
	dc.l $0000FFF8,$FFF8FFF8
	dc.l $00000007,$00070007
	dc.l $0000FFFC,$FFFCFFFC
	dc.l $00000003,$00030003
	dc.l $0000FFFE,$FFFEFFFE
	dc.l $00000001,$00010001
	dc.l $0000FFFF,$FFFFFFFF
	ENDM


Colour08 MACRO
	dc.l $FFFF0000,$00000000
	dc.l $80000000,$00000000
	dc.l $7FFF0000,$00000000
	dc.l $C0000000,$00000000
	dc.l $3FFF0000,$00000000
	dc.l $E0000000,$00000000
	dc.l $1FFF0000,$00000000
	dc.l $F0000000,$00000000
	dc.l $0FFF0000,$00000000
	dc.l $F8000000,$00000000
	dc.l $07FF0000,$00000000
	dc.l $FC000000,$00000000
	dc.l $03FF0000,$00000000
	dc.l $FE000000,$00000000
	dc.l $01FF0000,$00000000
	dc.l $FF000000,$00000000
	dc.l $00FF0000,$00000000
	dc.l $FF800000,$00000000
	dc.l $007F0000,$00000000
	dc.l $FFC00000,$00000000
	dc.l $003F0000,$00000000
	dc.l $FFE00000,$00000000
	dc.l $001F0000,$00000000
	dc.l $FFF00000,$00000000
	dc.l $000F0000,$00000000
	dc.l $FFF80000,$00000000
	dc.l $00070000,$00000000
	dc.l $FFFC0000,$00000000
	dc.l $00030000,$00000000
	dc.l $FFFE0000,$00000000
	dc.l $00010000,$00000000
	dc.l $FFFF0000,$00000000
	ENDM

Colour09 MACRO
	dc.l $FFFF0000,$0000FFFF
	dc.l $80000000,$00008000
	dc.l $7FFF0000,$00007FFF
	dc.l $C0000000,$0000C000
	dc.l $3FFF0000,$00003FFF
	dc.l $E0000000,$0000E000
	dc.l $1FFF0000,$00001FFF
	dc.l $F0000000,$0000F000
	dc.l $0FFF0000,$00000FFF
	dc.l $F8000000,$0000F800
	dc.l $07FF0000,$000007FF
	dc.l $FC000000,$0000FC00
	dc.l $03FF0000,$000003FF
	dc.l $FE000000,$0000FE00
	dc.l $01FF0000,$000001FF
	dc.l $FF000000,$0000FF00
	dc.l $00FF0000,$000000FF
	dc.l $FF800000,$0000FF80
	dc.l $007F0000,$0000007F
	dc.l $FFC00000,$0000FFC0
	dc.l $003F0000,$0000003F
	dc.l $FFE00000,$0000FFE0
	dc.l $001F0000,$0000001F
	dc.l $FFF00000,$0000FFF0
	dc.l $000F0000,$0000000F
	dc.l $FFF80000,$0000FFF8
	dc.l $00070000,$00000007
	dc.l $FFFC0000,$0000FFFC
	dc.l $00030000,$00000003
	dc.l $FFFE0000,$0000FFFE
	dc.l $00010000,$00000001
	dc.l $FFFF0000,$0000FFFF
	ENDM

Colour10 MACRO
	dc.l $FFFF0000,$FFFF0000
	dc.l $80000000,$80000000
	dc.l $7FFF0000,$7FFF0000
	dc.l $C0000000,$C0000000
	dc.l $3FFF0000,$3FFF0000
	dc.l $E0000000,$E0000000
	dc.l $1FFF0000,$1FFF0000
	dc.l $F0000000,$F0000000
	dc.l $0FFF0000,$0FFF0000
	dc.l $F8000000,$F8000000
	dc.l $07FF0000,$07FF0000
	dc.l $FC000000,$FC000000
	dc.l $03FF0000,$03FF0000
	dc.l $FE000000,$FE000000
	dc.l $01FF0000,$01FF0000
	dc.l $FF000000,$FF000000
	dc.l $00FF0000,$00FF0000
	dc.l $FF800000,$FF800000
	dc.l $007F0000,$007F0000
	dc.l $FFC00000,$FFC00000
	dc.l $003F0000,$003F0000
	dc.l $FFE00000,$FFE00000
	dc.l $001F0000,$001F0000
	dc.l $FFF00000,$FFF00000
	dc.l $000F0000,$000F0000
	dc.l $FFF80000,$FFF80000
	dc.l $00070000,$00070000
	dc.l $FFFC0000,$FFFC0000
	dc.l $00030000,$00030000
	dc.l $FFFE0000,$FFFE0000
	dc.l $00010000,$00010000
	dc.l $FFFF0000,$FFFF0000
	ENDM

Colour11 MACRO
	dc.l $FFFF0000,$FFFFFFFF
	dc.l $80000000,$80008000
	dc.l $7FFF0000,$7FFF7FFF
	dc.l $C0000000,$C000C000
	dc.l $3FFF0000,$3FFF3FFF
	dc.l $E0000000,$E000E000
	dc.l $1FFF0000,$1FFF1FFF
	dc.l $F0000000,$F000F000
	dc.l $0FFF0000,$0FFF0FFF
	dc.l $F8000000,$F800F800
	dc.l $07FF0000,$07FF07FF
	dc.l $FC000000,$FC00FC00
	dc.l $03FF0000,$03FF03FF
	dc.l $FE000000,$FE00FE00
	dc.l $01FF0000,$01FF01FF
	dc.l $FF000000,$FF00FF00
	dc.l $00FF0000,$00FF00FF
	dc.l $FF800000,$FF80FF80
	dc.l $007F0000,$007F007F
	dc.l $FFC00000,$FFC0FFC0
	dc.l $003F0000,$003F003F
	dc.l $FFE00000,$FFE0FFE0
	dc.l $001F0000,$001F001F
	dc.l $FFF00000,$FFF0FFF0
	dc.l $000F0000,$000F000F
	dc.l $FFF80000,$FFF8FFF8
	dc.l $00070000,$00070007
	dc.l $FFFC0000,$FFFCFFFC
	dc.l $00030000,$00030003
	dc.l $FFFE0000,$FFFEFFFE
	dc.l $00010000,$00010001
	dc.l $FFFF0000,$FFFFFFFF
	ENDM

Colour12 MACRO
	dc.l $FFFFFFFF,$00000000
	dc.l $80008000,$00000000
	dc.l $7FFF7FFF,$00000000
	dc.l $C000C000,$00000000
	dc.l $3FFF3FFF,$00000000
	dc.l $E000E000,$00000000
	dc.l $1FFF1FFF,$00000000
	dc.l $F000F000,$00000000
	dc.l $0FFF0FFF,$00000000
	dc.l $F800F800,$00000000
	dc.l $07FF07FF,$00000000
	dc.l $FC00FC00,$00000000
	dc.l $03FF03FF,$00000000
	dc.l $FE00EE00,$00000000
	dc.l $01FF01FF,$00000000
	dc.l $FF00FF00,$00000000
	dc.l $00FF00FF,$00000000
	dc.l $FF80FF80,$00000000
	dc.l $007F007F,$00000000
	dc.l $FFC0FFC0,$00000000
	dc.l $003F003F,$00000000
	dc.l $FFE0FFE0,$00000000
	dc.l $001F001F,$00000000
	dc.l $FFF0FFF0,$00000000
	dc.l $000F000F,$00000000
	dc.l $FFF8FFF8,$00000000
	dc.l $00070007,$00000000
	dc.l $FFFCFFFC,$00000000
	dc.l $00030003,$00000000
	dc.l $FFFEFFFE,$00000000
	dc.l $00010001,$00000000
	dc.l $FFFFFFFF,$00000000
	ENDM

Colour13 MACRO
	dc.l $FFFFFFFF,$0000FFFF
	dc.l $80008000,$00008000
	dc.l $7FFF7FFF,$00007FFF
	dc.l $C000C000,$0000C000
	dc.l $3FFF3FFF,$00003FFF
	dc.l $E000E000,$0000E000
	dc.l $1FFF1FFF,$00001FFF
	dc.l $F000F000,$0000F000
	dc.l $0FFF0FFF,$00000FFF
	dc.l $F800F800,$0000F800
	dc.l $07FF07FF,$000007FF
	dc.l $FC00FC00,$0000FC00
	dc.l $03FF03FF,$000003FF
	dc.l $FE00FE00,$0000FE00
	dc.l $01FF01FF,$000001FF
	dc.l $FF00FF00,$0000FF00
	dc.l $00FF00FF,$000000FF
	dc.l $FF80FF80,$0000FF80
	dc.l $007F007F,$0000007F
	dc.l $FFC0FFC0,$0000FFC0
	dc.l $003F003F,$0000003F
	dc.l $FFE0FFE0,$0000FFE0
	dc.l $001F001F,$0000001F
	dc.l $FFF0FFF0,$0000FFF0
	dc.l $000F000F,$0000000F
	dc.l $FFF8FFF8,$0000FFF8
	dc.l $00070007,$00000007
	dc.l $FFFCFFFC,$0000FFFC
	dc.l $00030003,$00000003
	dc.l $FFFEFFFE,$0000FFFE
	dc.l $00010001,$00000001
	dc.l $FFFFFFFF,$0000FFFF
	ENDM

Colour14 MACRO
	dc.l $FFFFFFFF,$FFFF0000
	dc.l $80008000,$80000000
	dc.l $7FFF7FFF,$7FFF0000
	dc.l $C000C000,$C0000000
	dc.l $3FFF3FFF,$3FFF0000
	dc.l $E000E000,$E0000000
	dc.l $1FFF1FFF,$1FFF0000
	dc.l $F000F000,$F0000000
	dc.l $0FFF0FFF,$0FFF0000
	dc.l $F800F800,$F8000000
	dc.l $07FF07FF,$07FF0000
	dc.l $FC00FC00,$FC000000
	dc.l $03FF03FF,$03FF0000
	dc.l $FE00FE00,$FE000000
	dc.l $01FF01FF,$01FF0000
	dc.l $FF00FF00,$FF000000
	dc.l $00FF00FF,$00FF0000
	dc.l $FF80FF80,$FF800000
	dc.l $007F007F,$007F0000
	dc.l $FFC0FFC0,$FFC00000
	dc.l $003F003F,$003F0000
	dc.l $FFE0FFE0,$FFE00000
	dc.l $001F001F,$001F0000
	dc.l $FFF0FFF0,$FFF00000
	dc.l $000F000F,$000F0000
	dc.l $FFF8FFF8,$FFF80000
	dc.l $00070007,$00070000
	dc.l $FFFCFFFC,$FFFC0000
	dc.l $00030003,$00030000
	dc.l $FFFEFFFE,$FFFE0000
	dc.l $00010001,$00010000
	dc.l $FFFFFFFF,$FFFF0000
	ENDM

Colour15 MACRO
	dc.l $FFFFFFFF,$FFFFFFFF
	dc.l $80008000,$80008000
	dc.l $7FFF7FFF,$7FFF7FFF
	dc.l $C000C000,$C000C000
	dc.l $3FFF3FFF,$3FFF3FFF
	dc.l $E000E000,$E000E000
	dc.l $1FFF1FFF,$1FFF1FFF
	dc.l $F000F000,$F000F000
	dc.l $0FFF0FFF,$0FFF0FFF
	dc.l $F800F800,$F800F800
	dc.l $07FF07FF,$07FF07FF
	dc.l $FC00FC00,$FC00FC00
	dc.l $03FF03FF,$03FF03FF
	dc.l $FE00FE00,$FE00FE00
	dc.l $01FF01FF,$01FF01FF
	dc.l $FF00FF00,$FF00FF00
	dc.l $00FF00FF,$00FF00FF
	dc.l $FF80FF80,$FF80FF80
	dc.l $007F007F,$007F007F
	dc.l $FFC0FFC0,$FFC0FFC0
	dc.l $003F003F,$003F003F
	dc.l $FFE0FFE0,$FFE0FFE0
	dc.l $001F001F,$001F001F
	dc.l $FFF0FFF0,$FFF0FFF0
	dc.l $000F000F,$000F000F
	dc.l $FFF8FFF8,$FFF8FFF8
	dc.l $00070007,$00070007
	dc.l $FFFCFFFC,$FFFCFFFC
	dc.l $00030003,$00030003
	dc.l $FFFEFFFE,$FFFEFFFE
	dc.l $00010001,$00010001
	dc.l $FFFFFFFF,$FFFFFFFF
	ENDM 

ColourTab: dc.l ColourTab00,ColourTab01,ColourTab02,ColourTab03,ColourTab04,ColourTab05,ColourTab06,ColourTab07,ColourTab08,ColourTab09,ColourTab10,ColourTab11,ColourTab12,ColourTab13,ColourTab14,ColourTab15

AndListTab:
	REPT 20
		AndList
	ENDR

ColourTab00:
	REPT 20
		Colour00
	ENDR 

ColourTab01:
	REPT 20
		Colour01
	ENDR

	ColourTab02:
	REPT 20
		Colour02
	ENDR

	ColourTab03:
	REPT 20
		Colour03
	ENDR

ColourTab04:
	REPT 20
		Colour04
	ENDR

ColourTab05:
	REPT 20
		Colour05
	ENDR

ColourTab06:
	REPT 20
		Colour06
	ENDR

ColourTab07:
	REPT 20
		Colour07
	ENDR

ColourTab08:
	REPT 20
		Colour08
	ENDR

ColourTab09:
	REPT 20
		Colour09
	ENDR

ColourTab10:
	REPT 20
		Colour10
	ENDR

ColourTab11:
	REPT 20
		Colour11
	ENDR

ColourTab12:
	REPT 20
		Colour12
	ENDR

ColourTab13:
	REPT 20
		Colour13
	ENDR

ColourTab14:
	REPT 20
		Colour14
	ENDR

ColourTab15:
	REPT 20
		Colour15
	ENDR

slopejumptable:
	dc.l fillslope000,fillslope001,fillslope002,fillslope003,fillslope004,fillslope005,fillslope006,fillslope007,fillslope008,fillslope009
	dc.l fillslope010,fillslope011,fillslope012,fillslope013,fillslope014,fillslope015,fillslope016,fillslope017,fillslope018,fillslope019
	dc.l fillslope020,fillslope021,fillslope022,fillslope023,fillslope024,fillslope025,fillslope026,fillslope027,fillslope028,fillslope029
	dc.l fillslope030,fillslope031,fillslope032,fillslope033,fillslope034,fillslope035,fillslope036,fillslope037,fillslope038,fillslope039
	dc.l fillslope040,fillslope041,fillslope042,fillslope043,fillslope044,fillslope045,fillslope046,fillslope047,fillslope048,fillslope049
	dc.l fillslope050,fillslope051,fillslope052,fillslope053,fillslope054,fillslope055,fillslope056,fillslope057,fillslope058,fillslope059
	dc.l fillslope060,fillslope061,fillslope062,fillslope063,fillslope064,fillslope065,fillslope066,fillslope067,fillslope068,fillslope069
	dc.l fillslope070,fillslope071,fillslope072,fillslope073,fillslope074,fillslope075,fillslope076,fillslope077,fillslope078,fillslope079
	dc.l fillslope080,fillslope081,fillslope082,fillslope083,fillslope084,fillslope085,fillslope086,fillslope087,fillslope088,fillslope089
	dc.l fillslope090,fillslope091,fillslope092,fillslope093,fillslope094,fillslope095,fillslope096,fillslope097,fillslope098,fillslope099
	dc.l fillslope100,fillslope101,fillslope102,fillslope103,fillslope104,fillslope105,fillslope106,fillslope107,fillslope108,fillslope109
	dc.l fillslope110,fillslope111,fillslope112,fillslope113,fillslope114,fillslope115,fillslope116,fillslope117,fillslope118,fillslope119
	dc.l fillslope120,fillslope121,fillslope122,fillslope123,fillslope124,fillslope125,fillslope126,fillslope127,fillslope128,fillslope129
	dc.l fillslope130,fillslope131,fillslope132,fillslope133,fillslope134,fillslope135,fillslope136,fillslope137,fillslope138,fillslope139
	dc.l fillslope140,fillslope141,fillslope142,fillslope143,fillslope144,fillslope145,fillslope146,fillslope147,fillslope148,fillslope149
	dc.l fillslope150,fillslope151,fillslope152,fillslope153,fillslope154,fillslope155,fillslope156,fillslope157,fillslope158,fillslope159
	dc.l fillslope160,fillslope161,fillslope162,fillslope163,fillslope164,fillslope165,fillslope166,fillslope167,fillslope168,fillslope169
	dc.l fillslope170,fillslope171,fillslope172,fillslope173,fillslope174,fillslope175,fillslope176,fillslope177,fillslope178,fillslope179
	dc.l fillslope180,fillslope181,fillslope182,fillslope183,fillslope184,fillslope185,fillslope186,fillslope187,fillslope188,fillslope189
	dc.l fillslope190,fillslope191,fillslope192,fillslope193,fillslope194,fillslope195,fillslope196,fillslope197,fillslope198,fillslope199,fillslope200

	dc.l fill_line_end,fill_line_end,fill_line_end,fill_line_end
filljump:
	dc.l fill_line_000,fill_line_008,fill_line_016,fill_line_024,fill_line_032,fill_line_040,fill_line_048,fill_line_056
	dc.l fill_line_064,fill_line_072,fill_line_080,fill_line_088,fill_line_096,fill_line_104,fill_line_112,fill_line_120
	dc.l fill_line_128,fill_line_136,fill_line_144,fill_line_152 
;	;,fill_line_160
;	dc.l fill_line_168,fill_line_176,fill_line_184
;	dc.l fill_line_192,fill_line_200,fill_line_208,fill_line_216,fill_line_224,fill_line_232,fill_line_240,fill_line_248
;	dc.l fill_line_256,fill_line_264,fill_line_272,fill_line_280,fill_line_288,fill_line_296,fill_line_304,fill_line_312
xlsb0	dc.w 0*4,0*4,0*4,0*4,0*4,0*4,0*4,0*4,0*4,0*4,0*4,0*4,0*4,0*4,0*4,0*4
	dc.w 1*4,1*4,1*4,1*4,1*4,1*4,1*4,1*4,1*4,1*4,1*4,1*4,1*4,1*4,1*4,1*4
	dc.w 2*4,2*4,2*4,2*4,2*4,2*4,2*4,2*4,2*4,2*4,2*4,2*4,2*4,2*4,2*4,2*4
	dc.w 3*4,3*4,3*4,3*4,3*4,3*4,3*4,3*4,3*4,3*4,3*4,3*4,3*4,3*4,3*4,3*4
	dc.w 4*4,4*4,4*4,4*4,4*4,4*4,4*4,4*4,4*4,4*4,4*4,4*4,4*4,4*4,4*4,4*4
	dc.w 5*4,5*4,5*4,5*4,5*4,5*4,5*4,5*4,5*4,5*4,5*4,5*4,5*4,5*4,5*4,5*4
	dc.w 6*4,6*4,6*4,6*4,6*4,6*4,6*4,6*4,6*4,6*4,6*4,6*4,6*4,6*4,6*4,6*4
	dc.w 7*4,7*4,7*4,7*4,7*4,7*4,7*4,7*4,7*4,7*4,7*4,7*4,7*4,7*4,7*4,7*4
	dc.w 8*4,8*4,8*4,8*4,8*4,8*4,8*4,8*4,8*4,8*4,8*4,8*4,8*4,8*4,8*4,8*4
	dc.w 9*4,9*4,9*4,9*4,9*4,9*4,9*4,9*4,9*4,9*4,9*4,9*4,9*4,9*4,9*4,9*4
	dc.w 10*4,10*4,10*4,10*4,10*4,10*4,10*4,10*4,10*4,10*4,10*4,10*4,10*4,10*4,10*4,10*4
	dc.w 11*4,11*4,11*4,11*4,11*4,11*4,11*4,11*4,11*4,11*4,11*4,11*4,11*4,11*4,11*4,11*4
	dc.w 12*4,12*4,12*4,12*4,12*4,12*4,12*4,12*4,12*4,12*4,12*4,12*4,12*4,12*4,12*4,12*4
	dc.w 13*4,13*4,13*4,13*4,13*4,13*4,13*4,13*4,13*4,13*4,13*4,13*4,13*4,13*4,13*4,13*4
	dc.w 14*4,14*4,14*4,14*4,14*4,14*4,14*4,14*4,14*4,14*4,14*4,14*4,14*4,14*4,14*4,14*4
	dc.w 15*4,15*4,15*4,15*4,15*4,15*4,15*4,15*4,15*4,15*4,15*4,15*4,15*4,15*4,15*4,15*4
	dc.w 16*4,16*4,16*4,16*4,16*4,16*4,16*4,16*4,16*4,16*4,16*4,16*4,16*4,16*4,16*4,16*4
	dc.w 17*4,17*4,17*4,17*4,17*4,17*4,17*4,17*4,17*4,17*4,17*4,17*4,17*4,17*4,17*4,17*4
	dc.w 18*4,18*4,18*4,18*4,18*4,18*4,18*4,18*4,18*4,18*4,18*4,18*4,18*4,18*4,18*4,18*4
	dc.w 19*4,19*4,19*4,19*4,19*4,19*4,19*4,19*4,19*4,19*4,19*4,19*4,19*4,19*4,19*4,19*4

temp_colour dc.w 0

pointlist: 
 dc.w 20,10,10,310,190,219,0,0,0,0
; dc.l 192,178,188,132,22,41,0,0,0,0
; dc.l 190,180,190,130,20,39,0,0,0,0

dirlist: 
 dc.w +1,-1,+1,-1,+1,-1,+1,-1,+1,-1,+1,-1
; dc.l -1,1,1,-1,-1,-1,0,0,0,0

screenbuffer1 ds.l 8192+256
screenbuffer2 ds.l 8192+256
screenyposbuffer1 ds.l 202
screenyposbuffer2 ds.l 202

linetable:
	ds.l 400 ; line[0].left (addr0) / line[0].right (addr4) / line[1].left (addr8) / line[1].right (addr12)

;plottable: dc.w 32768,16384,8192,4096,2048,1024,512,256,128,64,32,16,8,4,2,1

end_of_program



