SECTION "Bomb", ROM0

;object Bomb {
;   byte Data
;       **** **xx -> {Status, 00, 01: Off, 10: Pending, 11: Exploded}
;       **** xx** -> {Character ID}
;   byte Position {XY}
;   byte Ticks
;}
;3 bytes * 4 bombs limit * 4 characters = 48 bytes
;bombs = new Bomb[4*4]

;****************************************************************************************************
; Set to default the values of the bomb-related arrays
;****************************************************************************************************
BOMBS_CLEAR:
    ld hl, bombs_array
    ld bc, _BOMBS_ARRAY_SIZE
    CALL MEMCLEAR

    ld hl, bombs_used_array
    ld bc, _CHARACTERS_MAP_LIMIT
    CALL MEMCLEAR

    ld hl, bombs_used_max_array
    ld b, _CHARACTERS_MAP_LIMIT
.loop:
    ld a, 1
    ld [hl+], a
    dec b
    jr nz, .loop
    ret 

;****************************************************************************************************
; Updates the bombs array, increasing the tick counter and exploding the bomb
; or clearing it if the timer has reached the limit.
;****************************************************************************************************
BOMBS_UPDATE:
    ld d, _BOMBS_ARRAY_MAX_LENGTH
    ld hl, bombs_array
.foreach_bomb:
    ld a, d
    cp $00
    ret z
    dec d

    ld a, [hl+] ;Data
    ld e, a
    ld a, [hl+] ;Position
    ld b, a
    ld a, [hl+] ;Ticks
    ld c, a

    ;Check the bit in the data about whether this bomb is active
    ;if not, go to the next one in the array
    bit 1, e
    jr z, .foreach_bomb

    ;If it's active then update the ticks
    dec hl
    ld a, c
    dec a
    ld [hl+], a

    ;Check if we've reached the ticks needed to explode or clear
    cp $00
    jr nz, .foreach_bomb

    ;If it's in explosion phase, set the ticks for clearing
    bit 0, e
    jr nz, .not_explosion_phase
    dec hl
    ld a, _BOMBS_CLEAR_TIME
    ld [hl+], a
.not_explosion_phase:
    ;Take the position
    ld a, b
    and $F0
    swap a
    ld c, a ;X position in c
    ld a, b
    and $0F
    ld b, a ;Y position in b

    ;Set the clear bit in explodeFuncParams off and set the character ID field
    ld a, e
    sra a
    res 0, a
    ld [explodeFuncParams], a

    push hl
    ld hl, bombs_fire_ranges_array
    ld a, [explodeFuncParams]
    and _EXPLODE_CHARACTER_ID
    rrca
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    ld a, [hl]
    ld [bombCurrentFireRange], a
    pop hl

    ;We check if the bit in the data for clearing is active
    ;to see if we have to set the bit in explodeFuncParams on
    bit 0, e
    jr z, .clear_bit_not_set
    set 0, a
    ld [explodeFuncParams], a

    call BOMB_UPDATE_TILES

    ;Decrease the currently used bombs by this character
    push hl
    ld a, e
    sra a
    sra a ;We get the character's ID
    ld hl, bombs_used_array
    add a, l
    ld l, a
    ld a, [hl]
    dec a
    ld [hl], a
    pop hl

    ld a, e
    res 1, a ;Data will be 01
    jr .place_tiles

.clear_bit_not_set:
    ld a, e
    set 0, a ;Data will be 11

.place_tiles:
    ;Update the data
    dec hl
    dec hl
    dec hl
    ld [hl+], a
    inc hl
    inc hl

    ;Finally, we call the function to place the tiles
    push hl
    push de
    call BOMB_EXPLODE
    pop de
    pop hl
    jr .foreach_bomb

BOMB_UPDATE_TILES:
    ;Set the tile to empty in the map
    push hl
    call WEIGHT_GET
    ld a, _WEIGHTS_EMPTY
    ld [hl], a

    push de
    ld a, [bombCurrentFireRange]
    ld e, a
    res 7, e
    call BOMB_WEIGHTS_SET
    pop de

    call TILE_GET
    and $F0
    bit 0, c
    jr nz, .no_swap
    swap a
