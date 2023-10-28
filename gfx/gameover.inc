SECTION "Gameover tiles", ROMX
; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: gameover.png
; Pixel Width: 160px
; Pixel Height: 144px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

gameover_tile_map_size EQU $0168
gameover_tile_map_width EQU $14
gameover_tile_map_height EQU $12

gameover_tile_data_size EQU $0460
gameover_tile_count EQU $46

; ////////////////
; //            //
; //  Map Data  //
; //            //
; ////////////////

gameover_map_data:
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BB,$BC,$BD,$BA,$BE,$BF,$C0,$C1,$C2
DB $C3,$C4,$C5,$C6,$C7,$BA,$BA,$BA,$BA,$BA,$BA,$C8,$C9,$CA,$CB,$CC
DB $CD,$CE,$CF,$D0,$D1,$D2,$D3,$D4,$D5,$BA,$BA,$BA,$BA,$BA,$BA,$D6
DB $D7,$D8,$D9,$DA,$DB,$DC,$DD,$DE,$DF,$E0,$E1,$E2,$E3,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$E4,$E5,$E6,$E7
DB $E8,$E9,$C5,$EA,$EB,$C5,$EC,$ED,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $C8,$EE,$EF,$F0,$F1,$F2,$D3,$F3,$F4,$D3,$F5,$F6,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$F7,$F8,$F9,$FA,$FB,$BA,$E1,$FC,$FD,$E1,$FE,$FF
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA
DB $BA,$BA,$BA,$BA,$BA,$BA,$BA,$BA

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

