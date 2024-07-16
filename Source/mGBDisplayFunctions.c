#include "mGB.h"

void printversion(void)
{
	set_bkg_tiles(1,16,10,1,versionnumber);
}

void printhelp(void)
{
	j=helpmap[cursorColumn][cursorRowMain];
	set_bkg_tiles(1,16,18,1,helpdata[j]);
}

void updateDisplayValue(UBYTE p,UBYTE v)
{
	bkg[1]=0;
	switch(p){
		case 0U:
		case 7U:
		case 13U:
		case 20U:
			set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,octmap[v]);
			break;
		case 1U:
		case 8U:
			bkg[0]=44+v;set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,bkg);
			break;
		case 2U:
		case 9U:
		case 21U:
			if(!v) {
				bkg[0]=83;set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,bkg);
			} else {
				bkg[0]=48+v;set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,bkg);
			}
			break;
		case 4U:
		case 10U:
		case 17U:
			bkg[0]=1+(v >> 4);
			bkg[1]=1+(0x0F & v);
			set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,bkg);
			break;
		case 5U:
		case 11U:
		case 18U:
		case 22U:
			set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,susmap[v]);
			break;
		case 6U:
		case 12U:
		case 19U:
		case 23U:
			set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,panmap[v]);
			break;
		case 14U:
			if(v > 7U) {
				bkg[1]=v-7;
				bkg[0]=48;
				set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,bkg);
			} else {
				bkg[0]=39+v;
				set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,bkg);
			}
			break;
		case 3U:
			bkg[0]=1+(v >> 4);
			bkg[1]=1+(0x0F & v);
			set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,bkg);
			break;
		case 15U:
			bkg[0]=1+(v >> 4);
			bkg[1]=1+(0x0F & v);
			set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,bkg);
			break;
		case 16U:
			bkg[0]=1+v;set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,bkg);
			break;
		case 24U:
		case 25U:
		case 26U:
		case 27U:
			bkg[0]=1+(0x0F & v);
			set_bkg_tiles(tableData[p][0],tableData[p][1],2,1,bkg);
			break;
		default:
			break;
	}
}

void updateDisplaySynth(void)
{
  //printbyte(serialBufferPosition,serialBufferReadPosition,serialBuffer[serialBufferPosition]);
	for(i=0;i!=0x09U;i++) {
		if(tableCursorLookup[updateDisplaySynthCounter][i] != 0xFFU) {
			updateDisplayValue(tableCursorLookup[updateDisplaySynthCounter][i],dataSet[tableCursorLookup[updateDisplaySynthCounter][i]]);
		}
	}
}

void updateDisplay(void)
{
  UBYTE x=0;
	for(j=0;j!=0x04U;j++) {
		for(i=0;i!=0x09U;i++) {
			if(tableCursorLookup[j][i] != 0xFFU) {
				//updateValue(tableCursorLookup[j][i],dataSet[tableCursorLookup[j][i]]);
				updateDisplayValue(tableCursorLookup[j][i],dataSet[tableCursorLookup[j][i]]);
				updateValueSynth(tableCursorLookup[j][i]);
			}
		}
	}
}

void setCursor(void)
{
	if(cursorColumnLast != cursorColumn) {
		if(cursorColumn>0xF0U) cursorColumn=0x03U;
		if(cursorColumn>0x03U) cursorColumn=0U;
		cursorEnable[cursorColumn]=1U;
		if(!joyState[6]) {
			cursorEnable[cursorColumnLast]=0U;
		}

		//cursorRow[cursorColumn] = cursorRowMain;
		cursorColumnLast = cursorColumn;
	}

	for(j=0;j!=4;j++) {
		if(shiftSelect && !joyState[6] && cursorColumn != j) {
			cursorEnable[j] = 0;
		}
		if(cursorEnable[j]) {
			if(cursorRow[j] > 0xF0U) cursorRow[j] = 0x08U;
			if(cursorRow[j] > 0x08U) cursorRow[j] = 0U;
			move_sprite(SPRITE_ARRT_START, cursorBigStartX[cursorColumn], cursorBigStartY[0]);
			move_sprite(j+SPRITE_ARRL_START, cursorStartX[j], (cursorRow[j] * SCREEN_YSPACE) + SCREEN_PSTARTY + SCREEN_YO);
			if(j==cursorColumn) cursorRowMain = cursorRow[j];
		}
	}
	for(j=0;j!=4;j++) {
		if(!cursorEnable[j]) {
			cursorRow[j] = cursorRowMain;
			move_sprite(j+SPRITE_ARRL_START,0, 0);
		}
	}
	if(!joyState[6]) {
		shiftSelect = 0;
	} else {
		shiftSelect = 1;
	}
	printhelp();
}

