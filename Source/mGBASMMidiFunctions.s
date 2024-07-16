.module mGBASMMidiFunctions

_popReturn$::
ret

_asmEventMidiNoteOff::
	ld	hl,#_valueByte
	ld	(hl),#0x00
	jr _asmEventMidiNote
ret

_asmEventMidiNote::
	ld  a,(#_statusByte)
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
ret

_asmEventMidiCC::
	ld  a,(#_statusByte)
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
ret

_asmEventMidiPB::
	ld  a,(#_statusByte)
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
ret

_asmEventMidiPC::
	ld  a,(#_statusByte)
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
ret


_asmPu1Pbr$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_pbRange + 0
    ld	(de),A

	ld	de,#_dataSet + 4
    ld	(de),A
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
ret


_asmPu1VD$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoDepth + 0
    ld	(de),A

ret


_asmPu1VR$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoSpeed + 0
    ld	(de),A
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
ret
_asmPu1SusNoteOff$::
	ld	A,#0x00
	ld	(#0xFF12),A
ret


_asmPu1Nf$::
	ld	A,#0x00
	ld (#0xFF12),A
	ld	hl,#_pu1Sus
    ld	(hl),A
	ld	de,#_dataSet + 5
    ld	(de),A
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
ret

_asmPu2Pbr$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_pbRange + 1
    ld	(de),A

	ld	de,#_dataSet + 10
    ld	(de),A
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
ret


_asmPu2VD$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoDepth + 1
    ld	(de),A

ret


_asmPu2VR$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoSpeed + 1
    ld	(de),A
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
ret
_asmPu2SusNoteOff$::
	ld	A,#0x00
	ld	(#0xFF17),A
ret


_asmPu2Nf$::
	ld	A,#0x00
	ld (#0xFF17),A
	ld	hl,#_pu2Sus
    ld	(hl),A
	ld	de,#_dataSet + 11
    ld	(de),A
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
ret


_asmWavPbr$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_pbRange + 2
    ld	(de),A

	ld	de,#_dataSet + 17
    ld	(de),A
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
ret


_asmWavVD$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoDepth + 2
    ld	(de),A

ret


_asmWavVR$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoSpeed + 2
    ld	(de),A
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
ret
_asmWavSusNoteOff$::
	ld	A,#0x00
	ld	(#0xFF1C),A
ret


_asmWavNf$::
	ld	A,#0x00
	ld (#0xFF1C),A
	ld	hl,#_wavSus
    ld	(hl),A
	ld	de,#_dataSet + 11
    ld	(de),A
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
ret


_asmNoiVD$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoDepth + 3
    ld	(de),A

ret


_asmNoiVR$::
	ld	hl,#_valueByte
	ld	A,(hl)

	ld	de,#_vibratoSpeed + 3
    ld	(de),A
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
ret
_asmNoiSusNoteOff$::
	ld	A,#0x00
	ld	(#0xFF21),A
ret


_asmNoiNf$::
	ld	A,#0x00
	ld (#0xFF21),A
	ld	hl,#_noiSus
    ld	(hl),A
	ld	de,#_dataSet + 22
    ld	(de),A
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
ret

_asmPolyWav$::
	call _asmPu1Wav$;
	call _asmPu2Wav$;
	call _asmWavWav$;
ret

_asmPolyEnv$::
	call _asmPu1Env$;
	call _asmPu2Env$;
ret

_asmPolyLod$::
	call _asmPu1Lod$;
	call _asmPu2Lod$;
	call _asmWavLod$;
ret

_asmPolyPan$::
	call _asmPu1Pan$;
	call _asmPu2Pan$;
	call _asmWavPan$;
ret

_asmPolySus$::
	call _asmPu1Sus$;
	call _asmPu2Sus$;
	call _asmWavSus$;
ret

_asmPolyNf$::
	call _asmPu1Nf$;
	call _asmPu2Nf$;
	call _asmWavNf$;
ret
