; Spawn an obstacle but not always
spawnObstacles:
	ld a,[BOSS_STATUS]
	or a
	ret nz
	ld a, [ASTEROID_SPAWN_IN]
	or a
	call z, updateSpawnTimer
	dec a
	ld [ASTEROID_SPAWN_IN], a
	ret

updateSpawnTimer::
	ld de, 1
	call addScore

	ld b, 0

	call random
	and %01111111
	add $8
	ld c, a

	call createObstacle

	call random
	and %00011111
	inc a
	ret

; Create a random obstacle
; Params:
;    b -> y position
;	 c -> x position
; Return:
;    None
; Registers:
;    N/A
createObstacle::
	ld a,[NB_OBSTACLES]
	cp 8
	ret z

	push bc
	ld b, 0
	ld c, a
	add 0
	rl c
	rl c
	inc a
	ld [NB_OBSTACLES], a
	ld hl, OBSTACLES_ADDR
	add hl, bc
	ld bc, 2

	; y speed downward
	call random
	ld b, a
	ld a, [ASTEROID_MAX_SPEED_Y]
	and b
	inc a
	ld [hli], a

	pop bc
	; y value
	ld a, b
	ld [hli], a

	; x value
	ld a, c
	ld [hli], a

	; x speed
	call random
	ld b, a
	ld a, [ASTEROID_MAX_SPEED_X]
	and b
	ld [hl], a
	ret

; Update all obstacles
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
updateObstacles::
	xor a
	ld de, (OAM_SRC_START << 8) + SPRITE_SIZE * (NB_PLAYERS + NB_LASERS_MAX)
	ld bc, SPRITE_SIZE * 28
	call fillMemory

	ld hl, OBSTACLES_ADDR
	ld de, (OAM_SRC_START << 8) + SPRITE_SIZE * (NB_PLAYERS + NB_LASERS_MAX)

	ld a, [NB_OBSTACLES]
	or a
	ret z
.loop:
	push af

	; apply the speed to y
	ld a, [hli]
	ld b, a
	ld a, [hl]
	add b
	ld [hli], a

	; y
	add $10
	ld [de], a
	inc de

	; apply the speed to x
	inc hl
	ld a, [hl]
	ld b, a
	dec hl
	ld a, [hl]
	ld c, a
	ld a, b

	cp 2

	ld b, a
	ld a, c

	jr c, .notAdd
	sub b
	sub b
.notAdd:
	add b
	ld [hl], a

	; x
	ld a, [hli]
	add a, $8
	ld [de], a
	inc de


	ld a, ASTEROID_SPRITE_INDEX
	ld [de], a
	inc de

	ld a, %00010000
	ld [de], a
	inc de

	dec hl
	dec hl
	; y
	ld a, [hli]
	add $10
	ld [de], a
	inc de

	; x 2
	ld a, [hli]
	add a, $10
	ld [de], a
	inc de

	ld a, ASTEROID_SPRITE_INDEX + 2
	ld [de], a
	inc de

	ld a, %00010000
	ld [de], a
	inc de

	; delete the asteroid if it's y pos is below C0
	dec hl
	dec hl
	ld a, [hl]
	cp $C0
	jr c, .skip
	call deleteObstacle
.skip:
	; the padding byte
	inc hl
	inc hl
	inc hl

	pop af
	dec a
	jr nz, .loop
	ret


deleteObstacle::
	push hl
	push de

	ld a,[NB_OBSTACLES]
	dec a
	ld [NB_OBSTACLES],a

	ld d, h
	ld e, l

	rla
	rla

	dec de
	add OBSTACLES_ADDR & $FF
	sub a, e
	rla
	rla

	ld b, 0
	ld c, a

	inc hl
	inc hl
	inc hl

	call copyMemory

	pop de
	pop hl
	dec hl
	dec hl
	dec hl
	dec hl
	ret
