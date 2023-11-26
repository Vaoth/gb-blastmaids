SECTION "Enemy", ROM0
;object Enemy {
;enemies_array:
;   byte Data
;       **** xxxx -> {Character ID}
;       *xxx **** -> {State}
;       x*** **** -> {Enabled}
;   byte Y              |
;   byte X              | --> OAM DATA
;   byte Tile_ID        |
;   byte Attributes     |
;   byte targetY
;   byte targetX
;   byte NextDirection
;   byte LastDirection
;   byte Timer
;   byte[6] FREE
;}
;16 byte * 3 enemies = 48 bytes

;****************************************************************************************************
; Set all values in the enemies array to zero.
;****************************************************************************************************
ENEMIES_CLEAR:
    ld hl, enemies_array
    ld bc, _ENEMIES_ARRAY_SIZE
    CALL MEMCLEAR
    ret

;****************************************************************************************************
; Set the default values for all three enemies in the enemies array.
;****************************************************************************************************
ENEMIES_CREATE:
    ld a, [alive]
    ld b, a

    ld hl, enemies_array

    ld a, _ENEMIES_BURA_ID
    bit 1, b
    jr z, .bura_not_enabled
    set 7, a
.bura_not_enabled:
    ld [hl+], a
    ld a, _ENEMIES_BURA_SPAWNY
    ld [hl+], a
    ld a, _ENEMIES_BURA_SPAWNX
    ld [hl+], a
    ld a, 2
    ld [hl+], a ;Tile ID
    xor a
    ld [hl+], a ;Attributes
    ld d, 0
    ld e, _ENEMIES_ARGS_SIZE - _ENEMIES_TARGETY_INDEX
    add hl, de

    ld a, _ENEMIES_SUTO_ID
    bit 2, b
    jr z, .suto_not_enabled
    set 7, a
.suto_not_enabled:
    ld [hl+], a
    ld a, _ENEMIES_SUTO_SPAWNY
    ld [hl+], a
    ld a, _ENEMIES_SUTO_SPAWNX
    ld [hl+], a
    ld a, 4
    ld [hl+], a ;Tile ID
    xor a
    ld [hl+], a ;Attributes
    add hl, de

    ld a, _ENEMIES_KANPAKU_ID
    bit 3, b
    jr z, .kanpaku_not_enabled
    set 7, a
.kanpaku_not_enabled:
    ld [hl+], a
    ld a, _ENEMIES_KANPAKU_SPAWNY
    ld [hl+], a
    ld a, _ENEMIES_KANPAKU_SPAWNX
    ld [hl+], a
    ld a, 6
    ld [hl+], a ;Tile ID
    xor a
    ld [hl+], a ;Attributes
    ret

;****************************************************************************************************
; Updates all enemy-related logic, including movement, state and OAM graphics.
; Only applies to those enemies with the enabled flag in their data byte.
;****************************************************************************************************
ENEMIES_UPDATE:    
    ld a, _ENEMIES_COUNT+1
    ld [tempCounter], a
    ld hl, enemies_array
.foreach_loop:
    ld a, [tempCounter]
    dec a
    ld [tempCounter], a
    jr z, .exit_loop

    ld a, [hl+]
    bit 7, a
    ;Only proceed if the enemy is enabled
    jr nz, .continue_loop
    ld b, 0
    ld c, _ENEMIES_ARGS_SIZE - 1
    add hl, bc
    jr .foreach_loop
.continue_loop:
    ld [currentEnemyData], a
    dec hl
    push hl
    call ENEMY_STATE_UPDATE
    pop hl

    push hl
    call ENEMY_TARGET_UPDATE
    pop hl

    push hl
    call ENEMY_MOVE
    pop hl

    push hl
    call ENEMY_CHECK_POSITION
    pop hl

    push hl
    call ENEMY_CHECK_HIT
    pop hl

    call ENEMY_OAM_UPDATE

    ld d, 0
    ld e, _ENEMIES_ARGS_SIZE - _ENEMIES_TARGETY_INDEX
    add hl, de
    jr .foreach_loop
