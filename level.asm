SECTION "Level", ROM0
;object Level {
;   byte Data
;       **** ***x -> {Powerups     1: On, 0: Off}
;       **** **x* -> {Random holes 1: On, 0: Off}
;       **** *x** -> {Wave effect  1: On, 0: Off}
;       **** x*** -> {Lights out   1: On, 0: Off}
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

    LCDC_OFF
    push hl
    ld hl, _SCRN0
    ld bc, _LEVEL_TILE_MAP_SIZE
    call MEMCPY
    pop hl
    LCDC_ON

    ld a, [hl+]
    ld d, a
    ld a, [hl+]
    ld e, a

    ld hl, level_map
    ld bc, _LEVEL_SIZE
    call MEMCPY
    ret 