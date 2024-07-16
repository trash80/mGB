#include "mGB.h"

void clearParameterLocks(void)
{
	for(j=0;j!=24;j++) parameterLock[j] = 0;
}

void setDataValue(void)
{
	BOOLEAN up=0;
	UBYTE inc=1;
	systemIdle = 0;
	
	j = 0;
	if(i & J_UP) {
		j = 1;
		up=1;
		inc=16;
	} else if (i & J_DOWN) {
		j = 1;
		inc=16;
	} else if (i & J_LEFT) {
		j = 1;
	} else if (i & J_RIGHT) {	
		up=1;
		j = 1;
	}
	if(j) {
		for(j=0;j!=4;j++) {
			if(cursorEnable[j] && tableCursorLookup[j][cursorRow[j]] != 0xFFU) {
				x = tableCursorLookup[j][cursorRow[j]];
				l = tableData[x][2];
				switch(x) {
					case 6:
					case 12:
					case 19:
					case 23:
						if (i & J_DOWN) {
							dataSet[x]=0;
						} else if (i & J_UP) {
							dataSet[x]=3;
						} else if (i & J_LEFT) {
							dataSet[x]=2;
						} else if (i & J_RIGHT) {
							dataSet[x]=1;
						}
						break;
					case 0:
					case 7:
					case 13:
					case 20:
						inc=1;
					default:
					if(up) {
						dataSet[x]+=inc;
						if(dataSet[x]>=l) dataSet[x]=(l-1);
					} else if (dataSet[x]) {
						if(dataSet[x] > inc) {
							dataSet[x]-=inc;
						} else {
							dataSet[x]=0;
						}
					}
				}
				parameterLock[x] = 1;
				updateValueSynth(x);
			}
		}
	}
}


void getPad(void)
{
	i = joypad();
	if(i != lastPadRead) {
		lastPadRead = i;
		if(i) {
			if((i & J_A) && !joyState[0]) {
				joyState[0] = 1;
				if (i & J_SELECT) {
					toggleScreen();
				} else {
					setDataValue();
				}
				return;
			} else if (joyState[0]) {
				joyState[0] = 0;
				setDataValue();
				return;
			}
			if((i & J_B) && !joyState[1]) {
				joyState[1] = 1;
				if (i & J_SELECT) {
					recallMode = 0;
				} else {
					recallMode = 1;
				}
				snapRecall();
				return;
			} else if (joyState[1]) {
				joyState[1] = 0;
				return;
			}
			if((i & J_UP) && !joyState[2]) {
				joyState[2] = 1;
				cursorRow[cursorColumn]--;
				setCursor();
				return;
			} else if (joyState[2]) {
				joyState[2] = 0;
				return;
			}
			if((i & J_RIGHT) && !joyState[5]) {
				joyState[5] = 1;
				cursorColumn++;
				setCursor();
				return;
			} else if (joyState[5]) {
				joyState[5] = 0;
				return;
			}
			if((i & J_DOWN) && !joyState[3]) {
				joyState[3] = 1;
				cursorRow[cursorColumn]++;
				setCursor();
				return;
			} else if (joyState[3]) {
				joyState[3] = 0;
				return;
			}
			if((i & J_LEFT) && !joyState[4]) {
				joyState[4] = 1;
				cursorColumn--;
				setCursor();
				return;
			} else if (joyState[4]) {
				joyState[4] = 0;
				return;
			}
			if((i & J_SELECT) && !joyState[6]) {
				joyState[6] = 1;
				return;
			} else if (joyState[6]) {
				joyState[6] = 0;
				return;
			}
			if((i & J_START) && !joyState[7]) {
				joyState[7] = 1;
                NR12_REG = 0;
                NR22_REG = 0;
                NR32_REG = 0;
                NR42_REG = 0;
				pbWheelIn[0] = pbWheelIn[1] = pbWheelIn[2] = pbWheelIn[3] = 0x80;
                pu1Sus = pu2Sus = wavSus = 0;
				
				return;
			} else if (joyState[7]) {
				joyState[7] = 0;
				return;
			}
		} else {
			clearParameterLocks();
			for(j=0;j!=8;j++) {
				if(joyState[j]){
					joyState[j] = 0;
				}
			}
			return;
		}
	}
}
