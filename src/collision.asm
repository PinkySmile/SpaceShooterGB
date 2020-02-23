; Collision between spaceship and asteroid
; Params:
;	None
; Return:
;	None
; Registers:
;	N/A
checkCollisionSpaceshipAsteroid::
	ld hl, OBSTACLES_ADDR + 1
.loop:
	ld a, [hli]
	ld b, a
	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_Y_OFF]
	; check if it overflows
	cp $8
	call c, setPosMinY

	sub $8
	cp b ; check if the top point
	call c, checkAxisY

	ld a, l
	cp $88
	jr nz, .loop
	ret

checkAxisY::
	add $16
	cp b
	call nc, checkAxisX
	call z, checkAxisX
	ret

debug::
	ld b, b
	ret

checkAxisX::
	ld a, [hl]
	ld b, a
	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF]
	add $8
	cp b
	ret c
	; check if it overflows
	cp $16
	call c, setPosMinX

	sub $16
	cp b
	call c, go
	ret

setPosMinY::
	ld a, $8
	ret

setPosMinX::
	ld a, $16
	ret

; When the spaceship is hitted
; Params:
;	None
; Return:
;	None
; Registers:
;	N/A
gameOver::
	db "GAME  OVER"
gameOverEnd::
retry::
	db "START  RETRY"
retryEnd::

menu::
	db "SELECT MENU"
menuEnd::

go::
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

	ld hl, gameOver
	ld bc, gameOverEnd - gameOver
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

