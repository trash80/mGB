
UBYTE wavStepCounter;
/*
void updatePu1()
{
	if(pbWheelIn[PU1] != PBWHEEL_CENTER) {
		pbWheelActive[PU1] = 0x01U;

		if(pbWheelIn[PU1] != pbWheelInLast[PU1]) {
			pbWheelInLast[PU1] = pbWheelIn[PU1];
			setPitchBendFrequencyOffset(PU1,PU1_CURRENT_NOTE,0U);
		}
	} else if(pbWheelActive[PU1]) {
		pbWheelActive[PU1] = 0x00U;
		pbWheelInLast[PU1] = PBWHEEL_CENTER;
		NR14_REG = freq[noteStatus[PU1_CURRENT_NOTE]] >> 8U;
		NR13_REG = freq[noteStatus[PU1_CURRENT_NOTE]];
	}
//	if(vibratoDepth[PU1]) updateVibratoPosition(PU1);
}
void updatePu2()
{
	if(pbWheelIn[PU2] != PBWHEEL_CENTER) {
		pbWheelActive[PU2] = 1U;
		if(pbWheelIn[PU2] != pbWheelInLast[PU2]) {
			pbWheelInLast[PU2] = pbWheelIn[PU2];
			setPitchBendFrequencyOffset(PU2,PU2_CURRENT_NOTE,2U);
		}
	} else if(pbWheelActive[PU2]) {
		pbWheelActive[PU2] = 0U;
		pbWheelInLast[PU2] = PBWHEEL_CENTER;
		NR24_REG = freq[noteStatus[PU2_CURRENT_NOTE]] >> 8U;
		NR23_REG = freq[noteStatus[PU2_CURRENT_NOTE]];
	}
//	if(vibratoDepth[PU2]) updateVibratoPosition(PU2);
}

void updateWav()
{
	if(pbWheelIn[WAV] != PBWHEEL_CENTER) {
		pbWheelActive[WAV] = 1U;
		if(pbWheelIn[WAV] != pbWheelInLast[WAV]) {
			pbWheelInLast[WAV] = pbWheelIn[WAV];
			setPitchBendFrequencyOffset(WAV,WAV_CURRENT_NOTE,4U);
		}
	} else if(pbWheelActive[WAV]) {
		pbWheelActive[WAV] = 0U;
		pbWheelInLast[WAV] = PBWHEEL_CENTER;
		NR34_REG = freq[noteStatus[WAV_CURRENT_NOTE]] >> 8U;
		NR33_REG = freq[noteStatus[WAV_CURRENT_NOTE]];
		wavCurrentFreq = freq[noteStatus[WAV_CURRENT_NOTE]];
	}
	
	if(wavShapeLast != wavDataOffset) {
	  asmLoadWav(wavDataOffset);
  	  pbWheelInLast[WAV] = PBWHEEL_CENTER;
	}
}

void updateNoi()
{
	if(pbWheelIn[NOI] != PBWHEEL_CENTER) {
		systemIdle = 0;
		pbWheelActive[NOI] = 1U;
		if(pbWheelIn[NOI] != pbWheelInLast[NOI]) {
			pbWheelInLast[NOI] = pbWheelIn[NOI];
			setPitchBendFrequencyOffset(NOI,NOI_CURRENT_NOTE,6U);
		}
	} else if(pbWheelActive[NOI]) {
		pbWheelActive[NOI] = 0U;
		pbWheelInLast[NOI] = PBWHEEL_CENTER;
		NR43_REG = noiFreq[noteStatus[NOI_CURRENT_NOTE]];
	}
//	if(vibratoDepth[NOI]) updateVibratoPosition(NOI);
}


void playNotePu1()
{ 
	x = noteStatus[PU1_CURRENT_NOTE];
	note = addressByte;
	envelope = valueByte;
	note -=36U;
	if(envelope) {
		noteStatus[PU1_CURRENT_NOTE]=note;
		
		if(pu1Oct<0){
			if(note > (pu1Oct*-1)) note = note + pu1Oct;
		} else {
			note = note + pu1Oct;
		}
		if(pu1Oct!=0) while(note>71) note -=12;
		
		NR12_REG = ((envelope << 1U) & 0xF0U) + pu1Env; //Take a value from 0 to 127 and make it 0 to 255, and add in the envelope
		NR14_REG = 0x80+(freq[note]>>8U);
		NR13_REG = freq[note];
		currentFreqData[PU1] = freq[note];
		vibratoPosition[PU1]=0;
		
		pbNoteRange[0] = note - pbRange[0];
		pbNoteRange[1] = note + pbRange[0];
		
		noteStatus[PU1_CURRENT_STATUS]=1U;
	    //noteStatus[PU1_CURRENT_ENV]=noteStatus[PU1_OLD_ENV]=envelope;
		pbWheelInLast[PU1] = PBWHEEL_CENTER;
		
	} else if(x == note) {
		noteStatus[PU1_CURRENT_STATUS]=0U; // <<<
		if (!pu1Sus) {
			NR12_REG = 0x00U;
		}
	}
}

void playNotePu2()
{
	x = noteStatus[PU2_CURRENT_NOTE];
	note = addressByte;
	envelope = valueByte;
	note -=36U;
	if(envelope) {
		if(pu2Oct<0){
			if(note > (pu2Oct*-1)) note = note + pu2Oct;
		} else {
			note = note + pu2Oct;
		}
		if(pu2Oct!=0) while(note>71) note -=12;
		NR22_REG = ((envelope << 1U) & 0xF0U) + pu2Env; //Take a value from 0 to 127 and make it 0 to 255, and add in the envelope
		NR24_REG = 0x80+(freq[note]>>8U);
		//NR24_REG = trig + (freq[note]>>8U);
		NR23_REG = (freq[note]);
		currentFreqData[PU2] = freq[note];
		vibratoPosition[PU2]=0;
		
		pbNoteRange[2] = note - pbRange[1];
		pbNoteRange[3] = note + pbRange[1];
		
		noteStatus[PU2_CURRENT_STATUS]=1U;
		noteStatus[PU2_CURRENT_NOTE]=note;
	    //noteStatus[PU2_OLD_ENV] = noteStatus[PU2_CURRENT_ENV] = envelope;
		pbWheelInLast[PU2] = PBWHEEL_CENTER;

	} else if (x == note) {
		noteStatus[PU2_CURRENT_STATUS]=0U;
		if(!pu2Sus) {
			NR22_REG = 0x00U;
		}
	}
}


void playNoteWav()
{
	x = noteStatus[WAV_CURRENT_NOTE];
	note = addressByte;
	envelope = valueByte;
	note -=24U;
	if(envelope) {
		if(wavOct<0){
			if(note > (wavOct*-1)) note = note + wavOct;
		} else {
			note = note + wavOct;
		}
		
		if(wavOct!=0) while(note>71) note -=12;
		
		noteStatus[WAV_OLD_ENV] = envelope;
		envelope = (envelope>>5U);
		vibratoPosition[WAV]=0;
		
		switch(envelope) {
			case 0:
			envelope = 0x00U;
			break;
			case 1:
			envelope = 0x60U;
			break;
			case 2:
			envelope = 0x40U;
			break;
			default:
			envelope = 0x20U;
		}
		
		NR32_REG = envelope;
		NR34_REG = 0x07U&(freq[note]>>8U);
		NR33_REG = (freq[note]);
		pbNoteRange[4] = note - pbRange[2];
		pbNoteRange[5] = note + pbRange[2];
		noteStatus[WAV_CURRENT_STATUS]=1U;
		noteStatus[WAV_CURRENT_NOTE]=note;
	    noteStatus[WAV_CURRENT_ENV] =envelope;
		pbWheelInLast[WAV] = PBWHEEL_CENTER;
		
		wavCurrentFreq = freq[note];
		wavOriginalFreq = freq[note];
		currentFreqData[WAV] = freq[note];
		wavStepCounter = 0;
		counterWav=0U;
		counterWavStart=0U;
		cueWavSweep=1U;
		
	} else if (x == note) {
		noteStatus[WAV_CURRENT_STATUS]=0U;
		if(!wavSus) {
			NR32_REG = 0x00U;
		}
	}
}

void playNoteNoi()
{
	note = addressByte;
	envelope = valueByte;
	note-=24U;
	note = note + noiOct;
	if(envelope) {
		NR42_REG = ((envelope << 1) & 0xF0U) + noiEnv; //Take a value from 0 to 127 and make it 0 to 255, and add in the envelope
		NR43_REG = (noiFreq[note]);
		NR41_REG = 0xFFU; //sound length
		NR44_REG = 0x80U;
		currentFreqData[NOI] = noiFreq[note];
		
		vibratoPosition[NOI]=0;
		
		noteStatus[NOI_CURRENT_STATUS]=1;
		noteStatus[NOI_CURRENT_NOTE]=note;
	   // noteStatus[NOI_CURRENT_ENV] = noteStatus[NOI_OLD_ENV] = envelope;
		pbWheelInLast[NOI] = PBWHEEL_CENTER;
		
	} else if (noteStatus[NOI_CURRENT_NOTE] == note) {
	    //stop current note
		noteStatus[NOI_CURRENT_STATUS] = 0U;
		if(!noiSus) NR42_REG = 0x00U;
	}
}


void playNotePoly()
{
	if(valueByte) {
		polyVoiceSelect++;
		if(polyVoiceSelect==0x03U)polyVoiceSelect=0x00U;
		switch(polyVoiceSelect) {
			case 0U:
				polyNoteState[PU1] = addressByte;
				//playNotePu1();
				break;
			case 1U:
				polyNoteState[PU2] = addressByte;
				//playNotePu2();
				break;
			case 2U:
				polyNoteState[WAV] = addressByte;
				//playNoteWav();
				break;
		}
	} else {
		if(addressByte == (polyNoteState[PU1]-pu1Oct)) {
			//playNotePu1();
		}
		if (addressByte == (polyNoteState[PU2]-pu2Oct)) {
			//playNotePu2();
		}
		if (addressByte == (polyNoteState[WAV]-wavOct)) {
			//playNoteWav();
		}
	}
}

*/
void setOutputSwitch()
{
	NR51_REG = outputSwitch[0]+outputSwitch[1]+outputSwitch[2]+outputSwitch[3];
}

