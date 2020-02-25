; VBLANK interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
vblank_interrupt::
	push af
	push hl
	xor a
	ld hl, FRAME_COUNTER
	or [hl]
	jr z, .skip
	dec [hl]
.skip:
	ld a, OAM_SRC_START
	call DMA
	pop hl
	pop af
	reti

; HBLANK interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
hblank_interrupt::
	push hl
	push af
	ld a, 1
	ld hl, CREDITS_SLIDING
	xor [hl]
	ld [hl], a
	bit 0, a
	jr z, .reset

	ld a, [CREDITS_LINE_POS]
	ld [SCROLL_X], a
	ld hl, LYC
	ld a, [hl]
	add $9
	ld [hl], a
	jr .end
.reset:
	reset SCROLL_X
	ld hl, LYC
	ld a, [hl]
	sub $9
	ld [hl], a

.end:
	pop af
	pop hl
	reti

; Timer interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
timer_interrupt::
	reti

; Serial interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
serial_interrupt::
	reti

; Joypad interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
joypad_interrupt::
	reti
