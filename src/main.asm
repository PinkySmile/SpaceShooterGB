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

mainMenu::
	call waitVBLANK
	reset LCD_CONTROL
	reg BGP, %11011000
	reg SHOOT_COOLDOWN, 30

	ld de, $9800
	ld bc, $800
	ld a, 1
	call fillMemory

	ld hl, pressStart
	ld bc, pressStartEnd - pressStart
	ld de, $9984
	call copyMemory

	reg LCD_CONTROL, LCD_BASE_CONTROL
.loop:
	call random
	reset INTERRUPT_REQUEST
	halt
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
	ld hl, gameMelody
	call playSound
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
	ld hl, $FF42
	dec [hl]

	call executePlayerActions
	call updateRegisters
	call updatePlayer
	call updateLasers
	call updateObstacles
	call updateSound
	call spawnObstacles
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
include "src/collision.asm"