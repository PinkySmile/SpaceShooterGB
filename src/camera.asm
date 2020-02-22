; Locks the CPU
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    hl -> Not preserved
cameraFollowPlayer:
	ld a, [PLAYER1_STRUCT + PLAYER_STRUCT_X_OFF]
	ld hl, $FF43
	sub [hl]
	;COMPARE HERE AND DEC OR INC THE CAMERA POSITION.
	ret