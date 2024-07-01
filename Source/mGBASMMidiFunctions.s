.module mGBASMMidiFunctions

_asmUpdateMidiBuffer::
push bc
	ld	hl,#_serialBufferPosition
	ld  A, (hl)
	ld	hl,#_serialBufferReadPosition
  cp  (hl)
	jr z,_popReturn$

	inc (hl)

	ld	A,#<_serialBuffer
    add	A,(hl)
	ld	E,A
    ld	A,#>_serialBuffer
	ld	D,A
	ld	A,(DE)

	bit	7,A
	jr nz,_asmUpdateMidiBufferStatus$

	ld	hl,#_capturedAddress
	bit	0,(hl)
	jr z,_asmUpdateMidiBufferAddress$

	ld	hl,#_capturedAddress
	ld (hl),#0x00
	ld	hl,#_valueByte
	ld (hl),A
	ld hl,#_systemIdle
	ld (hl),#0x00

	ld	hl,#_statusByte
	ld	A,(hl)
	ld	B,A
	SWAP A
	AND	#0x0F

	cp	#0x0E
		jr z,_asmEventMidiPB$
	cp	#0x0B
		jr z,_asmEventMidiCC$
	cp	#0x08
		jr z,_asmEventMidiNoteOff$
	cp	#0x09
		jr z,_asmEventMidiNote$
	cp	#0x0C
		jp z,_asmEventMidiPC$
pop	bc
ret

_popReturn$::
pop	bc
ret

_asmUpdateMidiBufferStatus$::
	ld	B,A
	AND	#0xF0
	cp	#0xF0
		jr z,_popReturn$
	ld	A,B

	ld	hl,#_statusByte
	ld (hl),A
	ld	hl,#_capturedAddress
	ld (hl),#0x00

	ld hl,#_systemIdle
	ld (hl),#0x00
pop	bc
ret

_asmUpdateMidiBufferAddress$::
	ld (hl),#0x01
	ld	hl,#_addressByte
	ld (hl),A

	ld hl,#_systemIdle
	ld (hl),#0x00
pop	bc
ret

_asmEventMidiNoteOff$::
	ld	hl,#_valueByte
	ld	(hl),#0x00
	jr _asmEventMidiNote$
pop	bc
ret

_asmEventMidiNote$::
	ld	A,B
	AND	#0x0F
	cp	#0x00
		jp z,_asmPlayNotePu1;
	cp	#0x01
		jp z,_asmPlayNotePu2$;
	cp	#0x02
		jp z,_asmPlayNoteWav$;
	cp	#0x03
		jp z,_asmPlayNoteNoi$;
	cp	#0x04
		jp z,_asmPlayNotePoly$;
pop	bc
ret

_asmEventMidiCC$::
	ld	A,B
	AND	#0x0F
	cp	#0x00
		jp z,_asmEventMidiCCPu1$;
	cp	#0x01
		jp z,_asmEventMidiCCPu2$;
	cp	#0x02
		jp z,_asmEventMidiCCWav$;
	cp	#0x03
		jp z,_asmEventMidiCCNoi$;
	cp	#0x04
		jp z,_asmEventMidiCCPoly$;
pop	bc
ret

_asmEventMidiPB$::
	ld	A,B
	AND	#0x0F
	cp	#0x00
		jp z,_asmPu1MidiPb$;
	cp	#0x01
		jp z,_asmPu2MidiPb$;
	cp	#0x02
		jp z,_asmWavMidiPb$;
	cp	#0x03
		jp z,_asmNoiMidiPb$;
	cp	#0x04
		jp z,_asmPolyMidiPb$;
pop	bc
ret

_asmEventMidiPC$::
	ld	A,B
	AND	#0x0F
	cp	#0x00
		jp z,_asmPu1Lod$;
	cp	#0x01
		jp z,_asmPu2Lod$;
	cp	#0x02
		jp z,_asmWavLod$;
	cp	#0x03
		jp z,_asmNoiLod$;
	cp	#0x04
		jp z,_asmPolyLod$;
