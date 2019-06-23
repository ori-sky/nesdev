.include "memory.inc"

.segment "CODE"

.macro PPU_INIT
  ldx #$0                                                                       ; disable NMIs and rendering
  stx $2000                                                                     ; $2000 = PPUCTRL
                                                                                ; [0:1] nametable select
                                                                                ; [2:2] increment mode
                                                                                ; [3:3] sprite tile select
                                                                                ; [4:4] background tile select
                                                                                ; [5:5] sprite height
                                                                                ; [6:6] PPU master/slave
                                                                                ; [7:7] NMI enable
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
  PPU_PALETTE_CLEAR
.endmacro

.macro PPU_VBLANK_WAIT
.local loop
loop:
  bit $2002                                                                     ; $2002 = PPUSTATUS
                                                                                ; [0:4] reserved
                                                                                ; [5:5] sprite overflow
                                                                                ; [6:6] sprite 0 hit
                                                                                ; [7:7] currently in vblank
  bpl loop                                                                     ; loop until no longer in vblank
.endmacro

.macro PPU_PALETTE_CLEAR
.local loop
  lda $2002                                                                     ; read PPUSTATUS to reset PPU address
  lda #$3f                                                                      ; set PPU address to BG palette RAM ($3f00)
  sta $2006                                                                     ; $2006 = PPUADDR
                                                                                ; requires two stores, one for low byte and one for high byte
  lda #$0
  sta $2006
  ldx #$20                                                                      ; clear BG palette RAM ($3f00:$3f20)
loop:
  sta $2007                                                                     ; $2007 = PPUDATA
  dex
  bne loop
.endmacro
