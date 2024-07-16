#include "mGB.h"

void printbyte(UBYTE v1, UBYTE v2, UBYTE v3) {
  bkg[0] = (v1 >> 4) + 1;
  bkg[1] = (0x0F & v1) + 1;

  bkg[2] = 0;

  bkg[3] = (v2 >> 4) + 1;
  bkg[4] = (0x0F & v2) + 1;

  bkg[5] = 0;

  bkg[6] = (v3 >> 4) + 1;
  bkg[7] = (0x0F & v3) + 1;

  bkg[8] = 0;
  set_bkg_tiles(1, 16, 10, 1, bkg);
}

#include "mGBDisplayFunctions.c"
#include "mGBMemoryFunctions.c"
#include "mGBMidiFunctions.c"
#include "mGBSynthCommonFunctions.c"
#include "mGBSynthPitchFunctions.c"
#include "mGBUserFunctions.c"
#include "serial.c"

void setSoundDefaults(void) {
  rAUDENA = 0x8FU; // Turn sound on
  rAUDVOL = 0x77U; // Turn on Pulses outs

  setOutputPan(0U, 64U);
  setOutputPan(1U, 64U);
  setOutputPan(2U, 64U);
  setOutputPan(3U, 64U);

  asmLoadWav(wavDataOffset); // tRIANGLE
  rAUD3LEVEL = 0x00U;

  rAUD4GO = 0x80U;
  rAUD4LEN = 0x3FU; // sound length
}

void testSynths(void) {
  addressByte = 0x40;
  valueByte = 0x7F;
  asmPlayNotePu1();
}

void main(void) {

  CRITICAL {
    cpu_fast();
    checkMemory();
    displaySetup();
    setSoundDefaults();
    add_TIM(updateSynths);

    loadDataSet(0x00U);
    loadDataSet(0x01U);
    loadDataSet(0x02U);
    loadDataSet(0x03U);
  }

  /* Set TMA to divide clock by 0x100 */
  rTMA = 0x00U;
  /* Set clock to 262144 Hertz */
  rTAC = TACF_START | TACF_262KHZ;
  /* Handle VBL and TIM interrupts */

  set_interrupts(VBL_IFLAG | TIM_IFLAG | SIO_IFLAG);

  SHOW_BKG;
  SHOW_SPRITES;

  showSplashScreen();
  delay(2000);

  showMainScreen();
  printversion();
  // testSynths();
  gameMain();
}

inline void gameMain(void) {
  rSC = SIOF_XFER_START | SIOF_CLOCK_EXT;
  while (1) {
    systemIdle = 1;

    updateMidiBuffer();

    if (systemIdle)
      getPad();

    if (systemIdle)
      asmUpdatePu1();

    if (systemIdle)
      asmUpdatePu2();

    if (systemIdle)
      asmUpdateWav();

    if (systemIdle)
      asmUpdateNoi();

    if (systemIdle)
      mainScreen();
  }
}

void mainScreen(void) {
  if (currentScreen == 0) {
    return;
  };

  updateDisplaySynthCounter = (updateDisplaySynthCounter + 1) & 3U;

  updateDisplaySynth();
  // printbyte(statusByte, addressByte, valueByte);
  setPlayMarker();
}