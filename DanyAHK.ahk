#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
I_Icon = DanyAHK.ico

SetTitleMatchMode 2
; #WinActivateForce

Menu, Tray, NoStandard ; remove standard Menu items

#include libs\JSONLib.ahk
#include libs\Class_CustomFont.ahk
#Include libs\utils.ahk

#Include services\OSD.ahk
#include services\readJoystick.ahk
#Include services\VolumeJoystick.ahk

addTrayLabelItem("v24.10.11a")
#Include modules\multimedia.ahk
Menu, Tray, Add
#Include modules\windowOperations.ahk
Menu, Tray, Add
#Include modules\clock.ahk
; Menu, Tray, Add
; #Include modules\eliteDangerous.ahk
; Menu, Tray, Add
; #Include modules\joystickSettings.ahk
Menu, Tray, Add
#Include services\shortcutsLikeMac.ahk
Menu, Tray, Add

Menu, Tray, Add , E&xit, ExitButton

#Include modules\hotCorners.ahk


LabelForMenuTrayLabels:
Return

ExitButton:
ExitApp
