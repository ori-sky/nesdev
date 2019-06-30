.ifndef PPU_INC
PPU_INC = 1

.include "memory.inc"
.include "ppu/palette.inc"

.segment "CODE"

.macro PPU_INIT
  ldx #$0                                                                       ; disable NMIs and rendering
  stx $2000                                                                     ; $2000 = PPUCTRL
                                                                                ; [0:1] nametable select
                                                                                ;       0 = $2000
                                                                                ;       1 = $2400
                                                                                ;       2 = $2800
                                                                                ;       3 = $2c00
                                                                                ; [2:2] VRAM increment per PPUDATA read/write
                                                                                ;       0 = increment by  1 (horizontal)
                                                                                ;       1 = increment by 32 (vertical)
                                                                                ; [3:3] sprite pattern table select
                                                                                ;       0 = $0000
                                                                                ;       1 = $1000
                                                                                ; [4:4] background pattern table select
                                                                                ;       0 = $0000
                                                                                ;       1 = $1000
                                                                                ; [5:5] sprite size
                                                                                ;       0 = 8 x  8
                                                                                ;       1 = 8 x 16
                                                                                ; [6:6] PPU master/slave
                                                                                ; [7:7] enable NMIs
  stx $2001                                                                     ; $2001 = PPUMASK
                                                                                ; [0:0] greyscale
                                                                                ; [1:1] background left column enable
                                                                                ; [2:2] sprite left column enable
                                                                                ; [3:3] background enable
                                                                                ; [4:4] sprite enable
                                                                                ; [5:5] emphasize red
                                                                                ; [6:6] emphasize green
                                                                                ; [7:7] emphasize blue
  PPU_VBLANK_WAIT
  MEMORY_CLEAR
  PPU_VBLANK_WAIT
.endmacro

.macro PPU_NMI_ENABLE
  lda #%10000000
  sta $2000
.endmacro

.macro PPU_VBLANK_WAIT
.local loop
loop:
  bit $2002                                                                     ; $2002 = PPUSTATUS
                                                                                ; [0:4] reserved
                                                                                ; [5:5] sprite overflow
                                                                                ; [6:6] sprite 0 hit
                                                                                ; [7:7] currently in vblank
  bpl loop                                                                      ; loop until no longer in vblank
.endmacro

.macro PPU_PALETTE_CLEAR
.local loop
  ldy $2002                                                                     ; read PPUSTATUS to reset high/low latch to high
  ldy #$3f                                                                      ; set PPU address to BG palette RAM ($3f00)
  sty $2006                                                                     ; $2006 = PPUADDR
  ldy #$0
  sty $2006                                                                     ; requires two stores, one for high byte and one for low byte
loop:
  lda (MEMORY_ZEROPAGE_PALETTE), y
  sta $2007                                                                     ; $2007 = PPUDATA
  iny
  cpy #$1                                                                       ; loop over palette RAM ($3f00:$3f20)
  bne loop
.endmacro

.endif
