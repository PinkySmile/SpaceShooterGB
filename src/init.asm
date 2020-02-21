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

	ld bc, initDMA_end - initDMA
	ld de, $FF80
	ld hl, initDMA
	call copyMemory

	call loadSprites
	call drawBackground

	reg LCD_CONTROL, LCD_BASE_CONTROL
	ret

updateRegisters::
	xor a
        ld hl, SHOOT_COOLDOWN
        or [hl]
        jr z, .skip
        dec [hl]
.skip:
	ret