#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetTitleMatchMode 2
; #WinActivateForce


Menu, Tray, NoStandard ; remove standard Menu items

#include JSONLib.ahk
#include Class_CustomFont.ahk

#include readJoystick.ahk
#Include utils.ahk
#Include OSD.ahk

#Include multimedia.ahk

#Include windowOperations.ahk

#Include clock.ahk

#Include joystickSettings.ahk
#Include eliteDangerous.ahk
#Include VolumeJoystick.ahk

Menu, Tray, Add , E&xit, ButtonExit ;add a item named Exit that goes to the ButtonExit label

; The following abominable pure shit is in this way because of this:
; https://autohotkey.com/boards/viewtopic.php?f=14&t=18895
	StupidLabel:
	Return

	ButtonExit:
	ExitApp
