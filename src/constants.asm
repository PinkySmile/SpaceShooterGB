CGB_A_INIT EQU $11 ; Accumulator starting value on a Gameboy Color

; Sound control
DISABLE_CHANNELS_REGISTERS EQU $FF26

; Sound Channel 1
CHANNEL1_SWEEP EQU $FF10
CHANNEL1_LENGTH EQU $FF11
CHANNEL1_VOLUME EQU $FF12
CHANNEL1_LOW_FREQ EQU $FF13
CHANNEL1_HIGH_FREQ EQU $FF14

; Sound Channel 2
CHANNEL2_LENGTH EQU $FF16
CHANNEL2_VOLUME EQU $FF17
CHANNEL2_LOW_FREQ EQU $FF18
CHANNEL2_HIGH_FREQ EQU $FF19

; Sound channel 3
CHANNEL3_ON_OFF EQU $FF1A
CHANNEL3_LENGTH EQU $FF1B
CHANNEL3_OUTPUT EQU $FF1C
CHANNEL3_LOW_FREQ EQU $FF1D
CHANNEL3_HIGH_FREQ EQU $FF1E

; Sound channel 4
CHANNEL4_LENGTH EQU $FF20
CHANNEL4_VOLUME EQU $FF21
CHANNEL4_POLY EQU $FF22
CHANNEL4_RESTART EQU $FF23

; LCD
LCD_CONTROL EQU $FF40
LCD_BASE_CONTROL EQU %10010111

; VRAM
VRAM_START EQU $8000
VRAM_BG_START EQU $9800

; Characters
TM_CHARACTER EQU $88

; Joypad
JOYPAD_REGISTER EQU $FF00

; Interrupts
INTERRUPT_REQUEST EQU $FF0F
INTERRUPT_ENABLED EQU $FFFF
NO_INTERRUPT EQU 0
VBLANK_INTERRUPT EQU (1 << 0)
LCD_STAT_INTERRUPT EQU (1 << 1)
TIMER_INTERRUPT EQU (1 << 2)
SERIAL_INTERRUPT EQU (1 << 3)
JOYPAD_INTERRUPT EQU (1 << 4)

; Misc registers
DIV_REGISTER EQU $FF04
PALETTE_REGISTER EQU $FF47

; Game registers
FRAME_COUNTER EQU $C000
HARDWARE_TYPE EQU $C001
RANDOM_REGISTER EQU $C002
PLAYER1_STRUCT EQU $C003
SHOOT_COOLDOWN EQU $C018
NB_SHOOTS EQU $C019
SHOOTS_PTR EQU $C01A
MUSIC_TIMER EQU $C030
MUSIC_PTR_H EQU $C031
MUSIC_PTR_L EQU $C032
MUSIC_START_PTR_H EQU $C033
MUSIC_START_PTR_L EQU $C034
BANK_POINTER EQU $C100
CAMERA_SHOULD_MOVE_LEFT EQU $C01E
CAMERA_SHOULD_MOVE_RIGHT EQU $C01F

; Game constants
NB_SHOOTS_MAX EQU 10
NB_PLAYERS EQU 2
NB_LASERS_MAX EQU 10
NB_ASTEROIDS_MAX EQU 14
BASE_SHOOT_COOLDOWN EQU 15
SPACESHIP_PALETTE EQU %00100111

; DMG Palette
BGP EQU $FF47
OBP0 EQU $FF48
OBP1 EQU $FF49

; GBC Palette
BGPI EQU $FF68
BGPD EQU $FF69
OBPI EQU $FF6A
OBPB EQU $FF6B

; SGB Commands
PAL_TRN EQU $59
DATA_SND EQU $79
MLT_REQ EQU $89
CHR_TRN EQU $99
PCT_TRN EQU $A1
MASK_EN EQU $B9

; DMA
START_DMA EQU $FF46
DMA_DELAY EQU $28
DMA EQU $FF80

; OAM
OAM_SRC_START EQU $C800 / $100

; Player struct
PLAYER_STRUCT_X_OFF EQU $0
PLAYER_STRUCT_Y_OFF EQU $1

; Laser struct
LASER_STRUCT_X_OFF EQU $0
LASER_STRUCT_Y_OFF EQU $1

; Sprite offsets
SPRITE_SIZE EQU $4
SPRITE_POSITION_Y EQU $0
SPRITE_POSITION_X EQU $1
SPRITE_TILE_NBR EQU $2
SPRITE_ATTRIBUTE_FLAGS EQU $3

; Obstacles registers
; All the obstacles will be added by incrementing the base register
NB_OBSTACLES EQU $C050
ASTEROID_SPRITE_INDEX EQU $8

QUAVER EQU $8