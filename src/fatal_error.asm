fatalErrorText::
	db "PC 38H"
fatalErrorTextEnd::

pcAt38::
	ld hl, fatalErrorText
	ld bc, fatalErrorTextEnd - fatalErrorText
	jp dispError

; Displays an error message and lock CPU
; Params:
;    hl -> Text to display
;    bc -> Length of the text
; Return:
;    None
; Registers:
;    N/A
dispError::
	; Load text fonts
	call loadTextAsset
	; Display given text
	call displayText
	; Play a sound and lock CPU
	jp fatalError

; Plays sound and locks CPU
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
fatalError::
	reg DISABLE_CHANNELS_REGISTERS, $80
	reset CHANNEL2_VOLUME
	reset CHANNEL3_ON_OFF
	reset CHANNEL4_VOLUME
	ld c, $03
	ld d, $00
.loop:
	reg CHANNEL1_LENGTH, %10000000
	reg CHANNEL1_VOLUME, %11110001
	reg CHANNEL1_LOW_FREQ, $FF
    reg CHANNEL1_HIGH_FREQ,%10000001
	ld b, $FF
.loopWait:
	dec d
	jr nz, .loopWait
	dec b
	jr nz, .loopWait
	dec c
	jr nz, .loop
	jp lockup