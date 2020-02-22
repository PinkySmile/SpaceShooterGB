;laser sound sfx
laser::
	db $1F, $CF, $85, $D0, $87

destruction::
	db $00, $D5, $70, $80

initWPRAM::
    ld hl, WPRAM
    ld c, 8
    xor a
.loop:
    dec a
    ld [hli], a
    inc a
    ld [hli], a
    dec c
    jr nz, .loop
    ret

playChannel1Sound::
	ld de, CHANNEL1_SWEEP
	ld c, 5
.loop:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

playChannel2Sound::
	ld de, CHANNEL2_LENGTH
	ld c, 4
.loop:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

playChannelWave::
	ld de, CHANNEL3_ON_OFF
	ld c, 5
.loop:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

playNoiseSound::
	ld de, CHANNEL4_LENGTH
	ld c, 4
.loop:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

updateSound::
	xor a
	ld hl, MUSIC_TIMER
	or [hl]
	jr z, .skip
	dec [hl]
	jr nz, .skip
	ld a, [MUSIC_PTR_H]
	ld h, a
	ld a, [MUSIC_PTR_L]
	ld l, a
	call playChannel2Sound
	ld a, [hli]
	cp a, $FF
	jr z, .reset
	ld [MUSIC_TIMER], a
	ld a, h
	ld [MUSIC_PTR_H], a
	ld a, l
	ld [MUSIC_PTR_L], a
	ret
.reset:
	reg MUSIC_PTR_H, [MUSIC_START_PTR_H]
	reg MUSIC_PTR_L, [MUSIC_START_PTR_L]
	reg MUSIC_TIMER, QUAVER
.skip:
	ret

playSound::
	ld a, h
	ld [MUSIC_PTR_H], a
	ld a, l
	ld [MUSIC_PTR_L], a
	ld a, 1
	ld [MUSIC_TIMER], a
	ret
