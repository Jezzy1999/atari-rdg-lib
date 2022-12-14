        processor 6502

        include "vcs.h"
        include "macro.h"

	SEG.U vars
	ORG $80

SpriteXPosition ds 1

        SEG code
        ORG $F000

Reset
; Clear RAM and all TIA registers

	ldx #0
	lda #0
Clear   sta 0,x
	inx
	bne Clear

	lda #$56
	sta COLUP0

	ldx #$80
	stx GRP0                ; modify sprite 0 shape
StartOfFrame

; Start of vertical blank processing

        lda #2
        sta VBLANK
        sta VSYNC

; 3 scanlines of VSYNCH signal...

        sta WSYNC
        sta WSYNC
        sta WSYNC

        lda #0
        sta VSYNC           

	lda SpriteXPosition
        and #$7f

        sta WSYNC
	sta HMCLR

	sec
DivLoop:
	sbc #15
	bcs DivLoop

	eor #7
	asl
	asl
	asl
	asl

	sta HMP0
	sta RESP0
	sta WSYNC
	sta HMOVE

        REPEAT 35; scanlines
        sta WSYNC
        REPEND

        lda #0
        sta VBLANK

        ; 160 scanlines of picture...
	REPEAT 160
	sta WSYNC
	REPEND

        lda #%01000010
        sta VBLANK                     ; end of screen - enter blanking

        ; 30 scanlines of overscan...
        REPEAT 30
        sta WSYNC
        REPEND

CheckLeft:
        lda #%01000000
        bit SWCHA
        bne CheckRight
	dec SpriteXPosition

CheckRight:
	lda #%10000000
	bit SWCHA
	bne NoInput
	inc SpriteXPosition
NoInput:
        jmp StartOfFrame

        ORG $FFFA

        .word Reset          ; NMI
        .word Reset          ; RESET
        .word Reset          ; IRQ

    	END
