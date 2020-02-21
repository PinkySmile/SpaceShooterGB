
; Read one imput and move the player acordingly.
; Params:
;    None
; Return:
;    None
; Registers:
;    hl -> Not preserved
move::
	call getKeys
	bit 0, a
	call z, .right
	bit 1, a
	call z, .left
	ret

.right::
	ld hl, PLAYER_X
	inc [hl]
	ret

.left::
	ld hl, PLAYER_X
	dec [hl]
	ret