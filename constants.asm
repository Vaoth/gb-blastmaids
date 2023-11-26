;******************************************************************************************************************
; CONSTANTS
;******************************************************************************************************************
SECTION "Constants", ROM0

;Level related
_CHARACTERS_MAP_LIMIT EQU 4
_LEVEL_WIDTH_BYTES    EQU 8
_LEVEL_HEIGHT_BYTES   EQU 17
_LEVEL_SIZE           EQU _LEVEL_WIDTH_BYTES * _LEVEL_HEIGHT_BYTES

_LEVEL_WEIGHT_WIDTH  EQU 16
_LEVEL_WEIGHT_HEIGHT EQU 17
_LEVEL_WEIGHT_SIZE   EQU _LEVEL_WEIGHT_WIDTH * _LEVEL_WEIGHT_HEIGHT

_LEVEL_TILE_MAP_SIZE EQU $0400
_LEVEL_TILE_MAP_WIDTH EQU $20
_LEVEL_TILE_MAP_HEIGHT EQU $20

_LEVEL_MAX EQU 4


_WEIGHTS_POWERUP      EQU 0
_WEIGHTS_EMPTY        EQU 1
_WEIGHTS_BOMB_FIRE    EQU 4
_WEIGHTS_BOMB_AFTER   EQU %0011_1111
_WEIGHTS_BOMB         EQU $FE
_WEIGHTS_BLOCK        EQU $FF

;Level tiles
_TILES_EMPTY_ID EQU $0
_TILES_RANGE_POW_ID EQU $1
_TILES_BOMB_POW_ID EQU $2
_TILES_SPEED_POW_ID EQU $3
_TILES_LADDER_POW_ID EQU $4
_TILES_PUSH_POW_ID EQU $5
_TILES_WALL_ID EQU $8
_TILES_BRICK_ID EQU $9
_TILES_HOLE_ID EQU $A
_TILES_BOMB_ID EQU $B

;Bombs related
_BOMBS_NUMBER_LIMIT     EQU 4
_BOMBS_ARRAY_MAX_LENGTH EQU _CHARACTERS_MAP_LIMIT*_BOMBS_NUMBER_LIMIT
_BOMBS_ARRAY_SIZE       EQU 3*_BOMBS_ARRAY_MAX_LENGTH
_BOMBS_CLEAR_TIME       EQU 64
_BOMBS_EXPLOSION_TIME   EQU _BOMBS_CLEAR_TIME * 2 + _BOMBS_CLEAR_TIME / 2

;Player related
_PLAYER_ID     EQU 0
_P_SPAWN_X     EQU 16
_P_SPAWN_Y     EQU 16
_P_HIT_Y       EQU 8
_P_HIT_X       EQU 4
_P_HIT_WIDTH   EQU 7
_P_HIT_HEIGHT  EQU 7
_P_MAX_SPEED   EQU 3
_P_START_LIVES EQU 3

;Enemy related
_ENEMIES_DATA_INDEX       EQU 0
_ENEMIES_PY_INDEX         EQU 1
_ENEMIES_PX_INDEX         EQU 2
_ENEMIES_TILEID_INDEX     EQU 3 
_ENEMIES_ATTRIBUTES_INDEX EQU 4 
_ENEMIES_TARGETY_INDEX    EQU 5 
_ENEMIES_TARGETX_INDEX    EQU 6
_ENEMIES_NEXTDIR_INDEX    EQU 7
_ENEMIES_LASTDIR_INDEX    EQU 8 
_ENEMIES_TIMER_INDEX      EQU 9

_ENEMIES_DATA_ID_MASK        EQU %0000_1111
_ENEMIES_DATA_STATE_MASK     EQU %0111_0000
_ENEMIES_DATA_STATE_MASK_INV EQU %1000_1111

_ENEMY_STATE_PATROL  EQU %0000_0000
_ENEMY_STATE_ATTACK  EQU %0001_0000
_ENEMY_STATE_COLLECT EQU %0010_0000

_ENEMY_STATE_ATTACK_TIME  EQU $FF 
_ENEMY_STATE_COLLECT_TIME EQU $A0

