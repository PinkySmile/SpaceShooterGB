; Initialize the HRam ($FF80) to use DMA.
; Params:
;    a The start address divided by $100.
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
initDMA::
	ld [START_DMA], a
	ld a, DMA_DELAY
.wait:
	dec a
	jr nz, .wait
	ret
initDMA_end:

; Enable interupts and init RAM
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
init::
	reg INTERRUPT_ENABLED, VBLANK_INTERRUPT

	call waitVBLANK

	reset LCD_CONTROL

	xor a
	ld bc, $2000
	ld de, $C000
	call fillMemory

	ld hl, $FF24
	ld a, $77
	ld [hli], a
	ld a, $FF
	ld [hli], a

	ld bc, initDMA_end - initDMA
	ld de, $FF80
	ld hl, initDMA
	call copyMemory

	reg OBP0, SPACESHIP_PALETTE
	reg OBP1, ENNEMIES_PALETTE

	reg WY, $88
	reg WX, $80

	call loadSprites
	call DMA
	call initWPRAM

	ret

updateRegisters::
	xor a
	ld hl, SHOOT_COOLDOWN
	or [hl]
	jr z, .skip
	dec [hl]
.skip:
	ret