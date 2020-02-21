; Initialize the HRam ($FF80) to use DMA.
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
initDMA::
	ld [START_DMA], a
	ld a, DMA_DELAY
.wait:
	dec a
	jr nz, .wait
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
	push af
	xor a
	ld bc, $2000
	ld de, $C000
	call fillMemory
	ld bc, initDMA_end - initDMA
	ld de, $FF80
	ld hl, initDMA
	call copyMemory
	pop af
	ret