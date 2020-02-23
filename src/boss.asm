spawnBoss:
	reg BOSS_STATUS, 1
	ld hl, BOSS_STRUCT
	ld a, $3C
	ld [hli], a
	xor a
	ld [hli], a
	ld a, $20
	ld [hli], a

	ld hl, bossJingleBass
	call playSound2

	ld hl, MUSIC_2_START_PTR_H
	ld a, bossBass >> 8
	ld [hli], a
	ld a, bossBass & $FF
	ld [hl], a

	ld hl, bossJingleMelody
	call playSound

	ld hl, MUSIC_START_PTR_H
	ld a, bossMelody >> 8
	ld [hli], a
	ld a, bossMelody & $FF
	ld [hl], a
	ret

bossAttack::
	ld a, [BOSS_STATUS]
	or a
	ret z

	push af
	ld a, [BOSS_DEATH_COUNTER]
	or a
	jr z, .skip
	dec a
	ld [BOSS_DEATH_COUNTER], a
.skip:
	ld a, [BGP]
	bit 0, a
	jr z, .normalPalette
	reset BGP
	jr .endChangePalette
.normalPalette:
	reg BGP, %11011000
.endChangePalette:

	pop af
	cp $1
	jr z, .moveLeft
	cp $2
	jr z, .moveRight
	cp $3
	jr z, .moveCenter
	cp $4
	jr z, .waitToBackUp
	cp $5
	jr z, .moveDown
	cp $6
	jr z, .moveBackUp
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
	; time before the spaceships goes down
	ld a, $1E
	ld [$C210], a
.waitToBackUp:
	ld hl, $C210
	xor a
	dec [hl]
	jr nz, .end
	reg BOSS_STATUS, 5
.moveDown:
	ld hl, BOSS_STRUCT + PLAYER_STRUCT_Y_OFF
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	ld a, $F0
	cp [hl]
	jp nz, .end
	reg BOSS_STATUS, 6
	ld a, $EE
	ld [BOSS_STRUCT + PLAYER_STRUCT_Y_OFF], a
.moveBackUp:
	ld a, [OBP1]
	bit 0, a
	jr z, .normalPalette2
	reset OBP1
	jr .endChangePalette2
.normalPalette2:
	reg OBP1, ENNEMIES_PALETTE
.endChangePalette2:
	ld hl, BOSS_STRUCT + PLAYER_STRUCT_Y_OFF
	xor a
	dec [hl]
	cp [hl]
	jp nz, .end
	reg BOSS_STATUS, 1
.end:
	call updateBoss

	ld a, [BOSS_STATUS]
	bit 2, a
	ret nz
	ld hl, BOSS_NEXT_ATTACK
	dec [hl]
	jp nz, .ret

	ld [hl], $25
	ld a, [BOSS_STRUCT + PLAYER_STRUCT_Y_OFF]
	ld b, a
	ld a, [BOSS_STRUCT + PLAYER_STRUCT_X_OFF]
	ld c, a
	call createObstacle
.ret:
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

checkCollisionSpaceshipBoss::
	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF]
	ld b, a
	add a, PLAYER_SIZE_X
	ld hl, BOSS_STRUCT + PLAYER_STRUCT_X_OFF
	cp [hl]
	ret c

	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_Y_OFF]
	ld c, a
	add a, PLAYER_SIZE_Y
	ld hl, BOSS_STRUCT + PLAYER_STRUCT_Y_OFF
	cp [hl]
	ret c

	ld a, [BOSS_STRUCT + PLAYER_STRUCT_X_OFF]
	add a, BOSS_SIZE_X
	cp b
	ret c

	ld a, [BOSS_STRUCT + PLAYER_STRUCT_Y_OFF]
	add a, BOSS_SIZE_Y
	cp c
	ret c

	ld sp, $E000
	jp gameOver

killBoss::
	reg OBP1, ENNEMIES_PALETTE
	ld hl, gameMelody
	call playSound
	ld hl, gameBass
	call playSound2
	ld de, $100
	call addScore
	ld hl, destruction
	call playNoiseSound
	reg BOSS_DEATH_COUNTER, $6
	reg ASTEROID_SPAWN_IN, $20
	reset BOSS_STATUS
	ret