void hideCursor(void)
{
	for(j=0;j!=4;j++) {
		move_sprite(j+SPRITE_ARRL_START,0, 0);
	}
	move_sprite(SPRITE_ARRT_START, 0, 0);
}

void showCursor(void)
{
	setCursor();
}

void setPlayMarker(void)
{
	for(j=0;j!=4;j++) {
		if(!j) {
			bkg[0] = markerMapTiles[j][(2U + noteStatus[0])];
		} else if (j==1) {
			bkg[0] = markerMapTiles[j][(2U + noteStatus[2])];
		} else if (j==2) {
			bkg[0] = markerMapTiles[j][(2U + noteStatus[4])];
		} else {
			bkg[0] = markerMapTiles[j][(2U + noteStatus[6])];
		}
		set_bkg_tiles(markerMapTiles[j][0],markerMapTiles[j][1U],1U,1U,bkg);
	}
}

void cls(void)
{
	for(j=0;j!=20;j++) bkg[j]= 0x00U;
	for(j=0;j!=18;j++) {
		set_bkg_tiles(0,j,20,1,bkg);
	}
}

void showMainScreen(void)
{
	cls();
	currentScreen = 1;
	bkg[0]=66;set_bkg_tiles(3,3,1,1,bkg);
	bkg[0]=67;set_bkg_tiles(7,3,1,1,bkg);
	bkg[0]=68;set_bkg_tiles(11,3,1,1,bkg);
	bkg[0]=69;set_bkg_tiles(15,3,1,1,bkg);

	for(j=0;j!=28;j++) {
		bkg[0] = bkg[1] = 1;
		set_bkg_tiles(tableData[j][0],tableData[j][1],2,1,bkg);
	}

	updateDisplay();
    showCursor();
}

void showSplashScreen(void)
{
    hideCursor();
	cls();
	set_bkg_tiles(6,7,8,2,logo);
}

void toggleScreen(void)
{
	if(currentScreen == 0) {
		DISPLAY_ON;
		showMainScreen();
	} else {
		currentScreen = 0;
		DISPLAY_OFF;
	}
}

void displaySetup(void)
{
	DISPLAY_OFF;
	set_bkg_palette( 0, 1, &bgpalette[0] );

	/* Initialize the background */
	set_bkg_data(0, 92, data_font);
	//set_bkg_tiles(1,0, 20, 18, bgmap);

	set_sprite_palette(0,2,&spritepalette[0]);

	for(j=0;j!=4;j++) {
		cursorBigStartX[j] = SCREEN_XO + SCREEN_PSTARTX + (j * SCREEN_XSPACE) - 1;
		cursorBigStartY[j] = SCREEN_YO + SCREEN_PSTARTY - 8;
		cursorStartX[j] = SCREEN_XO + SCREEN_PSTARTX + (j * SCREEN_XSPACE) - 8;
		cursorStartY[j] = SCREEN_YO + SCREEN_PSTARTY;
		cursorRow[j] = cursorStartY[j];
	}

	SPRITES_8x8;

	set_sprite_data(SPRITE_ARRT,0x01U, data_barrow);
	set_sprite_data(SPRITE_ARRL,0x01U, data_larrow);


	set_sprite_tile(SPRITE_ARRT_START, SPRITE_ARRT);
	for(j=0;j!=4;j++) set_sprite_tile(j+SPRITE_ARRL_START, SPRITE_ARRL);

	for(j=0;j!=4;j++) set_sprite_prop(j+SPRITE_ARRT_START,1);
	for(j=0;j!=4;j++) set_sprite_prop(j+SPRITE_ARRL_START,1);

	DISPLAY_ON;
}
