.segment "HEADER"

header:
  .byte "NES", $1a                                                              ; magic identifier
  .byte $2                                                                      ; number of 16 KiB PRG-ROM pages
  .byte $1                                                                      ; number of  8 KiB CHR-ROM pages
  .byte %00000001                                                               ; flags 6 byte
                                                                                ; [0:0] mirroring
                                                                                ;       0 = horizontal (vertical arrangement)
                                                                                ;       1 = vertical (horizontal arrangement)
                                                                                ; [1:1] contains battery-backed PRG-RAM at $6000:$7fff or other persistent memory
                                                                                ; [2:2] 512-byte trainer present at $7000:$71ff
                                                                                ; [3:3] ignore mirroring and provide four-screen VRAM
                                                                                ; [4:7] bits 0:3 of mapper number
  .byte %00000000                                                               ; flags 7 byte
                                                                                ; [0:0] Vs. UniSystem
                                                                                ; [1:1] PlayChoice-10
                                                                                ; [2:3] reserved for NES 2.0
                                                                                ; [4:7] bits 4:7 of mapper number
  .byte $0                                                                      ; number of  8KiB PRG-RAM pages
                                                                                ; 0 implies 1 for compatibility
  .byte %00000000                                                               ; [0:0] TV system
                                                                                ;       0 = NTSC
                                                                                ;       1 = PAL
  .byte $0                                                                      ; reserved
  .byte $0, $0, $0, $0, $0                                                      ; unused

.segment "STARTUP"

.segment "CODE"

reset:
  sei                                                                           ; disable IRQs
  cld                                                                           ; disable decimal mode

  lda #%00000001                                                                ; enable pulse channel 1
  sta $4015                                                                     ; $4015 = APU: status
                                                                                ; [0:0] enable pulse channel 1
                                                                                ; [1:1] enable pulse channel 2
                                                                                ; [2:2] enable triangle channel
                                                                                ; [3:3] enable noise channel
                                                                                ; [4:4] enable delta modulation channel
                                                                                ; [5:7] reserved
  lda #$e3                                                                      ; middle C = 440 Hz = ~2.27ms = 0xe3
  sta $4002                                                                     ; $4002 = APU: bits 0:7 of pulse 1 timer
  lda #$0                                                                       ; set high bits of timer
  sta $4003                                                                     ; $4003 = APU: length counter load and bits 8:10 of pulse 1 timer
                                                                                ; [0:2] bits 8:10 of timer
                                                                                ; [3:7] length counter load
  lda #%10111111                                                                ; set pulse options
  sta $4000                                                                     ; $4000 = APU: pulse 1 options
                                                                                ; [0:3] volume/envelope divider period
                                                                                ; [4:4] constant volume/envelope
                                                                                ; [5:5] length counter halt
                                                                                ; [6:7] duty cycle
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
