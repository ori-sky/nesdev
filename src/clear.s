.include "header/ines.inc"

.segment "STARTUP"

.segment "CODE"

reset:
  sei                                                                           ; disable IRQs
  cld                                                                           ; disable decimal mode
  ldx #%01000000                                                                ; disable APU frame IRQ
  stx $4017                                                                     ; $4017 = APU: frame counter
                                                                                ; [0:5] reserved
                                                                                ; [6:6] IRQ inhibit
                                                                                ; [7:7] mode
                                                                                ;       0 = 4-step
                                                                                ;       1 = 5-step
  ldx #$ff                                                                      ; set up stack pointer
  txs
  inx                                                                           ; set x to 0
                                                                                ; disable NMI, rendering, and DMC IRQs
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
  stx $4010                                                                     ; $4010 = delta modulation flags
                                                                                ; [0:3] frequency
                                                                                ; [4:5] reserved
                                                                                ; [6:6] loop
                                                                                ; [7:7] IRQ enable
vblank1:
  bit $2002                                                                     ; $2002 = PPUSTATUS
                                                                                ; [0:4] reserved
                                                                                ; [5:5] sprite overflow
                                                                                ; [6:6] sprite 0 hit
                                                                                ; [7:7] currently in vblank
  bpl vblank1                                                                   ; loop until no longer in vblank
clear_memory:
  lda #$0
  sta $0000, x
  sta $0100, x
  sta $0200, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  inx
  bne clear_memory
vblank2:
  bit $2002
  bpl vblank2
clear_palette:
  lda $2002                                                                     ; read PPUSTATUS to reset PPU address
  lda #$3f                                                                      ; set PPU address to BG palette RAM ($3f00)
  sta $2006                                                                     ; $2006 = PPUADDR
                                                                                ; requires two stores, one for low byte and one for high byte
  lda #$0
  sta $2006
  ldx #$20                                                                      ; clear BG palette RAM ($3f00:$3f20)
@loop:
  sta $2007                                                                     ; $2007 = PPUDATA
  dex
  bne @loop
  lda #%10100000                                                                ; emphasize red and blue
  sta $2001
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