void setOutputPanBySynth(UBYTE synth, UBYTE value)
{
	outputSwitchValue[synth]=value;
	
	if(value == 3U) {
    	value = 0x11<<synth;
	} else if(value == 2U) {
    	value = 0x10<<synth;
	} else if(value == 1U) {
    	value = 0x01<<synth;
	} else {
    	value = 0x00;
	}
    outputSwitch[synth] = value;
	NR51_REG = outputSwitch[0]+outputSwitch[1]+outputSwitch[2]+outputSwitch[3];
}

void setOutputPan(UBYTE synth, UBYTE value)
{
  if(value > 96U) {
    value = 0x10U<<synth;
	outputSwitchValue[synth]=2;
  } else if (value > 32U) {
    value = 0x11U<<synth;
	outputSwitchValue[synth]=3;
  } else {
    value = 0x01U<<synth;
	outputSwitchValue[synth]=1;
  }
  outputSwitch[synth] = value;
  NR51_REG = outputSwitch[0]+outputSwitch[1]+outputSwitch[2]+outputSwitch[3];
}

void updateValueSynth(UBYTE p)
{
	switch(p)
	{
		case 0:
			pu1Oct = dataSet[p];
			pu1Oct = (pu1Oct - 2U) * 12U;
		break;
		case 1:
			NR11_REG = dataSet[p] << 3U << 3U |7U;
		break;
		case 2:
			pu1Env = dataSet[p];
		break;
		case 3:
			NR10_REG = dataSet[p];
		break;
		case 4:
			pbRange[0] = dataSet[p];
		break;
		case 5:
			pu1Sus = dataSet[p];
			if(!dataSet[p] && !noteStatus[PU1_CURRENT_STATUS]) NR12_REG = 0U;
		break;
		case 6:
			setOutputPanBySynth(0U,dataSet[p]);
		break;
		case 7:
			pu2Oct = dataSet[p];
			pu2Oct = (pu2Oct - 2U) * 12U;
		break;
		case 8:
			NR21_REG = dataSet[p] << 3U << 3U |7U;
		break;
		case 9:
			pu2Env = dataSet[p];
		break;
		case 10:
			pbRange[1] = dataSet[p];
		break;
		case 11:
			pu2Sus = dataSet[p];
			if(!dataSet[p] && !noteStatus[PU2_CURRENT_STATUS]) NR22_REG = 0U;
		break;
		case 12:
			setOutputPanBySynth(1U,dataSet[p]);
		break;
		case 13:
			wavOct = dataSet[p];
			wavOct = (wavOct - 2U) * 12U;
		break;
		case 14:
			wavDataOffset = (dataSet[p]<<4) + dataSet[15];
			break;
		case 15:
			wavDataOffset = (dataSet[14]<<4) + dataSet[p];
			break;
		case 16:
			wavSweepSpeed = dataSet[p];
			break;
		case 17:
			pbRange[2] = dataSet[p];
			break;
		case 18:
			wavSus = dataSet[p];
			if(!dataSet[p] && !noteStatus[WAV_CURRENT_STATUS]) NR32_REG = 0U;
			break;
		case 19:
			setOutputPanBySynth(2,dataSet[p]);
			break;
		case 20:
			noiOct = dataSet[p];
			noiOct = (noiOct - 2U) * 12U;
			break;
		case 21:
			noiEnv = dataSet[p];
			break;
		case 22:
			noiSus = dataSet[p];
			if(!dataSet[p] && !noteStatus[NOI_CURRENT_STATUS]) NR42_REG = 0U;
			break;
		case 23:
			setOutputPanBySynth(3U,dataSet[p]);
			break;
	}
}

