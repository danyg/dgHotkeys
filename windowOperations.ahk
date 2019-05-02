; #SingleInstance Force
; #MaxThreadsPerHotkey 10

; SetBatchLines, -1
; AutoTrim, Off

Delta=1
MinT=50
Fstate=
TransByWinClass := {}
DimPosByWinClass := {}

toggleAlwaysOnTop() {
	WinGet, ExStyle, ExStyle, A
	If (ExStyle & 0x8)
	  state = OFF
	Else
	  state = ON
	Winset, Alwaysontop, , A
	showOSD("Setting Always on Top " . state)
}

toggleFrame() {
	global Fstate
	WinGet, Style, Style, A
	If (Style & +0xC40000) { ; NOT BORDERLESS
		removeFrame()
	} else {
		restoreFrame()
	}

	showOSD("Setting Frame " . Fstate)
}

removeFrame() {
	global Fstate
	WinSet, Style, -0xC40000, A
	Fstate = ON
}

restoreFrame() {
	global Fstate
	WinSet, Style, +0xC40000, A
	Fstate = OFF
}

toggleFrameAndMaximize() {
	global Fstate

	WinGet, isMax, MinMax, A
	if(isMax == 1) {
		restoreFrame()
		WinRestore, A
	} else {
		removeFrame()
		WinMaximize, A
	}
	showOSD("Window to fullscreen " . Fstate)
}

toggleClickTrough() {
	WinGet, ExStyle, ExStyle, A
	If (ExStyle & 0x00000020) { ; NOT Click Trough
		WinSet, ExStyle, -0x00000020, A
		state = OFF
	} else {
		WinSet, ExStyle, +0x00000020, A
		state = ON
	}

	; showOSD("Setting Click Trough " . state)
	showOSD("Click Trough is: " . state)
}

showTransparency(){
	T := getTransparency()
	showOSD("Transparency: " . T . "%")
}

setOpaque(){
	WinSet, Trans, 255, A
	showTransparency()
}

getTransparency(){
	WinGet, Alpha, Transparent, A
	WinGetTitle, WinTit, A

	if(Alpha <= 0){
		Alpha := 255
	}

	Trans = %Alpha%
	Trans *= 0.392156
	Transform, Trans, Round, Trans

	return Trans
}

changeTransparency(delta){
	global MinT
	global TransByWinClass

	Trans0 := getTransparency()
	Trans0 += %delta%

	WinGetClass, WindowClass, A
	WinGet, WinID, ID, A
	; log("change opacity to [" . WindowClass . " - " . WinID . " ] to " . Trans0)
	If (WindowClass = Progman)
	{
		Trans0 = 100
	}
	Else If (Trans0 < MinT)
	{
		Trans0 = %MinT%
	}
	Else If (Trans0 > 100)
	{
		Trans0 = 100
	}

	setOpacity(Trans0, ID)

	;Apply opacity to the rest of windows that has same class as active Window
	WinGet windows, List
	Loop %windows%
	{
		id := windows%A_Index%
		WinGetClass, wClass, ahk_id %id%
		WinGetTitle, wTitle, ahk_id %id%

		; log("Applying transparency to " . id . " - " . TargetWinClass . " == " . wClass . " | " . wTitle)
		if(WindowClass = wClass) {
			; log("Applying transparency to " . id . " - " . wClass . " | " . wTitle)
			setOpacity(Trans0, id)
		}
	}

	; log("Storing Transparency for " . WindowClass . " ==> " . Trans0)
	; TransByWinClass.PX_WINDOW_CLASS := Trans0
	TransByWinClass[WindowClass] := Trans0
	JSON_save(TransByWinClass, "opacity.json")

	showTransparency()
}

setOpacity(Trans0, winId) {
	Alpha := Trans0
	Alpha *= 2.55
	Transform, Alpha, Round, %Alpha%
	WinSet, Trans, %Alpha%, ahk_id %winId%
}

saveWindowClassDimensionsAndPosition() {
	global DimPosByWinClass

	WinGetClass, WindowClass, A
	WinGet, WinID, ID, A

	WinGetPos, wX, wY, wW, wH, A

	DimPosByWinClass[WindowClass] := {X: wX, Y: wY, W: wW, H: wH}

	JSON_save(DimPosByWinClass, "dimPos.json")
	showOSD("Dimensions and Position Saved")
}

