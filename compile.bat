@echo off
:a
nasm kernel.asm -o kernel.bin
for %%i in (*.iconasm) do nasm -O0 -fbin %%i
for %%i in (*.icn) do del %%i
for %%i in (*.) do ren %%i %%i.icn
cd programs
 for %%i in (*.cxa) do cxa.py %%i %%~ni
 for %%i in (*.asm) do nasm -O0 -fbin %%i
 for %%i in (*.pgg) do del %%i
 for %%i in (*.) do ren %%i %%i.pgg
cd ..
pause
goto a: