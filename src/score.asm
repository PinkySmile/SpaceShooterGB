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
	ld a, [hld]
	call writeNumber
	ret