.exit_loop:
    ret

;****************************************************************************************************
; Makes an enemy move depending on direction if it does not collide with any walls.

; @param hl: Starting position of the enemy data in memory

; @alters a, bc, de, hl
;****************************************************************************************************
ENEMY_MOVE:
    ld a, [hl+]
    push hl
    and _ENEMIES_DATA_ID_MASK
    ld [currentActor], a

    ld de, actors_speed_array
    add e
    ld e, a
    ld a, 0
    adc d
    ld d, a
    ld a, [de]
    bit 0, a
    jr z, .speed_is_even
    ld a, 2
.speed_is_even:
    ld [actorSpeed], a

    ;Update the collisionFuncParams preemptively
    ld a, [currentActor]
    swap a
    set 3, a ;Activate bit for isCharacter
    ld [collisionFuncParams], a

    ld a, [hl+]
    ld [oY], a
    ld b, a ;Y
    ld a, [hl+]
    ld [oX], a
    ld c, a ;X
    ld d, 0
    ld e, 4
    add hl, de
    ld a, [hl+] ;nextDirection

    ld d, a
    ld a, [collisionFuncParams] 
    or d
    ld [collisionFuncParams], a ;Params require direction
    ld a, d

    cp _DIRECTION_NONE
    jr z, .no_direction
    ccf

    ;Offset Y or X accordingly given nextDirection
    ld hl, .directions
    rla 
    rla
    rla
    ld d, 0
    ld e, a
    add hl, de
    ld a, [actorSpeed]
    jp hl
    ;Jump to the direction offset from this address
    ;the operations it jumps to will add or subtract speed from either Y or X
.directions:
    ;Up
    sub b
    cpl
    inc a
    ld b, a
    ld d, a
    ld e, c
    jr .out
    ;Down
    add b
    ld b, a
    add 15 ;Down and right direction we need to shift the collision check 15 pixels
    ld d, a
    ld e, c
    jr .out
    ;Right
    add c
    ld c, a
    add 15
    ld d, b
    ld e, a
    jr .out
    ;Left 
    sub c
    cpl
    inc a
    ld c, a
    ld d, b
    ld e, a
    ;Right

.out:
    pop hl
    push hl
    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl+], a

    ld b, d
    ld c, e

    POSITION_GET b
    POSITION_GET c

    call CHECK_COLLISION ;Check the collision in next position
    pop hl
    jr nz, .collided ;if the next tile is not empty
    ret 
.collided:
    ld a, [oY]
    add 8
    ld b, a
    ld a, [oX]
    add 8
    ld c, a

    POSITION_GET b
    MULTIPLY_BY_16 b

    POSITION_GET c
    MULTIPLY_BY_16 c

    ld a, b
    ld [hl+], a
    ld a, c
    ld [hl+], a
    ;ld d, 0
    ;ld e, 4
    ;add hl, de
    ;ld a, [hl]
    ;xor %0000_0001
    ;ld [hl], a
    ret 
.no_direction:
    pop hl
    ret

;****************************************************************************************************
; Checks if an enemy is fully within a tile (i.e. its Y and X direction modulo 16 are both 0)
; If it is, then it calls the functions to decide new direction and decides whether
; to place a bomb or not, depending on its state

; @param hl: Starting position of the enemy data in memory

; @alters a, bc, de, hl
;****************************************************************************************************
ENEMY_CHECK_POSITION:
    ld a, [hl+]
    ld d, a
    ld a, [hl+]
    ld b, a
    and $0F
    ret nz
    ld a, [hl+]
    ld c, a
    and $0F
    ret nz

    ld a, d
    and _ENEMIES_DATA_STATE_MASK
    cp _ENEMY_STATE_ATTACK
    jr nz, .not_attack_state

    push hl
    push bc
    call ENEMY_STATE_ATTACK
    pop bc
    pop hl
    jr nz, .did_not_place_bomb

    ld d, 0
    ld e, _ENEMIES_LASTDIR_INDEX - _ENEMIES_TILEID_INDEX
    add hl, de
    ld a, [hl-]
    ld [hl], a
    ret 
