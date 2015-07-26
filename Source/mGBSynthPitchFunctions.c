void setPitchBendFrequencyOffset(UBYTE synth,UBYTE synth_pitch,UBYTE synth_note_range)
{
	systemIdle = 0;
	if(synth != NOI) {
		if(pbWheelIn[synth] & PBWHEEL_CENTER) {
			currentFreq = pbWheelIn[synth] - PBWHEEL_CENTER;
			currentFreq++;
			currentFreq = (currentFreq<<4) / PBWHEEL_CENTER;
			currentFreq = (freq[pbNoteRange[synth_note_range+1]] - freq[noteStatus[synth_pitch]]) * currentFreq;
			currentFreq = freq[noteStatus[synth_pitch]] + (currentFreq>>4);
		} else {
			currentFreq = PBWHEEL_CENTER - pbWheelIn[synth];
			currentFreq = (currentFreq<<4) / PBWHEEL_CENTER;
			currentFreq = (freq[noteStatus[synth_pitch]] - freq[pbNoteRange[synth_note_range]]) * currentFreq;
			currentFreq = freq[noteStatus[synth_pitch]] - (currentFreq>>4);
		}

		if(synth == PU1) {
			NR14_REG = (currentFreq>>8U);
			NR13_REG = currentFreq;
			currentFreqData[PU1] = currentFreq;
		} else if (synth == PU2) {
			NR24_REG = (currentFreq>>8U);
			NR23_REG = currentFreq;
			currentFreqData[PU2] = currentFreq;
		} else if (synth == WAV) {
			NR34_REG = (currentFreq>>8U);
			NR33_REG = currentFreq;
			wavCurrentFreq = currentFreq;
			currentFreqData[WAV] = currentFreq;
		}
	} else {
		if(pbWheelIn[NOI] > PBWHEEL_CENTER) {
		    noteStatus[NOI_CURRENT_NOTE] = noteStatus[NOI_CURRENT_NOTE];
			currentFreq = noiFreq[noteStatus[NOI_CURRENT_NOTE] + ((pbWheelIn[NOI] - PBWHEEL_CENTER) >>3)];
		} else {
		    noteStatus[NOI_CURRENT_NOTE] = noteStatus[NOI_CURRENT_NOTE];
			currentFreq = noiFreq[noteStatus[NOI_CURRENT_NOTE] - ((PBWHEEL_CENTER - pbWheelIn[NOI]) >>3)];
		}
		NR43_REG = currentFreq;
		currentFreqData[NOI] = currentFreq;
	}
}

void addVibrato(UBYTE synth){
	if(vibratoDepth[synth]) {
		currentFreq = currentFreqData[synth] + vibratoPosition[synth];
		pbWheelInLast[synth] = PBWHEEL_CENTER;
		if(synth == PU1) {
			NR14_REG = (currentFreq>>8U);
			NR13_REG = currentFreq;
		} else if (synth == PU2) {
			NR24_REG = (currentFreq>>8U);
			NR23_REG = currentFreq;
		} else if (synth == WAV) {
			NR34_REG = (currentFreq>>8U);
			NR33_REG = currentFreq;
		} else {
			NR43_REG = currentFreq;
		}
	}
}

UBYTE vibratoTimer[4];

void updateVibratoPosition(UBYTE synth)
{
	if(vibratoTimer[synth] == vibratoSpeed[synth]) {
		vibratoTimer[synth] = 0x00;
	if(vibratoSlope[synth] && vibratoPosition[synth] < vibratoDepth[synth]) {
		vibratoPosition[synth]+=1;
	} else {
		vibratoSlope[synth] = 0;
		if(vibratoPosition[synth]) {
			vibratoPosition[synth]-=1;
		} else {
			vibratoSlope[synth]=1;
		}
	}
	addVibrato(synth);
	
	}
	vibratoTimer[synth]++;
}
