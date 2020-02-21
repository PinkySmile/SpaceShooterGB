; Create a random obstacle
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A

create_obstacle::
    ld a, [NB_OBSTACLES]
    rl a
    ld b, 0
    ld c, a
    ld hl, NB_OBSTACLES
    add hl, bc

    inc hl

    ; x value
    call random
    ld [hl], a

    ; y value is set to 0 the obstacle must start at the top of the screen
    inc hl
    ld a, 0
    ld [hl], a

; Destroy an obstacle
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
destroy_obstacle::

    ; remove the first asteroid from the queue and resize the queue
    ld b, 0
    ld c, 2
    ld d, h
    ld e, l
    add hl, bc
    ld a, [NB_OBSTACLES]
    rl a
    ld c, a
    rr a
    dec a
    ld [NB_OBSTACLES], a
    call copyMemory
