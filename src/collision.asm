; Collision between spaceship and asteroid
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
checkCollisionSpaceshipAsteroid::
	ld hl, OBSTACLES_ADDR + 1

.loop:
	ld a, [hli]
	ld b, a
	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_Y_OFF]
	sub $B
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
	ret

checkAxisX::
	ld a, [hl]
	ld b, a
	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF]
	add $B
	cp b
	ret c
	sub $16
	cp b
	call c, go
	ret



; When the spaceship is hitted
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
go::
	; spaceship's pos is set to 0, 0 when hitted
	jp mainMenu

