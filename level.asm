SECTION "Level", ROM0
;object Level {
;   byte Data
;       **** ***x -> {Powerups        1: On, 0: Off}
;       **** **x* -> {Random holes    1: On, 0: Off}
;       **** *x** -> {Wave effect     1: On, 0: Off}
;       **** x*** -> {Lights out      1: On, 0: Off}
;       ***x **** -> {Vertical flip   1: On, 0: Off}
;       **x* **** -> {Horizontal flip 1: On, 0: Off}
;   byte Actors
;       **** ***x -> Player (must always be 1)
;       **** **x* -> {Bura    1: On, 0: Off}
;       **** *x** -> {Suto    1: On, 0: Off}
;       **** x*** -> {Kanpaku 1: On, 0: Off}
;
;   byte Tile map data high byte
;   byte Tile map data low byte
;   byte Level map data high byte
;   byte Level map data low byte
;   byte[2] FREE
;}
;8 bytes * 4 levels = 32 bytes



LEVEL_LOAD:
    ld a, [currentLevel]
    ld hl, levels_array
    rlca 
    rlca 
    rlca 
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a

    ld a, [hl+] ;data
    ld [levelData], a
    ld a, [hl+] ;actors
    ld [alive], a

    ld a, [hl+]
    ld d, a
    ld a, [hl+]
    ld e, a 
    push hl
    ld hl, level_tiles
    ld bc, 8
    call MEMCPY
    pop hl

    ld a, [hl+]
    ld d, a
    ld a, [hl+]
    ld e, a

    call LEVEL_DECOMPRESS

    call LEVEL_TILEMAP_DECOMPRESS
    ret 

LEVEL_DECOMPRESS:
    ld hl, level_map
.loop:
    ld a, [de]
    ld bc, level_unique_rows
    rlca 
    rlca 
    rlca 
    add a, c
    ld c, a
    ld a, 0
    adc b
    ld b, a
.copy_loop:
    ld a, [bc]
    inc bc
    ld [hl+], a
    ld a, [bc]
    inc bc
    ld [hl+], a
    ld a, l
    and $07
    jr nz, .copy_loop

    inc de
    ld a, l
    cp LOW(level_map + _LEVEL_SIZE)
    jr nz, .loop
    ret


LEVEL_TILEMAP_DECOMPRESS:
    LCDC_OFF
    ld de, level_map
    ld hl, _SCRN0
.loop:
    ld a, l
    and $03
    ld a, [de]
    jr nz, .second_nibble
    and $F0
    swap a
.second_nibble:
    and $0F
    bit 3, a
    jr z, .skip_copy_block

    sub _TILES_WALL_ID
    ld bc, level_tiles
    rlca 
    rlca 
    add a, c
    ld c, a
    ld a, 0
    adc b
    ld b, a
    ld a, [bc]
    inc bc

    ld [hl+], a
    ld a, [bc]
    inc bc
    ld [hl+], a

    push hl
    ld a, l
    add 30
    ld l, a
    ld a, 0
    adc h
    ld h, a
    ld a, [bc]
    inc bc
    ld [hl+], a
    ld a, [bc]
    ld [hl+], a
    pop hl

.return_skip_copy_block:
    ld a, l
    and $03
    jr nz, .loop

    inc de

    ld a, l
    and $1F
    jr nz, .next_line
    ld bc, 32
    add hl, bc
.next_line:
    ld a, h
    cp HIGH(_SCRN1)
    jr nz, .loop
    LCDC_ON
    ret 

.skip_copy_block:
    xor a
    ld [hl+], a
    ld [hl+], a
    ld b, h
    ld c, l
    ld a, l
    add 30
    ld l, a
    ld a, 0
    adc h
    ld h, a
    xor a
    ld [hl+], a
    ld [hl+], a
    ld h, b
    ld l, c
    jr .return_skip_copy_block