deleteLaser::
	push hl
	push de

	ld a,[NB_SHOOTS]
	dec a
	ld [NB_SHOOTS],a

	ld h, d
	ld l, e

	add a, e
	sub SHOOTS_PTR & $FF
	rla

	ld b, 0
	ld c, a

	inc hl
	dec de

	call copyMemory

	pop de
	pop hl
	dec de
	dec de
	ret

; Collision between spaceship and asteroid
; Params:
;    de -> The address of the laser struct
; Return:
;    None
; Registers:
;    hl -> Preserved
;	 de -> Preserved
checkCollisionsWithLasers::
	push hl
	ld hl, OBSTACLES_ADDR
.loop:
	inc hl

	inc de
	ld a, [de]
	cp [hl]
	call c, laserCollideY

	inc hl
	inc hl
	dec de

	ld a, l
	cp $88
	jr nz, .loop

	pop hl
	ret

laserCollideY::
	inc hl
	add $16
	cp b
	call nc, laserCollideX
	ret

laserCollideX::
	dec de
	ld a, [de]
	add $10
	inc de
	cp [hl]
	ret c
	sub $20
	cp [hl]
	call c, go
	ret

updateLasers::
	xor a
	ld hl, (OAM_SRC_START << 8) + SPRITE_SIZE * 2
	ld d, h
	ld e, l
	ld bc, 40
	call fillMemory

	ld a,[NB_SHOOTS]
	or a
	ret z
	ld de, SHOOTS_PTR
.loop:
	push af
	call checkCollisionsWithLasers

	inc de
	ld a, [de]
	add a, $10
	ld [hli], a

	dec de
	ld a, [de]
	add a, $8
	ld [hli], a

	ld a, $6
	ld [hli], a

	ld a, $0
	ld [hli], a

	inc de
	ld a, [de]
	sub a, 4
	ld [de], a

	cp a, $EE
	jr nc, .skip
	cp a, $90
	jr c, .skip
	call deleteLaser
.skip:
	inc de
	pop af
	dec a
	jr nz, .loop
	ret

shoot::
	ld a,[NB_SHOOTS]
	ld b, 0
	ld c, a
	rl c
	inc a
	ld [NB_SHOOTS], a
	ld hl, SHOOTS_PTR
	add hl, bc
	ld bc, 2
	ld d, h
	ld e, l
	ld hl, PLAYER1_STRUCT
	ld a, [hli]
	add a, 4
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ret