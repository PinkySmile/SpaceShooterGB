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

gameMelody::
;patt1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $73, $86, QUAVER ;MI 1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $73, $86, QUAVER ;MI 1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt2
	db $80, $84, $B2, $86, QUAVER * 2 ;SOL 1
	db $80, $84, $8A, $86, QUAVER ;FA 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $EF, $85, QUAVER * 2 ;SI 0
	db $80, $84, $63, $85, QUAVER ;SOL 0
	db $80, $84, $17, $84, QUAVER ;DO 0
	db $80, $84, $13, $85, QUAVER * 2 ;FA 0
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt2
	db $80, $84, $B2, $86, QUAVER * 2 ;SOL 1
	db $80, $84, $8A, $86, QUAVER ;FA 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $EF, $85, QUAVER * 2 ;SI 0
	db $80, $84, $63, $85, QUAVER ;SOL 0
	db $80, $84, $17, $84, QUAVER ;DO 0
	db $80, $84, $13, $85, QUAVER * 2 ;FA 0
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $73, $86, QUAVER ;MI 1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $73, $86, QUAVER ;MI 1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt4
	db $80, $84, $05, $87, QUAVER * 2 ;DO 2
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $F7, $86, QUAVER ;SI 1
	db $80, $84, $B2, $86, QUAVER * 2 ;SOL 1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $84, $B2, $86, QUAVER * 2 ;SOL 1
	db $80, $84, $F7, $86, QUAVER ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $05, $87, QUAVER * 2 ;DO 2
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt3
	db $80, $84, $63, $85, QUAVER * 2 ;SOL 0
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $EF, $85, QUAVER * 2 ;SI 0
	db $80, $84, $8A, $86, QUAVER * 2 ;FA 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $84, $05, $87, QUAVER * 2 ;DO 2
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $73, $86, QUAVER ;MI 1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $73, $86, QUAVER ;MI 1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt2
	db $80, $84, $B2, $86, QUAVER * 2 ;SOL 1
	db $80, $84, $8A, $86, QUAVER ;FA 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $EF, $85, QUAVER * 2 ;SI 0
	db $80, $84, $63, $85, QUAVER ;SOL 0
	db $80, $84, $17, $84, QUAVER ;DO 0
	db $80, $84, $13, $85, QUAVER * 2 ;FA 0
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt2
	db $80, $84, $B2, $86, QUAVER * 2 ;SOL 1
	db $80, $84, $8A, $86, QUAVER ;FA 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $EF, $85, QUAVER * 2 ;SI 0
	db $80, $84, $63, $85, QUAVER ;SOL 0
	db $80, $84, $17, $84, QUAVER ;DO 0
	db $80, $84, $13, $85, QUAVER * 2 ;FA 0
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt5
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $73, $86, QUAVER ;MI 1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt5
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $63, $85, QUAVER ;SOL 0
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $73, $86, QUAVER ;MI 1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt6
	db $80, $84, $05, $87, QUAVER * 2 ;DO 2
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $F7, $86, QUAVER ;SI 1
	db $80, $84, $B2, $86, QUAVER * 2 ;SOL 1
	db $80, $84, $05, $87, QUAVER ;DO 2
	db $80, $84, $F7, $86, QUAVER ;SI 1
	db $80, $84, $B2, $86, QUAVER * 2 ;SOL 1
	db $80, $84, $F7, $86, QUAVER ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $05, $87, QUAVER * 2 ;DO 2
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt7
	db $80, $84, $63, $85, QUAVER ;SOL 0
	db $80, $84, $13, $85, QUAVER ;FA 0
	db $80, $84, $E6, $84, QUAVER ;MI 0
	db $80, $84, $13, $85, QUAVER ;FA 0
	db $80, $84, $63, $85, QUAVER ;SOL 0
	db $80, $84, $EF, $85, QUAVER ;SI 0
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $73, $86, QUAVER ;MI 1
	db $80, $84, $B2, $86, QUAVER * 2 ;SOL 1
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $84, $05, $87, QUAVER * 2 ;DO 2
	db $80, $04, $F7, $86, QUAVER * 2 ; NO SOUND
