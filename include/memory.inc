.ifndef MEMORY_INC
MEMORY_INC = 1

.segment "CODE"

MEMORY_ZEROPAGE_PALETTE = $10

.macro MEMORY_STACK_SET sp
  ldx sp                                                                        ; set up stack pointer
  txs
.endmacro

.macro MEMORY_CLEAR
.local loop
  ldx #$0
loop:
  lda #$0
  sta $0000, x
  sta $0100, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  lda #$fe                                                                      ; move all sprites off-screen
  sta $0200, x
  inx
  bne loop
.endmacro

.macro MEMORY_ZEROPAGE_STORE addr, zeropage
  lda #<addr
  sta zeropage
  lda #>addr
  sta zeropage+1
.endmacro

.endif
