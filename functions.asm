SECTION "Functions", ROM0

;****************************************************************************************************
; Clears MAP
;****************************************************************************************************
MAP_CLEAR:
    ld hl, _SCRN0
    ld bc, $1F * $1F
    call MEMCLEAR
    ret
  
;****************************************************************************************************
; Clears OAM
;****************************************************************************************************
OAM_CLEAR:
  ld hl, shadowOAM
  ld bc, OAM_COUNT * 4
  call MEMCLEAR
  ret 

;****************************************************************************************************
; Initializes all variables on start
;****************************************************************************************************
VARS_INIT: 
  ;Everything which needs to be set to 0 at start here
  xor a
  ld [vblankCount], a
  ld [timerSeconds], a
  ld [tempCounter], a
  ld [bombs_array_length], a
  ld [currentEnemyData], a
  call BOMBS_CLEAR
  
  call ENEMIES_CLEAR
  call ENEMIES_CREATE

  ld a, _P_SPAWN_Y ;Player Y
  ld [pY], a
  ld a, _P_SPAWN_X ;Player X
  ld [pX], a
  
  ld d, 1
  ld hl, bombs_fire_ranges_array
  ld bc, _ENEMIES_COUNT + 1
  call MEMSET
  ld hl, actors_speed_array
  ld bc, _ENEMIES_COUNT + 1
  call MEMSET

  ld a, [randSeed]
  ld b, 0
  ld c, a
  call srand
  xor a
  ld [holesCount], a

  call WEIGHT_MAP_CREATE
  ret 

;****************************************************************************************************
; Updates scroll relative to player's position
;****************************************************************************************************
SCROLL_UPDATE:
  ld a, [pY]
  ld b, a
  ld a, (SCRN_Y / 2) - SCRN_Y + 8
  add a, b
  ;Center the scroll Y around the player avoiding overflow
  jr c, .no_y_overflow
  xor a
.no_y_overflow:
  ld b, 0
  ;min(max(0, y + (SCRN_Y / 2) - SCRN_Y + 8), 15*16 - SCRN_Y)
  call MATH_MINMAX
  ld b, 15*16 - SCRN_Y
  call MATH_MINMAX
  ld a, b
  ld [rSCY], a

  ld a, [pX]
  ld b, a
  ;Center the scroll X around the player avoiding overflow
  ld a, (SCRN_X / 2) - SCRN_X + 8
  add a, b
  jr c, .no_x_overflow
  xor a
.no_x_overflow:
  ld b, 0
  ;min(max(0, x + (SCRN_X / 2) - SCRN_X + 8), 15*16 - SCRN_X)
  call MATH_MINMAX
  ld b, 15*16 - SCRN_X
  call MATH_MINMAX
  ld a, b
  ld [rSCX], a
  ret

;
;
;
WEIGHT_MAP_CREATE:
    ld hl, weight_map
    ld de, level_map
    ld c, _LEVEL_SIZE
  
  .loop:
    ld a, [de]
    ld b, a
    inc de
    ld a, _WEIGHTS_EMPTY
    ;A byte in the level map encodes two tiles, therefore we can run two checks per byte
    bit 7, b ;Check collision higher nibble, if there is collision then override value
    jr z, .first_has_collision
    ld a, _WEIGHTS_BLOCK
  .first_has_collision:
    ld [hl+], a
    ld a, _WEIGHTS_EMPTY
    bit 3, b ;Check collision lower nibble
    jr z, .second_has_collision
    ld a, _WEIGHTS_BLOCK
  .second_has_collision:
    ld [hl+], a
  
    dec c
    jr nz, .loop
    ret 

MACRO LCDC_OFF
  xor a
  ld [rLCDC], a		;Set the LCDC off
ENDM

MACRO LCDC_ON
  ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
  ld [rLCDC], a
ENDM

;
; @param hl: Address memory destination
; @param de: Memory source to copy
;
STRCPY:
  ld a, [de]
  ;Check if the byte is zero
  cp 0
  ret z
  ;Continue if it's not
	inc de
  ld [hl+], a
  and a			    
  jr STRCPY

;****************************************************************************************************
; Copies a tilemap from memory to the screen. Used for unpadded map data.

; @param hl: Address memory destination
; @param de: Memory source to copy
; @param b: Rows

; @return hl = hl + b * 32
; @return de = de
; @return bc = $0000
; @return a = $00
;****************************************************************************************************
SCREENCPY:
    ld c, 20