;patt8
	db $80, $84, $F7, $86, QUAVER ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $8A, $86, QUAVER ;FA 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $8A, $86, QUAVER * 2 ;FA 1
	db $80, $84, $F7, $86, QUAVER ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $8A, $86, QUAVER ;FA 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $8A, $86, QUAVER * 2 ;FA 1
	db $80, $04, $F7, $86, QUAVER * 4 ; NO SOUND
;patt8
	db $80, $84, $F7, $86, QUAVER ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $8A, $86, QUAVER ;FA 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $8A, $86, QUAVER * 2 ;FA 1
	db $80, $84, $F7, $86, QUAVER ;SI 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $8A, $86, QUAVER ;FA 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $8A, $86, QUAVER * 2 ;FA 1
	db $80, $04, $F7, $86, QUAVER * 4 ; NO SOUND
;patt9
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $8A, $86, QUAVER ;FA 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $8A, $86, QUAVER * 2 ;FA 1
	db $80, $84, $0C, $86, QUAVER ;DO 1
	db $80, $84, $B2, $86, QUAVER ;SOL 1
	db $80, $84, $8A, $86, QUAVER ;FA 1
	db $80, $84, $0C, $86, QUAVER ;D0 1
	db $80, $84, $63, $85, QUAVER * 2 ;SOL 0
	db $80, $04, $F7, $86, QUAVER * 4 ; NO SOUND
;patt10
	db $80, $84, $39, $87, QUAVER * 2 ;MI 2
	db $80, $84, $05, $87, QUAVER * 2 ;DO 2
	db $80, $84, $F7, $86, QUAVER * 2 ;SI 1
	db $80, $84, $B2, $86, QUAVER * 2 ;SOL 1
	db $80, $84, $8A, $86, QUAVER * 2 ;FA 1
	db $80, $84, $73, $86, QUAVER * 2 ;MI 1
	db $80, $84, $0C, $86, QUAVER * 2 ;DO 1
	db $80, $84, $EF, $85, QUAVER * 2 ;SI 0
	db $80, $04, $F7, $86, $FF ;Loop

gameBass::
;patt1
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 6;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2;NO SOUND
;patt1
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 6;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2;NO SOUND
;patt2
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $00, $20, $80, QUAVER * 4 ;NO SOUND B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
;patt2
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $00, $20, $80, QUAVER * 4 ;NO SOUND B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
;patt1
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 6;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2;NO SOUND
;patt1
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 6;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2;NO SOUND
;patt4
    db $80, $00, $40, $20, $80, QUAVER * 2 ;DO B
    db $80, $00, $00, $D5, $81, QUAVER * 2 ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
;patt3
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
;patt5
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $C7, $82, QUAVER ;SOL B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND

;patt5
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $C7, $82, QUAVER ;SOL B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND

;patt8
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $C7, $82, QUAVER ;SOL B
    db $80, $00, $00, $20, $80, QUAVER * 5 ;NO SOUND
    db $80, $00, $40, $C7, $82, QUAVER ;SOL B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $C7, $82, QUAVER ;SOL B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND

;patt8
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $C7, $82, QUAVER ;SOL B
    db $80, $00, $00, $20, $80, QUAVER * 5 ;NO SOUND
    db $80, $00, $40, $C7, $82, QUAVER ;SOL B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $C7, $82, QUAVER ;SOL B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
;patt5
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $C7, $82, QUAVER ;SOL B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND

;patt5
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $C7, $82, QUAVER ;SOL B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND

;patt4
    db $80, $00, $40, $20, $80, QUAVER * 2 ;DO B
    db $80, $00, $00, $D5, $81, QUAVER * 2 ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
;patt3
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $D5, $81, QUAVER ;NO SOUND B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
;patt6
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
;patt6
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
;patt7
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER * 2 ;NO SOUND
    db $80, $00, $40, $D5, $81, QUAVER ;MI B
    db $80, $00, $40, $20, $80, QUAVER ;DO B
    db $80, $00, $00, $20, $80, QUAVER ;NO SOUND
;patt0
    db $80, $00, $00, $20, $80, QUAVER * 8 ;NOSOUND
    db $80, $00, $00, $20, $80, QUAVER * 8 ;NOSOUND
    db $80, $00, $00, $20, $80, $FF ; LOOP
