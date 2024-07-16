REM Automatically generated from Makefile
mkdir obj
mkdir out
# -ba 0 probably not needed anymore
..\..\gbdk-4.3.0\bin\lcc  -msm83:gb  -Wf--opt-code-speed  -Wf--legacy-banking  -Wm-yc  -Wm-yn"mGB"  -Wm-yt3  -Wm-ya1  -c -Wb-ba0 -o obj\mgb_save.rel mgb_save.c
# mostly so you can see the .asm
..\..\gbdk-4.3.0\bin\lcc  -msm83:gb  -Wf--opt-code-speed  -Wf--legacy-banking  -Wm-yc  -Wm-yn"mGB"  -Wm-yt3  -Wm-ya1  -c -o obj\mGB.rel mGB.c
..\..\gbdk-4.3.0\bin\lcc  -msm83:gb  -Wf--opt-code-speed  -Wf--legacy-banking  -Wm-yc  -Wm-yn"mGB"  -Wm-yt3  -Wm-ya1  -o out\mGB.gb obj\mGB.rel obj\mgb_save.rel *.s
