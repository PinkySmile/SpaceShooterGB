; Collision between spaceship and asteroid
; Params:
;	None
; Return:
;	None
; Registers:
;	N/A
checkCollisionSpaceshipAsteroid::
	ld de, OBSTACLES_ADDR + 1
	ld a, [NB_OBSTACLES]
.loop:
	push af
	ld a, [de]
	inc de
	inc a
	inc a
	ld b, a
	add a, $C
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_Y_OFF
	cp [hl]
	jr c, .noCollide

	ld a, [de]
	inc a
	inc a
	ld c, a
	add a, $C
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF
	cp [hl]
	jr c, .noCollide

	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_Y_OFF]
	add a, PLAYER_SIZE_X
	cp b
	jr c, .noCollide

	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF]
	add a, PLAYER_SIZE_Y
	cp c
	jr c, .noCollide

	jp gameOver
.noCollide:
	inc de
	inc de
	inc de
	pop af
	dec a
	jr nz, .loop
	ret

; When the spaceship is hitted
; Params:
;	None
; Return:
;	None
; Registers:
;	N/A
gameOver::
	reset CHANNEL3_ON_OFF
	reset CHANNEL2_VOLUME
	ld hl, destruction
	call playNoiseSound

	; tp camera to 0, 0
	call waitVBLANK
	xor a
	ld [$FF42], a
	ld [$FF43], a

	reset LCD_CONTROL
	reg BGP, %11011000
	ld de, $9800
	ld bc, $800
	ld a, 1
	call fillMemory

	ld hl, gameOverText
	ld bc, gameOverTextEnd - gameOverText
	ld de, $9925
	call copyMemory

	ld hl, retry
	ld bc, retryEnd - retry
	ld de, $9984
	call copyMemory

	ld hl, menu
	ld bc, menuEnd - menu
	ld de, $99C4
	call copyMemory

	reg LCD_CONTROL, LCD_BASE_CONTROL

	ld hl, gameOverSFX
	call playSound
.loop:
	call updateScore
	call updateSound
	reset INTERRUPT_REQUEST
	halt
	xor a
	call getKeys
	bit 7, a
	jr z, .continue
	bit 6, a
	jr nz, .loop
 	jp mainMenu
.continue:
	jp run

