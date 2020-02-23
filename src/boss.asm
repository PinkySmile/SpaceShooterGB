spawnBoss:
	reg BOSS_STATUS, 1
	reg BOSS_STRUCT + PLAYER_STRUCT_X_OFF, $3C
	reg BOSS_STRUCT + PLAYER_STRUCT_Y_OFF, 0
	ret

bossAttack::
	;call collideWithPlayer
	;call random
	;and %00001111
	;call z, createObstacle

	call updateBoss
	ld a, [BOSS_STATUS]
	cp $1
	jr z, .moveLeft
	cp $2
	jr z, .moveRight
	cp $3
	jr z, .moveCenter
	cp $4
	jr z, .moveDown
	jr .end
.moveLeft:
	ld hl, BOSS_STRUCT + PLAYER_STRUCT_X_OFF
	dec [hl]
	xor a
	cp [hl]
	jp nz, .end
	reg BOSS_STATUS, 2
.moveRight:
	ld hl, BOSS_STRUCT + PLAYER_STRUCT_X_OFF
	inc [hl]
	ld a, $80
	cp [hl]
	jp nz, .end
	reg BOSS_STATUS, 3
.moveCenter:
	ld hl, BOSS_STRUCT + PLAYER_STRUCT_X_OFF
	dec [hl]
	ld a, $3C
	cp [hl]
	jp nz, .end
	reg BOSS_STATUS, 4
.moveDown:
	ld hl, BOSS_STRUCT + PLAYER_STRUCT_Y_OFF
	inc [hl]
	inc [hl]
	xor a
	cp [hl]
	jp nz, .end
	reg BOSS_STATUS, 1
.end:
	ret

updateBoss::
	ld hl, BOSS_ADDR

	ld a, [BOSS_STRUCT + PLAYER_STRUCT_Y_OFF]
	ld b, a
	add a, $10
	ld [hli], a
	ld a, [BOSS_STRUCT + PLAYER_STRUCT_X_OFF]
	ld c, a
	add a, $8
	ld [hli], a
	ld a, $E
	ld [hli], a
	ld a, $10
	ld [hli], a

	ld a, b
	add a, $10
	ld [hli], a
	ld a, c
	add a, $10
	ld [hli], a
	ld a, $10
	ld [hli], a
	ld a, $10
	ld [hli], a

	ld a, b
	add a, $10
	ld [hli], a
	ld a, c
	add a, $18
	ld [hli], a
	ld a, $12
	ld [hli], a
	ld a, $10
	ld [hli], a

	ld a, b
	add a, $10
	ld [hli], a
	ld a, c
	add a, $20
	ld [hli], a
	ld a, $14
	ld [hli], a
	ld a, $10
	ld [hl], a
	ret