gameover_tile_data:
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $FF,$FF,$FF,$F8,$FF,$F0,$F8,$E7,$F0,$C8,$F0,$C8,$E0,$90,$E0,$90
DB $FF,$00,$FF,$0C,$3F,$DF,$3F,$5F,$3F,$5F,$3F,$5F,$3F,$5F,$3F,$5F
DB $FF,$79,$FF,$01,$FF,$81,$F7,$C9,$FF,$E1,$FF,$F1,$FF,$F9,$FF,$F9
DB $FF,$E0,$FF,$C0,$F0,$CF,$F0,$C8,$E0,$D0,$E0,$D0,$F0,$C8,$F8,$A4
DB $FF,$0F,$FF,$0F,$1F,$E7,$1F,$27,$1F,$27,$0F,$13,$0F,$13,$0F,$13
DB $FF,$FC,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $FF,$00,$FF,$00,$C0,$3F,$C0,$20,$C0,$20,$C0,$20,$E0,$10,$F0,$08
DB $FF,$1F,$FF,$0F,$3F,$CF,$3F,$4F,$1F,$27,$1F,$27,$0F,$13,$0F,$13
DB $FF,$E0,$FF,$E0,$F0,$CF,$F0,$C8,$F0,$C8,$E0,$90,$F0,$88,$F8,$24
DB $FF,$00,$FF,$07,$1F,$E7,$1F,$27,$1F,$27,$1F,$27,$1F,$27,$1F,$27
DB $FF,$00,$FF,$C0,$F0,$CF,$F0,$C8,$F0,$C8,$F0,$C8,$F0,$C8,$F0,$C8
DB $FF,$00,$FF,$02,$07,$FB,$07,$0B,$07,$0B,$07,$0B,$07,$0B,$07,$0B
DB $FF,$01,$FF,$01,$FF,$E1,$FF,$F1,$FF,$F9,$FF,$F9,$FF,$DD,$FF,$9F
DB $C0,$20,$C0,$20,$C0,$20,$C0,$20,$C0,$20,$C0,$20,$C0,$20,$C0,$20
DB $3F,$5F,$3F,$5F,$3F,$5F,$3F,$5F,$3F,$5F,$3F,$50,$3F,$5C,$3F,$5C
DB $FF,$F9,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$FF,$00,$03,$FC
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7E,$FF,$FE,$FF,$FE
DB $F8,$A4,$FC,$B2,$FC,$32,$FC,$32,$FE,$79,$FE,$79,$FE,$79,$FF,$FC
DB $07,$09,$07,$09,$07,$09,$03,$04,$03,$04,$03,$04,$01,$02,$01,$82
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$FF,$7F
DB $F8,$24,$F8,$24,$FC,$32,$FC,$32,$FC,$32,$FE,$39,$FE,$39,$FF,$3C
DB $07,$09,$03,$04,$01,$02,$01,$02,$03,$04,$03,$04,$03,$04,$07,$89
DB $F8,$24,$F8,$64,$F8,$64,$F8,$64,$F8,$E4,$F8,$E4,$F8,$E4,$F8,$E4
DB $1F,$27,$1F,$27,$1F,$27,$1F,$27,$1F,$27,$1F,$27,$1F,$27,$1F,$27
DB $F0,$C8,$F0,$C8,$F0,$C8,$F0,$C8,$F0,$C8,$F0,$C8,$F0,$C8,$F0,$C8
DB $07,$0B,$07,$0B,$07,$0A,$07,$00,$07,$0A,$07,$0B,$07,$0B,$07,$0B
DB $FF,$9F,$FF,$9F,$FF,$1F,$FF,$1F,$FF,$1F,$FF,$1F,$FF,$9F,$FF,$9C
DB $C0,$20,$E0,$90,$E0,$90,$F0,$CC,$FC,$E3,$FF,$F0,$FF,$FC,$FF,$FF
DB $3F,$5C,$3F,$5C,$3F,$5C,$3F,$5C,$3F,$5C,$3F,$DC,$FF,$08,$FF,$00
DB $03,$84,$03,$84,$03,$84,$03,$9C,$1B,$E4,$7F,$80,$FF,$18,$FF,$7C
DB $FF,$FC,$FF,$FC,$FF,$F9,$FF,$F8,$FF,$F0,$FF,$F0,$FF,$C0,$FF,$C0
DB $FE,$01,$FF,$FC,$FF,$FE,$FF,$FE,$FF,$FE,$FF,$FF,$FF,$3F,$FF,$1C
DB $01,$02,$00,$81,$80,$41,$80,$41,$80,$40,$C0,$3F,$FF,$00,$FF,$00
DB $FF,$7F,$FF,$3F,$FF,$3F,$FF,$3F,$7F,$9F,$7F,$9F,$FF,$1C,$FF,$00
DB $FF,$3C,$FF,$3C,$FF,$3E,$FF,$3E,$FF,$3E,$FF,$1F,$FF,$0F,$FF,$03
DB $07,$89,$0F,$93,$8F,$53,$8F,$53,$9F,$67,$DF,$27,$FF,$0F,$FF,$8F
DB $F8,$E4,$F8,$E4,$F8,$E4,$F8,$E4,$F8,$E4,$F8,$E7,$FF,$E0,$FF,$00
DB $1F,$27,$1F,$27,$1F,$27,$1F,$27,$1F,$27,$1F,$E7,$FF,$07,$FF,$00
DB $F0,$C8,$F0,$C8,$F0,$C8,$F0,$C8,$F0,$C8,$F0,$CF,$FF,$C0,$FF,$00
DB $07,$0B,$07,$0B,$07,$0B,$07,$0B,$07,$0B,$07,$FB,$FF,$02,$FF,$00
DB $FF,$DC,$FF,$FC,$FF,$F8,$FF,$F0,$FB,$E4,$F3,$CC,$FF,$00,$FF,$00
DB $FF,$FE,$FF,$F0,$FE,$E1,$F0,$EE,$E0,$D0,$E0,$90,$E0,$90,$C0,$20
DB $FF,$00,$FF,$10,$7E,$B9,$7E,$B9,$7E,$B9,$7E,$B9,$7E,$B9,$7E,$B9
DB $FF,$FC,$FF,$3F,$FF,$1F,$3F,$C7,$1F,$27,$0F,$13,$07,$0B,$07,$0B
DB $FF,$00,$FF,$00,$C0,$3F,$E0,$90,$E0,$90,$E0,$90,$F0,$C8,$F0,$C8
DB $FF,$1E,$FF,$3F,$7F,$9F,$7F,$9F,$7F,$9F,$3F,$5F,$3F,$5F,$3F,$5F
DB $FF,$01,$FF,$03,$FF,$C7,$FF,$CF,$FF,$CF,$FF,$DF,$FF,$9F,$FF,$BF
DB $FF,$00,$FF,$08,$3F,$CF,$3F,$4F,$3F,$4F,$3F,$4F,$3F,$4E,$3F,$4C
DB $FF,$1E,$FF,$1F,$FF,$1F,$FF,$9F,$FF,$DF,$FF,$DF,$FF,$FF,$FF,$FF
DB $FF,$00,$FF,$18,$7C,$9B,$7E,$9D,$7E,$9D,$7E,$9D,$7E,$9D,$7E,$9D
DB $FF,$07,$FF,$07,$07,$FB,$07,$0B,$07,$0B,$07,$0B,$07,$0B,$07,$0B
DB $7E,$B9,$7E,$B9,$7E,$B9,$7E,$B9,$7E,$B9,$7E,$B9,$7E,$B9,$7E,$B9
DB $07,$0B,$03,$05,$03,$05,$03,$05,$03,$05,$03,$05,$03,$05,$07,$0B
DB $F0,$C8,$F8,$E0,$F8,$E0,$F8,$E0,$F8,$F4,$F8,$F4,$F8,$F4,$FC,$FA
DB $1F,$2F,$1F,$2F,$1F,$07,$1F,$06,$1F,$06,$0F,$12,$07,$08,$03,$04
DB $FF,$BF,$FF,$3F,$FF,$3F,$FF,$3F,$FF,$7F,$FF,$7F,$FF,$FF,$FF,$FF
DB $3F,$4C,$3F,$4C,$3F,$48,$1F,$20,$3F,$48,$3F,$48,$3F,$4C,$3F,$4C
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$EF
DB $7E,$9D,$7C,$9A,$7C,$92,$3C,$42,$7C,$9A,$7C,$9A,$7E,$9D,$7E,$9D
DB $07,$0B,$0F,$17,$1F,$27,$3F,$4F,$1F,$27,$0F,$13,$07,$0B,$07,$0B
DB $E0,$90,$E0,$90,$E0,$90,$E0,$D8,$F8,$E6,$FE,$E1,$FF,$F8,$FF,$FE
DB $7E,$B9,$7E,$B9,$7E,$B9,$7E,$B9,$7E,$B9,$7E,$B9,$FF,$10,$FF,$00
DB $07,$0B,$07,$0B,$0F,$13,$1F,$27,$3F,$C7,$FF,$1F,$FF,$3F,$FF,$FF
DB $FC,$FA,$FC,$FA,$FE,$F9,$FE,$F9,$FE,$F9,$FF,$FC,$FF,$FC,$FF,$FE
DB $07,$09,$07,$09,$0F,$13,$0F,$13,$0F,$13,$1F,$E7,$FF,$07,$FF,$0F
DB $3F,$4E,$3F,$4F,$3F,$4F,$3F,$4F,$3F,$4F,$3F,$CE,$FF,$08,$FF,$00
DB $FF,$EF,$FF,$EF,$FF,$CF,$FF,$8F,$DF,$2F,$9F,$6F,$FF,$0F,$FF,$0E
DB $7E,$9D,$7E,$9D,$7E,$9D,$7E,$9D,$7E,$9D,$7E,$9D,$FF,$1C,$FF,$06
DB $07,$0B,$07,$0B,$07,$0B,$07,$0B,$07,$00,$03,$FC,$FF,$01,$FF,$03
