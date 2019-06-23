.segment "CODE"

.macro MEMORY_CLEAR
.local loop
  ldx #$0
loop:
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
  bne loop
.endmacro
