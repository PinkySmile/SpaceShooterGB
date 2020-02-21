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
	pop af
	ret

; Setups the GBC palette data
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Not preserved
setupGBCPalette::
	ld a, $86;
	ld hl, BGPI
	ld [hli], a
	xor a
	ld [hl], a
	ld [hl], a
	ret