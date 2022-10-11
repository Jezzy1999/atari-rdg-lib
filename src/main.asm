        processor 6502

        include "vcs.h"
        include "macro.h"

	SEG.U vars
	ORG $80

SpriteXPosition ds 1

        SEG code
        ORG $F000

Reset
StartOfFrame

; Start of vertical blank processing

        lda #0
        sta VBLANK

        lda #2
        sta VSYNC

; 3 scanlines of VSYNCH signal...

        sta WSYNC
        sta WSYNC
        sta WSYNC

        lda #0
        sta VSYNC           

; 37 scanlines of vertical blank...

        REPEAT 37; scanlines
        sta WSYNC
        REPEND

        ; 192 scanlines of picture...
	REPEAT 192
	sta WSYNC
	REPEND

        lda #%01000010
        sta VBLANK                     ; end of screen - enter blanking

        ; 30 scanlines of overscan...
        REPEAT 30
        sta WSYNC
        REPEND

        jmp StartOfFrame

        ORG $FFFA

        .word Reset          ; NMI
        .word Reset          ; RESET
        .word Reset          ; IRQ

    	END