.no_swap:
    ld [hl], a
    pop hl
    ret 

;****************************************************************************************************
; Place bomb in a position of the map.

; @param b: Pixel Y position of the bomb
; @param c: Pixel X position of the bomb
; @param [currentActor]: ID of the actor calling this function.

; @return b = 0
; @return c = 0
; @return de = [bomb_map_data] + 4
; @return hl = [map_data] + (b * screen_size + c)
;****************************************************************************************************
BOMB_PLACE:
    POSITION_GET b
    POSITION_GET c

    call CHECK_COLLISION
    ret nz

    push hl
    push de
    call BOMBS_COMPARE_AMOUNT
    pop de
    jr nz, .unequal
    pop hl
    ret
.unequal:
    inc a
    ld [hl], a
    pop hl

    ld a, d
    and $F0
    or TILES_BOMB_ID
    bit 0, c
    jr nz, .no_swap
    swap a
.no_swap:
    ld [hl], a

    call WEIGHT_GET
    ld a, _WEIGHTS_BOMB
    ld [hl], a

    ld hl, bombs_fire_ranges_array
    ld a, [currentActor]
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    ld a, [hl]
    ld [bombCurrentFireRange], a

    ld a, [bombCurrentFireRange]
    ld e, a
    set 7, e
    call BOMB_WEIGHTS_SET

    ;Find a free position in the bombs_array to place this bomb
    ld d, _BOMBS_ARRAY_MAX_LENGTH
    ld hl, bombs_array
.foreach_bomb:
    ld a, d
    cp $00
    jr z, .exit_loop
    dec d

    ld a, [hl] ;Data
    bit 1, a
    jr z, .exit_loop
    inc hl
    inc hl
    inc hl
    jr .foreach_bomb
.exit_loop:
    ;Data, character ID in bits 3-2
    ld a, [currentActor] 
    sla a
    sla a
    ;Status in bits 1-0 of Data
    or %0000_0010 
    ld [hl+], a
    xor a
    or c
    swap a
    or b
    ld [hl+], a ;Position
    ld a, _BOMBS_EXPLOSION_TIME
    ld [hl+], a ;Ticks

    call MAP_TO_ADDRESS
    ld de, bomb_map_data
    ld b, bomb_tile_height
    ld c, bomb_tile_width
    call TILECPY
    ret

;****************************************************************************************************
; Explode a bomb in all directions given its position.

; @param b: Y position of the bomb in the map.
; @param c: X position of the bomb in the map.
; @param [explodeFuncParams]:
;           Bit 0: Clear (true or false)
;           Bits 5-1: Character ID

; @return a  = $04
; @return bc = bc
; @return de = [explosion_end_map_data] + 16
; @return hl = $0400
;****************************************************************************************************
BOMB_EXPLODE:
    call WEIGHT_GET
    ld a, [explodeFuncParams]
    bit 0, a
    ld a, _WEIGHTS_EMPTY
    jr nz, .clear_flag
    ld a, _WEIGHTS_BOMB_AFTER
.clear_flag:
    ld [hl], a

    ld hl, 0 ;h = Counter, l = Range
    call BOMB_CALCULATE_RANGES

    ;Place the center tile of the explosion
    ld de, explosion_center_map_data
    call BOMB_EXPLOSION_COPY_TILE

    ;Now we can do the tiles for all four directions
    ld hl, 0 ;h = Counter, l = Range
    push bc
.restart:
    pop bc
    ;Check if we're done with all directions (i.e. h == _DIRECTION_NONE)
    ld a, h
    cp _DIRECTION_NONE
    ret z
    push bc

    ;If the range of the explosion is zero in this direction then there's no need to do it
    ld de, explosionRanges
    ld a, h
    add a, e
    ld e, a
    ld a, [de]
    ld l, a
    cp $0
    jr z, .next
.loop:
    dec l
    call BOMB_DIRECTION_ADD_OFFSET

    ;Check if we've reached zero range, because if it is then it's the last tile
    ;and we need to use a different tile for the direction's end
    ld a, l
    cp $0
    jr z, .last
    call BOMB_EXPLOSION_COPY_TILE
    jr .loop

