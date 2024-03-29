.include "header/ines.inc"
.include "memory.inc"
.include "apu.inc"
.include "ppu.inc"

.segment "STARTUP"

.segment "DATA"

palette: .tag Palette

.segment "CODE"

reset:
  sei                                                                           ; disable IRQs
  cld                                                                           ; disable decimal mode
  MEMORY_STACK_SET #$ff
  APU_INIT
  PPU_INIT
  MEMORY_STORE_WORD palette, MEMORY_ZEROPAGE_PALETTE
  lda #PALETTE_ORANGE
  sta palette+Palette::bg
  PPU_PALETTE_CLEAR
  ;lda #%10100000                                                                ; emphasize red and blue
  ;sta $2001
@hang:
  jmp @hang

nmi:
  rti                                                                           ; return from interrupt

.segment "VECTORS"

ivt:
  .word nmi                                                                     ; non-maskable interrupt
  .word reset                                                                   ; reset
  .word 0                                                                       ; external IRQ

.segment "CHARS"
