strncpy::
	xor a
	or b
	or c
	ret z

	ld a, [hli]
	or a
	ret z

	ld [de], a
	inc de
	dec bc
	jr strncpy


credits::
	reset CREDITS_SLIDING
	call waitVBLANK

	reset LCD_CONTROL
	call updateSound
	call updateSound2

	ld de, $9800
	ld a, $1
	ld bc, $800
	call fillMemory
	call updateSound
	call updateSound2

	ld hl, creditsText
	ld bc, creditsTextEnd - creditsText
	ld de, $9800
	call copyMemory

	ld hl, creditTextArray
	ld de, $9840
	ld bc, $20
	call strncpy

	reg WY, $90
	reg WX, $7
	reg LYC, $F
	inc a
	ld [CREDITS_CURRENT_LINE], a
	reset CREDITS_SLIDING
	reg CREDITS_LAST_ADDR_H, h
	reg CREDITS_LAST_ADDR_L, l
	reg CREDITS_LINE_POS, $80

	ld hl, STAT_CONTROL
	set 6, [hl]

	ei
	reg INTERRUPT_ENABLED, LCD_STAT_INTERRUPT
	reg LCD_CONTROL, LCD_BASE_CONTROL
.loop:
	ld a, [LY]
	cp $90
	jr nz, .loop

	ld a, [CREDITS_SLIDING]
	ld hl, CREDITS_LINE_POS
	bit 1, a
	jr z, .inc

	dec [hl]
	dec [hl]
	ld a, $80
	cp [hl]
	jr nz, .skip

	jr .nextLine
.inc:
	inc [hl]
	inc [hl]
	jr nz, .skip

.nextLine:
	reg CREDITS_LINE_POS, $A0
	ld a, [CREDITS_LAST_ADDR_H]
	ld h, a
	ld a, [CREDITS_LAST_ADDR_L]
	ld l, a
	xor a
	or [hl]
	jr z, .nextText
	ld a, [LYC]
	add a, $10
	ld [LYC], a
	inc a
	ld [CREDITS_CURRENT_LINE], a
	ld e, a

	xor a
	rl e
	rla
	or a
	rl e
	rla

	add $98
	ld d, a
	ld bc, $20
	call strncpy

	ld a, h
	ld [CREDITS_LAST_ADDR_H], a
	ld a, l
	ld [CREDITS_LAST_ADDR_L], a
	jr .skip

.nextText:
	reg CREDITS_CURRENT_LINE, $10
	dec a
	ld [LYC], a

	ld hl, CREDITS_SLIDING
	ld a, %10
	xor [hl]
	ld [hl], a
	jr nz, .skip

	ld a, [CREDITS_LAST_ADDR_H]
	ld h, a
	ld a, [CREDITS_LAST_ADDR_L]
	ld l, a
	inc hl

	ld a, l
	cp a, creditTextArrayEnd & $FF
	jr nz, .ok
	ld a, h
	cp a, creditTextArrayEnd >> 8
	jr z, .mainMenu

.ok:
	ld de, $9840
	ld bc, $20
	call strncpy

	ld a, h
	ld [CREDITS_LAST_ADDR_H], a
	ld a, l
	ld [CREDITS_LAST_ADDR_L], a

.skip:
	call updateSound
	call updateSound2
	call getKeys
	xor $FF
	jr nz, .mainMenu
	jp .loop
.mainMenu:
	ld hl, STAT_CONTROL
	res 6, [hl]
	reg INTERRUPT_ENABLED, VBLANK_INTERRUPT
	reset SCROLL_X
	di
	jp mainMenu.lateInit