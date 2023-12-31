SECTION "Menu Tiles", ROM0

; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: menu.png
; Pixel Width: 160px
; Pixel Height: 144px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

menu_tile_map_size EQU $0168
menu_tile_map_width EQU $14
menu_tile_map_height EQU $12

menu_tile_data_size EQU $0900
menu_tile_count EQU $90

; ////////////////
; //            //
; //  Map Data  //
; //            //
; ////////////////

menu_map_data:
DB $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
DB $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$81
DB $82,$83,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
DB $80,$84,$85,$86,$87,$88,$89,$8A,$8B,$80,$80,$80,$80,$80,$80,$80
DB $80,$80,$80,$80,$8C,$8D,$8E,$8F,$90,$91,$92,$92,$93,$94,$95,$96
DB $80,$80,$80,$80,$80,$80,$80,$80,$97,$98,$92,$99,$9A,$9B,$9C,$9D
DB $92,$9E,$9F,$A0,$80,$80,$80,$80,$80,$80,$80,$A1,$98,$92,$92,$A2
DB $A3,$A4,$80,$A5,$A6,$92,$A7,$A8,$80,$80,$80,$80,$80,$80,$80,$A9
DB $92,$92,$AA,$AB,$AC,$AD,$AE,$AF,$B0,$92,$B1,$92,$80,$80,$80,$80
DB $80,$80,$80,$B2,$92,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD
DB $80,$80,$80,$80,$80,$80,$80,$BE,$BF,$C0,$C1,$C2,$C3,$C4,$C5,$C6
DB $C7,$C8,$C9,$CA,$80,$80,$80,$80,$80,$80,$80,$BE,$CB,$CC,$80,$80
DB $CD,$CE,$80,$CF,$D0,$80,$80,$BC,$80,$80,$80,$80,$80,$80,$80,$D1
DB $D2,$D3,$80,$80,$D4,$D5,$D6,$D7,$D8,$80,$80,$C9,$80,$80,$80,$80
DB $80,$80,$80,$80,$D9,$DA,$DB,$DC,$DD,$DE,$DF,$80,$80,$E0,$E1,$80
DB $80,$80,$80,$80,$80,$80,$80,$80,$E2,$E3,$80,$80,$80,$E4,$E5,$80
DB $E6,$E7,$E8,$E1,$80,$80,$80,$80,$80,$E9,$80,$80,$80,$EA,$EB,$EC
DB $80,$80,$ED,$80,$EE,$EF,$80,$E8,$80,$80,$80,$80,$80,$F0,$F1,$F2
DB $F3,$EC,$F4,$F5,$80,$80,$E4,$EC,$F6,$F7,$EF,$80,$80,$80,$80,$80
DB $80,$F8,$F9,$F9,$F9,$80,$FA,$FB,$FC,$FD,$FD,$FE,$FF,$00,$F7,$EF
DB $80,$80,$80,$80,$80,$01,$F9,$F9,$02,$80,$03,$04,$05,$06,$07,$08
DB $09,$0A,$0B,$F7,$80,$80,$80,$80,$80,$F9,$F9,$F9,$0C,$80,$0D,$0E
DB $92,$92,$92,$92,$92,$92,$0F,$0B

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

