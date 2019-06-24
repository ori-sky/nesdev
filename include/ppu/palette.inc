.ifndef PPU_PALETTE_INC
PPU_PALETTE_INC = 1

PALETTE_ORANGE = $17

.struct PaletteEntry
  color1 .byte
  color2 .byte
  color3 .byte
.endstruct

.struct Palette
  bg  .byte
  bg0 .tag PaletteEntry
  .byte
  bg1 .tag PaletteEntry
  .byte
  bg2 .tag PaletteEntry
  .byte
  bg3 .tag PaletteEntry
  .byte
  fg0 .tag PaletteEntry
  .byte
  fg1 .tag PaletteEntry
  .byte
  fg2 .tag PaletteEntry
  .byte
  fg3 .tag PaletteEntry
.endstruct

.endif
