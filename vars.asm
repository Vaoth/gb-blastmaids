;******************************************************************************************************************
; VARIABLES AND ARRAYS
;******************************************************************************************************************
SECTION "Weight map", WRAM0[$C120]
weight_map: ds _LEVEL_WEIGHT_SIZE

SECTION "Level variables", WRAM0[$C230]
;Level related
level_map: ds _LEVEL_SIZE
currentLevel: db
levelData: db
level_tiles: ds 8

SECTION "Variables", WRAM0
;Bombs related
explosionRanges: ds 4
bombs_array: ds _BOMBS_ARRAY_SIZE
bombs_array_length: db
explodeFuncParams: db
bombs_used_array: ds _CHARACTERS_MAP_LIMIT
bombs_used_max_array: ds _CHARACTERS_MAP_LIMIT
bombs_fire_ranges_array: ds _ENEMIES_COUNT + 1
bombCurrentFireRange: db

;Player related
player_sprites: ds 2*2
pY: db
pX: db
actors_speed_array: ds _ENEMIES_COUNT + 1
actorSpeed: db
lives: db

;Enemy related
enemies_array: ds _ENEMIES_ARRAY_SIZE
enemy_direction_priorities: ds 4
enemy_direction_weights: ds 4
enemy_intersection_bricks: db
alive: db ; **** ksbm
currentEnemyData: db

;Holes related
holes_array: ds _HOLES_PARAMETERS*_HOLES_NUMBER_LIMIT
holesCount: db

;Misc
vblankCount: db
timerSeconds: db
hitbox_locs: ds 2
current_hitbox_locs: ds 2
currentActor: db
tempCounter: db
collisionFuncParams: db
oY: db
oX: db
randSeed: db

;Powerup related
powerupsCounter: db

;Menu related
cursorIndex: db
cursorCounter: db
blinkCounter: db
blinkState: db