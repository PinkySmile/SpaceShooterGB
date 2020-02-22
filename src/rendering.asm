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
	ld hl, VRAM_BG_START
.loop:
	call random
	and $F

	jr z, .skip
	ld a, 1
.skip:
	ld [hli], a
	bit 5, h
	jr z, .loop
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
	; Load font into VRAM
	ld hl, textAssets
	ld bc, textAssetsEnd - textAssets
	ld de, VRAM_START
	call uncompress

	; Load background into VRAM
	ld hl, background
	ld bc, backgroundEnd - background
	ld de, VRAM_START
	call uncompress

	; Load space ship into VRAM
	ld hl, spaceship
	ld bc, spaceshipEnd - spaceship
	call copyMemory

	; Load laser into VRAM
	ld hl, laserSprite
	ld bc, laserSpriteEnd - laserSprite
	call uncompress

	; Load asteroids into VRAM
    ld hl, asteroids
    ld bc, asteroidsEnd - asteroids
    call copyMemory

	ld bc, $10
	ld a, $FF
	call fillMemory
