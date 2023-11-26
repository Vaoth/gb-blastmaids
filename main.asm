;****************************************************************************************************
;*	MAIN.ASM - Blast Maids source code
;****************************************************************************************************
;* for the University of Seville end-of-degree project
;* v1.0.1
;****************************************************************************************************

;****************************************************************************************************
;*	Includes
;****************************************************************************************************

	;System includes
	INCLUDE	"system/hwgb.inc"

  ;Tile includes
  INCLUDE "gfx/levels.inc"
  INCLUDE "gfx/tiles.inc"
  INCLUDE "gfx/sprites.inc"
  INCLUDE "gfx/menu.inc"
  INCLUDE "gfx/gameover.inc"
  INCLUDE "gfx/win.inc"

	;Project includes
  INCLUDE	"functions.asm"
  INCLUDE	"input.asm"
  INCLUDE	"constants.asm"
  INCLUDE	"level.asm"
  INCLUDE	"vars.asm"
  INCLUDE "player.asm"
  INCLUDE "bomb.asm"
  INCLUDE "rand.asm"
  INCLUDE "holes.asm"
  INCLUDE "powerup.asm"
  INCLUDE "enemy.asm"
  INCLUDE "menu.asm"

;****************************************************************************************************
;*	Header
;****************************************************************************************************


SECTION "OAM DMA routine", ROM0
COPY_DMA_ROUTINE:
  ld  hl, DMA_ROUTINE
  ld  b, DMA_ROUTINE_END - DMA_ROUTINE ; Number of bytes to copy
  ld  c, LOW(hOAMDMA) ; Low byte of the destination address
.copy
  ld  a, [hli]
  ldh [c], a
  inc c
  dec b
  jr  nz, .copy
  ret

DMA_ROUTINE:
  ldh [rDMA], a
  
  ld  a, 40
.wait
  dec a
  jr  nz, .wait
  ret
DMA_ROUTINE_END:

SECTION "Shadow OAM", WRAM0,ALIGN[8]
shadowOAM: ds 4 * 40 ; This is the buffer we'll write sprite data to
    
SECTION "OAM DMA", HRAM
hOAMDMA: ds DMA_ROUTINE_END - DMA_ROUTINE ; Reserve space to copy the routine to
    

SECTION "Header", ROM0[$100] ; Make room for the header
    jp INIT

    ds $150 - @, 0

;****************************************************************************************************
;*	Program Start
;****************************************************************************************************
SECTION "Program Start", ROM0
INIT:
  ei
  ld sp, $FFFE ;Set stack pointer to end of HRAM
  call COPY_DMA_ROUTINE

  call WAIT_VBLANK
  LCDC_OFF

  call MAP_CLEAR
  call OAM_CLEAR

  ld hl, _VRAM8000
  ld de, sprites_tile_data
  ld bc, sprites_tile_data_size
  call MEMCPY

  xor a
  ld [currentLevel], a

  jp MENU_INIT

SEQUENCE_MAIN:
  call WAIT_VBLANK
  ld de, $2FFF
  call FADE_OUT
  LCDC_OFF

  call MAP_CLEAR
  call OAM_CLEAR

  ld hl, _VRAM9000
  ld de, tiles_data
  ld bc, tiles_data_size
  call MEMCPY

  ld hl, _VRAM8800
  ld de, win_tile_data
  ld bc, win_tile_data_size
  call MEMCPY

  ld de, gameover_tile_data
  ld bc, gameover_tile_data_size
  call MEMCPY

  LCDC_ON
  ld a, [currentLevel]
  call PLAYER_LOAD
  call LEVEL_LOAD
  call VARS_INIT

  ld de, $2FFF
  call FADE_IN

MAIN:
  call INPUT_CHECK
  call PLAYER_UPDATE
  call ENEMIES_UPDATE
  call UPDATE_TIMERS
  call BOMBS_UPDATE
  call HOLE_EVENT_CHECK
  call PLAYER_CHECK_HIT
  call CHECK_WIN_CONDITIONS

  call WAIT_VBLANK
  ld  a, HIGH(shadowOAM)
  call hOAMDMA

  call WAIT_VBLANK
  call SCROLL_UPDATE
  jr MAIN

WAIT_VBLANK:
  ld a, [rLY]
  cp 144 				    ;Check if the LCD is past VBlank
  jr c, WAIT_VBLANK	;rLY >= 144?
  ret

UPDATE_TIMERS:
  ld a, [vblankCount]
  inc a
  cp a, 60
  jr nz, .one_second
  ld a, [timerSeconds]
  inc a
  ld [timerSeconds], a
  xor a
.one_second:
  ld [vblankCount], a
  ret 
