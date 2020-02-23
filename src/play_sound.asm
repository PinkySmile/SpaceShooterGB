;laser sound sfx
;Channel1
laser::
	db $1F, $CF, $85, $D0, $87

;Channel4
destruction::
	db $00, $D5, $70, $80

;GO SFX Channel2
gameOverSFX::
    db $80, $C0, $0C, $86, QUAVER * 4; DO 1
    db $80, $C0, $EF, $85, QUAVER * 4; SI 0
    db $80, $C0, $CD, $85, QUAVER * 4; LA# 0
    db $80, $C0, $AC, $85, QUAVER * 8; LA 0
    db $80, $00, $AC, $85, $00; LA 0

wpRamWave::
    db $FF, $88, $00, $88, $FF, $88, $00, $88, $FF, $88, $00, $88, $FF, $88, $00, $88


initWPRAM::
    ld hl, wpRamWave
    ld de, WPRAM
    ld bc, 16
    call copyMemory

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
	ld [MUSIC_START_PTR_H], a
	ld a, l
	ld [MUSIC_PTR_L], a
	ld [MUSIC_START_PTR_L], a
	ld a, 1
	ld [MUSIC_TIMER], a
	ret

updateSound2::
	xor a
	ld hl, MUSIC_2_TIMER
	or [hl]
	jr z, .skip
	dec [hl]
	jr nz, .skip
	ld a, [MUSIC_2_PTR_H]
	ld h, a
	ld a, [MUSIC_2_PTR_L]
	ld l, a
	call playChannelWave
	ld a, [hli]
	cp a, $FF
	jr z, .reset
	ld [MUSIC_2_TIMER], a
	ld a, h
	ld [MUSIC_2_PTR_H], a
	ld a, l
	ld [MUSIC_2_PTR_L], a
	ret
.reset:
	reg MUSIC_2_PTR_H, [MUSIC_2_START_PTR_H]
	reg MUSIC_2_PTR_L, [MUSIC_2_START_PTR_L]
	reg MUSIC_2_TIMER, QUAVER
.skip:
	ret

playSound2::
	ld a, h
	ld [MUSIC_2_PTR_H], a
	ld [MUSIC_2_START_PTR_H], a
	ld a, l
	ld [MUSIC_2_PTR_L], a
	ld [MUSIC_2_START_PTR_L], a
	ld a, 1
	ld [MUSIC_2_TIMER], a
	ret