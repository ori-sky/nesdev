.include "header/ines.inc"
.include "memory.inc"
.include "apu.inc"

.segment "STARTUP"

.segment "DATA"

apu: .tag APU

.segment "CODE"

reset:
  sei                                                                           ; disable IRQs
  cld                                                                           ; disable decimal mode
  MEMORY_STACK_SET #$ff
  APU_INIT
  MEMORY_STORE_WORD apu, MEMORY_ZEROPAGE_APU
  ldx #$e3
  jsr apu_pulse1_play
  ldx #$b3
  jsr apu_pulse2_play
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