.did_not_place_bomb:
    call ENEMY_SET_NEXT_DIRECTION
    ret

.not_attack_state:

    push bc
    call ENEMY_SET_NEXT_DIRECTION

    push hl
    call WEIGHT_GET 
    ld a, [hl]
    cp _WEIGHTS_BOMB
    pop hl
    pop bc
    ret nc 
    ;Only place bomb if not on a bomb

    ld a, [enemy_intersection_bricks]
    cp 0
    ret z
    cp 2
    jr nc, .two_or_more_bricks
    ld a, [hl+]
    ld d, a
    cp [hl]
    ret nz
    jp ENEMY_PLACE_BOMB
.two_or_more_bricks:
    inc hl
    ld a, [hl-]
    ld [hl], a
    jp ENEMY_PLACE_BOMB

;****************************************************************************************************
; Places a bomb on the enemy's position

; @param b: Pixel position Y of enemy
; @param c: Pixel position X of enemy

; @alters: a, bc, de, hl
;****************************************************************************************************
ENEMY_PLACE_BOMB:
    ld a, 8
    add b
    ld b, a
    ld a, 8 
    add c
    ld c, a
    call BOMB_PLACE
    ret 

;****************************************************************************************************
; A complicated function which decides the next direction of the enemy, based on:
; - TargetX and TargetY relative to the enemy position
; - The direction we came from
; - Weights around the tiles we're trying to move to

; @param hl: Starting position of the enemy data in memory plus three (i.e. on Tile attribute)

; @alters a, bc, de, hl
;****************************************************************************************************
ENEMY_SET_NEXT_DIRECTION:
    xor a
    ld [enemy_intersection_bricks], a

    inc hl ;Tile
    inc hl ;Attributes
    ld a, [hl+] ;targetY
    sub b
    ld d, %0010_0000 ;Directions: Up (low nibble) and right (high nibble)
    jr c, .not_negative_y
    ld d, %0010_0001 ;Directions: Down (low nibble) and right (high nibble)
.not_negative_y:

    push hl
    push bc
    call rand
    bit 0, a
    jr z, .swap_chance ;<-- PROVISIONAL RNG?
    swap d
.swap_chance:
    pop bc
    pop hl

    ld a, [hl+] ;targetX
    sub c
    jr nc, .not_negative_x
    set 4, d ;If the x is not negative it will set x direction to left
    ;by setting this bit in the high nibble
.not_negative_x:
    ld a, [hl+]
    cp _DIRECTION_NONE
    jr nz, .no_direction
    ld a, [hl]
    xor %0000_0001
.no_direction:
    xor %0000_0001 ;Complement of current next direction is the direction we come from
    ld [hl-], a
    ld e, a

    push hl
    ld hl, enemy_direction_priorities + 3
    ld [hl-], a
    dec hl
    ld a, d
    and $0F
    cp e
    jr nz, .y_not_equal
    xor %0000_0001 ;Complement of bit, changes direction
.y_not_equal
    ld [hl-], a
    ld a, d
    swap a
    and $0F
    cp e
    jr nz, .x_not_equal
    xor %0000_0001 ;Complement of bit, changes direction
.x_not_equal:
    ld [hl+], a
    xor [hl]
    inc hl
    xor e
    ld [hl], a

    POSITION_GET b
    POSITION_GET c
    
    ld e, $FF
.directions_loop:
    inc e
    ld a, e
    cp _DIRECTION_NONE
    jr z, .try_weights
    ld hl, enemy_direction_priorities
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    ld a, [hl]
    ld d, a

    push bc
    ld hl, direction_matrix
    rla 
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    ld a, [hl+]
    add b
    ld b, a
    ld a, [hl]
    add c
    ld c, a

    push de
    call TILE_GET
    and $0F
    cp _TILES_BRICK_ID
    jr nz, .not_brick
    ld a, [enemy_intersection_bricks]
    inc a
    ld [enemy_intersection_bricks], a
