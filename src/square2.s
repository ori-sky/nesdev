.include "header/ines.inc"

.segment "STARTUP"

.segment "CODE"

reset:
  sei                                                                           ; disable IRQs
  cld                                                                           ; disable decimal mode

  lda #%00000011                                                                ; enable pulse 1 and pulse 2
  sta $4015                                                                     ; $4015 = APU: status
                                                                                ; [0:0] enable pulse channel 1
                                                                                ; [1:1] enable pulse channel 2
                                                                                ; [2:2] enable triangle channel
                                                                                ; [3:3] enable noise channel
                                                                                ; [4:4] enable delta modulation channel
                                                                                ; [5:7] reserved
  lda #$e3                                                                      ; middle C = 440 Hz = ~2.27ms = 0xe3
  sta $4002                                                                     ; $4002 = APU: bits 0:7 of pulse 1 timer
  lda #$b3                                                                      ; middle E
  sta $4006                                                                     ; $4006 = APU: bits 0:7 of pulse 2 timer
  lda #$0                                                                       ; set high bits of timer
  sta $4003                                                                     ; $4003 = APU: length counter load and bits 8:10 of pulse 1 timer
                                                                                ; [0:2] bits 8:10 of timer
                                                                                ; [3:7] length counter load
  sta $4007                                                                     ; $4007 = APU: length counter load and bits 8:10 of pulse 2 timer
  lda #%10111111                                                                ; set pulse 1 options
  sta $4000                                                                     ; $4000 = APU: pulse 1 options
                                                                                ; [0:3] volume/envelope divider period
                                                                                ; [4:4] constant volume/envelope
                                                                                ; [5:5] length counter halt
                                                                                ; [6:7] duty cycle
  lda #%10111100                                                                ; set pulse 1 options
  sta $4004                                                                     ; $4004 = APU: pulse 2 options
hang:
  jmp hang
nmi:
  rti                                                                           ; return from interrupt

.segment "VECTORS"

ivt:
  .word nmi                                                                     ; non-maskable interrupt
  .word reset                                                                   ; reset
  .word 0                                                                       ; external IRQ

.segment "CHARS"
