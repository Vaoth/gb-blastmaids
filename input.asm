SECTION "Joypad vars", WRAM0

rPAD: ds 1

SECTION "Joypad", ROM0

INPUT_READ:
    xor a
    ld [rPAD], a

    ld a, %00100000 ; Read D-PAD
    ld [rP1], a

    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]

    and $0F ; Keep low nibble
    swap a ; Swap low and high nibble
    ld b, a

    ld a, %00010000 ; Read buttons
    ld [rP1], a

    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]

    and $0F
    or b

    cpl ; Make the complement of it
    ld [rPAD], a ; Save in rPAD the controls
    ld a, $30 ; Reset joypad
    ld [rP1], a
    ret

INPUT_CHECK:
    call INPUT_READ

    ;Update currentActor to indicate we're the player in the functions
    ;we're going to call
    ld a, _PLAYER_ID
    ld [currentActor], a

    ;Update the collisionFuncParams preemptively
    swap a
    set 3, a ;Activate bit for isCharacter
    ld [collisionFuncParams], a

    ld a, [actors_speed_array]
    ld [actorSpeed], a
    ld d, a

    ld a, [pY]
    ld [oY], a
    ld a, [pX]
    ld [oX], a

    ld a, [rPAD]

    cp PADF_START
    jp z, INPUT_START_BUTTON
    cp PADF_SELECT
    jp z, INPUT_SELECT_BUTTON
    cp PADF_A
    jp z, INPUT_A_BUTTON
    cp PADF_B
    jp z, INPUT_B_BUTTON

    cp PADF_UP
    jp z, INPUT_UP_BUTTON
    cp PADF_DOWN
    jp z, INPUT_DOWN_BUTTON
    cp PADF_LEFT
    jp z, INPUT_LEFT_BUTTON
    cp PADF_RIGHT
    jp z, INPUT_RIGHT_BUTTON
    ret

INPUT_START_BUTTON:
    ret

INPUT_SELECT_BUTTON:
    ret

INPUT_A_BUTTON:
    ld a, [pX]
    add a, 8
    ld c, a
    ld a, [pY]
    add a, 8
    ld b, a
    call BOMB_PLACE
    ret

INPUT_B_BUTTON:
    ;ld a, [cursorCounter]
    ;inc a
    ;ld [cursorCounter], a
    ;cp _CURSOR_COUNTER_LIMIT
    ;ret c
    ;xor a
    ;ld [cursorCounter], a
    ;
    ;ld a, [currentLevel]
    ;inc a
    ;ld [currentLevel], a
    ;
    ;call LEVEL_LOAD
    ;call VARS_INIT
    ret

INPUT_UP_BUTTON:
    ld a, [collisionFuncParams]
    or _DIRECTION_UP
    ld [collisionFuncParams], a

    ld a, [pX]
    ld c, a
    ld a, [pY]
    sub d
    ld b, a
    call CHECK_BOUNDARY ;Check the collision in next position
    jr nz, PLAYER_COLLIDED ;if the next tile is not empty

    ld a, [actorSpeed]
    ld d, a
    ld a, [pY]
    sub d
    ld [pY], a
    ret

INPUT_DOWN_BUTTON:
    ld a, [collisionFuncParams]
    or _DIRECTION_DOWN
    ld [collisionFuncParams], a

    ld a, [pX]
    ld c, a
    ld a, [pY]
    add d
    ld b, a
    call CHECK_BOUNDARY ;Check the collision in next position
    jr nz, PLAYER_COLLIDED ;if the next tile is not empty

    ld a, [actorSpeed]
    ld d, a
    ld a, [pY]
    add d
    ld [pY], a
    ret

INPUT_LEFT_BUTTON:
    ld a, [collisionFuncParams]
    or _DIRECTION_LEFT
    ld [collisionFuncParams], a

    ld a, [pX]
    sub d
    ld c, a
    ld a, [pY]
    ld b, a
    call CHECK_BOUNDARY ;Check the collision in next position
    jr nz, PLAYER_COLLIDED ;if the next tile is not empty

    ld a, [actorSpeed]
    ld d, a
    ld a, [pX]
    sub d
    ld [pX], a
    ret

INPUT_RIGHT_BUTTON:
    ld a, [collisionFuncParams]
    or _DIRECTION_RIGHT
    ld [collisionFuncParams], a

    ld a, [pX]
    add d
    ld c, a
    ld a, [pY]
    ld b, a
    call CHECK_BOUNDARY ;Check the collision in next position
    ;If the next tile is not empty
    jr nz, PLAYER_COLLIDED 

    ld a, [actorSpeed]
    ld d, a
    ld a, [pX]
    add d
    ld [pX], a
    ret

PLAYER_COLLIDED:
    ;This function only applies if speed is over 1
    ld a, [actorSpeed]
    and %0111_1111
    cp $01
    ret c

    ld a, [pY]
    ld b, a
    ld a, [pX]
    ld c, a

    ;Add the direction to the collision matrix to get the values to apply
    ld hl, collision_matrix
    ld a, [collisionFuncParams]
    and _COLLISION_DIRECTION
    sla a
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a

    ;If the value is $FF it means we must not change this value
    ld a, [hl+]
    cp $FF
    jr z, .keep_y

    ld b, a
    ld a, [pY]
    add 8
    POSITION_GET a
    MULTIPLY_BY_16 a
    add b
    ld b, a
.keep_y
    ld a, [hl+]
    cp $FF
    jr z, .keep_x

    ld c, a
    ld a, [pX]
    add 8
    POSITION_GET a
    MULTIPLY_BY_16 a
    add c
    ld c, a
.keep_x
    ld a, b
    ld [pY], a
    ld a, c
    ld [pX], a
    ret