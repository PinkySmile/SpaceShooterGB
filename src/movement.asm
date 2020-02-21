
; Read one imput and move the player acordingly.
; Params:
;    None
; Return:
;    None
; Registers:
;	 af -> Not preserved
;    hl -> Not preserved
move::
	call getKeys
	bit 0, a
	call z, .right
	bit 1, a
	call z, .left
	reg OAM_SRC_START + SPRITE_POSITION_X, [PLAYER1_STRUCT + PLAYER_STRUCT_X]
	reg OAM_SRC_START + SPRITE_POSITION_Y, [PLAYER1_STRUCT + PLAYER_STRUCT_Y]
	reg OAM_SRC_START + SPRITE_TILE_NBR, $0
	reg OAM_SRC_START + SPRITE_ATTRIBUTE_FLAGS, %000000

	reg OAM_SRC_START + SPRITE_SIZE + SPRITE_POSITION_X, [PLAYER1_STRUCT + PLAYER_STRUCT_X]
	reg OAM_SRC_START + SPRITE_SIZE + SPRITE_POSITION_Y, [PLAYER1_STRUCT + PLAYER_STRUCT_Y]
	reg OAM_SRC_START + SPRITE_SIZE + SPRITE_TILE_NBR, $1
	reg OAM_SRC_START + SPRITE_SIZE + SPRITE_ATTRIBUTE_FLAGS, %000000
	ret

.right::
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_X
	inc [hl]
	ret

.left::
	ld hl, PLAYER1_STRUCT + PLAYER_STRUCT_X
	dec [hl]
	ret