SECTION "Player", ROM0
;****************************************************************************************************
;@param Y
;@param X
;@param Tile_ID
;@param Attributes
;****************************************************************************************************

; top-left: x + 4, y + 4
; bottom-right: x + 12, y + 16
PLAYER_LOAD:
    ld hl, shadowOAM ;Set stack to point at the OAM
    ld a, [pY]
    ld [hl+], a ;Y
    ld a, [pX]
    ld [hl+], a ;X
    ld a, 0
    ld [hl+], a ;Tile ID
    xor a
    ld [hl+], a ;Attributes

    ld a, [pY]
    ld [hl+], a ;Y
    ld a, [pX]
    add a, 8
    ld [hl+], a ;X
    ld a, 0
    ld [hl+], a ;Tile ID
    ld a, %0010_0000
    ld [hl+], a ;Attributes
    ret
    
PLAYER_UPDATE:
    ld a, [rSCY]
    ld b, a
    ld a, [pY]
    ld d, a
    add a, 16
    sub a, b
    ld [shadowOAM], a ;Y
    ld [shadowOAM + 4], a ;Y

    ld a, [rSCX]
    ld b, a
    ld a, [pX]
    ld e, a
    add a, 8
    sub a, b
    ld [shadowOAM + 1], a ;X
    add a, 8
    ld [shadowOAM + 4 + 1], a
    ret

PLAYER_CHECK_HIT:
    ld a, [pY]
    add 8
    ld b, a
    ld a, [pX]
    add 8
    ld c, a

    POSITION_GET b
    POSITION_GET c

    call WEIGHT_GET
    ld a, [hl]
    bit 7, a
    ret z
    cp _WEIGHTS_BOMB
    ret nc
    ;Hit by a bomb

    ld a, [alive]
    res 0, a
    ld [alive], a
    ret 
    
    