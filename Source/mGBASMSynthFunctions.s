.module mGBASMSynthFunctions

_asmUpdatePu1::
push bc
	ld	hl, #_pu1NoteOffTrigger
	ld	A,(hl)
	bit 0,A
	jr nz, _asmUpdatePu1Noff$

	ld	hl, #_pbWheelIn + 0
	ld	A,(hl)
	cp #0x80
	jr nz, _asmUpdatePu1PbWheel$

	ld	hl, #_pbWheelActive + 0
	ld	A,(hl)
	bit 0,A
	jr nz, _asmUpdatePu1PbWheelReset$
pop bc
ret

_asmUpdatePu1Noff$::
	ld	A,#0x00
	ld (#0xFF12),A
	ld (hl),A
pop bc
ret

_asmUpdatePu1PbWheel$::
	ld	hl, #_pbWheelInLast + 0
	cp (hl)
	jr nz, _asmUpdatePu1PbWheelSet$

	ld	A, #0x01
	ld	hl, #_pbWheelActive + 0
	ld	(hl), A
pop bc
ret
_asmUpdatePu1PbWheelSet$::
	ld	(hl), A

  ld	A, #0x01
	ld	hl, #_pbWheelActive + 0
	ld	(hl), A

  ld	A, #0x00
  push	af
  inc	sp
  call	_setPitchBendFrequencyOffset
  inc	sp
pop bc
ret

_asmUpdatePu1PbWheelReset$::
	ld	A, #0x00
	ld	(hl), A
	ld	A, #0x80
	ld	hl, #_pbWheelInLast + 0
	ld	(hl), A

	ld	hl, #_noteStatus + 1
	ld	A,(hl)
	ld	B,A

	ld	A,#<_freq
    add	A,B
    add	A,B
	ld	E,A
    ld	A,#>_freq
	ld	D,A

	ld  A,(DE)
	ld	(#0xFF13),A
	ld	hl, #_currentFreqData + 0
	ld	(hl+), A

	inc	DE

	ld  A,(DE)
	ld	(hl), A
	ld	(#0xFF14),A
pop bc
ret

;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------

_asmUpdatePu2::
push bc
	ld	hl, #_pu2NoteOffTrigger
	ld	A,(hl)
	bit 0,A
	jr nz, _asmUpdatePu2Noff$

	ld	hl, #_pbWheelIn + 1
	ld	A,(hl)
	cp #0x80
	jr nz, _asmUpdatePu2PbWheel$

	ld	hl, #_pbWheelActive + 1
	ld	A,(hl)
	bit 0,A
	jr nz, _asmUpdatePu2PbWheelReset$
pop bc
ret

_asmUpdatePu2Noff$::
	ld	A,#0x00
	ld (#0xFF17),A
	ld (hl),A
pop bc
ret

_asmUpdatePu2PbWheel$::
	ld	hl, #_pbWheelInLast + 1
	cp (hl)
	jr nz, _asmUpdatePu2PbWheelSet$

	ld	A, #0x01
	ld	hl, #_pbWheelActive + 1
	ld	(hl), A
pop bc
ret
_asmUpdatePu2PbWheelSet$::
	ld	(hl), A

	ld	A, #0x01
	ld	hl, #_pbWheelActive + 1
	ld	(hl), A

  ld	A, #0x01
  push	af
  inc	sp
  call	_setPitchBendFrequencyOffset
  inc	sp
pop bc
ret

_asmUpdatePu2PbWheelReset$::
	ld	A, #0x00
	ld	(hl), A
	ld	A, #0x80
	ld	hl, #_pbWheelInLast + 1
	ld	(hl), A

	ld	hl, #_noteStatus + 3
	ld	A,(hl)
	ld	B,A


	ld	A,#<_freq
    add	A,B
    add	A,B
	ld	E,A
    ld	A,#>_freq
	ld	D,A

	ld  A,(DE)
	ld	(#0xFF18),A
	ld	hl, #_currentFreqData + 2
	ld	(hl+), A

	inc	DE

	ld  A,(DE)
	ld	(hl), A
	ld	(#0xFF19),A
pop bc
ret

;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------

_asmUpdateWav::
push bc
	ld	hl, #_wavNoteOffTrigger
	ld	A,(hl)
	bit 0,A
	jr nz, _asmUpdateWavNoff$

	ld	hl, #_wavShapeLast
	ld	A,(hl)
	ld	hl, #_wavDataOffset
	cp	(hl)
	jr nz, _asmUpdateWavData$


	ld	hl, #_pbWheelIn + 2
	ld	A,(hl)
	cp #0x80
	jr nz, _asmUpdateWavPbWheel$

	ld	hl, #_pbWheelActive + 2
	ld	A,(hl)
	bit 0,A
	jr nz, _asmUpdateWavPbWheelReset$

pop bc
ret

_asmUpdateWavNoff$::
	ld	A,#0x00
	ld (#0xFF1C),A
	ld (hl),A
pop bc
ret



_asmUpdateWavData$::
	ld	A,(hl)
	push	af
	inc	sp
	call _asmLoadWav
	lda	sp,1(sp)

	ld	A, #0x80
	ld	hl, #_pbWheelInLast + 2
	ld	(hl), A
pop bc
ret

_asmUpdateWavPbWheel$::
	ld	hl, #_pbWheelInLast + 2
	cp (hl)
	jr nz, _asmUpdateWavPbWheelSet$

	ld	A, #0x01
	ld	hl, #_pbWheelActive + 2
	ld	(hl), A
pop bc
ret
_asmUpdateWavPbWheelSet$::
	ld	(hl), A

	ld	A, #0x01
	ld	hl, #_pbWheelActive + 2
	ld	(hl), A

  ld	A, #0x02
  push	af
  inc	sp
  call	_setPitchBendFrequencyOffset
  inc	sp
pop bc
ret

_asmUpdateWavPbWheelReset$::
	ld	A, #0x00
	ld	(hl), A
	ld	A, #0x80
	ld	hl, #_pbWheelInLast + 2
	ld	(hl), A

	ld	hl, #_noteStatus + 5
	ld	A,(hl)
	ld	B,A

	ld	A,#<_freq
    add	A,B
    add	A,B
	ld	E,A
    ld	A,#>_freq
	ld	D,A

	ld  A,(DE)

	ld	hl, #_wavCurrentFreq
	ld	(hl), A
	ld	hl, #_currentFreqData + 4
	ld	(hl), A
	ld  C,A
	;ld  A,#0x00
	;ld	(#0xFF1E),A
	ld  A,C
	ld	(#0xFF1D),A

	inc	DE
	ld  A,(DE)

	inc	hl
	ld	(hl), A

	ld	hl, #_wavCurrentFreq + 1
	ld	(hl), A

	and  #0x7F
	ld	(#0xFF1E),A
pop bc
ret

;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------

_asmUpdateNoi::
push bc
	ld	hl, #_pbWheelIn + 3
	ld	A,(hl)
	cp #0x80
	jr nz, _asmUpdateNoiPbWheel$

	ld	hl, #_pbWheelActive + 3
	ld	A,(hl)
	bit 0,A
	jr nz, _asmUpdateNoiPbWheelReset$
pop bc
ret

_asmUpdateNoiPbWheel$::
	ld	hl, #_pbWheelInLast + 3
	cp (hl)
	jr nz, _asmUpdateNoiPbWheelSet$

	ld	A, #0x01
	ld	hl, #_pbWheelActive + 3
	ld	(hl), A
pop bc
ret
_asmUpdateNoiPbWheelSet$::
	ld	(hl), A

	ld	A, #0x01
	ld	hl, #_pbWheelActive + 3
	ld	(hl), A

  call	_setPitchBendFrequencyOffsetNoise
pop bc
ret

_asmUpdateNoiPbWheelReset$::
	ld	A, #0x00
	ld	(hl), A
	ld	A, #0x80
	ld	hl, #_pbWheelInLast + 3
	ld	(hl), A

	ld	hl, #_noteStatus + 3
	ld	A,(hl)
	ld	B,A

	ld	A,#<_noiFreq
    add	A,B
	ld	E,A
    ld	A,#>_noiFreq
	ld	D,A

	ld  A,(DE)
	ld	(#0xFF22),A
	ld	hl, #_currentFreqData + 6
	ld	(hl), A

	ld  A,#0xFF
	ld	(#0xFF20),A
	;ld  A,#0x80
	;ld	(#0xFF23),A
pop bc
ret

;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------

_asmPlayNotePu1::
	ld	hl, #_addressByte
	ld	A,(hl)
	SUB #0x24
	ld	hl, #_pu1Oct
	add (hl)

	ld  B, A
	ld	hl, #_valueByte
	ld	A,(hl)
	ld  C, A

	cp #0x00
	jr	nz,_asmPlayNotePu1OnSet$
	jr	_asmPlayNotePu1Off$

_asmPlayNotePu1OnSet$::
	ld	A, (#0xFF12)
	cp #0x00
	jr	z,_asmPlayNotePu1OnSetOn$
	jr	_asmPlayNotePu1OnSetOff$
_asmPlayNotePu1OnSetOn$::
	ld	A, #0x80
	ld	hl, #_pu1Trig
	ld	(hl),A

	ld	hl, #_pu1Vel
	ld	A,C
	ld  (hl),A
	RLCA
	AND #0xF0
	ld	hl, #_pu1Env
	OR	(hl)
	ld	(#0xFF12),A

	jr	_asmPlayNotePu1On$
_asmPlayNotePu1OnSetOff$::

	ld	hl, #_pu1Vel
	ld	A,(hl)
	cp  C
	jr  nz,_asmPlayNotePu1OnSetOn$
	ld  hl, #_pu1NoteOffTrigger
	ld	A, (hl)
	bit 0, A
	jr	nz,_asmPlayNotePu1OnSetOn$

	ld	A, #0x00
	ld	hl, #_pu1Trig
	ld	(hl),A

	jr	_asmPlayNotePu1On$
pop bc
ret


_asmPlayNotePu1On$::
	ld	hl, #_noteStatus + 1
	ld	(hl),B

	ld	A,#<_freq
    add	A,B
    add	A,B
	ld	E,A
    ld	A,#>_freq
	ld	D,A

	ld  A,(DE)
	ld	(#0xFF13),A
	ld	hl, #_currentFreqData + 0
	ld	(hl+), A

	inc	DE

	ld  A,(DE)
	ld	(hl), A

	ld	hl, #_pu1Trig
	ld  C,(hl)
	or  C
	ld	(#0xFF14),A

	ld	A,#0x00
	ld	hl,#_vibratoPosition + 0
	ld	(hl),A

	ld	A,#0x80
	ld	hl,#_pbWheelInLast + 0
	ld	(hl),A

	ld  hl,#_pbRange + 0
	ld  C,(hl)
	ld  A,B
	sub C
	ld	hl,#_pbNoteRange + 0
	ld	(hl+),A
	ld  A,B
	add C
	ld  (hl),A

	ld  A,#0x01
	ld	hl, #_noteStatus + 0
	ld	(hl),A

	ld	A,#0x00
	ld	hl, #_pu1NoteOffTrigger
	ld	(hl),A
pop bc
ret

_asmPlayNotePu1Off$::
	ld	hl, #_noteStatus + 1
	ld	A,(hl)
	cp	B
	jr	nz,_asmPlayNoteOffPu1Return$

	ld	hl, #_noteStatus + 0
	ld	A,#0x00
	ld (hl), A

	ld	hl, #_pu1Sus
	ld	A,(hl)
	bit	0, A
	jr	nz,_asmPlayNoteOffPu1Return$

	ld	A,#0x01
	ld	hl, #_pu1NoteOffTrigger
	ld	(hl),A

	;ld	A,#0x00
	;ld (#0xFF12),A
pop bc
ret

_asmPlayNoteOffPu1Return$::
pop bc
ret

;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------

_asmPlayNotePu2$::
	ld	hl, #_addressByte
	ld	A,(hl)
	SUB #0x24
	ld	hl, #_pu2Oct
	add (hl)

	ld  B, A
	ld	hl, #_valueByte
	ld	A,(hl)
	ld  C, A

	cp #0x00
	jr	nz,_asmPlayNotePu2OnSet$
	jr	_asmPlayNotePu2Off$

_asmPlayNotePu2OnSet$::
	ld	A, (#0xFF17)
	cp #0x00
	jr	z,_asmPlayNotePu2OnSetOn$
	jr	_asmPlayNotePu2OnSetOff$
_asmPlayNotePu2OnSetOn$::
	ld	A, #0x80
	ld	hl, #_pu2Trig
	ld	(hl),A

	ld	hl, #_pu2Vel
	ld	A,C
	ld  (hl),A
	RLCA
	AND #0xF0
	ld	hl, #_pu2Env
	OR	(hl)
	ld	(#0xFF17),A

	jr	_asmPlayNotePu2On$
_asmPlayNotePu2OnSetOff$::
	ld	hl, #_pu2Vel
	ld	A,(hl)
	cp  C
	jr  nz,_asmPlayNotePu2OnSetOn$
	ld  hl, #_pu2NoteOffTrigger
	ld	A, (hl)
	bit 0, A
	jr	nz,_asmPlayNotePu2OnSetOn$

	ld	A, #0x00
	ld	hl, #_pu2Trig
	ld	(hl),A

	jr	_asmPlayNotePu2On$
pop bc
ret

_asmPlayNotePu2On$::
	ld	hl, #_noteStatus + 3
	ld	(hl),B

	ld	A,#<_freq
    add	A,B
    add	A,B
	ld	E,A
    ld	A,#>_freq
	ld	D,A

	ld  A,(DE)
	ld	(#0xFF18),A
	ld	hl, #_currentFreqData + 2
	ld	(hl+), A

	inc	DE

	ld  A,(DE)
	ld	(hl), A
	ld	hl, #_pu2Trig
	ld  C,(hl)
	or  C
	ld	(#0xFF19),A

	ld	A,#0x00
	ld	hl,#_vibratoPosition + 1
	ld	(hl),A

	ld	A,#0x80
	ld	hl,#_pbWheelInLast + 1
	ld	(hl),A

	ld  hl,#_pbRange + 1
	ld  C,(hl)
	ld  A,B
	sub C
	ld	hl,#_pbNoteRange + 2
	ld	(hl+),A
	ld  A,B
	add C
	ld  (hl),A

	ld  A,#0x01
	ld	hl, #_noteStatus + 2
	ld	(hl),A

	ld	A,#0x00
	ld	hl, #_pu2NoteOffTrigger
	ld	(hl),A
pop bc
ret

_asmPlayNotePu2Off$::
	ld	hl, #_noteStatus + 3
	ld	A,(hl)
	cp	B
	jp	nz,_popReturn$

	ld	hl, #_noteStatus + 2
	ld	A,#0x00
	ld (hl), A

	ld	hl, #_pu2Sus
	ld	A,(hl)
	bit	0, A
	jp	nz,_popReturn$

	ld	A,#0x01
	ld	hl, #_pu2NoteOffTrigger
	ld	(hl),A

	;ld	A,#0x00
	;ld (#0xFF17),A
pop bc
ret


;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------


_asmPlayNoteWav$::
	ld	hl, #_addressByte
	ld	A,(hl)
	SUB #0x18
	ld	hl, #_wavOct
	add (hl)
	ld  B, A
	ld	hl, #_valueByte
	ld	A,(hl)
	ld  C, A

	cp #0x00
	jr	nz,_asmPlayNoteWavOn$
	jp	_asmPlayNoteWavOff$
pop bc
ret

_asmPlayNoteWavOn$::
	ld	hl, #_noteStatus + 5
	ld	(hl),B
	and #0x60
	cp #0x60
		jr z,_asmPlayNoteWavVolF$
	cp #0x40
		jr z,_asmPlayNoteWavVolM$
	ld	A,#0x60
	ld (#0xFF1C),A
	jr _asmPlayNoteWavSet$
pop bc
ret
_asmPlayNoteWavVolF$::
	ld	A,#0x20
	ld (#0xFF1C),A
	jr _asmPlayNoteWavSet$
pop bc
ret
_asmPlayNoteWavVolM$::
	ld	A,#0x40
	ld (#0xFF1C),A
	jr _asmPlayNoteWavSet$
pop bc
ret

_asmPlayNoteWavSet$::
	ld	A,#<_freq
    add	A,B
    add	A,B
	ld	E,A
    ld	A,#>_freq
	ld	D,A

	ld  A,(DE)

	ld	hl, #_wavCurrentFreq
	ld	(hl), A
	ld	hl, #_currentFreqData + 4
	ld	(hl), A
	ld  C,A
	ld  A,#0x00
	ld	(#0xFF1E),A
	ld  A,C
	ld	(#0xFF1D),A

	inc	DE
	ld  A,(DE)

	inc	hl
	ld	(hl), A

	ld	hl, #_wavCurrentFreq + 1
	ld	(hl), A

	ld	(#0xFF1E),A

	ld	A,#0x00
	ld	hl,#_vibratoPosition + 2
	ld	(hl),A

	ld	A,#0x00
	ld	hl,#_wavStepCounter
	ld	(hl),A
	ld	hl,#_counterWav
	ld	(hl+),A
	ld	(hl),A
	ld	hl,#_counterWavStart
	ld	(hl),A

	ld	A,#0x80
	ld	hl,#_pbWheelInLast + 2
	ld	(hl),A

	ld  hl,#_pbRange + 2
	ld  C,(hl)
	ld  A,B
	sub C
	ld	hl,#_pbNoteRange + 4
	ld	(hl+),A
	ld  A,B
	add C
	ld  (hl),A

	ld  A,#0x01
	ld	hl, #_noteStatus + 4
	ld	(hl),A
	ld	hl,#_cueWavSweep
	ld	(hl),A

	ld	A,#0x00
	ld	hl, #_wavNoteOffTrigger
	ld	(hl),A
pop bc
ret



_asmPlayNoteWavOff$::
	ld	hl, #_noteStatus + 5
	ld	A,(hl)
	cp	B
	jp	nz,_popReturn$


	ld	hl, #_noteStatus + 4
	ld	A,#0x00
	ld (hl), A

	ld	hl, #_wavSus
	ld	A,(hl)
	bit	0, A
	jp	nz,_popReturn$

	ld	A,#0x01
	ld	hl, #_wavNoteOffTrigger
	ld	(hl),A

	;ld	A,#0x00
	;ld (#0xFF1C),A
pop bc
ret


;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------

_asmPlayNoteNoi$::
	ld	hl, #_addressByte
	ld	A,(hl)
	SUB #0x18
	ld	hl, #_pu2Oct
	add (hl)
	ld  B, A
	ld	hl, #_valueByte
	ld	A,(hl)
	ld  C, A

	cp #0x00
	jr	nz,_asmPlayNoteNoiOn$
	jr	_asmPlayNoteNoiOff$
pop bc
ret

_asmPlayNoteNoiOn$::
	ld	hl, #_noteStatus + 7
	ld	(hl),B

	ld	hl, #_noiEnv
	ld	A,C
	RLCA
	AND #0xF0
	OR	(hl)
	ld	(#0xFF21),A

	ld	A,#<_noiFreq
    add	A,B
	ld	E,A
    ld	A,#>_noiFreq
	ld	D,A

	ld  A,(DE)
	ld	(#0xFF22),A
	ld	hl, #_currentFreqData + 6
	ld	(hl), A

	ld  A,#0xFF
	ld	(#0xFF20),A
	ld  A,#0x80
	ld	(#0xFF23),A

	ld	A,#0x00
	ld	hl,#_vibratoPosition + 3
	ld	(hl),A

	ld	A,#0x80
	ld	hl,#_pbWheelInLast + 3
	ld	(hl),A

	ld  A,#0x01
	ld	hl, #_noteStatus + 6
	ld	(hl),A
pop bc
ret

_asmPlayNoteNoiOff$::
	ld	hl, #_noteStatus + 7
	ld	A,(hl)
	cp	B
	jp	nz,_popReturn$

	ld	hl, #_noteStatus + 6
	ld	A,#0x00
	ld (hl), A

	ld	hl, #_pu2Sus
	ld	A,(hl)
	bit	0, A
	jp	nz,_popReturn$

	ld	A,#0x00
	ld (#0xFF21),A
pop bc
ret


;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------
;--------------------------------------------------------------

_asmPlayNotePoly$::
	ld	hl, #_addressByte
	ld	A,(hl)
	ld  B, A
	ld	hl, #_valueByte
	ld	A,(hl)
	ld  C, A

	cp #0x00
	jr	nz,_asmPlayNotePolyOn$
	jr	_asmPlayNotePolyOff$
pop bc
ret
_asmPlayNotePolyOff$::
	ld	hl,#_polyNoteState + 0
	ld	A,(hl)
	cp	B
	call z,_asmPlayNotePolyPu1Off$;

	ld	hl, #_addressByte
	ld	A,(hl)
	ld  B, A
	ld	hl,#_polyNoteState + 1
	ld	A,(hl)
	cp	B
	call z,_asmPlayNotePolyPu2Off$;

	ld	hl, #_addressByte
	ld	A,(hl)
	ld  B, A
	ld	hl,#_polyNoteState + 2
	ld	A,(hl)
	cp	B
	call z,_asmPlayNotePolyWavOff$;
pop bc
ret

_asmPlayNotePolyPu1Off$::
	call _asmPlayNotePu1
	push bc
ret
_asmPlayNotePolyPu2Off$::
	call _asmPlayNotePu2$
	push bc
ret
_asmPlayNotePolyWavOff$::
	call _asmPlayNoteWav$
	push bc
ret

_asmPlayNotePolyOn$::
	ld	hl,#_polyVoiceSelect
	ld	A,(hl)
	inc A
	cp	#0x03
	jr	z,_asmPlayNotePolyRst$
	jr	_asmPlayNotePolyCon$
pop bc
ret
_asmPlayNotePolyRst$::
	ld	A, #0x00
	jr	_asmPlayNotePolyCon$
pop bc
ret
_asmPlayNotePolyCon$::
	ld	(hl),A
	cp	#0x00
	jr	z,_asmPlayNotePolyPu1$
	cp	#0x01
	jr	z,_asmPlayNotePolyPu2$

	ld	hl,#_polyNoteState + 2
	ld	(hl),B
	jp	_asmPlayNoteWav$;
pop bc
ret
_asmPlayNotePolyPu1$::
	ld	hl,#_polyNoteState + 0
	ld	(hl),B
	jp	_asmPlayNotePu1;

pop bc
ret
_asmPlayNotePolyPu2$::
	ld	hl,#_polyNoteState + 1
	ld	(hl),B
	jp	_asmPlayNotePu2$;
pop bc
ret
