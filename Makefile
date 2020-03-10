NAME = space_shooter

ASM = rgbasm

LD = rgblink

FIX = rgbfix

FIXFLAGS = -jsv -k 01 -l 0x33 -m 0x01 -p 0 -r 00 -t "`echo "$(NAME)" | tr a-z A-Z | tr "_" " "`"

ASMFLAGS =

LDFLAGS = -n $(NAME).sym -l $(NAME).link

FXFLAGS =

FX = rgbgfx

SRCS = \
	src/main.asm \
	src/mem_layout.asm \
	src/assets.asm \
	src/text.asm

IMGS = \
	assets/asteroids.png \
	assets/spaceship.png \
	assets/logo.png \
	assets/boss.png

COMPRESSED_IMGS = \
	assets/font.png \
	assets/bigj.png \
	assets/biga.png \
	assets/bigm.png \
	assets/epitech.png \
	assets/background.png \
	assets/laser.png

COMPRESSEDIMGSFX = $(COMPRESSED_IMGS:%.png=%.cfx)

IMGSFX = $(IMGS:%.png=%.fx)

OBJS = $(SRCS:%.asm=%.o)

all:	tools/compressor $(NAME).gbc

tools/compressor:
	$(MAKE) -C tools compressor

run:	re
	wine "$(BGB_PATH)" ./$(NAME).gbc

runw:	re
	"$(BGB_PATH)" ./$(NAME).gbc

%.fx : %.png
	$(FX) $(FXFLAGS) -o $@ $<

%.cfx : %.png
	$(FX) $(FXFLAGS) -o $@ $<
	tools/compressor $@

%.o : %.asm
	$(ASM) -o $@ $(ASMFLAGS) $<

$(NAME).gbc:	$(COMPRESSEDIMGSFX) $(IMGSFX) $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)
	$(FIX) $(FIXFLAGS) $@

clean:
	$(MAKE) -C tools clean
	$(RM) $(OBJS) $(IMGSFX) $(COMPRESSEDIMGSFX)

fclean:	clean
	$(MAKE) -C tools fclean
	$(RM) $(NAME).gbc

re:	fclean all