.loop:
    ld a, [de]
    inc de
    ld [hl+], a
    dec c
    jr nz, .loop
    dec b
    ret z
    ld c, 20
    ld a, 12
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    jr .loop

;****************************************************************************************************
; Copy memory from one source to a destination.

; @param hl: Address memory destination
; @param de: Memory source to copy
; @param bc: Size of memory (counter)

; @return hl = hl + bc
; @return de = de
; @return bc = $0000
; @return a = $00
;****************************************************************************************************
MEMCPY:
    ld a, [de]
    inc de
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, MEMCPY
    ret

;****************************************************************************************************
; Copy memory from one source to a destination with a height and width.

; @param hl: Address memory destination
; @param de: Memory source to copy
; @param b: Height of tiles to copy (MAX: $FF)
; @param c: Width of tiles to copy (MAX: $FF)

; @return hl = hl + (b * scrn_vx_b) + c
; @return de = de + b + c
; @return bc = $0000
; @return a = $00
;****************************************************************************************************
TILECPY:
    ld a, [rLY]
    cp 144 				    ;Check if the LCD is past VBlank
    jr c, TILECPY	;rLY >= 144?
    push bc
.tilecpy_loop:
    ld a, [de]
    inc de
    ld [hl+], a
    dec c
    ld a, c
    ;Check if we're done with the width
    cp $0
    jr nz, .tilecpy_loop
    pop bc
    dec b
    ld a, b
    ;Check if we're done with the height
    cp $0
    ret z ;If we are, then return
    ;Otherwise, go to the next line of the screen
    push bc
    ld a, SCRN_VX_B
    sub a, c
    ld b, 0
    ld c, a
    add hl, bc
    pop bc
    push bc
    jr .tilecpy_loop

;****************************************************************************************************
; Clear the memory (set to 0) of a destination

; @param hl: Address memory destination
; @param bc: Size of memory (counter)

; @return hl = hl + bc
; @return bc = 0
;****************************************************************************************************
MEMCLEAR:
    xor a
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, MEMCLEAR
    ret 

;****************************************************************************************************
; Set the memory of destination to a fixed value

; @param hl: Address memory destination
; @param bc: Size of memory (counter)
; @param d: Value to set memory to

; @return hl = hl + bc
; @return bc = 0
;****************************************************************************************************
MEMSET:
    ld a, d
    ld [hl+], a
    dec bc
    ld a, b
    or c
    jr nz, MEMSET
    ret 

;****************************************************************************************************
; Convert the position in the array map to the pixel position

; @param r: Position in the map

; @return r = r // 16
;****************************************************************************************************

MACRO POSITION_GET
    srl \1
    srl \1
    srl \1
    srl \1
ENDM

;****************************************************************************************************
; Multiplication functions by a fixed number, MULTIPLY_BY_n

; @param r: Input

; @return r = a * n
;****************************************************************************************************

MACRO MULTIPLY_BY_8
    sla \1
    sla \1
    sla \1
ENDM

MACRO MULTIPLY_BY_16
    swap \1
ENDM

;****************************************************************************************************
; Clears a tile from the map.

; @param b: Position Y in map.
; @param c: Position X in map.
;****************************************************************************************************
TILE_CLEAR:
    push bc
    call WEIGHT_GET
    ld a, _WEIGHTS_EMPTY
    ld [hl], a
    
    call MAP_TO_ADDRESS
    ld de, empty_map_data
    ld b, 2
    ld c, 2
    call TILECPY
    pop bc
    ret

;****************************************************************************************************
; Get the tile byte in the map from its Y and X position in it.

; @param b: Y position in map
; @param c: X position in map

; @return a = if x % 2 == 0 swap(map[y, x]) else map[y,x]
; @return hl = [level_map] + (b * 8) + (c / 2)
;****************************************************************************************************
TILE_GET:
    ld a, b
    MULTIPLY_BY_8 a ;a = b * 8
    ld h, c
    srl c ;c = c / 2
    add a, c ;a = a + (c / 2), thus a = (b * 8) + (c / 2) = (y * 8) + (x / 2)
    ld c, h
    ld hl, level_map
    ;Add to the address (y * 8) + (x / 2) to get the tile position in table
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    ld a, [hl]

    ;Check if X is even or not to see if we have to swap the nibble
    ;This is because one byte encodes 2 tiles
    bit 0, c
    ret nz
    swap a
    ret

;****************************************************************************************************
; Get the weight in the map of a tile from its Y and X position.

; @param b: Y position in map
; @param c: X position in map

