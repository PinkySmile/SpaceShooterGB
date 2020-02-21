; Create a random obstacle
; Params:
;    None
; Return:
;    None
; Registers:
;    N/A

create_obstacle::
    ld de, [NB_OBSTACLES]
    ld hl, NB_OBSTACLES

.loop:
    cp hl, de
    inc de
    jp nz, loop

    ld de, af
    inc de
    ; x value
    call random
    ld [hl], a

    ; y value is set to 0 the obstacle must start at the top of the screen
    inc hl
    reset hl

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