.not_brick:

    call WEIGHT_GET 
    ld d, [hl]
    ld hl, enemy_direction_weights
    ld a, e
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    ld a, d
    ld [hl], a
    pop de
    pop bc
    cp _WEIGHTS_EMPTY + 1
    jr nc, .directions_loop

    pop hl
    ld a, d
    ld [hl], a
    ret 

.try_weights:
    call WEIGHT_GET 
    ld a, [hl]
    cp _WEIGHTS_EMPTY + 1
    jr c, .greater_than_empty_weight
    ld a, _WEIGHTS_BLOCK
.greater_than_empty_weight
    ld b, a
    ld c, e
    ld d, 0
    ld e, $FF
.weighted_direction_loop:
    inc e
    ld a, e
    cp _DIRECTION_NONE
    jr z, .exit

    ld hl, enemy_direction_weights
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    ld a, [hl]
    cp b
    jr nc, .weighted_direction_loop
    ld b, a
    ld c, e
    set 0, d
    jr .weighted_direction_loop

.exit:
    bit 0, d
    jr z, .block_direction
    ld a, c
    ld hl, enemy_direction_priorities
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    ld a, [hl]

    pop hl
    ld [hl], a
    ret
.block_direction:
    pop hl
    ld a, _DIRECTION_NONE
    ld [hl], a
    ret 

;****************************************************************************************************
; Updates the enemy's state to attack if on patrol and within fire range (divided by two) of player.

; @param hl: Start of enemy array data

; @alters a, bc, de, hl
;****************************************************************************************************
ENEMY_STATE_UPDATE:
    ld a, [hl+]
    ld d, a
    and _ENEMIES_DATA_STATE_MASK
    cp _ENEMY_STATE_PATROL
    jp nz, ENEMY_STATE_TIMER

    ld a, d
    and _ENEMIES_DATA_ID_MASK
    ld de, bombs_fire_ranges_array
    add e
    ld e, a
    ld a, 0
    adc d
    ld d, a
    ld a, [de]
    ld d, a
    sra d

    MULTIPLY_BY_16 d

    ld a, [hl+]
    ld b, a
    ld a, [hl]
    ld c, a

    ld a, [pY]
    ld e, a
    sub d
    jr nc, .no_underflow_y
    xor a
.no_underflow_y:
    cp b
    ret nc
    ld a, e
    add d
    jr nc, .no_overflow_y
    ld a, $FF
.no_overflow_y:
    cp b
    ret c

    ld a, [pX]
    ld e, a
    sub d
    jr nc, .no_underflow_x
    xor a
.no_underflow_x:
    cp c
    ret nc
    ld a, e
    add d
    jr nc, .no_overflow_x
    ld a, $FF
.no_overflow_x:
    cp c
    ret c

    dec hl
    dec hl
    ld a, [hl]
    and _ENEMIES_DATA_STATE_MASK_INV
    or _ENEMY_STATE_ATTACK
    ld [hl], a
    ret 

;****************************************************************************************************
; Decreases the internal enemy state timer, if it reaches zero then it switches back to patrol state.

; @param hl: Start of enemy array data

; @alters a, bc, de, hl
;****************************************************************************************************
ENEMY_STATE_TIMER:
    dec hl
    ld b, h
    ld c, l

    ld d, 0
    ld e, _ENEMIES_TIMER_INDEX
    add hl, de
    ld a, [hl]
    dec a
    ld [hl], a
    ret nz
    ld a, [bc]
    and _ENEMIES_DATA_STATE_MASK_INV
    ;or _ENEMY_STATE_PATROL, not necessary because it's 0 but if it was different we'd have to uncomment this
    ld [bc], a
    ret 

;****************************************************************************************************
; Function for the attack state, it decides whether to place a bomb or not to kill the player
; based on whether it can place a bomb in fire range which can reach the player (empty path)

; @param hl: Start of enemy array data

; @alters a, bc, de, hl
;****************************************************************************************************
ENEMY_STATE_ATTACK:
    ld d, 0
    ld e, _ENEMIES_NEXTDIR_INDEX - _ENEMIES_TILEID_INDEX
    add hl, de
    ld a, [hl]
    cp _DIRECTION_NONE
    ret z

    ld d, _DIRECTION_DOWN

    POSITION_GET b
    POSITION_GET c
    ld a, [pY]
    add 8
    POSITION_GET a
    ld h, a
    sub b
    jr z, .y_is_zero
    jr nc, .y_no_carry
    ld d, _DIRECTION_UP
.y_no_carry:
    ld a, [pX]
    add 8
    POSITION_GET a
    ld l, a
    sub c
    ret nz
    jr .x_no_carry 
.y_is_zero:
    ld d, _DIRECTION_RIGHT
    ld a, [pX]
    POSITION_GET a
    ld l, a
    sub c
    jr z, .x_is_zero
    jr nc, .x_no_carry
    ld d, _DIRECTION_LEFT
.x_no_carry:
    jr .continue
.x_is_zero:
    ld d, _DIRECTION_NONE

.continue:
    ;If we're here, then at least either X or Y distance is zero.
    ;Direction to check is now in d
    ld a, h
    swap a
    or l
    ld e, a
    push bc

    ld a, d
    cp _DIRECTION_NONE
    jr z, .direction_is_none

    ld hl, direction_matrix
    rlca
    add l
    ld l, a
    ld a, 0 
    adc h
    ld h, a
.loop
    ld a, b
    swap a
    or c
    cp e
    jr z, .direction_is_none
    
    ld a, [hl+]
    add b
    ld b, a

    ld a, [hl-]
    add c
    ld c, a

    push hl
    call WEIGHT_GET
    ld a, [hl]
    pop hl
    cp _WEIGHTS_BOMB
    jr c, .loop
    pop bc
    ret 
.direction_is_none:
    pop bc
    MULTIPLY_BY_16 b
    MULTIPLY_BY_16 c

    call ENEMY_PLACE_BOMB
    xor a
    cp 0
    ret 
    

;****************************************************************************************************
; Updates the TargetY and TargetY depending on which enemy type it is.

; @param hl: Start of enemy array data

; @alters a, bc, de, hl
;****************************************************************************************************
ENEMY_TARGET_UPDATE:
    ld a, [hl+]
    ld d, 0
    ld e, _ENEMIES_TARGETY_INDEX-1
    add hl, de

    ld b, h
    ld c, l

    ld d, a
    and _ENEMIES_DATA_ID_MASK
    ld e, a
    ld a, d
    and _ENEMIES_DATA_STATE_MASK
    cp _ENEMY_STATE_PATROL
    jp z, ENEMY_STATE_PATROL_TARGET
    cp _ENEMY_STATE_ATTACK
    jp z, ENEMY_STATE_ATTACK_TARGET
    ret 

ENEMY_STATE_ATTACK_TARGET:
    ld a, [pY]
    ld [hl+], a
    ld a, [pX]
    ld [hl], a
    ret 

ENEMY_STATE_PATROL_TARGET:
    ld a, e
    cp _ENEMIES_BURA_ID
    jr z, .state_patrol_bura
    cp _ENEMIES_SUTO_ID
    jr z, .state_patrol_suto
    cp _ENEMIES_KANPAKU_ID
    jr z, .state_patrol_bura
    ret 
.state_patrol_bura:
    ld a, [pY]
    ld [hl+], a
    ld a, [pX]
    ld [hl], a
    ret 
.state_patrol_suto:
    ld a, [alive]
    bit 1, a
    jr z, .state_patrol_suto_target

    ;get Bura's info
    ld hl, enemies_array + (_ENEMIES_BURA_ID - 1) * _ENEMIES_ARGS_SIZE
    ld a, [hl+]
    ld [bc], a
    inc bc
    ld a, [hl]
    ld [bc], a
    ret 
