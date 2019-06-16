ROMS=square.nes

.PHONY: all
all: $(ROMS)

.PHONY: clean
clean:
	rm -fv $(ROMS)

%.nes: src/%.s
	cl65 -t nes $^ -o $@
