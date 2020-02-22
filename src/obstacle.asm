; Create a random obstacle
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A

createObstacle::
    ld a, [NB_OBSTACLES]
    rl a
    inc a
    ld b, 0
    ld c, a
    ld hl, NB_OBSTACLES
    add hl, bc

    ; y value is set to 0 the obstacle must start at the top of the screen
    ld a, 10
    ld [hli], a

    ; x value
    call random
    and %01111111
    ld [hli], a

    ld hl, NB_OBSTACLES
    inc [hl]
    ret

; Destroy an obstacle
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
destroyObstacle::

    ; remove the first asteroid from the queue and resize the queue

    ;ld b, 0
    ;ld c, 2
    ;ld d, h
    ;ld e, l
    ;add hl, bc
    ;ld a, [NB_OBSTACLES]
    ;rl a
    ;ld c, a
    ;rr a
    ;dec a
    ;ld [NB_OBSTACLES], a
    ;call copyMemory
    push hl

    ld b, 0
   	ld c, 2
    ld d, h
    ld e, l
    add hl, bc
    ld a,[NB_OBSTACLES]
    ld c, a
    rl c
    dec a
    ld [NB_OBSTACLES],a
    call copyMemory

    pop hl
    dec hl
    dec hl
    ret

; Update all obstacles
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
updateObstacles::
    ld hl, NB_OBSTACLES + 1
    ld de, (OAM_SRC_START << 8) + SPRITE_SIZE * (NB_PLAYERS + NB_LASERS_MAX)
.loop;
    ; y
    ld a, [hli]
    add a, $10
    ld [de], a
    inc de

    ; x
    ld a, [hli]
    add a, $8
    ld [de], a
    inc de

    ld a, ASTEROID_SPRITE_INDEX
    ld [de], a
    inc de

    ld a, 0
    ld [de], a
    inc de

    dec hl
    dec hl
    ld a, [hli]
    add a, $10
    ld [de], a
    inc de

    ; x
    ld a, [hli]
    add a, $10
    ld [de], a
    inc de

    ld a, ASTEROID_SPRITE_INDEX + 2
    ld [de], a
    inc de

    ld a, 0
    ld [de], a
    inc de

    ld a, $00
    cp e
    jr nz, .loop
    ret

     ;ld a, [NB_OBSTACLES]
     ;ld hl, nb_OBSTACLES; $CO50
     ;ld b, 0
     ;ld c, a
     ;add hl, bc

;.loop:
 ;   cp c
  ;  inc a
   ; ld b,
    ;jp nz, loop
    ;ld a,[NB_OBSTACLES]
    ;	or a
    ;	ret z

    ;	ld hl, (OAM_SRC_START << 8) + SPRITE_SIZE * 12
    ;	ld d, h
    ;	ld e, l
    ;	ld b, 0
    ;	ld c, a
    ;	rl c
    ;	call fillMemory ; move the oamram

    ;	ld de, SHOOTS_PTR
    ;.loop:
    ;	push af
    ;	inc de
    ;	ld a, [de]
    ;	add a, $10
    ;	ld [hli], a

    ;	dec de
    ;	ld a, [de]
    ;	add a, $8
    ;	ld [hli], a

    ;	ld a, $8
    ;	ld [hli], a

    ;	ld a, $0
    ;	ld [hli], a

    ;	inc de
    ;	ld a, [de]
    ;	sub a, 4
    ;	ld [de], a

    ;	inc de
    ;	pop af
    ;	dec a
    ;	jr nz, .loop
    ;	ret