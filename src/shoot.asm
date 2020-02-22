deleteLaser::
	push hl

	ld b, 0
	ld c, 2
	ld d, h
	ld e, l
	add hl, bc
	ld a,[NB_SHOOTS]
	ld c, a
	rl c
	dec a
	ld [NB_SHOOTS],a
	call copyMemory

	pop hl
	dec hl
	dec hl
	ret

updateLasers::
	ld a,[NB_SHOOTS]
	or a
	ret z

	ld hl, (OAM_SRC_START << 8) + SPRITE_SIZE * 2
	ld d, h
	ld e, l
	ld b, 0
	ld c, a
	rl c
	call fillMemory

	ld de, SHOOTS_PTR
.loop:
	push af
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