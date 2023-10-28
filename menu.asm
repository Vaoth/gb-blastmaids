SECTION "Menu", ROM0

MENU_INIT:
    ;Load menu background image
    ld hl, _VRAM8800
    ld de, menu_tile_data
    ld bc, menu_tile_data_size
    call MEMCPY

    ;Load title tiles
    ld de, title_tile_data
    ld bc, title_tile_data_size
    call MEMCPY

    ;Load font
    ld hl, $9500
    ld de, font_tile_data
    ld bc, font_tile_data_size
    call MEMCPY
  
    ld hl, _SCRN0
    ld de, menu_map_data
    ld b, 18
    call SCREENCPY

    ld hl, _MENU_MESSAGE_START_ADDR
    ld de, MENU_MESSAGE_START
    call STRCPY

    ld hl, _MENU_MESSAGE_HELP_ADDR
    ld de, MENU_MESSAGE_HELP
    call STRCPY

    xor a
    ld [rSCY], a
    ld [rSCX], a
    ld [rNR52], a

    LCDC_ON
    ; Init display registers in the first (blank) frame
    ld a, %11100100 
    ld [rBGP], a
    ld [rOBP0], a
    ;ld a, TACF_START | TACF_262KHZ
    ;ld [rTAC], a

    xor a
    ld [cursorIndex], a
    ld [cursorCounter], a
    ld [blinkState], a
    ld a, _MENU_BLINK_SPEED
    ld [blinkCounter], a

    call MENU_CURSOR_LOAD

MENU_INIT_MAIN:
    ld a, [randSeed]
    inc a
    ld [randSeed], a
    
    call MENU_INPUT_CHECK
    call MENU_UPDATE_BLINK

    ;Update the cursor
    ld a, [cursorIndex]
    MULTIPLY_BY_16 a
    add _CURSOR_Y
    ld [shadowOAM], a

    call WAIT_VBLANK
    ld  a, HIGH(shadowOAM)
    call hOAMDMA
    jr MENU_INIT_MAIN


MENU_INPUT_CHECK:
    call INPUT_READ

    ld a, [rPAD]

    cp PADF_START
    jp z, MENU_INPUT_START_BUTTON
    cp PADF_UP
    jp z, MENU_INPUT_UP_BUTTON
    cp PADF_DOWN
    jp z, MENU_INPUT_DOWN_BUTTON

    xor a
    ld [cursorCounter], a
    ret

MENU_INPUT_START_BUTTON:
    ld a, [cursorCounter]
    inc a
    ld [cursorCounter], a
    cp _CURSOR_COUNTER_LIMIT
    ret c
    xor a
    ld [cursorCounter], a

    ld a, [cursorIndex]
    cp 0
    jp z, MENU_OPTION_START

    ld de, $2FFF
    call FADE_OUT
    call FADE_IN
    
    ld a, _MENU_BLINK_SPEED
    ld [blinkCounter], a
    ret 

MENU_INPUT_UP_BUTTON:
    ld a, [cursorCounter]
    inc a
    ld [cursorCounter], a
    cp _CURSOR_COUNTER_LIMIT
    ret c
    xor a
    ld [cursorCounter], a

    ld a, [cursorIndex]
    cp 0
    ret z
    dec a
    ld [cursorIndex], a
    ret 

MENU_INPUT_DOWN_BUTTON:
    ld a, [cursorCounter]
    inc a
    ld [cursorCounter], a
    cp _CURSOR_COUNTER_LIMIT
    ret c
    xor a
    ld [cursorCounter], a

    ld a, [cursorIndex]
    cp _MENU_MAIN_OPTIONS
    ret z
    inc a
    ld [cursorIndex], a
    ret 

MENU_CURSOR_LOAD:
    ld hl, shadowOAM ;Set stack to point at the OAM
    ld a, [cursorIndex]
    MULTIPLY_BY_16 a
    add _CURSOR_Y
    ld [hl+], a ;Y
    ld a, _CURSOR_X
    ld [hl+], a ;X
    ld a, 8
    ld [hl+], a ;Tile ID
    xor a
    ld [hl+], a ;Attributes
    ret 

MENU_OPTION_START:
    ld a, _P_START_LIVES
    ld [lives], a

    jp SEQUENCE_MAIN

MENU_GAMEOVER:
    ld de, $2FFF
    call FADE_OUT

    LCDC_OFF

    ld hl, _SCRN0
    ld de, gameover_map_data
    ld b, 18
    call SCREENCPY

    LCDC_ON

    ld de, $2FFF
    call FADE_IN

MENU_GAMEOVER_LOOP:
    call INPUT_READ

    ld a, [rPAD]

    cp PADF_START
    jr nz, MENU_GAMEOVER_LOOP

    ld a, [lives]
    cp 0
    jp nz, SEQUENCE_MAIN

    xor a
    ld [currentLevel], a

    call WAIT_VBLANK
    LCDC_OFF
    jp MENU_INIT

MENU_WIN:
    ld de, $2FFF
    call FADE_OUT

    LCDC_OFF

    ld hl, _SCRN0
    ld de, win_map_data
    ld b, 18
    call SCREENCPY

    ld a, [currentLevel]
    cp _LEVEL_MAX
    jr c, .not_last_level

    ld hl, _WIN_MESSAGE_THANKYOU_ADDR
    ld de, WIN_MESSAGE_THANKYOU
    call STRCPY

    ld hl, _WIN_MESSAGE_FORPLAYING_ADDR
    ld de, WIN_MESSAGE_FORPLAYING
    call STRCPY
.not_last_level:
    LCDC_ON

    ld de, $2FFF
    call FADE_IN

MENU_WIN_LOOP:
    call INPUT_READ

    ld a, [rPAD]

    cp PADF_START
    jr nz, MENU_WIN_LOOP

    ld a, [currentLevel]
    cp _LEVEL_MAX
    jp c, SEQUENCE_MAIN

    xor a
    ld [currentLevel], a

    call WAIT_VBLANK
    LCDC_OFF
    jp MENU_INIT

MENU_UPDATE_BLINK:
    ld a, [blinkCounter]
    dec a
    ld [blinkCounter], a
    ret nz

    ld a, _MENU_BLINK_SPEED
    ld [blinkCounter], a

    ld a, [blinkState]
    xor %0000_0001
    ld [blinkState], a
    jr z, .title_blink

    call WAIT_VBLANK
    ld hl, _SCRN0
    ld de, title_map_data
    ld b, 3
    call SCREENCPY
    ret 
.title_blink:
    call WAIT_VBLANK
    ld hl, _SCRN0
    ld de, menu_map_data
    ld b, 3
    call SCREENCPY
    ret 