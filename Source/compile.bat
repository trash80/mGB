REM Automatically generated from Makefile
mkdir obj
..\..\gbdk-4.3.0\bin\lcc  -msm83:gb  -Wf--max-allocs-per-node50000  -Wm-yc  -Wm-yn"mGB"  -Wm-yt3  -Wm-ya1  -c -Wb-ba0 -o obj\mgb_save.rel mgb_save.c
..\..\gbdk-4.3.0\bin\lcc  -msm83:gb  -Wf--max-allocs-per-node50000  -Wm-yc  -Wm-yn"mGB"  -Wm-yt3  -Wm-ya1  -c -o obj\mGBASMFunctions.rel mGBASMFunctions.s
..\..\gbdk-4.3.0\bin\lcc  -msm83:gb  -Wf--max-allocs-per-node50000  -Wm-yc  -Wm-yn"mGB"  -Wm-yt3  -Wm-ya1  -c -o obj\mGBASMSynthFunctions.rel mGBASMSynthFunctions.s
..\..\gbdk-4.3.0\bin\lcc  -msm83:gb  -Wf--max-allocs-per-node50000  -Wm-yc  -Wm-yn"mGB"  -Wm-yt3  -Wm-ya1  -c -o obj\mGBASMMidiFunctions.rel mGBASMMidiFunctions.s
..\..\gbdk-4.3.0\bin\lcc  -msm83:gb  -Wf--max-allocs-per-node50000  -Wm-yc  -Wm-yn"mGB"  -Wm-yt3  -Wm-ya1  -c -o obj\mGB.rel mGB.c
..\..\gbdk-4.3.0\bin\lcc  -msm83:gb  -Wf--max-allocs-per-node50000  -Wm-yc  -Wm-yn"mGB"  -Wm-yt3  -Wm-ya1  -Wm-ya1 -o mGB.gb obj\mGB.rel obj\mgb_save.rel obj\mGBASMFunctions.rel obj\mGBASMSynthFunctions.rel obj\mGBASMMidiFunctions.rel