.last:
    ;Get the address for the direction's end tile by adding d*4 to the end tile map data
    ld de, explosion_end_map_data
    ld a, h
    sla a
    sla a
    add a, e
    ld e, a
    call BOMB_EXPLOSION_COPY_TILE

.next:
    inc h
    jr .restart

;
;
;
BOMB_EXPLOSION_COPY_TILE:
    ld a, [explodeFuncParams]
    bit 0, a
    jr nz, .skip_weight_set
    push hl
    call WEIGHT_GET
    ld a, [hl]
    set 7, a
    ld [hl], a
    pop hl
.skip_weight_set:
    push hl
    push bc
    push de
    call MAP_TO_ADDRESS
    pop de

    ld a, [explodeFuncParams]
    bit 0, a
    jr z, .clear_bool_not_set
    ld de, empty_map_data
.clear_bool_not_set:
    ld b, 2
    ld c, 2
    call TILECPY
    pop bc
    pop hl
    ret


;****************************************************************************************************
; Calculate how many tiles below the explosion range are empty in a direction.

; @param b: Y position of the bomb in the map.
; @param c: X position of the bomb in the map.
; @param h: Direction (0: Up, 1: Down, 2: Right, 3: Left)
; @param l: Range
; @param [explodeFuncParams]:
;           Bit 0: Clear (true or false)
;           Bits 5-1: Character ID

; @return a  = $04
; @return bc = bc
; @return de = [explosionRanges]
; @return hl = $0400
;****************************************************************************************************
BOMB_CALCULATE_RANGES:
    push bc

    ;Check if we're done with all directions (i.e. h == _DIRECTION_NONE)
    ld a, h
    cp _DIRECTION_NONE
    jr nz, .loop 
    pop bc
    ret
.loop:
    ;Check if we've reached the range limit
    ld a, [bombCurrentFireRange]
    cp l
    jr z, .next

    inc l
    call BOMB_DIRECTION_ADD_OFFSET

.continue:
    push hl
    xor a
    ;Set to 0 so it knows we're not the player, and set ID
    ld a, [explodeFuncParams]
    sra a
    swap a
    res 3, a
    ld [collisionFuncParams], a
    call CHECK_COLLISION
    pop hl
    ;If the next tile is empty then we can continue, otherwise go to next direction
    jr z, .loop
    dec l

    ;We still have the tile stored in d, so if it's not empty we check first if it's a bomb
    ;only if we're not in clear phase
    ld a, [explodeFuncParams]
    bit 0, a
    jr z, .next
    ld a, d
    and $0F
    cp TILES_BOMB_ID
    jr z, .found_bomb
    ;Otherwise check if it's a brick
    cp TILES_BRICK_ID
    jr z, .found_brick
    jr .next

.found_brick:
    push hl
    push bc
    push de
    call BRICK_DESTROY
    pop de
    pop bc
    pop hl
    jr .next
.found_bomb:
    ;If it is a bomb, then we have to make that bomb explode
    ;To do this we first need to get the bombs' data from its position
    push hl
    push bc
    push de
    call BOMBS_GET_FROM_POS
    ;Set the ticks to one so it will explode NEXT update
    ld a, 1
    ld [hl], a
    pop de
    pop bc
    pop hl
.next:
    pop bc
    
    ;Store the range for this direction in the explosionRanges array
    ld de, explosionRanges
    ld a, h
    add a, e
    ld e, a
    ld a, l
    ld [de], a

    ld l, 0
    inc h
    jr BOMB_CALCULATE_RANGES

;****************************************************************************************************
; Calculate how many tiles below the explosion range are empty in a direction.

; @param b: Y position of the bomb in the map.
; @param c: X position of the bomb in the map.

; @return b = (c << 4) & b
; @return d = _BOMBS_ARRAY_MAX_LENGTH
; @return hl = Desired tick address if succesful, end of bombs_array if not
;****************************************************************************************************

BOMBS_GET_FROM_POS:
    ;Put both positions in a single register
    ld a, b
    swap c
    or c
    ld b, a

    ld d, _BOMBS_ARRAY_MAX_LENGTH
    ld hl, bombs_array
