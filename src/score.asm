; PARAM: de the number to add
addScore::
	ld hl, SCORE_REGISTER
	ld a, e
	add a, [hl]
	daa
	ld [hli], a
	ld a, d
	adc a, [hl]
	daa
	ldi [hl], a
	xor a
	adc a, [hl]
	daa
	ld [hl], a
	ret

updateScore::
	ld hl, SCORE_REGISTER + 2
	ld a, [hld]
	ld de, $9C00
	call writeNumber
	ld a, [hld]
	call writeNumber
	ld a, [hl]
	call writeNumber

	ld a, $20
	cp [hl]
	jr nc, .bossDisabled
	reg DISABLE_BOSS, 0

.bossDisabled:
	ld a, [DISABLE_BOSS]
	or a
	ret nz
	; spawn the boss if the score is a multiple of 500 and the boss has not spawned yet
	ld a, [BOSS_STATUS]
	or a
	ret nz

	;ld b,b
	ld a, [hl]
	and %11110000
	ret nz
	inc hl

	call spawnBoss
	ret