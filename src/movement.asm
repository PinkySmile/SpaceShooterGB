
; Read one imput and move the player acordingly.
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
move::
	call getKeys
	push af
	and %00000001
	jr z, .right
	pop af
	and %00000010
	jr z, .left
	ret
.right:
	ld a, [PLAYER_X]
	inc a
	ld [PLAYER_X], a
	pop af
	ret
.left:
	ld a, [PLAYER_X]
	dec a
	ld [PLAYER_X], a
	ret