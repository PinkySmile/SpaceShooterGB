; Draw the background
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
drawBackground::
	ld d, 20
	ld e, 32
	ld bc, $20 - 20
	ld hl, VRAM_BG_START
.loop:
	call random
	and $F

	jr z, .skip
	ld a, 1
.skip:
	ld [hli], a
	dec d
	jr nz, .loop
	dec e
	ld d, 20
	add hl, bc
	jr nz, .loop
	ret

; Load all sprites and put thems inside the VRam
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
loadSprites::
	; Load background into VRAM
	ld hl, background
	ld bc, backgroundEnd - background
	ld de, VRAM_START
	call uncompress

	; Load space ship into VRAM
	ld hl, spaceship
	ld bc, spaceshipEnd - spaceship
	call copyMemory