.state_patrol_suto_target:
    ld a, [pY]
    ld [hl+], a
    ld a, [pX]
    add 16*3
    ld [hl], a
    ret 
.state_patrol_kanpaku:
    ld a, [pY]
    sub 2*16
    ld [hl+], a
    ld a, [pX]
    ld [hl], a
    ret 

;****************************************************************************************************
; Sets the state to collection, TargetY and TargetX to the location of the powerup it found.

; @param hl: Start of enemy array data

; @alters a, bc, de, hl
;****************************************************************************************************
ENEMY_STATE_COLLECT:
    ld hl, enemies_array
    dec a
    MULTIPLY_BY_16 a
    add l
    ld l, a
    ld a, 0 
    adc h
    ld h, a

    ld a, [hl]
    and _ENEMIES_DATA_STATE_MASK_INV
    or _ENEMY_STATE_COLLECT
    ld [hl+], a
    inc hl
    inc hl
    inc hl
    inc hl
    ld a, b
    MULTIPLY_BY_16 a
    ld [hl+], a
    ld a, c
    MULTIPLY_BY_16 a
    ld [hl+], a
    inc hl
    inc hl
    ld a, _ENEMY_STATE_COLLECT_TIME
    ld [hl], a
    ret 

;****************************************************************************************************
; Copies the information from our enemy to the shadow OAM, adjusting as needed.

; @param hl: Start of enemy array data

; @alters a, bc, de, hl
;****************************************************************************************************
ENEMY_OAM_UPDATE:
    ;We will be loading everything into shadowOAM
    ;We need to do this in two sets, because sprites are 16x16 made up of two 8x16 sprites.
    ld a, [hl+]
    ld de, shadowOAM
    and _ENEMIES_DATA_ID_MASK
    rlca 
    rlca 
    rlca 
    add e
    ld e, a
    ld a, 0
    adc h
    ld h, a

    ;Take the data
    ;We subtract the Y and X of the scroll from the Y and X of the sprite
    ;because the Y and X position in the OAM is relative to the screen
    ld a, [rSCY]
    ld b, a
    ld a, [hl+] ;Y
    add a, 16 ;Y must be offset by 16
    sub b
    ld b, a
    ld [de], a
    inc de

    ld a, [rSCX]
    ld c, a
    ld a, [hl+] ;X
    add a, 8 ;X must be offset by 8
    sub c
    ld c, a
    ld [de], a
    inc de

    ld a, [hl+] ;Tile_ID
    ld [de], a
    inc de
    ld a, [hl+] ;Attributes
    ld [de], a
    inc de

    ;Second part of sprite
    dec hl
    dec hl
    ld a, b
    ld [de], a ;Y
    inc de
    ld a, c
    add a, 8
    ld [de], a ;X
    inc de

    ld a, [hl+] ;Tile_ID
    ld [de], a
    inc de
    ld a, [hl+] ;Attributes
    or %0010_0000
    ld [de], a
    ret 

;****************************************************************************************************
; Checks whether an enemy has been hit by a bomb or not
;****************************************************************************************************
ENEMY_CHECK_HIT:
    ld d, h
    ld e, l
    inc hl
    ld a, [hl+]
    add 8
    ld b, a ;Y
    ld a, [hl-]
    add 8
    ld c, a ;X

    POSITION_GET b
    POSITION_GET c

    call WEIGHT_GET
    ld a, [hl]
    bit 7, a
    ret z
    cp _WEIGHTS_BOMB
    ret nc
    ;Was hit by bomb
    ld h, d
    ld l, e

    ld a, [hl]
    res 7, a
    ld [hl+], a
    ld a, -16
    ld [hl+], a
    ld [hl], a

    ld a, [currentActor]
    ld d, a
    ld a, %0000_0001
.remove_alive:
    rlca 
    dec d
    jr nz, .remove_alive
    ld d, a
    ld a, [alive]
    xor d
    and $0F
    ld [alive], a
    ret 
