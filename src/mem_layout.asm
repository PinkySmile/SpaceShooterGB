; Crash handler
SECTION "rst 38h", ROM0
	jp pcAt38

SECTION "vblank", ROM0
	jp vblank_interrupt

SECTION "hblank", ROM0
	jp hblank_interrupt

SECTION "timer", ROM0
	jp timer_interrupt

SECTION "serial", ROM0
	jp serial_interrupt

SECTION "joypad", ROM0
	jp joypad_interrupt

SECTION "Start", ROM0
	nop
	jp main

SECTION "Header", ROM0
	ds $150 - $104