listenNewWindows() {
	global TransByWinClass
	global DimPosByWinClass
	TransByWinClass := JSON_load("opacity.json")
	DimPosByWinClass := JSON_load("dimPos.json")

	DetectHiddenWindows, On
	Hwnd := WinExist(A_ScriptFullPath)
	DllCall( "RegisterShellHookWindow", UInt,Hwnd )
	MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
	OnMessage( MsgNum, "onShellMessage" )
}

setOpacityForNewWindow( WindowClass, winID ) {
	global TransByWinClass
	global MinT

	if(TransByWinClass[WindowClass] >= MinT) {
		logn(" | Setting Opacity to : " . TransByWinClass[WindowClass] . "%")
		setOpacity(TransByWinClass[WindowClass], winID)
	}
}

restoreDimensionsAndPositionForNewWindow(WindowClass, winID) {
	global DimPosByWinClass
	if(DimPosByWinClass[WindowClass]) {
		logn(" | Setting Position to : " . DimPosByWinClass[WindowClass].X . " x " . DimPosByWinClass[WindowClass].Y . " | " . DimPosByWinClass[WindowClass].W . " by " . DimPosByWinClass[WindowClass].H)
		restoreDimensionsAndPositionForCurrentWindow()
	}
}

restoreDimensionsAndPositionForCurrentWindow() {
	global DimPosByWinClass
	WinGetClass, WindowClass, A

	if(DimPosByWinClass[WindowClass]) {
		WinMove, A,, DimPosByWinClass[WindowClass].X, DimPosByWinClass[WindowClass].Y, DimPosByWinClass[WindowClass].W, DimPosByWinClass[WindowClass].H
	}
}

forgetDimensionsAndPositionForCurrentWindow() {
	global DimPosByWinClass
	WinGetClass, WindowClass, A

	if(DimPosByWinClass[WindowClass]) {
		DimPosByWinClass.Delete(WindowClass)
		JSON_save(DimPosByWinClass, "dimPos.json")
		showOSD("Dimensions and Position Forgotten")
	}
}

onShellMessage( wParam, winID ) {
	WinGetTitle, title, ahk_id %winID%
	WinGetClass, WindowClass, ahk_id %winID%

	If (wParam=1) {
		log("Detected New Window Class: " . WindowClass . ", ID: " . winID . ", Title: " . title)
		setOpacityForNewWindow(WindowClass, winID)
		restoreDimensionsAndPositionForNewWindow(WindowClass, winID)
	}
}


listenNewWindows()

Menu, Tray, Add
addTrayLabelItem("Active Window Control")

addHotkey("^#T",       	"`u21ea Toggle Always on Top", Func("toggleAlwaysOnTop").bind(), false)
addHotkey("^#F",       	"`u21ea Toggle Frame", Func("toggleFrame").bind(), false)
addHotkey("+^#F",       "`u21ea Toggle Frame and fullscreen", Func("toggleFrameAndMaximize").bind(), false)
addHotkey("^#G",       	"`u21ea Toggle Click Trough", Func("toggleClickTrough").bind(), false)
addHotkey("^#F1",       "`uD83D`uDDC1 Restore Current Window Dimensions and Position", Func("restoreDimensionsAndPositionForCurrentWindow").bind(), false)
addHotkey("^#F2",       "`ud83d`udcbe Save Current Window Dimensions and Position", Func("saveWindowClassDimensionsAndPosition").bind(), false)
addHotkey("^#F3",       "`u274c Forget Current Window Dimensions and Position", Func("forgetDimensionsAndPositionForCurrentWindow").bind(), false)
addHotkey("!MButton",  	"`uD83D`uDD05 Show Opacity Value", Func("showTransparency").bind(), false)
addHotkey("^!MButton", 	"`uD83D`uDD05 Set Opaque", Func("setOpaque").bind(), false)
addHotkey("!WheelUp",   "`uD83D`uDD05 Increase Opacity 1x", Func("changeTransparency").bind(1), false)
addHotkey("!WheelDown", "`uD83D`uDD06 Decrease Opacity 1x", Func("changeTransparency").bind(-1), false)
addHotkey("^!WheelUp",   "`uD83D`uDD05 Increase Opacity 5x", Func("changeTransparency").bind(5), false)
addHotkey("^!WheelDown", "`uD83D`uDD06 Decrease Opacity 5x", Func("changeTransparency").bind(-5), false)







