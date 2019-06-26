.include "header/ines.inc"
.include "memory.inc"
.include "apu.inc"
.include "ppu.inc"

.segment "STARTUP"

.segment "DATA"

apu:     .tag APU
palette: .tag Palette
note:    .byte $e3

.segment "CODE"

reset:
  sei                                                                           ; disable IRQs
  cld                                                                           ; disable decimal mode
  MEMORY_STACK_SET #$ff
  APU_INIT
  PPU_INIT
  MEMORY_STORE_WORD apu, MEMORY_ZEROPAGE_APU
  MEMORY_STORE_WORD palette, MEMORY_ZEROPAGE_PALETTE
  lda #PALETTE_ORANGE
  sta palette+Palette::bg
  PPU_PALETTE_CLEAR
  PPU_NMI_ENABLE
@hang:
  jmp @hang

nmi:
  ldx note
  dex
  stx note
  jsr apu_pulse1_play
  rti                                                                           ; return from interrupt

.segment "VECTORS"

ivt:
  .word nmi                                                                     ; non-maskable interrupt
  .word reset                                                                   ; reset
  .word 0                                                                       ; external IRQ

.segment "CHARS"
