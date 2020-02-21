; SGB Opcodes parameter
MLT_REQ_PAR:        ; Params for Multiplayer request
MASK_EN_FREEZE_PAR: ; Params for freezing screen
	db $01
CHR_TRN_PAR:        ; Params for character transfer
PCT_TRN_PAR:        ; Params for color data
PAL_TRN_PAR:        ; Params for palette data
MASK_EN_CANCEL_PAR: ; Params for unfreezing screen
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; Sends a value to the SGB
; Params:
;    a -> The value to place in the Joypad register
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
sendSGBVal::
	ld [JOYPAD_REGISTER], a         ; Put value in Joypad register
	nop                             ; Wait a bit
	reg JOYPAD_REGISTER, %00110000  ; Reset data lines
	ret

; Sends a single bit of data to the SGB
; Params:
;    a -> The bit to send (It will send bit 0 of a)
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
sendSGBPacketBit::
	push af

	bit 0, a    ; Check bit to send
	jr z, .val2 ; Select value to be sent
	ld a, $10
	jr .end
.val2:
	ld a, $20
.end:

	call sendSGBVal ; Send the value picked
	pop af          ; Restore af
	ret

; Sends a byte of data to the SGB
; Params:
;    a -> Byte to send
; Return:
;    None
; Registers:
;    a  -> Preserved
;    f  -> Not preserved
;    bc -> Preserved
;    de -> Not preserved
;    hl -> Preserved
sendSGBPacketByte::
	ld d, 8              ; Number of bits left to send
.loop:
	call sendSGBPacketBit; Send the first bit of a
	rra                  ; Select the next bit of a
	dec d
	jr nz, .loop         ; Continue loop
	ret

; Sends a command to the SGB
; Params:
;    a  -> Opcode of the command * 8 + length
;    hl -> Pointer to the data parameters
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Preserved
;    hl -> Not preserved
sendSGBCommand::
	push de
	push af
	xor a                  ; Send the start bit
	call sendSGBVal
	ld e, $10              ; Number of byte left to send
	pop af

.loop:
	call sendSGBPacketByte ; Send a byte of data
	ld a, [hli]            ; Load the next byte to be sent
	dec e
	jr nz, .loop

	ld a, $20              ; Send the stop bit
	call sendSGBVal
	pop de
	ret

; Loads the cartridge SGB Boarder and send it to the SGB
; af -> Not preserved
; bc -> Not preserved
; de -> Not preserved
; hl -> Not preserved
loadSGBBorder::
	; Disable screen view
	reg PALETTE_REGISTER, $E4
	ld a, MASK_EN
	ld hl, MASK_EN_FREEZE_PAR
	call sendSGBCommand

	; Send tile characters
	call trashVRAM
	ld a, CHR_TRN
	ld hl, CHR_TRN_PAR
	reg LCD_CONTROL, %10010001
	call sendSGBCommand

	; Send tile data
	call trashVRAM
	ld a, PCT_TRN
	ld hl, PCT_TRN_PAR
	reg LCD_CONTROL, %10010001
	call sendSGBCommand

	; Send palette data
	call trashVRAM
	ld a, PAL_TRN
	ld hl, PAL_TRN_PAR
	reg LCD_CONTROL, %10010001
	call sendSGBCommand

	; Enable screen view
	ld a, MASK_EN
	ld hl, MASK_EN_CANCEL_PAR
	call sendSGBCommand