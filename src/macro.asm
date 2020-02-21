; Like doing ld [**], *
; VBLANK interrupt handler
; Params:
;    \1 -> Address to write to
;    \2 -> Value to write
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
reg: MACRO
	ld a, \2
	ld [\1], a
ENDM

reset: MACRO
	xor a
	ld [\1], a
ENDM