menu_tile_data:
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$0F,$0F,$1F,$10,$7F,$60,$FF,$80
DB $00,$00,$00,$00,$00,$00,$F8,$F8,$FF,$87,$FF,$01,$FF,$00,$FF,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$E0,$60,$F0,$30
DB $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$03,$02,$07,$05,$0F,$0B
DB $0F,$0F,$3F,$38,$7F,$60,$FF,$C7,$FF,$1C,$FF,$60,$FF,$80,$FF,$00
DB $FF,$00,$FF,$1F,$FF,$F0,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $FF,$00,$FF,$FF,$FF,$00,$FF,$00,$FF,$00,$FF,$03,$FE,$0E,$F8,$18
DB $F8,$18,$FC,$EC,$FE,$36,$FE,$1E,$FF,$FF,$80,$80,$00,$00,$3F,$3F
DB $00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$C0,$C0,$77,$77,$FF,$F8
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E0,$E0,$FF,$1F
DB $08,$08,$3E,$3E,$62,$62,$42,$42,$62,$62,$06,$06,$0C,$0C,$F8,$F8
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$03,$03,$07,$06
DB $1F,$1C,$1F,$18,$3F,$30,$7F,$60,$FF,$C0,$FF,$80,$FF,$00,$FE,$01
DB $FF,$00,$FF,$00,$FE,$01,$F0,$0F,$80,$7F,$0F,$FF,$3F,$F0,$FF,$C0
DB $FF,$00,$80,$7F,$00,$FF,$0F,$FF,$7F,$F9,$FF,$C3,$FF,$03,$FF,$06
DB $F1,$31,$67,$E6,$DF,$D8,$BF,$B0,$FF,$C0,$FF,$80,$FF,$00,$FF,$00
DB $FF,$C0,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$07,$FF,$1C,$FF,$60
DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $C0,$C0,$E0,$60,$F0,$30,$FF,$1F,$FE,$0E,$FF,$03,$FF,$03,$FF,$00
DB $07,$07,$3F,$3C,$7F,$70,$FF,$E0,$3F,$30,$1F,$18,$CF,$CC,$E7,$67
DB $FC,$FC,$FF,$03,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$FF
DB $00,$00,$80,$80,$C0,$C0,$F0,$70,$FC,$1C,$FE,$06,$FF,$03,$FF,$FD
DB $0F,$0C,$1F,$18,$3F,$30,$3F,$20,$7F,$60,$7F,$40,$FF,$C0,$FE,$81
DB $FD,$03,$FD,$03,$FB,$06,$F7,$0E,$EF,$1C,$DF,$38,$3F,$F0,$FF,$C0
DB $FF,$06,$FF,$0C,$FF,$08,$FF,$18,$FF,$10,$FF,$30,$FF,$20,$FF,$40
DB $FF,$01,$FF,$03,$FF,$06,$FF,$08,$FF,$10,$FF,$30,$FF,$40,$FF,$C0
DB $FF,$80,$FF,$00,$FF,$00,$FF,$01,$FF,$03,$FF,$07,$FF,$87,$FF,$8F
DB $FF,$00,$FF,$20,$FF,$F0,$FF,$F8,$FF,$F8,$FF,$FD,$FF,$FD,$FF,$FF
DB $FF,$18,$FF,$60,$FF,$40,$FF,$80,$FF,$80,$FF,$3C,$FF,$7C,$FF,$FC
DB $E2,$23,$F1,$11,$F9,$09,$FC,$04,$FE,$06,$FF,$03,$FF,$01,$FF,$00
DB $00,$FF,$00,$FF,$FE,$FF,$FF,$83,$FF,$80,$FF,$80,$FF,$80,$9F,$E0
DB $07,$FF,$01,$FF,$00,$FF,$E0,$9F,$FC,$63,$FE,$31,$FF,$18,$FF,$04
DB $01,$01,$03,$03,$03,$02,$07,$06,$07,$04,$0F,$0C,$0F,$08,$0F,$08
DB $FF,$80,$FF,$81,$FF,$81,$FF,$82,$FF,$82,$FF,$86,$FF,$84,$FF,$84
DB $FF,$80,$FF,$81,$FF,$01,$FF,$03,$FD,$0D,$FB,$1B,$FF,$3F,$FF,$7F
DB $F8,$88,$F0,$10,$F0,$30,$E0,$20,$FC,$7C,$FE,$FE,$FE,$FE,$FC,$FC
DB $FF,$FE,$1F,$1F,$0F,$0F,$07,$07,$03,$03,$01,$01,$18,$18,$3C,$3C
DB $FF,$04,$FF,$06,$FF,$02,$FF,$82,$FF,$82,$FF,$81,$FF,$81,$FF,$C1
DB $87,$F8,$C1,$7E,$C0,$7F,$E8,$77,$E7,$38,$E7,$38,$F3,$3C,$F1,$1E
DB $FF,$02,$FF,$01,$3F,$C1,$1F,$E0,$07,$F8,$E7,$18,$F3,$0C,$FF,$00
DB $1F,$19,$1F,$11,$1F,$13,$1F,$12,$1F,$12,$1F,$12,$1F,$16,$1F,$14
DB $FF,$00,$FF,$06,$FF,$0E,$FB,$1F,$F1,$3F,$E0,$7F,$C0,$FF,$80,$FF
DB $FF,$84,$FF,$84,$FF,$88,$FF,$88,$FF,$99,$FF,$9D,$F7,$B5,$E6,$A6
DB $DF,$5F,$F1,$F1,$C0,$C0,$8F,$8F,$18,$18,$30,$30,$23,$23,$66,$66
DB $F0,$F0,$88,$88,$84,$84,$82,$82,$02,$02,$01,$01,$C1,$C1,$61,$61
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$02,$02
DB $7E,$7E,$3F,$3F,$3F,$3F,$1F,$1F,$0F,$0F,$7F,$7F,$81,$81,$00,$00
DB $FF,$C3,$FF,$C2,$7F,$42,$FF,$C6,$FF,$C4,$FF,$EC,$FF,$E8,$FF,$F8
DB $F1,$1E,$F1,$1E,$F0,$1F,$F0,$1F,$F0,$1F,$F0,$3F,$E0,$3F,$E0,$7F
DB $1F,$1C,$1F,$18,$1F,$18,$1F,$18,$1F,$10,$1F,$10,$1F,$10,$3F,$30
DB $FF,$03,$FE,$07,$FC,$0F,$F8,$0F,$F0,$1F,$F0,$1F,$E0,$3F,$E0,$7F
DB $00,$FF,$00,$FF,$00,$FF,$01,$FF,$03,$FF,$02,$FE,$04,$FC,$08,$F8
DB $E2,$E2,$62,$E2,$E2,$E2,$E2,$E2,$63,$63,$23,$23,$1A,$1A,$0E,$0E
DB $44,$44,$46,$46,$60,$60,$20,$20,$38,$38,$0F,$0F,$80,$80,$40,$40
DB $21,$21,$21,$21,$61,$61,$43,$43,$C6,$C6,$84,$84,$08,$08,$10,$10
DB $04,$04,$08,$08,$08,$08,$91,$91,$73,$73,$22,$22,$22,$22,$22,$22
DB $0C,$0C,$76,$76,$C0,$C0,$80,$80,$1E,$1E,$33,$33,$21,$21,$31,$31
DB $FF,$F0,$1F,$10,$1F,$18,$0F,$08,$0F,$08,$07,$04,$0F,$09,$8F,$89
DB $FF,$20,$FF,$40,$FF,$41,$FF,$43,$FF,$C3,$FF,$87,$FF,$0F,$F8,$08
DB $80,$FF,$80,$FF,$40,$7F,$60,$7F,$20,$3F,$30,$3F,$10,$1F,$18,$1F
DB $7F,$80,$7F,$80,$3F,$C0,$3F,$C0,$1F,$E0,$1F,$E0,$0F,$F0,$0F,$F0
DB $3F,$20,$3F,$20,$7F,$60,$7F,$40,$7F,$40,$7F,$40,$7F,$60,$3F,$20
DB $FF,$00,$FF,$00,$FF,$00,$FF,$01,$FF,$01,$FF,$03,$FE,$03,$FE,$83
DB $C0,$7F,$80,$FF,$80,$FF,$00,$FF,$00,$FF,$01,$FF,$03,$FF,$02,$FE
DB $18,$F8,$30,$F0,$60,$E0,$C0,$C0,$80,$80,$00,$00,$00,$00,$00,$00
DB $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$01,$01
DB $20,$20,$1F,$1F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $20,$20,$C2,$C2,$02,$02,$00,$00,$00,$00,$00,$00,$80,$80,$F8,$F8
DB $22,$22,$23,$23,$11,$11,$08,$08,$04,$04,$02,$02,$01,$01,$00,$00
DB $01,$01,$03,$03,$C6,$C6,$3C,$3C,$00,$00,$00,$00,$01,$01,$FE,$FE
DB $8F,$8A,$0F,$0E,$1F,$1C,$2F,$29,$2F,$29,$5F,$5B,$A6,$A6,$42,$42
DB $F8,$08,$F8,$F8,$F0,$F0,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00
DB $08,$0F,$08,$0F,$08,$0F,$0C,$0F,$04,$07,$04,$07,$02,$03,$01,$01
DB $07,$F8,$07,$F8,$03,$FC,$03,$FC,$01,$FE,$01,$FE,$00,$FF,$00,$FF
DB $FE,$83,$FE,$83,$FE,$83,$FE,$87,$FC,$87,$FC,$87,$FC,$87,$FC,$87
DB $04,$FC,$0C,$FC,$08,$F8,$10,$F0,$10,$F0,$30,$F0,$20,$E0,$20,$E0
DB $80,$80,$80,$80,$40,$40,$20,$20,$20,$20,$10,$10,$10,$18,$10,$1C
DB $86,$FE,$81,$FF,$B9,$C7,$FD,$83,$FF,$C3,$3E,$0E,$38,$38,$00,$00
DB $00,$00,$01,$01,$03,$03,$04,$04,$08,$08,$10,$10,$20,$20,$C0,$C0
DB $86,$86,$0C,$0C,$F8,$F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $3F,$30,$1F,$10,$0F,$08,$0F,$0C,$07,$04,$07,$06,$03,$02,$01,$01
DB $FC,$87,$FE,$87,$FE,$C3,$FE,$43,$FE,$43,$FF,$43,$FF,$61,$FF,$21
DB $20,$E0,$20,$E0,$20,$E0,$20,$E0,$20,$E0,$20,$E0,$20,$E0,$A0,$E0
DB $10,$1E,$10,$1F,$10,$1F,$10,$1F,$10,$1F,$20,$23,$20,$20,$40,$40
DB $00,$00,$00,$00,$03,$FF,$02,$FE,$02,$FE,$01,$FD,$00,$F8,$00,$00
DB $01,$01,$3E,$3E,$C0,$C0,$00,$00,$00,$00,$0F,$0F,$F0,$F0,$70,$70
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$41,$41,$C0,$C0
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E0,$E0,$3F,$3F
DB $FF,$B0,$FF,$90,$FF,$88,$7F,$48,$7F,$68,$3F,$24,$1F,$14,$0F,$0E
DB $A0,$E0,$A0,$E0,$F0,$70,$F0,$70,$F8,$38,$F8,$18,$FE,$0E,$FF,$03
DB $00,$00,$00,$00,$03,$03,$06,$06,$0C,$0C,$30,$30,$40,$40,$C0,$C0
DB $00,$00,$1F,$1F,$F0,$F0,$C0,$C0,$70,$70,$18,$18,$0F,$0F,$01,$01
DB $80,$80,$00,$00,$F8,$F8,$0F,$0F,$00,$00,$00,$00,$00,$00,$FF,$FF
DB $00,$00,$01,$01,$02,$02,$C0,$C0,$00,$00,$00,$00,$00,$00,$FF,$FF
DB $C1,$C1,$01,$01,$01,$01,$03,$03,$06,$06,$0C,$0C,$38,$38,$E0,$E0
DB $C0,$C0,$70,$70,$1C,$1C,$06,$06,$03,$03,$01,$01,$01,$01,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$80
DB $07,$07,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $FF,$03,$FE,$8E,$F8,$D8,$30,$30,$10,$10,$10,$10,$20,$20,$60,$60
DB $00,$00,$00,$00,$00,$00,$00,$00,$08,$08,$14,$1C,$08,$08,$00,$00
DB $20,$20,$20,$20,$30,$30,$10,$10,$10,$10,$18,$18,$08,$08,$0C,$0C
DB $08,$08,$04,$04,$04,$04,$05,$05,$06,$06,$02,$02,$02,$02,$03,$03
DB $01,$01,$41,$41,$81,$81,$02,$02,$04,$04,$08,$08,$30,$30,$C0,$C0
DB $60,$60,$30,$30,$18,$18,$08,$08,$00,$00,$06,$06,$03,$03,$01,$01
DB $00,$00,$00,$5A,$11,$28,$18,$66,$36,$49,$38,$46,$08,$34,$48,$08
DB $40,$40,$60,$60,$70,$70,$5C,$5C,$4E,$4E,$43,$43,$40,$40,$C0,$C0
DB $00,$00,$10,$10,$08,$08,$06,$06,$02,$02,$01,$01,$E0,$E0,$3F,$3F
DB $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$C0,$C0,$40,$40
DB $04,$04,$04,$04,$02,$02,$02,$02,$43,$43,$A1,$E1,$41,$41,$01,$01
DB $03,$03,$03,$03,$03,$03,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
DB $00,$00,$00,$00,$80,$80,$C0,$C0,$60,$60,$30,$30,$18,$18,$0C,$0C
DB $08,$08,$18,$18,$10,$10,$30,$30,$20,$20,$33,$33,$1E,$1F,$1C,$1F
DB $00,$00,$00,$00,$00,$00,$03,$03,$0F,$0F,$9F,$9F,$FF,$FF,$7F,$FF
DB $01,$01,$1F,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $80,$80,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$03,$03,$02,$02,$02,$02
DB $C0,$C0,$E0,$E0,$A0,$A0,$30,$30,$10,$10,$08,$08,$0C,$0C,$0C,$0C
DB $01,$01,$01,$01,$01,$01,$01,$01,$03,$03,$02,$02,$02,$02,$06,$06
DB $02,$02,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $18,$1F,$31,$3F,$63,$7F,$67,$7F,$3F,$3F,$1F,$1F,$1F,$1F,$1F,$1F
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$07,$07,$07,$07,$07,$07
DB $04,$04,$02,$02,$01,$01,$01,$01,$00,$00,$00,$00,$80,$80,$C0,$C0
DB $00,$00,$00,$00,$00,$00,$80,$80,$F0,$F0,$DE,$DE,$43,$43,$70,$70
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$01,$01
DB $40,$40,$40,$40,$40,$40,$47,$47,$5C,$5C,$60,$60,$80,$80,$18,$18
DB $1E,$1E,$32,$32,$E5,$E5,$09,$09,$11,$11,$07,$06,$0F,$0C,$3F,$38
DB $00,$00,$00,$00,$00,$00,$80,$80,$C0,$C0,$E0,$E0,$D8,$D8,$EC,$6C
DB $3F,$3F,$3F,$3F,$3F,$3F,$7F,$7F,$7F,$7F,$7F,$7F,$FF,$FF,$FF,$FF
DB $FF,$FF,$FF,$FF,$FF,$FF,$FE,$FE,$FE,$FE,$FC,$FC,$FC,$FC,$F8,$F8
DB $0F,$0F,$0F,$0F,$1F,$1F,$1F,$1F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F
DB $C0,$C0,$C0,$C0,$E3,$E3,$EF,$EF,$F9,$F9,$FB,$FA,$E7,$E6,$C7,$C4
DB $9E,$9E,$80,$80,$E0,$E0,$FC,$BC,$FF,$07,$FF,$00,$FF,$00,$FF,$00
DB $00,$00,$00,$00,$FF,$FF,$00,$00,$80,$80,$FF,$FF,$FF,$00,$FF,$00
DB $00,$00,$01,$01,$1E,$1E,$00,$00,$3F,$3F,$FF,$E0,$FF,$00,$FF,$00
DB $60,$60,$83,$83,$1F,$1E,$FF,$F0,$FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $7F,$60,$FF,$80,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $C3,$C3,$E1,$21,$F0,$10,$F8,$08,$FC,$04,$FE,$02,$FF,$01,$FF,$01
DB $80,$80,$80,$80,$40,$40,$20,$20,$10,$10,$08,$08,$04,$04,$03,$03
DB $F8,$F8,$F8,$F8,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$E0,$E0,$E0,$E0
DB $7F,$7F,$7F,$7F,$7F,$7F,$7E,$7E,$FC,$FC,$F8,$F8,$F0,$F0,$E1,$E1
DB $8F,$88,$1F,$18,$3F,$30,$3F,$20,$7F,$40,$FF,$C0,$FF,$80,$FF,$00
DB $C0,$C0,$E0,$20,$F0,$10,$F8,$08,$FC,$04,$FE,$02,$FF,$01,$FF,$01

; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: title.png
; Pixel Width: 160px
; Pixel Height: 24px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

title_tile_map_size EQU $3C
title_tile_map_width EQU $14
title_tile_map_height EQU $03

title_tile_data_size EQU $0370
title_tile_count EQU $37

; ////////////////
; //            //
; //  Map Data  //
; //            //
; ////////////////

title_map_data:
DB $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F
DB $20,$21,$22,$10,$10,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D
DB $2E,$2F,$30,$31,$32,$33,$34,$10,$10,$35,$36,$37,$38,$39,$3A,$3B
DB $3C,$3D,$3E,$3F,$40,$41,$42,$43,$44,$45,$46,$10

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

title_tile_data:
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$3F,$3F,$20,$3F,$20,$3F,$27,$38,$27,$38,$23,$3C
DB $00,$00,$00,$00,$FF,$FF,$00,$FF,$00,$FF,$FF,$00,$EF,$10,$E7,$18
DB $00,$00,$00,$00,$FF,$FF,$00,$FF,$00,$FF,$1F,$E0,$9F,$60,$CF,$30
DB $00,$00,$00,$00,$F8,$F8,$08,$F8,$08,$F8,$C9,$39,$C9,$39,$8B,$7B
DB $00,$00,$00,$00,$FF,$FF,$80,$FF,$80,$FF,$9F,$E0,$1F,$E0,$1F,$E0
DB $00,$00,$03,$03,$FE,$FF,$30,$FF,$20,$FF,$23,$FC,$07,$F8,$07,$F8
DB $00,$00,$F8,$F8,$0F,$FF,$00,$FF,$40,$BF,$FE,$01,$DE,$21,$8E,$71
DB $00,$00,$00,$00,$FF,$FF,$00,$FF,$00,$FF,$FF,$00,$FF,$00,$EF,$10
DB $00,$00,$00,$00,$FF,$FF,$01,$FF,$01,$FF,$F9,$07,$B9,$47,$B9,$47
DB $00,$00,$00,$00,$FF,$FF,$00,$FF,$00,$FF,$3F,$C0,$1F,$E0,$0F,$F0
DB $00,$00,$00,$00,$FF,$FF,$00,$FF,$00,$FF,$8F,$70,$8F,$70,$CF,$30
DB $00,$00,$00,$00,$FF,$FF,$06,$FF,$06,$FF,$E6,$1F,$C4,$3F,$C4,$3F
DB $00,$00,$00,$00,$FF,$FF,$00,$FF,$00,$FF,$7C,$83,$7C,$83,$7C,$83
DB $00,$00,$00,$00,$FF,$FF,$00,$FF,$00,$FF,$3F,$C0,$3F,$C0,$1F,$E0
DB $00,$00,$00,$00,$FF,$FF,$00,$FF,$00,$FF,$9F,$60,$9F,$60,$0F,$F0
DB $00,$00,$00,$00,$FF,$FF,$01,$FF,$00,$FF,$F8,$07,$BC,$43,$BE,$41
DB $00,$00,$3F,$3F,$E0,$FF,$00,$FF,$04,$FB,$3F,$C0,$7D,$82,$78,$87
DB $00,$00,$80,$80,$FC,$FC,$04,$FC,$04,$FC,$E4,$1C,$E4,$1C,$E4,$1C
DB $23,$3C,$33,$3C,$13,$1C,$13,$1C,$13,$1C,$13,$1C,$13,$1C,$33,$3C
DB $E7,$18,$E7,$18,$E7,$18,$EF,$10,$FF,$00,$EF,$10,$E7,$18,$E7,$18
DB $CF,$30,$CF,$30,$CF,$30,$8F,$70,$0F,$F0,$8F,$70,$CF,$30,$CF,$30
DB $8A,$7B,$9A,$7B,$92,$73,$96,$77,$9C,$7F,$80,$7F,$80,$7F,$8C,$73
DB $3F,$C0,$3F,$C0,$6F,$90,$6F,$90,$6F,$90,$4F,$B0,$CF,$30,$FF,$00
DB $87,$78,$8F,$70,$87,$78,$87,$78,$C7,$38,$C3,$3C,$C4,$3B,$CE,$31
DB $86,$79,$E6,$19,$F8,$07,$FC,$03,$FE,$01,$FF,$00,$FF,$00,$3F,$C0
DB $CF,$30,$CF,$30,$0F,$F0,$0F,$F0,$0F,$F0,$0F,$F0,$0F,$F0,$0F,$F0
DB $99,$67,$99,$67,$81,$7F,$81,$7F,$9F,$7F,$90,$70,$90,$70,$98,$78
DB $8F,$F0,$C7,$F8,$4F,$70,$4F,$70,$4F,$70,$4F,$70,$4F,$70,$CD,$F2
DB $DF,$20,$DF,$20,$FF,$00,$FF,$00,$FF,$00,$EF,$10,$EF,$10,$EF,$10
DB $C8,$3F,$C8,$3F,$C9,$3E,$C9,$3E,$C1,$3E,$C1,$3E,$C3,$3C,$C3,$3C
DB $FE,$01,$FE,$01,$BE,$41,$BE,$41,$BF,$40,$3F,$C0,$3F,$C0,$FF,$00
DB $1F,$E0,$1F,$E0,$1F,$E0,$1F,$E0,$1F,$E0,$1F,$E0,$1F,$E0,$1F,$E0
DB $0F,$F0,$0F,$F0,$0F,$F0,$0F,$F0,$0F,$F0,$0F,$F0,$0F,$F0,$0F,$F0
DB $9E,$61,$9F,$60,$9F,$60,$9F,$60,$9F,$60,$9F,$60,$9F,$60,$9F,$60
DB $78,$87,$FE,$01,$7F,$80,$7F,$80,$7F,$80,$3F,$C0,$4F,$B0,$E3,$1C
DB $64,$9C,$64,$9C,$86,$7E,$C2,$3E,$E2,$1E,$F2,$0E,$F2,$0E,$F2,$0E
DB $23,$3C,$23,$3C,$27,$38,$27,$38,$20,$3F,$20,$3F,$3F,$3F,$00,$00
DB $E7,$18,$E7,$18,$EF,$10,$FF,$00,$00,$FF,$00,$FF,$FF,$FF,$00,$00
DB $CF,$30,$CF,$30,$DF,$20,$9F,$60,$00,$FF,$00,$FF,$FF,$FF,$00,$00
DB $8C,$73,$9D,$62,$BF,$40,$FF,$00,$00,$FF,$00,$FF,$FF,$FF,$00,$00
DB $C7,$38,$87,$78,$C7,$38,$EF,$10,$00,$FF,$00,$FF,$FF,$FF,$00,$00
DB $EE,$11,$EF,$10,$EF,$10,$F5,$0A,$00,$FF,$00,$FF,$FF,$FF,$01,$01
DB $1F,$E0,$1E,$E1,$9E,$61,$FC,$03,$20,$DF,$00,$FF,$07,$FF,$FC,$FC
DB $0F,$F0,$0F,$F0,$1F,$E0,$1F,$E0,$00,$FF,$80,$FF,$FF,$FF,$00,$00
DB $8C,$7C,$84,$7C,$C4,$3C,$E4,$1C,$05,$FD,$07,$FE,$FF,$FD,$0F,$0B
DB $8D,$F2,$8D,$F2,$9E,$E1,$9E,$E1,$80,$FF,$80,$FF,$FF,$FF,$FF,$00
DB $CF,$30,$CF,$30,$CF,$30,$DF,$20,$00,$FF,$00,$FF,$FF,$FF,$FF,$00
DB $C3,$3C,$C6,$39,$CF,$30,$EF,$10,$00,$FF,$00,$FF,$FF,$FF,$F8,$18
DB $1F,$E0,$1F,$E0,$1F,$E0,$BF,$40,$00,$FF,$00,$FF,$FF,$FF,$3F,$3F
DB $9F,$60,$9F,$60,$BF,$40,$FF,$00,$00,$FF,$00,$FF,$FF,$FF,$FF,$F8
DB $0F,$F0,$0F,$F0,$1F,$E0,$9F,$60,$00,$FF,$00,$FF,$FF,$FF,$FF,$1F
DB $9E,$61,$BE,$41,$BC,$43,$F8,$07,$00,$FF,$00,$FF,$FF,$FF,$F8,$F8
DB $E1,$1E,$F1,$0E,$F9,$06,$5F,$A0,$02,$FD,$00,$FF,$F0,$FF,$1F,$1F
DB $F2,$0E,$E2,$1E,$E2,$1E,$C6,$3E,$04,$FC,$0C,$FC,$78,$F8,$C0,$C0

; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: font.png
; Pixel Width: 128px
; Pixel Height: 24px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

font_tile_count EQU $25
font_tile_data_size EQU font_tile_count * 16

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

font_tile_data:
DB $00,$00,$20,$20,$50,$50,$50,$50,$F8,$F8,$88,$88,$88,$88,$00,$00
DB $00,$00,$F0,$F0,$88,$88,$F0,$F0,$88,$88,$88,$88,$F0,$F0,$00,$00
DB $00,$00,$70,$70,$88,$88,$80,$80,$80,$80,$88,$88,$70,$70,$00,$00
DB $00,$00,$F0,$F0,$88,$88,$88,$88,$88,$88,$88,$88,$F0,$F0,$00,$00
DB $00,$00,$F8,$F8,$80,$80,$F0,$F0,$80,$80,$80,$80,$F8,$F8,$00,$00
DB $00,$00,$F8,$F8,$80,$80,$F0,$F0,$80,$80,$80,$80,$80,$80,$00,$00
DB $00,$00,$70,$70,$88,$88,$80,$80,$98,$98,$88,$88,$78,$78,$00,$00
DB $00,$00,$88,$88,$88,$88,$F8,$F8,$88,$88,$88,$88,$88,$88,$00,$00
DB $00,$00,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$00,$00
DB $00,$00,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$80,$80
DB $00,$00,$88,$88,$90,$90,$A0,$A0,$E0,$E0,$90,$90,$88,$88,$00,$00
DB $00,$00,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$F8,$F8,$00,$00
DB $00,$00,$84,$84,$CC,$CC,$CC,$CC,$B4,$B4,$B4,$B4,$84,$84,$00,$00
DB $00,$00,$88,$88,$C8,$C8,$A8,$A8,$A8,$A8,$98,$98,$88,$88,$00,$00
DB $00,$00,$70,$70,$88,$88,$88,$88,$88,$88,$88,$88,$70,$70,$00,$00
DB $00,$00,$F0,$F0,$88,$88,$88,$88,$F0,$F0,$80,$80,$80,$80,$00,$00
DB $00,$00,$70,$70,$88,$88,$88,$88,$88,$88,$88,$88,$70,$70,$08,$08
DB $00,$00,$F0,$F0,$88,$88,$88,$88,$F0,$F0,$90,$90,$88,$88,$00,$00
DB $00,$00,$70,$70,$88,$88,$60,$60,$10,$10,$88,$88,$70,$70,$00,$00
DB $00,$00,$F8,$F8,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00
DB $00,$00,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$70,$70,$00,$00
DB $00,$00,$88,$88,$88,$88,$88,$88,$50,$50,$50,$50,$20,$20,$00,$00
DB $00,$00,$84,$84,$B4,$B4,$B4,$B4,$B4,$B4,$48,$48,$48,$48,$00,$00
DB $00,$00,$88,$88,$50,$50,$20,$20,$20,$20,$50,$50,$88,$88,$00,$00
DB $00,$00,$88,$88,$50,$50,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00
DB $00,$00,$F8,$F8,$08,$08,$10,$10,$60,$60,$80,$80,$F8,$F8,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$60,$60,$90,$90,$90,$90,$90,$90,$90,$90,$60,$60,$00,$00
DB $00,$00,$20,$20,$60,$60,$20,$20,$20,$20,$20,$20,$20,$20,$00,$00
DB $00,$00,$60,$60,$90,$90,$10,$10,$60,$60,$80,$80,$F0,$F0,$00,$00
DB $00,$00,$60,$60,$10,$10,$60,$60,$10,$10,$90,$90,$60,$60,$00,$00
DB $00,$00,$30,$30,$50,$50,$90,$90,$F0,$F0,$10,$10,$10,$10,$00,$00
DB $00,$00,$70,$70,$80,$80,$E0,$E0,$10,$10,$90,$90,$60,$60,$00,$00
DB $00,$00,$60,$60,$80,$80,$E0,$E0,$90,$90,$90,$90,$60,$60,$00,$00
DB $00,$00,$F0,$F0,$10,$10,$20,$20,$20,$20,$40,$40,$40,$40,$00,$00
DB $00,$00,$60,$60,$90,$90,$60,$60,$90,$90,$90,$90,$60,$60,$00,$00
DB $00,$00,$60,$60,$90,$90,$90,$90,$70,$70,$10,$10,$60,$60,$00,$00


