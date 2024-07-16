# If you move this project you can change the directory 
# to match your GBDK root directory (ex: GBDK_HOME = "C:/GBDK/"
ifndef GBDK_HOME
	GBDK_HOME = ../gbdk
endif

PROJECTNAME = mGB

LCC = $(GBDK_HOME)/bin/lcc 

LCCFLAGS += -msm83:gb # GB/GBC
# LCCFLAGS += -v # verbose
# LCCFLAGS += -autobank 

ifdef DEBUG
LCCFLAGS += -debug -v
endif

ifdef RELEASE
LCCFLAGS += -Wf--max-allocs-per-node50000 # A better speed optimization than --opt-code-speed
else
LCCFLAGS += -Wf--opt-code-speed # Optimize for code speed rather than size
endif

# sdcc settings (-Wf and -Wp)
# LCCFLAGS += -Wf--legacy-banking # Use legacy method to call banked functions

# sdasgb (asm) settings (-Wa)
# LCCFLAGS += -Wa-l # generate asm listing
# LCCFLAGS += -Wa-a # All symbols are global
# LCCFLAGS += -Wa-s # Create symbol file/outfile[.sym]
# LCCFLAGS += -Wa-j # Enable NoICE Debug Symbols
# LCCFLAGS += -Wa-y # Enable SDCC Debug Symbols
# LCCFLAGS += -Wa-g # Undefined symbols are global
# LCCFLAGS += -Wa-n # Don't resolve global assigned value symbols
# LCCFLAGS += -Wa-z # Disable case sensitivity for symbols

# sdldgb (linker) settings (-Wl)
# LCCFLAGS += -Wl-m # Map output generated as (out)file[.map]
# LCCFLAGS += -Wl-j # NoICE Debug output as (out)file[.noi]
# LCCFLAGS += -Wl-w # Wide listing format for map file

# makebin settings (-Wm)
# LCCFLAGS += -Wm-yS # Convert .noi file named like input file to .sym
LCCFLAGS += -Wm-yc # GBC compatible
LCCFLAGS += -Wm-yn"$(PROJECTNAME)" # cartridge name
LCCFLAGS += -Wm-yt3 # MBC type = ROM+MBC1+RAM+BATT 
LCCFLAGS += -Wm-ya1 # number of ram banks: -ya 1


OBJ=obj
OUT=out

build:
	mkdir -p $(OBJ)
	mkdir -p $(OUT)
	
	# mostly so you can see the .asm
	$(LCC) $(LCCFLAGS) -c -o $(OBJ)/mGB.rel mGB.c

  # SRAM bank 0
	$(LCC) $(LCCFLAGS) -Wf-ba0 -c -o $(OBJ)/mgb_save.rel mgb_save.c
	$(LCC) $(LCCFLAGS) -o $(OUT)/$(PROJECTNAME).gb $(OBJ)/mGB.rel $(OBJ)/mgb_save.rel *.s

compile.bat: Makefile
	@echo "REM Automatically generated from Makefile" > compile.bat
	@make -sn | sed y/\\//\\\\/ | sed s/mkdir\ \-p/mkdir/ | grep -v make >> compile.bat

clean:
	rm -rf $(OBJ)
	rm -rf $(OUT)