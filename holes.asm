SECTION "Holes", ROM0

;Decide if we can place a hole
HOLE_EVENT_CHECK:
    ld a, [levelData]
    bit 1, a
    ret z

    ld a, [timerSeconds]
    sub a, _HOLES_SPAWN_TIME
    ret c
    xor a
    ld [timerSeconds], a
    ld a, [holesCount]
    cp _HOLES_NUMBER_LIMIT
    jr z, HOLE_CLEAR
    call HOLE_PLACE
    ret 

HOLE_PLACE:
    ;Generate random number in bc
    ;b will be the y value, c will be the x value
    call rand 
    ;Get their tile positions in the map
    POSITION_GET b
    POSITION_GET c
    ;Get the tile from that position
    call WEIGHT_GET
    ld a, [hl]
    cp _WEIGHTS_EMPTY ;Check if empty
    ;If it's not then generate another position
    jr nz, HOLE_PLACE
    ;If it is, then place a hole there and increase the counter
    call TILE_GET
    and $F0
    or _TILES_HOLE_ID
    bit 0, c
    jr nz, .no_swap
    swap a
.no_swap:
    ld [hl], a
    ld d, 0
    ld a, [holesCount]
    ld e, a
    sla e ;Multiply the counter by 2
    inc a
    ld [holesCount], a ;Increase counter
    ;Add to array
    ld hl, holes_array
    add hl, de
    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ;Finally, load the tile into the screen
    call WEIGHT_GET
    ld a, _WEIGHTS_BLOCK
    ld [hl], a

    call MAP_TO_ADDRESS
    ld de, hole_map_data
    ld b, hole_tile_height
    ld c, hole_tile_width
    call TILECPY
    ret

HOLE_CLEAR:
    ld a, [holesCount]
    ld d, 0
    ld e, a ;Counter
    dec a
    ld [holesCount], a

    ;Take the first element from the array and clear it
    ld hl, holes_array
    ld a, [hl+]
    ld b, a
    ld a, [hl+]
    ld c, a
    push bc

    ;Push the other elements in the array to the left
    ld hl, holes_array
    ld bc, holes_array
    inc bc
.hole_clear_loop:
    inc bc
    ld a, [bc]
    ld [hl+], a
    inc bc
    ld a, [bc]
    ld [hl+], a
    dec e
    ld a, e
    cp 1
    jr nz, .hole_clear_loop
    xor a
    ld [hl+], a
    ld [hl+], a
    pop bc

    call TILE_GET
    and $F0
    bit 0, c
    jr nz, .no_swap
    swap a
.no_swap:
    ld [hl], a
    
    call TILE_CLEAR
    ret 