pop	bc
ret

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
_asmPu1MidiPb$::
	ld	hl, #_valueByte
	ld	A,(hl)
	ld	hl, #_addressByte
	ld	B,(hl)
	RLCA
	ld  C,A
	ld	A,B
	RLCA
	RLCA
	AND	#0x01
	OR	C

	ld	de,#_pbWheelIn + 0
    ld	(de),A
pop	bc
ret

_asmPu2MidiPb$::
	ld	hl, #_valueByte
	ld	A,(hl)
	ld	hl, #_addressByte
	ld	B,(hl)
	RLCA
	ld  C,A
	ld	A,B
	RLCA
	RLCA
	AND	#0x01
	OR	C

	ld	de,#_pbWheelIn + 1
    ld	(de),A
pop	bc
ret

_asmWavMidiPb$::
	ld	hl, #_valueByte
	ld	A,(hl)
	ld	hl, #_addressByte
	ld	B,(hl)
	RLCA
	ld  C,A
	ld	A,B
	RLCA
	RLCA
	AND	#0x01
	OR	C

	ld	de,#_pbWheelIn + 2
    ld	(de),A
pop	bc
ret

_asmNoiMidiPb$::
	ld	hl, #_valueByte
	ld	A,(hl)
	ld	hl, #_addressByte
	ld	B,(hl)
	RLCA
	ld  C,A
	ld	A,B
	RLCA
	RLCA
	AND	#0x01
	OR	C

	ld	de,#_pbWheelIn + 3
    ld	(de),A
pop	bc
ret

_asmPolyMidiPb$::
	ld	hl, #_valueByte
	ld	A,(hl)
	ld	hl, #_addressByte
	ld	B,(hl)
	RLCA
	ld  C,A
	ld	A,B
	RLCA
	RLCA
	AND	#0x01
	OR	C

	ld	de,#_pbWheelIn + 0
    ld	(de),A
	ld	de,#_pbWheelIn + 1
    ld	(de),A
	ld	de,#_pbWheelIn + 2
    ld	(de),A
pop	bc
ret



;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
_asmEventMidiCCPu1$::
	ld	hl,#_addressByte
	ld	A,(hl)
	cp	#0x01
		jr z,_asmPu1Wav$;
	cp	#0x02
		jr z,_asmPu1Env$;
	cp	#0x03
		jr z,_asmPu1Swp$;
	cp	#0x04
		jp z,_asmPu1Pbr$;
	cp	#0x05
		jp z,_asmPu1Lod$;
	cp	#0x0A
		jp z,_asmPu1Pan$;
	cp	#0x0B
		jp z,_asmPu1VD$;
	cp	#0x0C
		jp z,_asmPu1VR$;
	cp	#0x40
		jp z,_asmPu1Sus$;
	cp	#0x7B
		jp z,_asmPu1Nf$;
pop	bc
ret

_asmPu1Wav$::
	ld	de,#_parameterLock + 1
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)

	RLCA
	AND #0xC0
	OR #0x07
	ld (#0xFF11),A

	SWAP A
	RRCA
	RRCA
	AND #0x03
	ld	de,#_dataSet + 1
    ld	(de),A
pop	bc
ret


_asmPu1Env$::
	ld	de,#_parameterLock + 2
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)

	RRCA
	RRCA
	RRCA
	AND #0x0F

	ld	hl,#_pu1Env
	ld	(hl),A

	ld	de,#_dataSet + 2
    ld	(de),A
pop	bc
ret


_asmPu1Swp$::
	ld	de,#_parameterLock + 3
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)

	ld (#0xFF10),A

	ld	de,#_dataSet + 3
    ld	(de),A
pop	bc
ret


_asmPu1Pbr$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_pbRange + 0
    ld	(de),A

	ld	de,#_dataSet + 4
    ld	(de),A
pop	bc
ret


_asmPu1Lod$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_dataSet + 24
    ld	(de),A

	ld	a,#0x00
	push	af
	inc	sp
	call	_loadDataSet
    lda	sp,1(sp)
	ld	a,#0x00
	push	af
	inc	sp
	call	_updateSynth
    lda	sp,1(sp)
pop	bc
ret


_asmPu1Pan$::
	ld	de,#_parameterLock + 6
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)
	AND #0x60
	cp A, #0x00
	jr z, _asmPu1PanLeft$
	cp A, #0x20
	jr z, _asmPu1PanCenter$
	cp A, #0x40
	jr z, _asmPu1PanCenter$
	cp A, #0x60
	jr z, _asmPu1PanRight$