_ENEMIES_BURA_ID     EQU 1
_ENEMIES_BURA_SPAWNY EQU $10
_ENEMIES_BURA_SPAWNX EQU $F0

_ENEMIES_SUTO_ID     EQU 2
_ENEMIES_SUTO_SPAWNY EQU $F0
_ENEMIES_SUTO_SPAWNX EQU $10

_ENEMIES_KANPAKU_ID     EQU 3
_ENEMIES_KANPAKU_SPAWNY EQU $F0
_ENEMIES_KANPAKU_SPAWNX EQU $F0

_ENEMIES_SADA_ID    EQU 4
_ENEMIES_COUNT      EQU 3
_ENEMIES_ARGS_SIZE  EQU 16
_ENEMIES_ARRAY_SIZE EQU _ENEMIES_COUNT * _ENEMIES_ARGS_SIZE

;Holes related
_HOLES_NUMBER_LIMIT EQU 4
_HOLES_SPAWN_TIME   EQU 30
_HOLES_PARAMETERS   EQU 2 ;The array contains for each hole [y x]

;Powerup related
_POWERUPS_SPAWN_CHANCE EQU 102
_POWERUPS_NUMBER_LIMIT EQU 8

;Misc
_DIRECTION_UP    EQU 0
_DIRECTION_DOWN  EQU 1
_DIRECTION_RIGHT EQU 2
_DIRECTION_LEFT  EQU 3
_DIRECTION_NONE  EQU 4

;Masks for [collisionFuncParams]
;           Bits 1-0: Direction (0: Up, 1: Down, 2: Right, 3: Left)
;           Bits 3-2: Character ID.
;           Bit 4: isCharacter (true or false)
;           Bits 6-5: Speed
_COLLISION_DIRECTION    EQU %0000_0011
_COLLISION_CHARACTER_ID EQU %1111_0000
_COLLISION_ISCHARACTER  EQU %0000_1000

;Masks for [explodeFuncParams]:
;           Bit 0: Clear (true or false)
;           Bits 5-1: Character ID
_EXPLODE_CLEAR        EQU %0000_0001
_EXPLODE_CHARACTER_ID EQU %0001_1110

;Menu related
_CURSOR_Y                EQU 72
_CURSOR_X                EQU 14
_CURSOR_COUNTER_LIMIT    EQU 32
_MENU_MAIN_OPTIONS       EQU 1 ;Includes 0
_MENU_MESSAGE_START_ADDR EQU $98E2
_MENU_MESSAGE_HELP_ADDR  EQU $9922

_WIN_MESSAGE_THANKYOU_ADDR   EQU $99A6
_WIN_MESSAGE_FORPLAYING_ADDR EQU $99E5

_MENU_BLINK_SPEED EQU $70

;******************************************************************************************************************
; MATRICES AND POINTERS
;******************************************************************************************************************

;Hitbox matrix logic:
;y = P_HITBOX_Y, x = P_HITBOX_X
;UP     (y,          x        ), (y,          x + width)
;DOWN   (y + height, x        ), (y + height, x + width)
;RIGHT  (y,          x + width), (y + height, x + width)
;LEFT   (y,          x        ), (y + height, x        )
hitbox_matrix:
db _P_HIT_Y                , _P_HIT_X               , _P_HIT_Y                , _P_HIT_X + _P_HIT_WIDTH ;Up
db _P_HIT_Y + _P_HIT_HEIGHT, _P_HIT_X               , _P_HIT_Y + _P_HIT_HEIGHT, _P_HIT_X + _P_HIT_WIDTH ;Down
db _P_HIT_Y                , _P_HIT_X + _P_HIT_WIDTH, _P_HIT_Y + _P_HIT_HEIGHT, _P_HIT_X + _P_HIT_WIDTH ;Right
db _P_HIT_Y                , _P_HIT_X               , _P_HIT_Y + _P_HIT_HEIGHT, _P_HIT_X                ;Left
  
;The direction matrix logic is self-explanatory.
direction_matrix:
db -1,0 ;up 00
db 1,0 ;down 01
db 0,1 ;right 10
db 0,-1 ;left 11
  
