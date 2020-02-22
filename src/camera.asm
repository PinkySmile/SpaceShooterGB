; Locks the CPU
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    hl -> Not preserved
cameraFollowPlayer::
	; X position of the player 1 camera related
	ld a, [OAM_SRC_START << 8 + 1]
	ld hl, $FF43

	ld hl, CAMERA_SHOULD_MOVE_LEFT
	bit 0, [hl]
	jr z, .moveCamLeft
	; Set to the register if the camera should move to the left (0 enabled, 1 disabled)
	ld b, $20
	cp b
	ld [hl], 1
	jr c, .negLeft
	jr .endLeft
.negLeft:
	ld [hl], 0
	jr .endLeft
.stopMovingLeft:
	ld hl, CAMERA_SHOULD_MOVE_LEFT
	ld [hl], 1
	jr .endLeft
.moveCamLeft:
	ld hl, $FF43
	cp [hl]
	jr z, .stopMovingLeft; If the camera is already at the player's position, stop moving the camera
	dec [hl]
.endLeft:

	ld hl, CAMERA_SHOULD_MOVE_RIGHT
	bit 0, [hl]
	jr z, .moveCamRight
	; Set to the register if the camera should move to the right (0 enabled, 1 disabled)
	ld b, $80
	cp b
	ld [hl], 1
	jr nc, .negRight
	jr .endRight
.negRight:
	ld [hl], 0
	jr .endRight
.stopMovingRight:
	ld hl, CAMERA_SHOULD_MOVE_RIGHT
	ld [hl], 1
	jr .endRight
.moveCamRight:
	ld hl, $FF43
	cp [hl]
	jr z, .stopMovingRight; If the camera is already at the player's position, stop moving the camera
	inc [hl]
.endRight:
	ret
