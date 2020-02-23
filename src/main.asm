include "src/constants.asm"
include "src/macro.asm"

SECTION "Main", ROM0

pressStart::
	db "PRESS  START"
pressStartEnd::

; Locks the CPU
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
lockup::
	reset INTERRUPT_ENABLED
	halt

; Main function
main::
	call init               ; Init
	ld sp, $E000            ; Init stack
	;jp intro

mainMenu::
	ld hl, menuMelody
	call playSound2
	ld hl, menuBass
	call playSound

	call waitVBLANK
	reset LCD_CONTROL
	call DMA
	reg BGP, %11011000
	reg SHOOT_COOLDOWN, 30

	ld de, $8800
	ld hl, logo
	ld bc, logoEnd - logo
	call copyMemory

	ld de, OAM_SRC_START << 8
	ld bc, $A0
	xor a
	call fillMemory

	ld de, $9800
	ld bc, $800
	ld a, 1
	call fillMemory

	ld hl, $9802
	ld d, $8
	ld bc, $20 - $10
	ld a, $80
.bgLoop:
	ld e, $10
.bgCopyLoop:
	ld [hli], a
	inc a
	dec e
	jr nz, .bgCopyLoop
	add hl, bc
	dec d
	jr nz, .bgLoop

	ld hl, pressStart
	ld bc, pressStartEnd - pressStart
	ld de, $9984
	call copyMemory

	reg LCD_CONTROL, LCD_BASE_CONTROL
.loop:
	call random
	reset INTERRUPT_REQUEST
	halt
	call updateSound
	call updateSound2
	ld hl, SHOOT_COOLDOWN
	xor a
	dec [hl]
	jr nz, .skip
	ld a, [BGP]
	xor %11
	ld [BGP], a
	ld [hl], 30
.skip:
	call getKeys
	bit 7, a
	jr nz, .loop

; Runs the main program
run::
	xor a

	ld de, $C01A
	ld bc, 300
	ld a, 0
	call fillMemory

	ld hl, SCORE_REGISTER + 2
	ld [NB_OBSTACLES], a
	ld [NB_SHOOTS], a
	ld [hl-], a
	ld [hl-], a
	inc a
	ld [hl-], a

	ld hl, gameMelody
	call playSound
	ld hl, gameBass
	call playSound2
	ld hl, ASTEROID_SPAWN_IN
	ld [hl], $FF
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF
	ld a, $44
	ld [hli], a
	ld a, $70
	ld [hl], a
	ei
	reg BGP, %11011000

	call waitVBLANK
	reset LCD_CONTROL
	call drawBackground
	reg LCD_CONTROL, LCD_BASE_CONTROL
	ld hl, $FF42
.gameLoop:
	reset INTERRUPT_REQUEST
	halt
	call updateScore
	ld hl, SCROLL_Y
	dec [hl]

	call checkCollisionSpaceshipAsteroid
	call checkCollisionSpaceshipBoss
	call executePlayerActions
	call updateRegisters
	call updatePlayer
	call updateLasers
	call updateObstacles
	call updateSound
	call updateSound2
	call spawnObstacles
	call bossAttack
	jr .gameLoop

include "src/init.asm"
include "src/fatal_error.asm"
include "src/utils.asm"
include "src/interrupts.asm"
include "src/rendering.asm"
include "src/player.asm"
include "src/play_sound.asm"
include "src/obstacle.asm"
include "src/shoot.asm"
include "src/intro.asm"
include "src/collision.asm"
include "src/game_bass.asm"
include "src/game_melody.asm"
include "src/menu_bass.asm"
include "src/menu_melody.asm"
include "src/boss.asm"
include "src/score.asm"
include "src/boss_bass.asm"
include "src/boss_melody.asm"
include "src/boss_jingle_bass.asm"
include "src/boss_jingle_melody.asm"