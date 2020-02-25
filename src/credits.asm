showCreditText::
	ld hl, creditsText
	ld de, $9800
	ld bc, creditsTextEnd - creditsText
	call copyMemory

	ld hl, assembly
	ld de, $9860
	ld bc, assemblyEnd - assembly
	call copyMemory

	ld hl, andgel
	ld de, $98A0
	ld bc, andgelEnd - andgel
	call copyMemory

	ld hl, clement
	ld de, $98E0
	ld bc, clementEnd - clement
	call copyMemory

	ld hl, tristan
	ld de, $9920
	ld bc, tristanEnd - tristan
	call copyMemory

	ld hl, graphics
	ld de, $99A0
	ld bc, graphicsEnd - graphics
	call copyMemory

	ld hl, marc
	ld de, $99E0
	ld bc, marcEnd - marc
	call copyMemory

	ld hl, music
	ld de, $9A60
	ld bc, musicEnd - music
	call copyMemory

	ld hl, jonat
	ld de, $9AA0
	ld bc, jonatEnd - jonat
	call copyMemory
	ret

credits::
	call waitVBLANK
	reset LCD_CONTROL
	call drawBackground
	call showCreditText
	reg LCD_CONTROL, LCD_BASE_CONTROL
	reg WY, $90
	reg WX, $7
	reg SCROLL_Y, $E0
	xor a
	push af
.loop:
	reset INTERRUPT_REQUEST
	halt
	pop af
	xor $1
	push af
	jr nz, .skip
	ld hl, SCROLL_Y
	inc [hl]
.skip:
	call updateSound
	call updateSound2
	call getKeys
	xor $FF
	jr z, .loop
	reg SCROLL_Y, 0
	pop af
	jp mainMenu