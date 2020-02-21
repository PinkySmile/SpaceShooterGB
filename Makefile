NAME = space_shooter

ASM = rgbasm

LD = rgblink

FIX = rgbfix

FIXFLAGS = -Cjsv -k 01 -l 0x33 -m 0x01 -p 0 -r 00 -t "`echo "$(NAME)" | tr a-z A-Z | tr "_" " "`"

ASMFLAGS =

LDFLAGS = -n $(NAME).sym -l $(NAME).link

FXFLAGS =

FX = rgbgfx

SRCS =	src/main.asm \
	src/mem_layout.asm

IMGS = 	assets/font.png

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
	tools/compressor $@

%.o : %.asm
	$(ASM) -o $@ $(ASMFLAGS) $<

$(NAME).gbc:	$(IMGSFX) $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)
	$(FIX) $(FIXFLAGS) $@

clean:
	$(MAKE) -C tools clean
	$(RM) $(OBJS) $(IMGSFX)

fclean:	clean
	$(MAKE) -C tools fclean
	$(RM) $(NAME).gbc

re:	fclean all
