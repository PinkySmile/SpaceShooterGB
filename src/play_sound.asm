;laser sound sfx
laser::
    db $1F, $CF, $85, $D0, $87

destruction::
    db $00, $D5, $70, $80

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