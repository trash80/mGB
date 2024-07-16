#include "mGB.h"

#define MIDI_STATUS_BIT 0x80
#define MIDI_STATUS_NOTE_ON 0x09
#define MIDI_STATUS_NOTE_OFF 0x08
#define MIDI_STATUS_AT 0x0A
#define MIDI_STATUS_CC 0x0B
#define MIDI_STATUS_PC 0x0C
#define MIDI_STATUS_AT_MONO 0x0D
#define MIDI_STATUS_PB 0x0E

#define MIDI_STATUS_SYSTEM 0xF0

void updateMidiBuffer(void) {
  if (serialBufferReadPosition == serialBufferPosition) {
    return;
  }

  serialBufferReadPosition++; // unsigned overflow from 255 -> 0 is automatic.

  UBYTE byte = serialBuffer[serialBufferReadPosition];

  // STATUS BYTE
  if (byte & MIDI_STATUS_BIT) {
    if ((byte & MIDI_STATUS_SYSTEM) == MIDI_STATUS_SYSTEM) {
      return;
    }
    statusByte = byte;
    capturedAddress = 0;
    systemIdle = 0;
    return;
  }

  // 2ND BYTE (note/CC control)
  if (!capturedAddress) {
    capturedAddress = 1;
    addressByte = byte;
    systemIdle = 0;
    return;
  }

  // 3RD BYTE (velocity/value)
  capturedAddress = 0;
  valueByte = byte;
  systemIdle = 0;

  switch ((statusByte >> 4) & 0x0F) {
  case MIDI_STATUS_PB:
    asmEventMidiPB();
    break;
  case MIDI_STATUS_CC:
    asmEventMidiCC();
    break;
  case MIDI_STATUS_NOTE_ON:
    asmEventMidiNote();
    break;
  case MIDI_STATUS_NOTE_OFF:
    asmEventMidiNoteOff();
    break;
  case MIDI_STATUS_PC:
    asmEventMidiPC();
    break;
  }
}