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
