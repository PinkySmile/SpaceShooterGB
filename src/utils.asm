; The fonts used.
textAssets: incbin "assets/font.fx"
textAssetsEnd:

; Uncompress compressed data
; Params:
;    hl -> Pointer to the compressed data
;    de -> Destination address
;    bc -> Data size
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
uncompress::
	ld a, [hli]

	ld [de], a
	inc de
	ld [de], a
	inc de

	dec bc
	xor a
	or b
	or c
	jr nz, uncompress
	ret

; Generates a pseudo random number.
; Params:
;    None
; Return:
;    a -> The number generated
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
random::
	push hl

	ld a, [RANDOM_REGISTER]
	ld hl, DIV_REGISTER
	add a, [hl]
	ld [RANDOM_REGISTER], a

	pop hl
	ret

; Puts randm values in VRAM
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Not preserved
trashVRAM::
	call waitVBLANK
	reset LCD_CONTROL
	ld hl, $9FFF
.start:
	call random
	ld [hl-], a
	bit 7, h
	jr nz, .start
	ret

; Loads the font into VRAM
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
loadTextAsset::
	; Save registers
	push af
	push hl
	push bc
	push de

	call waitVBLANK
	; Disable LCD
	reset LCD_CONTROL
	ld hl, textAssets
	ld bc, textAssetsEnd - textAssets
	ld de, VRAM_START
	; Copy text font info VRAM
	call uncompress

	; Restore registers
	pop de
	pop bc
	pop hl
	pop af
	ret

; Copies a chunk of memory into another
; Params:
;    bc -> The length of the chunk to copy
;    de -> The destination address
;    hl -> The source address
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
copyMemory::
	xor a ; Check if size is 0
	or b
	or c
	ret z

	; Copy a byte of memory from hl to de
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	jr copyMemory ; Recurse until bc is 0

; Fill a chunk of memory with a single value
; Params:
;    a  -> Value to fill
;    bc -> The length of the chunk to copy
;    de -> The destination address
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Preserved
fillMemory::
	push af ; Save a
	xor a   ; Check if bc is 0
	or b
	or c
	jr z, .return
	pop af

	; Load a into de
	ld [de], a
	inc de
	dec bc
	jr fillMemory ; Recurse intil bc is 0
.return: ; End of recursion
	pop af
	ret

; Wait for VBLANK. Only returns when a VBLANK occurs.
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
waitVBLANK::
	ld a, [LCD_CONTROL] ; Check if LCD is disabled
	bit 7, a
	ret z

	ld a, [INTERRUPT_ENABLED] ; Save old interrupt enabled
	push af
	reset INTERRUPT_REQUEST; Clear old requests
	reg INTERRUPT_ENABLED, VBLANK_INTERRUPT; Enable only VBLANK interrupt
.loop:
	halt   ; Wait for interrupt
	pop af ; Restore old interrupt enabled
	ld [INTERRUPT_ENABLED], a
	ret

; Displays text on screen.
; Params:
;    bc -> Length of the text.
;    hl -> Pointer to the start of the text.
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
displayText::
	call waitVBLANK
	reset LCD_CONTROL
	ld de, VRAM_BG_START
	call copyMemory
	reg LCD_CONTROL, %10010001
	ret

; Wait for VBLANK. Only returns when a VBLANK occurs.
; Params:
;    a -> The number of frames to wait for.
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Not preserved
waitFrames::
	ld hl, FRAME_COUNTER
	ld [hl], a
	reg INTERRUPT_ENABLED, VBLANK_INTERRUPT
	xor a
.loop:
	or [hl]
	ret z
	halt
	jr nz, .loop


dispBorderLine::
	ld [hli], a
	inc a
	ld e, 18
.loop:
	ld [hli], a
	dec e
	jr nz, .loop
	inc a
	ld [hli], a
	inc a
	ret

; Displays the keyboard
; Params:
;    None
; Return:
;    None
; Registers
;    af -> Preserved
;    bc -> Preserved
;    de -> Not preserved
;    hl -> Preserved
displayKeyboard::
	push af
	push hl
	push bc
	ld a, 128
	ld hl, $9880
	call dispBorderLine
	ld e, 32
	call .inc
	ld c, 12
.loop:
	ld [hli], a
	inc a
	push af
	ld b, 8

.loop2:
	ld [hl], $00
	inc hl
	ld a, e
	ld [hli], a
	inc e
	dec b
	jr nz, .loop2

	xor a
	ld [hli], a
	ld [hli], a

	pop af
	ld [hli], a
	dec a

	call .inc
	dec c
	jr nz, .loop

	inc a
	inc a
	call dispBorderLine

	pop hl
	pop bc
	pop af
	ret
.inc:
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ret

; Get all pressed keys
; Params:
;    None
; Return:
;    a -> All the pressed keys
;       bit 0 ->

; Opens the window to type text in.
; Params:
;    a  -> Character which replace typed text (\0 for no covering)
;    hl -> Pointer to a buffer.
;    bc -> Buffer max size.
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
typeText::
	call loadTextAsset
	call displayKeyboard
	reg LCD_CONTROL, %10010001
.loop:
	call waitVBLANK

	ret