; @return hl = weight_map + y * 16 + x
;****************************************************************************************************
WEIGHT_GET:
    ld hl, weight_map
    ld a, b
    MULTIPLY_BY_16 a ;a = b * 16
    add c
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a
    ret 

;****************************************************************************************************
; Check if the next move collides with a wall

; @param b: Next position Y in map
; @param c: Next position X in map
; @param [collisionFuncParams]:
;           Bits 1-0: Direction (0: Up, 1: Down, 2: Right, 3: Left)
;           Bit  3:   isCharacter (true or false)
;           Bits 7-4: Character ID.

; @return a = map[y, x]
; @return d = map[y, x]
; @return hl = [level_map] + (b * 8) + c
; @return z = 1 if map[y, x] == 0
;****************************************************************************************************
CHECK_COLLISION:
    ;Get the tile in the map from these positions
    call TILE_GET

    ld d, a
    and $0F
    ;The fourth bit indicates whether the tile has collision or not
    bit 3, a
    ;If the tile has collision then it will return nz
    ret nz
    ;If it doesn't have collision then we will check if it's a powerup
    cp TILES_EMPTY_ID
    ret z

    ld a, [collisionFuncParams]
    and _COLLISION_CHARACTER_ID | _COLLISION_ISCHARACTER
    swap a
    ld e, a
    call POWERUP_CHECK
    bit 3, a
    ret

;****************************************************************************************************
; Calculate the map positions of all hitbox corners

; @param a:
;       Bit 1-0: Direction (0: Up, 1: Down, 2: Right, 3: Left)
; @param b: Pixel position Y
; @param c: Pixel position X
; @param de: Hitbox map storage address

; @return hl = hitbox_matrix + d * 4
; @return de = de + 2
;****************************************************************************************************

HITBOX_MAP:
    sla a
    sla a

    ld hl, hitbox_matrix
    add l
    ld l, a
    ld a, 0
    adc h
    ld h, a

    ld a, 2
.hitbox_map_loop:
    ld [tempCounter], a
    push bc
    ld a, [hl+]
    add b
    ld b, a
    ld a, [hl+]
    add c
    ld c, a
    
    POSITION_GET b
    POSITION_GET c

    ld a, b
    swap a
    or c
    ld [de], a
    inc de
    pop bc

    ld a, [tempCounter]
    dec a
    cp $00
    jr nz, .hitbox_map_loop 
    ret

;****************************************************************************************************
; Check if we're crossing the boundary between two tiles, and if we are then check the collision

; @param b: Next Y position in pixels.
; @param c: Next X position in pixels.
; @param [oY]: Current Y position in pixels.
; @param [oX]: Current X position in pixels.
; @param [collisionFuncParams]:
;           Bits 1-0: Direction (0: Up, 1: Down, 2: Right, 3: Left)
;           Bit  3:   isCharacter (true or false)
;           Bits 7-4: Character ID.

; @alters: a, b, c, d, e, hl
; @return z = 1 if map[y, x] == 0 || e == 4
;****************************************************************************************************
CHECK_BOUNDARY:
    ;Create the hitbox map for the next position
    ld de, hitbox_locs
    ld a, [collisionFuncParams]
    and _COLLISION_DIRECTION
    call HITBOX_MAP

    ;Create the hitbox map for the current position
    ld a, [oX]
    ld c, a
    ld a, [oY]
    ld b, a

    ld de, current_hitbox_locs
    ld a, [collisionFuncParams]
    and _COLLISION_DIRECTION
    call HITBOX_MAP

    ld a, 2 ;Counter
    ;We use 2, because we are checking two corners for a direction
    ;Load both hitbox maps to compare
    ld hl, hitbox_locs
    ld de, current_hitbox_locs
.check_loop:
    ld [tempCounter], a

    ld a, [hl+]
    ld b, a
    ;Check if current[i] = next[i]
    ld a, [de]
    inc de
    cp b
    jr z, .not_crossed_boundary

    push de
    push hl
    ld a, [currentActor]
    sla a
    sla a
    set 0, a ;Set the bit0 to 1 to indicate we're a character
    ld e, a

    ;Separate b into b and c
    ld a, b
    and $0F
    ld c, a
    ld a, b
    and $F0
    swap a
    ld b, a
    call CHECK_COLLISION
    pop hl
    pop de
    ;If it's not empty then we can stop, otherwise check the other points
    ret nz
.not_crossed_boundary:     
    ld a, [tempCounter]
    dec a
    cp 0
    jr nz, .check_loop
    ret

