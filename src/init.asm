; Enable interupts and init RAM
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
init::
	push af
	xor a
	ld bc, $2000
	ld de, $C000
	call fillMemory
	pop af
	ret