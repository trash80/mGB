.module mGBASMFunctions

_asmMain::
	ld	A,#0x01
	ld	hl,#_systemIdle
	ld	(hl),A
	
	call _asmUpdateMidiBuffer
	
	ld	A,#0x01
	ld	hl,#_systemIdle
	bit 0,(hl)
	call nz, _getPad
	ld	A,#0x01
	ld	hl,#_systemIdle
	bit 0,(hl)
	call nz, _asmUpdatePu1
	ld	hl,#_systemIdle
	bit 0,(hl)
	call nz, _asmUpdatePu2
	ld	hl,#_systemIdle
	bit 0,(hl)
	call nz, _asmUpdateWav
	ld	hl,#_systemIdle
	bit 0,(hl)
	call nz, _asmUpdateNoi
	ld	hl,#_systemIdle
	bit 0,(hl)
	jr nz,_asmMainScreen
	
	jr _asmMain
ret
_asmMainScreen::
	ld	hl,#_currentScreen
	bit 0,(hl)
	jr z,_asmMain
	
	ld	hl,#_updateDisplaySynthCounter
	ld	A,(hl)
	inc A
	and #0x03
	ld	(hl),A
	
	call _updateDisplaySynth
	
	call _setPlayMarker
	jr _asmMain
ret

_asmLoadWav::
push bc
    lda hl,4(sp)        ; Load a stack offset
    ld  A,(hl)          ; Load micro offset into a

    ld bc,#_wavShapeLast
	ld (bc),A

	ld	HL, #_wavData; load HL with the beginning 
	ld  C, A
	ld  B, #0x00
	add  HL, BC
	
	
	;ld	HL, #_wavData; load HL with the beginning
	ld	C,#0x30	; #0xFF30 is the bottom of wave RAM
	ld	A, #0x00		; \
	ld	(#0xFF1A),A	; / Turn off wave channel

	; Copy
	; 1
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 2
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 3
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 4
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 5
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 6
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 7
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 8
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer
	
	; 9
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 10
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 11
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 12
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 13
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 14
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 15
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer

	; 16
	ld	A,(HL+)		; Load 1 byte... (And increment source pointer)
	ldh (C),A	; ... and dump it into wave RAM
	inc	C		; Increment target pointer
	
	ld	A, #0x80		; \
	ld	(#0xFF1A),A	; / Turn on wave channel
	
	
	ld	hl, #_wavCurrentFreq
	ld	A, (hl+)
	ld	(#0xFF1D),A
	
	ld  A,(hl)
	or  #0x80
	ld	(#0xFF1E),A
	
    ld hl,#_systemIdle
	ld (hl),#0x00
pop	bc
ret