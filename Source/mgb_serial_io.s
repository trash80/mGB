.globl _update_port_io
_update_port_io:
	ld	hl,#_midiDataWritePosition
    inc	(hl)
	ld	a,#<_midiData
	add	a,(hl)
	ld	e,a
	ld	a,#>_midiData
	adc	a,#0x00
	ld	d,a
	ldh	a,(0x01)
	ld	(de),a
	RET