;The collision matrix follows the logic that your position when you collide will be if you go:
;Up -> y = tile(y)*16 - hitbox.y, x = x
;Down -> y = tile(y)*16, x = x
;Right: y = y, x = tile(x)*16 + hitbox.x
;Left: y = y, x = tile(x)*16 - hitbox.x
;The tile(y)*16 and tile(x)*16 value is left to calculated in the function.
collision_matrix:
db -_P_HIT_Y, $FF
db 0, $FF
db $FF, _P_HIT_X
db $FF, -_P_HIT_X
  
powerup_pointers:
db HIGH(POWERUP_RANGE), LOW(POWERUP_RANGE)
db HIGH(POWERUP_BOMB), LOW(POWERUP_BOMB)
db HIGH(POWERUP_SPEED), LOW(POWERUP_SPEED)
db HIGH(POWERUP_LADDER), LOW(POWERUP_LADDER)
db HIGH(POWERUP_PUSH), LOW(POWERUP_PUSH)

levels_array:
;  Data      , Actors   , Tile map data high    , Tile map data low   , Level map data high, Level map data low
db %0000_0011, %0000_1111, HIGH(level1_tiles), LOW(level1_tiles), HIGH(level1_map)   , LOW(level1_map), 0, 0  ;Level 1 (index 0)
db %0000_0011, %0000_1111, HIGH(level2_tiles), LOW(level2_tiles), HIGH(level2_map)   , LOW(level2_map), 0, 0  ;Level 2
db %0000_0011, %0000_1111, HIGH(level3_tiles), LOW(level3_tiles), HIGH(level3_map)   , LOW(level3_map), 0, 0  ;Level 3
db %0000_0011, %0000_1111, HIGH(level4_tiles), LOW(level4_tiles), HIGH(level4_map)   , LOW(level4_map), 0, 0  ;Level 4

level_unique_rows:
db $88,$88,$88,$88,$88,$88,$88,$88
db $80,$09,$09,$90,$90,$99,$09,$00
db $80,$80,$80,$89,$89,$80,$80,$80
db $89,$09,$00,$90,$90,$90,$09,$09
db $80,$80,$89,$89,$89,$89,$80,$80
db $89,$00,$99,$09,$09,$09,$90,$09
db $89,$89,$80,$80,$80,$80,$89,$89
db $80,$90,$99,$09,$09,$09,$90,$90
db $80,$09,$99,$09,$09,$09,$99,$00
db $89,$09,$09,$90,$90,$99,$09,$09
db $89,$80,$89,$80,$80,$89,$80,$89
db $89,$09,$90,$09,$99,$00,$99,$09
db $80,$89,$80,$89,$89,$80,$89,$80
db $89,$90,$09,$90,$00,$99,$00,$99
db $80,$89,$89,$80,$80,$89,$89,$80
db $80,$09,$09,$90,$00,$99,$09,$00
db $89,$09,$99,$00,$90,$09,$99,$09
db $89,$09,$99,$99,$09,$99,$99,$09
db $89,$80,$89,$89,$89,$89,$80,$89
db $80,$90,$09,$99,$09,$99,$00,$90
db $80,$89,$80,$80,$80,$80,$89,$80
db $80,$09,$09,$09,$09,$09,$09,$00
db $80,$80,$88,$98,$08,$98,$80,$80
db $89,$09,$08,$09,$09,$08,$09,$09
db $80,$89,$90,$98,$98,$90,$99,$80
db $89,$88,$08,$09,$09,$08,$08,$89
db $80,$90,$90,$99,$09,$90,$90,$90
db $89,$89,$89,$80,$80,$89,$89,$89
db $80,$00,$90,$00,$00,$00,$90,$00

; Binary	Hex		Definition
; 0000		$0		Empty
; 0001		$1		Powerup: Increase explosion range
; 0010		$2		Powerup: Extra bombs
; 0011 		$3 		Powerup: Speed increase
; 0100 		$4 		Powerup: Ladder
; 0101 		$5 		Powerup: Pushing bombs
; 0110 		$6
; 0111 		$7
; 1000 		$8 		Wall
; 1001 		$9 		Breakable brick
; 1010 		$A 		Hole
; 1011 		$B 		Bomb
; 1100 		$C 
; 1101 		$D
; 1110 		$E
; 1111 		$F