_asmPu1PanLeft$::
	ld	A,#0x02
	ld	de,#_dataSet + 6
    ld	(de),A
	ld  B,#0x10

	ld  A,(#0xFF25)
	and #0xEE
	or	B
	ld (#0xFF25),A
pop	bc
ret
_asmPu1PanCenter$::
	ld	A,#0x03
	ld	de,#_dataSet + 6
    ld	(de),A
	ld  B,#0x11

	ld  A,(#0xFF25)
	and #0xEE
	or	B
	ld (#0xFF25),A
pop	bc
ret
_asmPu1PanRight$::
	ld	A,#0x01
	ld	de,#_dataSet + 6
    ld	(de),A
	ld  B,#0x01

	ld  A,(#0xFF25)
	and #0xEE
	or	B
	ld (#0xFF25),A
pop	bc
ret


_asmPu1VD$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoDepth + 0
    ld	(de),A

pop	bc
ret


_asmPu1VR$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoSpeed + 0
    ld	(de),A
pop	bc
ret


_asmPu1Sus$::
	ld	hl,#_valueByte
	ld	A,(hl)
	bit 6,A
	jr nz, _asmPu1SusOn$
	jr _asmPu1SusOff$
_asmPu1SusOn$::
	ld	A,#0x01
	ld	de,#_dataSet + 5
    ld	(de),A
	ld	hl,#_pu1Sus
    ld	(hl),A
pop	bc
ret
_asmPu1SusOff$::
	ld	A,#0x00
	ld	de,#_dataSet + 5
    ld	(de),A
	ld	hl,#_pu1Sus
    ld	(hl),A

	ld	hl,#_noteStatus + 0
	ld	A,(hl)
	bit 0,A
	jr z, _asmPu1SusNoteOff$
pop	bc
ret
_asmPu1SusNoteOff$::
	ld	A,#0x00
	ld	(#0xFF12),A
pop	bc
ret


_asmPu1Nf$::
	ld	A,#0x00
	ld (#0xFF12),A
	ld	hl,#_pu1Sus
    ld	(hl),A
	ld	de,#_dataSet + 5
    ld	(de),A
pop	bc
ret


;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
_asmEventMidiCCPu2$::
	ld	hl,#_addressByte
	ld	A,(hl)
	cp	#0x01
		jr z,_asmPu2Wav$;
	cp	#0x02
		jr z,_asmPu2Env$;
	cp	#0x04
		jp z,_asmPu2Pbr$;
	cp	#0x05
		jp z,_asmPu2Lod$;
	cp	#0x0A
		jp z,_asmPu2Pan$;
	cp	#0x0B
		jp z,_asmPu2VD$;
	cp	#0x0C
		jp z,_asmPu2VR$;
	cp	#0x40
		jp z,_asmPu2Sus$;
	cp	#0x7B
		jp z,_asmPu2Nf$;
pop	bc
ret

_asmPu2Wav$::
	ld	de,#_parameterLock + 8
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)

	RLCA
	AND #0xC0
	OR #0x07
	ld (#0xFF16),A

	SWAP A
	RRCA
	RRCA
	AND #0x03
	ld	de,#_dataSet + 8
    ld	(de),A
pop	bc
ret


_asmPu2Env$::
	ld	de,#_parameterLock + 9
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)

	RRCA
	RRCA
	RRCA
	AND #0x0F

	ld	hl,#_pu2Env
	ld	(hl),A

	ld	de,#_dataSet + 9
    ld	(de),A
pop	bc
ret

_asmPu2Pbr$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_pbRange + 1
    ld	(de),A

	ld	de,#_dataSet + 10
    ld	(de),A
pop	bc
ret


_asmPu2Lod$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_dataSet + 25
    ld	(de),A

	ld	a,#0x01
	push	af
	inc	sp
	call	_loadDataSet
    lda	sp,1(sp)
	ld	a,#0x01
	push	af
	inc	sp
	call	_updateSynth
    lda	sp,1(sp)
pop	bc
ret


_asmPu2Pan$::
	ld	de,#_parameterLock + 12
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)
	AND #0x60
	cp A, #0x00
	jr z, _asmPu2PanLeft$
	cp A, #0x20
	jr z, _asmPu2PanCenter$
	cp A, #0x40
	jr z, _asmPu2PanCenter$
	cp A, #0x60
	jr z, _asmPu2PanRight$
_asmPu2PanLeft$::
	ld	A,#0x02
	ld	de,#_dataSet + 12
    ld	(de),A
	ld  B,#0x20

	ld  A,(#0xFF25)
	and #0xDD
	or	B
	ld (#0xFF25),A
pop	bc
ret
_asmPu2PanCenter$::
	ld	A,#0x03
	ld	de,#_dataSet + 12
    ld	(de),A
	ld  B,#0x22

	ld  A,(#0xFF25)
	and #0xDD
	or	B
	ld (#0xFF25),A
pop	bc
ret
_asmPu2PanRight$::
	ld	A,#0x01
	ld	de,#_dataSet + 12
    ld	(de),A
	ld  B,#0x02

	ld  A,(#0xFF25)
	and #0xDD
	or	B
	ld (#0xFF25),A
pop	bc
ret


_asmPu2VD$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoDepth + 1
    ld	(de),A

pop	bc
ret


_asmPu2VR$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoSpeed + 1
    ld	(de),A
pop	bc
ret


_asmPu2Sus$::
	ld	hl,#_valueByte
	ld	A,(hl)
	bit 6,A
	jr nz, _asmPu2SusOn$
	jr _asmPu2SusOff$
_asmPu2SusOn$::
	ld	A,#0x01
	ld	de,#_dataSet + 11
    ld	(de),A
	ld	hl,#_pu2Sus
    ld	(hl),A
pop	bc
ret
_asmPu2SusOff$::
	ld	A,#0x00
	ld	de,#_dataSet + 11
    ld	(de),A
	ld	hl,#_pu2Sus
    ld	(hl),A

	ld	hl,#_noteStatus + 5
	ld	A,(hl)
	bit 0,A
	jr z, _asmPu2SusNoteOff$
pop	bc
ret
_asmPu2SusNoteOff$::
	ld	A,#0x00
	ld	(#0xFF17),A
pop	bc
ret


_asmPu2Nf$::
	ld	A,#0x00
	ld (#0xFF17),A
	ld	hl,#_pu2Sus
    ld	(hl),A
	ld	de,#_dataSet + 11
    ld	(de),A
pop	bc
ret

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
_asmEventMidiCCWav$::
	ld	hl,#_addressByte
	ld	A,(hl)
	cp	#0x01
		jr z,_asmWavWav$;
	cp	#0x02
		jr z,_asmWavOst$;
	cp	#0x03
		jr z,_asmWavSwp$;
	cp	#0x04
		jp z,_asmWavPbr$;
	cp	#0x05
		jp z,_asmWavLod$;
	cp	#0x0A
		jp z,_asmWavPan$;
	cp	#0x0B
		jp z,_asmWavVD$;
	cp	#0x0C
		jp z,_asmWavVR$;
	cp	#0x40
		jp z,_asmWavSus$;
	cp	#0x7B
		jp z,_asmWavNf$;
pop	bc
ret


_asmWavWav$::
	ld	de,#_parameterLock + 14
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)
	RLCA
	AND #0xF0
	SWAP A

	ld	de,#_dataSet + 14
    ld	(de),A

	SWAP A

	ld	hl,#_dataSet + 15
	ADD A,(hl)
	ld	hl,#_wavDataOffset
	ld	(hl),A
pop	bc
ret


_asmWavOst$::
	ld	de,#_parameterLock + 15
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)
	RRCA
	RRCA
	AND #0x1F
	ld	de,#_dataSet + 15
    ld	(de),A
	ld	B,A

	ld	hl,#_dataSet + 14
	ld  A,(hl)
	SWAP A
	ADD B

	ld	hl,#_wavDataOffset
	ld	(hl),A
pop	bc
ret


_asmWavSwp$::
	ld	de,#_parameterLock + 16
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)
	RLCA
	SWAP A
	AND #0x0F
	ld hl,#_wavSweepSpeed
	ld (hl),A
	ld	de,#_dataSet + 16
    ld	(de),A
pop	bc
ret


_asmWavPbr$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_pbRange + 2
    ld	(de),A

	ld	de,#_dataSet + 17
    ld	(de),A
pop	bc
ret


_asmWavLod$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_dataSet + 26
    ld	(de),A

	ld	a,#0x02
	push	af
	inc	sp
	call	_loadDataSet
    lda	sp,1(sp)
	ld	a,#0x02
	push	af
	inc	sp
	call	_updateSynth
    lda	sp,1(sp)
pop	bc
ret


_asmWavPan$::
	ld	de,#_parameterLock + 12
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)
	AND #0x60
	cp A, #0x00
	jr z, _asmWavPanLeft$
	cp A, #0x20
	jr z, _asmWavPanCenter$
	cp A, #0x40
	jr z, _asmWavPanCenter$
	cp A, #0x60
	jr z, _asmWavPanRight$
_asmWavPanLeft$::
	ld	A,#0x02
	ld	de,#_dataSet + 19
    ld	(de),A
	ld  B,#0x40

	ld  A,(#0xFF25)
	and #0xBB
	or	B
	ld (#0xFF25),A
pop	bc
ret
_asmWavPanCenter$::
	ld	A,#0x03
	ld	de,#_dataSet + 19
    ld	(de),A
	ld  B,#0x44

	ld  A,(#0xFF25)
	and #0xBB
	or	B
	ld (#0xFF25),A
pop	bc
ret
_asmWavPanRight$::
	ld	A,#0x01
	ld	de,#_dataSet + 19
    ld	(de),A
	ld  B,#0x04

	ld  A,(#0xFF25)
	and #0xBB
	or	B
	ld (#0xFF25),A
pop	bc
ret


_asmWavVD$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoDepth + 2
    ld	(de),A

pop	bc
ret


_asmWavVR$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoSpeed + 2
    ld	(de),A
pop	bc
ret


_asmWavSus$::
	ld	hl,#_valueByte
	ld	A,(hl)
	bit 6,A
	jr nz, _asmWavSusOn$
	jr _asmWavSusOff$
_asmWavSusOn$::
	ld	A,#0x01
	ld	de,#_dataSet + 18
    ld	(de),A
	ld	hl,#_wavSus
    ld	(hl),A
pop	bc
ret
_asmWavSusOff$::
	ld	A,#0x00
	ld	de,#_dataSet + 18
    ld	(de),A
	ld	hl,#_wavSus
    ld	(hl),A

	ld	hl,#_noteStatus + 10
	ld	A,(hl)
	bit 0,A
	jr z, _asmWavSusNoteOff$
pop	bc
ret
_asmWavSusNoteOff$::
	ld	A,#0x00
	ld	(#0xFF1C),A
pop	bc
ret


_asmWavNf$::
	ld	A,#0x00
	ld (#0xFF1C),A
	ld	hl,#_wavSus
    ld	(hl),A
	ld	de,#_dataSet + 11
    ld	(de),A
pop	bc
ret

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
_asmEventMidiCCNoi$::
	ld	hl,#_addressByte
	ld	A,(hl)
	cp	#0x02
		jr z,_asmNoiEnv$;
	cp	#0x05
		jr z,_asmNoiLod$;
	cp	#0x0A
		jp z,_asmNoiPan$;
	cp	#0x0B
		jp z,_asmNoiVD$;
	cp	#0x0C
		jp z,_asmNoiVR$;
	cp	#0x40
		jp z,_asmNoiSus$;
	cp	#0x7B
		jp z,_asmNoiNf$;
pop	bc
ret


_asmNoiEnv$::
	ld	de,#_parameterLock + 21
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)

	RRCA
	RRCA
	RRCA
	AND #0x0F

	ld	hl,#_noiEnv
	ld	(hl),A

	ld	de,#_dataSet + 21
    ld	(de),A
pop	bc
ret


_asmNoiLod$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_dataSet + 27
    ld	(de),A

	ld	a,#0x03
	push	af
	inc	sp
	call	_loadDataSet
    lda	sp,1(sp)
	ld	a,#0x03
	push	af
	inc	sp
	call	_updateSynth
    lda	sp,1(sp)
pop	bc
ret


_asmNoiPan$::
	ld	de,#_parameterLock + 23
	ld	A,(de)
	bit 0, A
	jp nz, _popReturn$

	ld	hl,#_valueByte
	ld	A,(hl)
	AND #0x60
	cp A, #0x00
	jr z, _asmNoiPanLeft$
	cp A, #0x20
	jr z, _asmNoiPanCenter$
	cp A, #0x40
	jr z, _asmNoiPanCenter$
	cp A, #0x60
	jr z, _asmNoiPanRight$
_asmNoiPanLeft$::
	ld	A,#0x02
	ld	de,#_dataSet + 23
    ld	(de),A
	ld  B,#0x80

	ld  A,(#0xFF25)
	and #0x77
	or	B
	ld (#0xFF25),A
pop	bc
ret
_asmNoiPanCenter$::
	ld	A,#0x03
	ld	de,#_dataSet + 23
    ld	(de),A
	ld  B,#0x88

	ld  A,(#0xFF25)
	and #0x77
	or	B
	ld (#0xFF25),A
pop	bc
ret
_asmNoiPanRight$::
	ld	A,#0x01
	ld	de,#_dataSet + 23
    ld	(de),A
	ld  B,#0x08

	ld  A,(#0xFF25)
	and #0x77
	or	B
	ld (#0xFF25),A
pop	bc
ret


_asmNoiVD$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoDepth + 3
    ld	(de),A

pop	bc
ret


_asmNoiVR$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoSpeed + 3
    ld	(de),A
pop	bc
ret


_asmNoiSus$::
	ld	hl,#_valueByte
	ld	A,(hl)
	bit 6,A
	jr nz, _asmNoiSusOn$
	jr _asmNoiSusOff$
_asmNoiSusOn$::
	ld	A,#0x01
	ld	de,#_dataSet + 22
    ld	(de),A
	ld	hl,#_noiSus
    ld	(hl),A
pop	bc
ret
_asmNoiSusOff$::
	ld	A,#0x00
	ld	de,#_dataSet + 22
    ld	(de),A
	ld	hl,#_noiSus
    ld	(hl),A

	ld	hl,#_noteStatus + 15
	ld	A,(hl)
	bit 0,A
	jr z, _asmNoiSusNoteOff$
pop	bc
ret
_asmNoiSusNoteOff$::
	ld	A,#0x00
	ld	(#0xFF21),A
pop	bc
ret


_asmNoiNf$::
	ld	A,#0x00
	ld (#0xFF21),A
	ld	hl,#_noiSus
    ld	(hl),A
	ld	de,#_dataSet + 22
    ld	(de),A
pop	bc
ret

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
_asmEventMidiCCPoly$::
	ld	hl,#_addressByte
	ld	A,(hl)

	cp	#0x01
		jr z,_asmPolyWav$;
	cp	#0x02
		jr z,_asmPolyEnv$;
	cp	#0x05
		jr z,_asmPolyLod$;
	cp	#0x0A
		jr z,_asmPolyPan$;
	cp	#0x40
		jr z,_asmPolySus$;
	cp	#0x7B
		jr z,_asmPolyNf$;
pop	bc
ret

_asmPolyWav$::
	call _asmPu1Wav$;
push	bc
	call _asmPu2Wav$;
push	bc
	call _asmWavWav$;
ret

_asmPolyEnv$::
	call _asmPu1Env$;
push	bc
	call _asmPu2Env$;
ret

_asmPolyLod$::
	call _asmPu1Lod$;
push	bc
	call _asmPu2Lod$;
push	bc
	call _asmWavLod$;
ret

_asmPolyPan$::
	call _asmPu1Pan$;
push	bc
	call _asmPu2Pan$;
push	bc
	call _asmWavPan$;
ret

_asmPolySus$::
	call _asmPu1Sus$;
push	bc
	call _asmPu2Sus$;
push	bc
	call _asmWavSus$;
ret

_asmPolyNf$::
	call _asmPu1Nf$;
push	bc
	call _asmPu2Nf$;
push	bc
	call _asmWavNf$;
ret
