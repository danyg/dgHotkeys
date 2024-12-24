@echo off
SET CURRENTDIR=%cd%
"C:\Program Files\AutoHotkey\Compiler\ahk2exe" /in "%CURRENTDIR%\DanyAHK.ahk" /icon "%CURRENTDIR%\DanyAHK.ico" /out "%CURRENTDIR%\build\DanyAHK.exe" /base "C:\Program Files\AutoHotkey\v1.1.37.02\Unicode 64-bit.bin"
@REM "C:\Program Files\AutoHotkey\v1.1.37.02\AutoHotkeyU32.exe" /icon "%CURRENTDIR%\DanyAHK.ico" "%CURRENTDIR%\DanyAHK.ahk"
