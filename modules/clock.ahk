
;####################################################################################################################
;
; STARTS Dany Hotkeys
;
;####################################################################################################################

clockCreated:=false
clockVisible:=false
CLOCK_LEFT=300
CLOCK_WIDTH=300

CLOCK_SETTINGS := {}

createClock() {
	global clockCreated
	global BackgroundClockText

	global CLOCK_WIDTH

	if(clockCreated = false) {
		CustomColor = 222222  ; Can be any RGB color (it will be made transparent below).
		TColor = 080808  ; Can be any RGB color (it will be made transparent below).

		Gui, OSD_Clock:New
		Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  +E0x20  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
		Gui, Margin, 2, 2
		Gui, Color, %CustomColor%
		Gui, Font, s10, "Trebuchet MS" ; Set a large font size (32-point).
		Gui, Add, Text, Center vBackgroundClockText x2 y2 w%CLOCK_WIDTH% cf3f3f3 BackgroundTrans, x

		WinSet, TransColor, %TColor% 180

		_showClock()

		clockCreated := true

		showHideClock()
	}
}

readClockSettings() {
	global CLOCK_SETTINGS
	global CLOCK_LEFT

	CLOCK_SETTINGS := JSON_load("config\\clock.json")
	if(CLOCK_SETTINGS.HasKey("clockLeft")) {
		CLOCK_LEFT := CLOCK_SETTINGS.clockLeft
	}
}

saveClockSettings() {
	global CLOCK_SETTINGS
	global CLOCK_LEFT

	CLOCK_SETTINGS.clockLeft := CLOCK_LEFT

	JSON_save(CLOCK_SETTINGS, "config\\clock.json")
}

showHideClock() {
	global CLOCK_WIDTH
	global CLOCK_LEFT
	global CLOCK_SETTINGS
	global CLOCK_CONFIG_MODE
	global clockVisible

	refreshClockCBK := Func("refreshClock").Bind()

	if(clockVisible = true) {
		log("Hiding Clock")
		SetTimer, %refreshClockCBK%, Off
		Gui, OSD_Clock:Hide
		clockVisible := false

		if(CLOCK_CONFIG_MODE = true) {
			CLOCK_SETTINGS.showOnStart := false
		}

	} else {
		createClock()
		log("Showing Clock")
		refreshClock()

		SetTimer, %refreshClockCBK%, 1000

		_showClock()

		Gui, OSD_Clock:-AlwaysOnTop
		Gui, OSD_Clock:+AlwaysOnTop

		if(CLOCK_CONFIG_MODE = true) {
			CLOCK_SETTINGS.showOnStart := true
		}

		clockVisible := true
	}
}

_showClock() {
	global CLOCK_WIDTH
	global CLOCK_LEFT

	Gui, OSD_Clock:Show, x%CLOCK_LEFT% y0 w%CLOCK_WIDTH% NoActivate
}

refreshClock() {
	global BackgroundClockText
	global rr

	FormatTime, MyTime,, dddd dd MMMM yyyy    HH:mm:ss
	GuiControl, OSD_Clock:Text, BackgroundClockText, %MyTime%
}

CLOCK_CONFIG_MODE := False
toggleClockConfigMode() {
	global CLOCK_CONFIG_MODE

	if(CLOCK_CONFIG_MODE = True) {
		clockConfigModeOff()
	} else {
		clockConfigModeOn()
	}
}

clockConfigDefineKeys() {
	addTemporalHotKey("^!LEFT",    "Move Clock Left", Func("moveClockLeft").bind(), false)
	addTemporalHotKey("^!RIGHT",   "Move Clock Right", Func("moveClockRight").bind(), false)
	addTemporalHotKey("^+!LEFT",   "Move Clock Left (FAST)", Func("moveClockLeftFast").bind(), false)
	addTemporalHotKey("^+!RIGHT",  "Move Clock Right (FAST)", Func("moveClockRightFast").bind(), false)
}

