.include "header/ines.inc"
.include "apu.inc"
.include "ppu.inc"

.segment "STARTUP"

.segment "CODE"

reset:
  sei                                                                           ; disable IRQs
  cld                                                                           ; disable decimal mode
  ldx #$ff                                                                      ; set up stack pointer
  txs
  APU_INIT
  PPU_INIT
  lda #%10100000                                                                ; emphasize red and blue
  sta $2001
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
