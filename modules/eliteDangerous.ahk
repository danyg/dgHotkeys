;####################################################################################################################
;
; STARTS Dany Hotkeys
;
;####################################################################################################################
edMode:=false
edDbgMode:=False

toggleEDMode() {
	global edMode
	static update := Func("updateED").Bind()

	if(edMode = false) {
		showOSD("ED Mode On")
		edMode:=true
		showEDOSD("Elite: Dangerous Mode ON")

		SetTimer, %update%, 500
	} else {
		showOSD("ED Mode Off")
		edMode:=false
		SetTimer, %update%, Off
		hideEDOSD()
	}
	return
}

toggleEDDebugMode(){
	global edDbgMode
	if(edDbgMode = false) {
		edDbgMode := true
	} else {
		edDbgMode := false
	}
}

test := 1
updateED() {
	global edDbgMode
	global JOY_SETTINGS

	JoyData := getJoystickData( JOY_SETTINGS.JOYSTICK )
	Throttle := (JoyData.Z - 100) * -1
	ZMov := JoyData.V * 1

	UTC_time := A_NowUTC
	FormatTime, date, %UTC_time%, dd MMM
	FormatTime, year, %UTC_time%, yyyy
	FormatTime, time, %UTC_time%, HH:mm:ss
	year := year + 1286

	controlsData := JSON_to(getJoystickData( JOY_SETTINGS.JOYSTICK ), 4, "   ")

	MyStr := ""
	MyStr := MyStr . "Throttle: " . Throttle . "%\n"
	MyStr := MyStr . "Z-Mov     : " . ZMov . "%\n"
	if(edDbgMode) {
		MyStr := MyStr . "\n" . controlsData
	}

	updateEDOSD(time . "\n" . date . " " . year, MyStr)
}

Try
{
	EDFont := New CustomFont("EuroCAPS.TTF", "eurocaps", 12)
}
Catch e
{
	log("Error loading EuroCAPS.TTF: " . e)
}

TimeEDText =
ExtraEDText =
edOSDCreated:=false

showEDOSD(TextOfOSD){
	global TimeEDText
	global ExtraEDText
	global edDbgMode
	global EDFont

	; Top := 20
	; Left := 1440
	Top := 135
	; Left := 2830
	Left = Center

	; Width := 460
	Width := 320

	if(edDbgMode) {
		Height:= 600
	} else {
		Height:= 60
	}

	Padding := 5
	TWidth := (Width / 2) - (Padding * 2)
	THeight:= Height - (Padding * 2)
	LTLeft := Padding
	RTLeft := (Width / 2) + Padding

	TextOfOSD := JavaEscapedToUnicode(TextOfOSD)

	BackgroundColor = 3C2329  ; Can be any RGB color (it will be made transparent below).
	FontColor = FFA518;
	TColor = 080808  ; Can be any RGB color (it will be made transparent below).

	Gui, OSD_ED_Background:New
	Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  +E0x20  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, Color, %BackgroundColor%
	WinSet, Transparent, 180
	Gui, OSD_ED_Background:Show, x%Left% y%Top% w%Width% h%Height% NoActivate

	Gui, OSD_ED_Foreground:New
	Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  +E0x20  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, Color, %TColor%

	Gui, Font, s15, Euro Caps ; Set a large font size (32-point).
	Gui, Add, Text, Center x%LTLeft% y%Padding% w%TWidth% h%THeight% vTimeEDText c%FontColor% BackgroundTrans, 00:00:00\n00 AAA 0000
	Gui, Add, Text, x%RTLeft% y%Padding% w%TWidth% h%THeight% vExtraEDText c%FontColor% BackgroundTrans, %TextOfOSD%
	WinSet, TransColor, %TColor% 180
	Gui, OSD_ED_Foreground:Show, x%Left% y%Top% w%Width% h%Height% NoActivate

	return
}

updateEDOSD(TimeStr, TextOfOSD){
	global TimeEDText
	global ExtraEDText

	GuiControl, OSD_ED_Foreground:Text, TimeEDText, %TimeStr%
	GuiControl, OSD_ED_Foreground:Text, ExtraEDText, %TextOfOSD%
}

hideEDOSD(){
	global CurrentOSDEDText

	Gui, OSD_ED_Foreground:Hide
	Gui, OSD_ED_Background:Hide
	Gui, OSD_ED_Foreground:Destroy
	Gui, OSD_ED_Background:Destroy

}

; toggleEDMode()

addTrayLabelItem("Others")
addHotkey("^#E", "`uD83D`uDD52 Toggle Elite Dangerous Mode", Func("toggleEDMode").bind(), false)
addHotkey("^#W", "`uD83D`uDD52 Toggle Elite Dangerous DEBUG Mode", Func("toggleEDDebugMode").bind(), false)