;****************************************************************
CHARMAP "A", $50
CHARMAP "B", $51
CHARMAP "C", $52
CHARMAP "D", $53
CHARMAP "E", $54
CHARMAP "F", $55
CHARMAP "G", $56
CHARMAP "H", $57
CHARMAP "I", $58
CHARMAP "J", $59
CHARMAP "K", $5A
CHARMAP "L", $5B
CHARMAP "M", $5C
CHARMAP "N", $5D
CHARMAP "O", $5E
CHARMAP "P", $5F
CHARMAP "Q", $60
CHARMAP "R", $61
CHARMAP "S", $62
CHARMAP "T", $63
CHARMAP "U", $64
CHARMAP "V", $65
CHARMAP "W", $66
CHARMAP "X", $67
CHARMAP "Y", $68
CHARMAP "Z", $69
CHARMAP " ", $6A
CHARMAP "0", $6B
CHARMAP "1", $6C
CHARMAP "2", $6D
CHARMAP "3", $6E
CHARMAP "4", $6F
CHARMAP "5", $70
CHARMAP "6", $71
CHARMAP "7", $72
CHARMAP "8", $73
CHARMAP "9", $74

MENU_MESSAGE_START:
    db "START", 0

MENU_MESSAGE_HELP:
    db "HELP", 0