;****************************************************************************************************
; Determine the min and max value between two numbers

; @param a: First 8 bit number
; @param b: Second 8 bit number

; @return a = max(a,b)
; @return b = min(a,b)
; @return c = a
;****************************************************************************************************

MATH_MINMAX:
    cp b
    ;a-b, if a > b then c=0, a is the maximum and we can return
    ret nc
    ;Otherwise, swap a and b
    ld c, a
    ld a, b
    ld b, c
    ret

;****************************************************************************************************
; Translate a position in the map to the screen address

; @param b: Y position in map
; @param c: X position in map

; @return a = 0
; @return bc = _SCRN0
; @return de = SCRN_VX_B * 2
;****************************************************************************************************
MAP_TO_ADDRESS:
    sla c

    ld d, 0
    ld e, SCRN_VX_B * 2 ;Screen width bytes * 2 because our tiles are 16x16
    ld h, 0
    ld l, c

.sum_loop:
    add hl, de
    dec b
    ld a, b
    cp $0
    jr nz, .sum_loop
    
    ld bc, _SCRN0
    add hl, bc
    ret

;****************************************************************************************************
; Destroy a brick from the map given its Y and X position.

; @param b: Y position in map
; @param c: X position in map

; @return hl = hl + (b * scrn_vx_b) + c
; @return de = de + b + c
; @return bc = $0000
; @return a = $00
;****************************************************************************************************
BRICK_DESTROY:
    call TILE_GET
    and $F0
    bit 0, c
    jr nz, .no_swap
    swap a
.no_swap:
    ld [hl], a

    call POWERUP_SPAWN
    ret c

    call TILE_CLEAR
    ret 

;****************************************************************************************************
; Fade out effect

; @param de: Time to fade out
;****************************************************************************************************
FADE_OUT:
  ld a, %11100100 
  ld [rBGP], a

  call WASTE_CYCLES
  ld a, %11111001 
  ld [rBGP], a

  call WASTE_CYCLES
  ld a, %11111110 
  ld [rBGP], a

  call WASTE_CYCLES
  ld a, %11111111 
  ld [rBGP], a
  ret 

;****************************************************************************************************
; Fade in effect

; @param de: Time to fade out
;****************************************************************************************************
FADE_IN:
  ld a, %11111111 
  ld [rBGP], a

  call WASTE_CYCLES
  ld a, %11111110 
  ld [rBGP], a

  call WASTE_CYCLES
  ld a, %11111001 
  ld [rBGP], a

  call WASTE_CYCLES
  ld a, %11100100 
  ld [rBGP], a
  ret 

;****************************************************************************************************
; @param de: Time to waste
;****************************************************************************************************
WASTE_CYCLES:
  ld b, d
  ld c, e
.loop:
  dec bc
  ld a, b
  or c
  jr nz, .loop
  ret 

;****************************************************************************************************
; Initializes the game over sequence
;****************************************************************************************************
SEQUENCE_GAMEOVER:
  ld a, [lives]
  dec a
  ld [lives], a

  ;Remove player and enemies from screen and reset scroll
  call OAM_CLEAR
  ld [rSCY], a
  ld [rSCX], a

  call WAIT_VBLANK
  ld  a, HIGH(shadowOAM)
  call hOAMDMA

  ld sp, $FFFE ;Set stack pointer to end of HRAM
  jp MENU_GAMEOVER

;****************************************************************************************************
; Initializes the win level sequence
;****************************************************************************************************
SEQUENCE_WIN_LEVEL:
  ;Remove player and enemies from screen and reset scroll
  call OAM_CLEAR
  ld [rSCY], a
  ld [rSCX], a

  call WAIT_VBLANK
  ld  a, HIGH(shadowOAM)
  call hOAMDMA

  ld a, [currentLevel]
  inc a
  ld [currentLevel], a

  ld a, [lives]
  inc a
  ld [lives], a

  ld sp, $FFFE ;Set stack pointer to end of HRAM
  jp MENU_WIN

;****************************************************************************************************
; Checks win and loss conditions based on the status of alive actors
;****************************************************************************************************
CHECK_WIN_CONDITIONS:
  ld a, [alive]
  cp %0000_0001
  ;If it's 1 then it means only the player is alive
  ;Then start level complete sequence...
  jp z, SEQUENCE_WIN_LEVEL

  and %0000_0001
  cp %0000_0000
  ;Player is not alive
  ;Then game over sequence...
  jp z, SEQUENCE_GAMEOVER
  ret 