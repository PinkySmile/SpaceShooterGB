makeEpitechBackground::
	ld de, $9800
	ld a, $0C
	ld bc, $800
	call fillMemory

	ld a, $80
	ld e, 4
	ld hl, $9883
.loop:
	ld d, 13
.loop2:
	ld [hli], a
	inc a
	dec d
	jr nz, .loop2
	inc a
	ld bc, $20 - 13
	dec e
	add hl, bc
	jr nz, .loop

	ld hl, $9C00
	ld a, $8D
	ld d, 4
	ld bc, $20
.loop3:
	ld [hl], a
	add a, $E
	add hl, bc
	dec d
	jr nz, .loop3
	ret

initPlayer::
	ld hl, OAM_SRC_START << 8

	reg PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF, $24
	reg PLAYER1_STRUCT + PLAYER_STRUCT_Y_OFF, $F0

	call updatePlayer
	ret

movePlayer::
	ld a, $68
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_Y_OFF
	cp [hl]
	jr nz, .up

	xor a
	ld hl, SHOOT_COOLDOWN
	or [hl]
	jr nz, .right

	ld hl, INTRO_COUNTER
	ld a, $FC
	cp [hl]
	jr z, .right

.shoot:
	ld hl, laser
	call playChannel1Sound
	call shoot
	ld hl, SHOOT_COOLDOWN
	ld [hl], $20
	ld hl, INTRO_COUNTER
	dec [hl]

.right:
	ld hl, SHOOT_COOLDOWN
	dec [hl]
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF
	inc [hl]
	jr .end

.up:
	dec [hl]
.end:
	call updatePlayer
	call updateLasers
	call checkLaser
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF
	ld a, $A0
	cp [hl]
	ret nz
	ld hl, INTRO_COUNTER
	dec [hl]
	ret

checkLaser::
	ld a,[NB_SHOOTS]
	or a
	ret z
	ld de, SHOOTS_PTR
	push af
.loop:
	inc de
	ld a, [de]

	cp a, $50
	jr nc, .skip
	ld hl, SHOOTS_PTR
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld hl, (OAM_SRC_START << 8) + SPRITE_SIZE * 16
	ld a, [INTRO_COUNTER]
	inc a
	cpl
	ccf
	rla
	rla
	rla
	push bc
	ld b, 0
	ld c, a
	add hl, bc
	pop bc

	ld a, c
	add $10
	ld [hli], a
	ld a, b
	add $8
	ld [hli], a
	ld a, [INTRO_COUNTER]
	inc a
	cpl
	ccf
	rla
	rla
	add $B6
	ld [hli], a
	xor a
	ld [hli], a

	ld a, c
	add $10
	ld [hli], a
	ld a, b
	add $10
	ld [hli], a
	ld a, [INTRO_COUNTER]
	inc a
	cpl
	ccf
	rla
	rla
	add $B8
	ld [hli], a
	xor a
	ld [hli], a

	call deleteLaser
.skip:
	inc de
	pop af
	dec a
	jr nz, .loop
	ret

moveBoss::
	ld a, $10
	ld hl, BOSS_STRUCT + PLAYER_STRUCT_Y_OFF
	cp [hl]
	jr nz, .down
	jr .skip
.down:
	inc [hl]
.skip:
	dec hl
	inc [hl]
	ld a, [hl]
	cp $20
	jr z, .explode
	cp $40
	jr z, .explode2
	cp $60
	jr z, .explode
	cp $70
	jr z, .explode
	cp $80
	jr z, .explode2
	cp $98
	jr z, .explode
	cp $A0
	jr z, .finalExplode
	jr nc, .fade
	reg BGP, %00011011
	jr .end
.finalExplode:
	ld hl, BGP
	add 0
	rr [hl]
	add 0
	rr [hl]
	ld hl, destructionOn
	call playNoiseSound
	jr .end
.explode2:
	ld hl, meteorDestruction
	jr .exp
.explode:
	ld hl, destruction
.exp:
	reg BGP, %00000000
	call playNoiseSound
	jr .end
.fade:
	ld hl, INTRO_COUNTER
	dec [hl]
	ld a, [hl]
	and a, $F
	jr nz, .end

	ld hl, BGP
	add 0
	rr [hl]
	add 0
	rr [hl]

.end:
	call updateBoss
	ret

initBoss::
	ld hl, BOSS_STRUCT
	ld a, $0
	ld [hli], a
	ld a, $D8
	ld [hli], a
	call updateBoss
	ret

intro::
	ei
	reg BGP, %00101011
	reg INTRO_COUNTER, $FF
	call initPlayer
	call initBoss
	call makeEpitechBackground
	reg WX, $5C
	reg WY, $20
	reg SCROLL_X, $D5
	reg LCD_CONTROL, LCD_BASE_CONTROL
	ld a, $40
	call waitFrames
	xor a
.start:
	ld hl, WX
	inc [hl]
	ld hl, SCROLL_X
	inc [hl]
	reset INTERRUPT_REQUEST
	halt
	or [hl]
	jr nz, .start

	ld a, $10
	call waitFrames

	ld hl, nantes
	ld bc, nantesEnd - nantes
	ld de, $9907
	call copyMemory

	ld a, $8
	call waitFrames

	reg BGP, %00011011
	ld a, $4
	call waitFrames
	reg BGP, %00001011
	ld a, $10
	call waitFrames
	reg BGP, %00011011
.loop:
	reset INTERRUPT_REQUEST
	ld a, [INTRO_COUNTER]

	push af
	cp $FC
	jr nc, .move

	cp $D0
	jr nc, .moveBoss

	cp $B0
	jr nc, .dec
	xor a
	ld [INTRO_COUNTER], a
	jr .skip
.dec:
	ld hl, INTRO_COUNTER
	dec [hl]
	jr .skip
.moveBoss:
	call moveBoss
	jr .skip
.move:
	call movePlayer
.skip:
	halt
	pop af
	or a
	jr nz, .loop

	call waitVBLANK
	reset LCD_CONTROL
	call loadSprites
	xor a
	ld hl, textAssets + 32 * 8
	ld bc, textAssetsEnd - (textAssets + 32 * 8)
	ld de, VRAM_START + 32 * 16
	call uncompress
	reg LCD_CONTROL, LCD_BASE_CONTROL
	di
	ld hl, bam
	call playNoiseSound
	jp mainMenu
