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
