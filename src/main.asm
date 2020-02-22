include "src/constants.asm"
include "src/macro.asm"

SECTION "Main", ROM0

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

	ei
	jr run                  ; Run main program

; Runs the main program
run::
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF
	ld a, $45
	ld [hli], a
	ld a, $70
	ld [hl], a
.gameLoop:
	halt
	ld hl, $FF42
	dec [hl]

	call executePlayerActions
	call updateRegisters
	call updatePlayer
	call updateLasers
	call createObstacle
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