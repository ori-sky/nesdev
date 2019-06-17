ROMS=square.nes square2.nes

.PHONY: all
all: $(ROMS)

.PHONY: clean
clean:
	rm -fv $(ROMS)

%.nes: src/%.o
	ld65 -t nes $^ -o $@

src/%.o: src/%.s
	ca65 -t nes -I include $^ -o $@
