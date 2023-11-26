SECTION "Powerups", ROM0
;object Powerup {
;   byte Type
;   byte Position {YX}
;}

;****************************************************************************************************
; Spawns a powerup in the map position

; @param b: Position Y in map.
; @param c: Position X in map.
;****************************************************************************************************
POWERUP_SPAWN:
    ld a, [levelData]
    bit 0, a
    ret z

    push bc
    call rand
    ld a, b
    pop bc
    ;Determine if the powerup can spawn
    cp _POWERUPS_SPAWN_CHANCE
    ret nc

    call WEIGHT_GET
    ld a, _WEIGHTS_POWERUP
    ld [hl], a

    ld a, [collisionFuncParams]
    and _COLLISION_CHARACTER_ID
    swap a
    cp _PLAYER_ID
    call nz, ENEMY_STATE_COLLECT

    push bc
    ;Determine which powerup spawns
    call rand
    ld a, b
    and %0000_0111
    ld de, powerups_chance_pool
    add a, e
    ld e, a
    pop bc
    push bc

    ;Place it in the map
    call TILE_GET
    and $F0
    ld b, a
    ld a, [de]
    or b
    bit 0, c
    jr nz, .no_swap
    swap a
.no_swap:
    ld [hl], a
    ld a, [de]
    sub a, _TILES_RANGE_POW_ID

    ;Draw the powerup in screen
    ld de, powerup_map_data
    sla a
    sla a
    add a, e
    ld e, a
    pop bc

    push bc
    push de
    call MAP_TO_ADDRESS
    pop de
    ld b, 2
    ld c, 2
    call TILECPY
    pop bc

    xor a
    cp $1
    ret

;****************************************************************************************************
; Check the powerup's effect and apply it to the actor.

; @param b: Position Y in map.
; @param c: Position X in map.
; @param d: Powerup tile byte.
; @param e: Extra parameters
;           Bits 3-0: Character ID
;           Bit 7: isCharacter (true or false)
; @param hl: Powerup tile address in map.
;****************************************************************************************************

POWERUP_CHECK:
    ;Remove the powerup from the map
    ld a, d
    and $F0
    bit 0, c
    jr nz, .no_swap
    swap a
.no_swap:
    ld [hl], a

    ;If not an actor remove it from the weight map and return
    bit 7, e
    jr z, .remove_weight

    ;Use the powerup type to select the correct function pointer to apply the effect
    ld a, d
    and $0F
    sub _TILES_RANGE_POW_ID
    ld hl, powerup_pointers
    sla a
    add l
    ld l, a
    ld a, 0
    adc h
    push de
    ld a, [hl+]
    ld d, a
    ld a, [hl+]
    ld e, a
    ld h, d
    ld l, e
    pop de
    jp hl
.remove_weight
    call WEIGHT_GET
    ld a, _WEIGHTS_EMPTY
    ld [hl], a
    ret 

;****************************************************************************************************
; Increases the range of the actor's bombs.
;****************************************************************************************************
POWERUP_RANGE:
    ld a, e
    and %0000_1111
    ld de, bombs_fire_ranges_array
    add a, e
    ld e, a
    ld a, [de]
    inc a
    ld [de], a
    jp TILE_CLEAR

;****************************************************************************************************
; Increases the max amount of bombs an actor can use simultaneously, capped to _BOMBS_NUMBER_LIMIT.
;****************************************************************************************************
POWERUP_BOMB:
    ld a, e
    and %0000_1111
    ld de, bombs_used_max_array
    add a, e
    ld e, a
    ld a, [de]
    cp _BOMBS_NUMBER_LIMIT
    jp nc, TILE_CLEAR
    inc a
    ld [de], a
    jp TILE_CLEAR

;****************************************************************************************************
; Increases the speed of an actor, capped to _P_MAX_SPEED.
;****************************************************************************************************
POWERUP_SPEED:
    ld a, e
    and %0000_1111
    ld de, actors_speed_array
    add a, e
    ld e, a
    ld a, [de]
    cp _P_MAX_SPEED
    jp nc, TILE_CLEAR
    inc a
    ld [de], a
    jp TILE_CLEAR

;****************************************************************************************************
; Not implemented
;****************************************************************************************************
POWERUP_LADDER:
    jp TILE_CLEAR

;****************************************************************************************************
; Not implemented
;****************************************************************************************************
POWERUP_PUSH:
    jp TILE_CLEAR

;****************************************************************************************************
; Not implemented
;****************************************************************************************************
POWERUP_CONFUSION:
    jp TILE_CLEAR