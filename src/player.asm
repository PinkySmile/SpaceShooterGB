updatePlayer::
	ld l, 0
	ld h, OAM_SRC_START

	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_Y_OFF]
	add a, $10
	ld [hli], a
	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF]
	add a, $8
	ld [hli], a
	ld a, $2
	ld [hli], a
	xor a
	ld [hli], a

	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_Y_OFF]
	add a, $10
	ld [hli], a
	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF]
	add a, $10
	ld [hli], a
	ld a, $3
	ld [hli], a
	xor a
	ld [hl], a
	ret

; Read input and execute the actions associated.
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Not preserved
executePlayerActions::
	call getKeys
	bit 0, a
	call z, .right
	bit 1, a
	call z, .left
	bit 2, a
	call z, .down
	bit 3, a
	call z, .up
	bit 4, a
	call z, .shoot
	bit 5, a
	call z, .shoot
	ret

.shoot::
	xor a
	ld hl, SHOOT_COOLDOWN
	or [hl]
	ret nz
	ld [hl], BASE_SHOOT_COOLDOWN
	ld hl, laser
	call playChannel1Sound
	ret

.right::
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF
	inc [hl]
	ret

.left::
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF
	dec [hl]
	ret

.up::
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_Y_OFF
	inc [hl]
	ret

.down::
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_Y_OFF
	dec [hl]
	ret