clockConfigModeOn() {
	global CLOCK_CONFIG_MODE

	legend = Clock Config Mode ON
	legend := legend . "\n\nSave and exit Clock Config Mode (" . getHumanKeyName("^+#H") . ")"

	legend := legend . "\nToggle Show Thin Clock on Start (" . getHumanKeyName("^#H") . ")"

	legend := legend . "\n Move Clock Left"
	legend := legend . "\n Move Clock Right"
	legend := legend . "\n Move Clock Left (FAST)"
	legend := legend . "\n Move Clock Right (FAST)"

	enableClockConfigModeKeys()
	showConfigInstructions(legend)

	CLOCK_CONFIG_MODE:=true
}

showConfigInstructions(text) {
	hideInstructions()

	SysGet, PMonNum, MonitorPrimary
	SysGet, PMon, Monitor, %PMonNum%
	X := (( PMonRight - PMonLeft ) / 2 ) - 150
	Y := 20
	TextOfOSD := JavaEscapedToUnicode(text)

	log("Showing Tooltip at: " . X . " x " . Y . " OTHER STUFF: " . PMonRight . " | " . PMonLeft . " | " . PMon)
	CoordMode, ToolTip, Screen

	ToolTip, %TextOfOSD%, %X%, %Y%
	DestroyGUI := Func("hideInstructions").Bind()
	time := getShowTimeOfText(TextOfOSD)
	SetTimer, %DestroyGUI%, %time%
}

hideInstructions() {
	; SplashTextOff
	ToolTip
}

clockConfigModeOff() {
	global CLOCK_CONFIG_MODE

	hideInstructions()

	disableClockConfigModeKeys()

	showOSD("Clock Config Mode Off")

	saveClockSettings()

	CLOCK_CONFIG_MODE:=false
}

enableClockConfigModeKeys() {
	enableTemporalHotKey("^!LEFT")
	enableTemporalHotKey("^!RIGHT")
	enableTemporalHotKey("^+!LEFT")
	enableTemporalHotKey("^+!RIGHT")
}

disableClockConfigModeKeys() {
	disableTemporalHotKey("^!LEFT")
	disableTemporalHotKey("^!RIGHT")
	disableTemporalHotKey("^+!LEFT")
	disableTemporalHotKey("^+!RIGHT")
}

_moveClockLeft(inc) {
	global CLOCK_LEFT

	possibleLeft := CLOCK_LEFT - inc

	if(possibleLeft > 0) {
		CLOCK_LEFT := possibleLeft
	} else {
		CLOCK_LEFT := 0
	}
	_showClock()
}

_moveClockRight(inc) {
	global CLOCK_LEFT

	CLOCK_LEFT := CLOCK_LEFT + inc

	_showClock()
}

moveClockLeft() {
	_moveClockLeft(1)
}

moveClockRight() {
	_moveClockRight(1)
}

moveClockLeftFast() {
	_moveClockLeft(5)
}

moveClockRightFast() {
	_moveClockRight(5)
}

showTime() {
	FormatTime, MyTime,, dddd, dd MMMM, yyyy    HH:mm
	showOSD("`uD83D`uDD52 " . MyTime)
	return
}

readClockSettings()
clockConfigDefineKeys()
disableClockConfigModeKeys()

if(!CLOCK_SETTINGS.HasKey("showOnStart") || CLOCK_SETTINGS.showOnStart = true) {
	createClock()
}

addTrayLabelItem("Mini Clock")
addHotkey("^#H",    "`uD83D`uDD52 Toggle Thin Clock", Func("showHideClock").bind(), false)
addHotkey("^+#H",    "`uD83D`uDD52 Toggle Thin Clock Config", Func("toggleClockConfigMode").bind(), false)
addHotkey("^#J", "`uD83D`uDD52 Show Time", Func("showTime").bind(), false)
