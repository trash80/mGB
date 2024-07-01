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
#include "mGBSynthCommonFunctions.c"
#include "mGBSynthPitchFunctions.c"
#include "mGBUserFunctions.c"

void setSoundDefaults(void) {
  NR52_REG = 0x8FU; // Turn sound on
  NR50_REG = 0x77U; // Turn on Pulses outs

  setOutputPan(0U, 64U);
  setOutputPan(1U, 64U);
  setOutputPan(2U, 64U);
  setOutputPan(3U, 64U);

  asmLoadWav(wavDataOffset); // tRIANGLE
  NR32_REG = 0x00U;

  NR44_REG = 0x80U;
  NR41_REG = 0x3FU; // sound length
}

void testSynths(void) {
  addressByte = 0x40;
  valueByte = 0x7F;
  asmPlayNotePu1();
}

void main(void) {
  disable_interrupts();
  cpu_fast();
  checkMemory();
  displaySetup();
  setSoundDefaults();
  add_TIM(updateSynths);

  loadDataSet(0x00U);
  loadDataSet(0x01U);
  loadDataSet(0x02U);
  loadDataSet(0x03U);
  enable_interrupts();

  /* Set TMA to divide clock by 0x100 */
  TMA_REG = 0x00U;
  /* Set clock to 262144 Hertz */
  TAC_REG = 0x05U;
  /* Handle VBL and TIM interrupts */

  set_interrupts(VBL_IFLAG | TIM_IFLAG | SIO_IFLAG);

  SHOW_BKG;
  SHOW_SPRITES;

  showSplashScreen();
  delay(2000);

  showMainScreen();
  printversion();
  // testSynths();
  asmMain();
}
