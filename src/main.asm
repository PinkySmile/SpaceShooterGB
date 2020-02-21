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

; Tests if the current hardware is SGB
; Params:
;    None
; Return:
;    a      -> 0 if on DMG. 1 if on SGB.
;    Flag Z -> 1 if on DMG. 0 if on SGB.
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
testSGB::
	ld a, MLT_REQ
	ld hl, MLT_REQ_PAR
	call sendSGBCommand
	ld hl, JOYPAD_REGISTER
	ld b, [hl]
	ld [hl], %11100000
	ld [hl], %11010000
	ld [hl], %11110000
	ld a, [hl]
	xor b
	ret

; Main function
main::
	call init               ; Init
	ld sp, $E000            ; Init stack

	ei
	reg INTERRUPT_ENABLED, VBLANK_INTERRUPT
	jr run                  ; Run main program

; Runs the main program
run::
	ld hl, $FF42
	call drawBackground
.gameLoop:
	halt
	dec [hl]
	jr .gameLoop

include "src/init.asm"
include "src/fatal_error.asm"
include "src/utils.asm"
include "src/sgb_utils.asm"
include "src/interrupts.asm"