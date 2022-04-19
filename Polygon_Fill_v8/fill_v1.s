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

	lea	slopetab,a6

	lea 	slopejumptable,a4		; pointer to slope jump table
	moveq.l	#0,d1 			; ends up holding biggest
	moveq.l	#-1,d4 			; ends up holding smallest
	
point_loop:	movem.w	(a0),d0/d2/d3/d5	; get xstart, ystart, xend, yend

		lea	linetable,a3 	; fill points table left edge
		cmp.w 	d0,d3 		; compare xstart, xend
		beq 	point_next 	; if same ignore
		bcc 	.point_noswap	; if xstart lt xend
			exg 	d0,d3 		; swap xstart, xend
			exg 	d2,d5 		; swap ystart, yend
			lea 	4(a3),a3 	; right edge

.point_noswap:	move.w 	d3,d6
		lsl.w 	#3,d6 	 	; xend *8
		lea 	(a3,d6.w),a2 	; end position of fill points

		cmp.w 	d0,d4 		; smallest xpos
		bcs 	.point_low
			move.w 	d0,d4 	; yes

.point_low:	cmp.w 	d3,d1		; biggest xpos
		bcc 	.point_high
			move.w 	d3,d1 	; yes

.point_high:	
		sub.w 	d0,d3 		; xdiff
		moveq.l 	#0,d6 		; reverse clear 
		sub.w 	d2,d5 		; ydiff
 		bcc 	.y_positive 	; not negative
 			neg.w 	d5 	; negate ydiff
			moveq.l 	#1,d6 	; reverse set 

.y_positive:	move.w 	d3,d0
		and.w 	#%11111111110,d0	; make even
		add.w 	d0,d0		; multiply by 2
		move.l 	(a6,d0.w),a3	; get slope v
		and.w 	#%11111111110,d5	; make even
		add.w 	d5,d5		; multiply by 2
		move.l 	(a3,d5.w),d5	; get slope
 
		tst.w	d6 			; is reverse set
		beq 	.point_line_pos
			neg.l 	d5 		; yes

.point_line_pos:	swap 	d2 			; swap xstart
		lsl.w 	#2,d3 			; xdiff *4
		move.l 	(a4,d3.w),a3		; get jump pos
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
