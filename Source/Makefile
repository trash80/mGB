BIN=../gbdk-n/bin
OBJ=./obj



build:
	mkdir -p $(OBJ)
	$(BIN)/gbdk-n-compile.sh mgb_save.c -o $(OBJ)/mgb_save.rel -Wa-l -ba0

	$(BIN)/gbdk-n-assemble.sh $(OBJ)/mGBASMFunctions.rel mGBASMFunctions.s
	$(BIN)/gbdk-n-assemble.sh $(OBJ)/mGBASMSynthFunctions.rel mGBASMSynthFunctions.s
	$(BIN)/gbdk-n-assemble.sh $(OBJ)/mGBASMMidiFunctions.rel mGBASMMidiFunctions.s

	$(BIN)/gbdk-n-compile.sh mgb.c -o $(OBJ)/mgb.rel -I ./ -Wa-l -Wl-m -Wl-j

	$(BIN)/gbdk-n-link.sh $(OBJ)/mgb.rel $(OBJ)/mgb_save.rel $(OBJ)/mGBASMFunctions.rel $(OBJ)/mGBASMSynthFunctions.rel $(OBJ)/mGBASMMidiFunctions.rel -o $(OBJ)/mgb.ihx

	$(BIN)/gbdk-n-make-rom.sh -ya 1 -yc $(OBJ)/mgb.ihx mgb.gb

clean:
	rm -rf $(OBJ)
	rm -f mgb.gb