void updateSynth(UBYTE synth)
{
	for(i=0;i!=0x09U;i++) {
		if(tableCursorLookup[synth][i] != 0xFFU) {
			dataSet[tableCursorLookup[synth][i]] = dataSet[tableCursorLookup[synth][i]];
			updateValueSynth(tableCursorLookup[synth][i]);
		}
	}
}


void updateSynths()
{
	enable_interrupts();
	
	if(vibratoDepth[PU1]) updateVibratoPosition(PU1);
	if(vibratoDepth[PU2]) updateVibratoPosition(PU2);
	if(vibratoDepth[WAV]) updateVibratoPosition(WAV);
	if(vibratoDepth[NOI]) updateVibratoPosition(NOI);
	if(wavSweepSpeed) {
		if(!wavStepCounter) {
		counterWav++;
		if(wavSweepSpeed && cueWavSweep) {
			wavCurrentFreq=currentFreqData[WAV]-(counterWav<<wavSweepSpeed);
			if(!(wavSweepSpeed>>3U) && (wavCurrentFreq>0x898U)) {
				wavCurrentFreq = 0U;
				cueWavSweep = 0U;
			}
			NR34_REG = wavCurrentFreq >> 8U;
			NR33_REG = wavCurrentFreq;
		}
		}
		wavStepCounter++;
		if(wavStepCounter == 0x02U) wavStepCounter = 0;
	}
}
