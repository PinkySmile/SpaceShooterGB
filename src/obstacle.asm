; Create a random obstacle
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A

create_obstacle::
    ld c, [NB_OBSTACLES]
    ld b, [c]

    inc c
    ; x value
    call random
    ld a, [b]

    ; y value is set to 0 the obstacle must start at the top of the screen
    inc b
    ld 0, [b]

; Destroy an obstacle
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A
destroy_obstacle::
    ld a, NB_OBSTACLES
    ld a, [NB_OBSTACLES]

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
