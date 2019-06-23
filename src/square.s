.include "header/ines.inc"
.include "apu.inc"

.segment "STARTUP"

.segment "CODE"

apu: .tag APU

reset:
  sei                                                                           ; disable IRQs
  cld                                                                           ; disable decimal mode
  ldx #$ff                                                                      ; set up stack pointer
  txs
  APU_INIT
  ldx apu
  ldy #$e3                                                                      ; middle C = 440 Hz = ~2.27ms = 0xe3
  jsr apu_pulse1_play
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
