#include "mGB.h"

UBYTE wavStepCounter;

void setOutputSwitch(void)
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
			NR11_REG = ((dataSet[p] << 3) << 3) |7;
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
			NR21_REG = ((dataSet[p] << 3) << 3) |7;
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
    default:
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


void updateSynths(void)
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