.foreach_bomb:
    ld a, d
    cp $00
    ret z
    dec d

    ld a, [hl+] ;Data
    ;Check the bit in the data about whether this bomb is active
    bit 1, a
    ld a, [hl+] ;Position
    ld c, a
    ld a, [hl+] ;Ticks

    ;if not active, go to the next one in the array
    jr z, .foreach_bomb
    ;If it is, then compare both positions
    ld a, b
    cp c
    jr nz, .foreach_bomb
    dec hl
    ;If they're the same, then this is our bomb and we have its tick address in hl
    ret

;****************************************************************************************************
; Add the direction offset to a position.

; @param b: Y position of the bomb in the map.
; @param c: X position of the bomb in the map.
; @param h: Direction (0: Up, 1: Down, 2: Right, 3: Left)
 
; @return b = b + direction_matrix[h*2]
; @return c = c + direction_matrix[h*2 + 1]
;****************************************************************************************************
BOMB_DIRECTION_ADD_OFFSET:
    ;Get counter
    ld a, h

    ;Add the counter to the direction matrix
    sla a
    ld de, direction_matrix
    add e
    ld e, a
    ld a, 0
    adc d
    ld d, a

    ;Apply the matrix values to the position
    ld a, [de]
    add b
    ld b, a
    inc de

    ld a, [de]
    add c
    ld c, a
    inc de

    ;Get the correct explosion tile for this direction
    ld de, explosion_v_middle_map_data
    ld a, h
    cp $02
    ret c
    ld de, explosion_h_middle_map_data
    ret

;****************************************************************************************************
; Compare the amount of bombs currently used by a character to its max amount of bombs.

; @param [currentActor]: ID of the actor calling this function.
 
; @return z = 0 if equal
;****************************************************************************************************
BOMBS_COMPARE_AMOUNT:
    ld a, [currentActor]
    ld hl, bombs_used_max_array
    add a, l
    ld l, a
    ld e, [hl]

    ld hl, bombs_used_array
    ld a, [currentActor]
    add a, l
    ld l, a
    ld a, [hl]
    cp e
    ret

;****************************************************************************************************
; Adds or subtracts the weights of a bomb to the weights map

; @param b: Y location in the map of the bomb
; @param c: X location in the map of the bomb
; @param e: Fire range (bits 6-0) - Subtract or add bomb weight (bit 7, 0: Sub, 1: Add)

; @alters: a, bc, de, hl
;****************************************************************************************************
BOMB_WEIGHTS_SET:
    call WEIGHT_GET
    push bc
    ld b, h
    ld c, l
    ld h, 0
    
.new_loop:
    ld a, e
    and %0111_1111
    ld l, a
    push bc
.loop:
    ld a, l
    cp 0
    jr z, .next_direction
    dec l

    push hl

    ld a, h
    ld hl, .directions
    rla 
    rla 
    rla
    add l
    ld l, a
    ld a, 0 
    adc h
    ld h, a
    jp hl

.directions:
;--------------------------------------
    ;Up
    nop 
    ld a, c
    ld c, $10
    sub c
    ld c, a
    jr .out

    ;Down
    nop 
    nop 
    ld a, $10
    add c
    ld c, a
    jr .out

    ;Right
    nop 
    nop 
    nop 
    nop 
    inc bc
    jr .out

    ;Left
    nop 
    dec bc
    jr .out
;--------------------------------------
.out:
    pop hl
    ld a, 0 
    adc b
    ld b, a
    ld a, [bc]
    cp _WEIGHTS_BLOCK
    jr z, .next_direction
    cp _WEIGHTS_BOMB
    jr z, .loop
    bit 7, e
    jr z, .clear
    add l
    add _WEIGHTS_BOMB_FIRE
.return_clear:
    ld [bc], a
    jr .loop
.next_direction:
    pop bc
    inc h
    ld a, h
    cp _DIRECTION_NONE 
    jr nz, .new_loop
    pop bc
    ret 
.clear:
    res 7, a
    sub l
    jr c, .underflow
    sub _WEIGHTS_BOMB_FIRE
    jr c, .underflow
    jr .return_clear
.underflow:
    ld a, _WEIGHTS_EMPTY
    jr .return_clear