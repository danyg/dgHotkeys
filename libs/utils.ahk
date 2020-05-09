#Escapechar \

JavaEscapedToUnicode(s) {
    i := 1
    while j := RegExMatch(s, "`u[A-Fa-f0-9]{1,4}", m, i)
        e .= SubStr(s, i, j-i) Chr("0x" SubStr(m, 3)), i := j + StrLen(m)
    return e . SubStr(s, i)
}

addTrayLabelItem(str){
	Menu, Tray, Add, %str% , LabelForMenuTrayLabels
	Menu, Tray, Disable,  %str%
}

addHotkey(key, label, action, annouceLabel=true){

	label := JavaEscapedToUnicode(label)

	wrapper := Func("execHotkey").bind(label, action, annouceLabel)

	Loop, parse, key, |
		Hotkey, % "" A_LoopField, %wrapper%

	label := label . " (" . getHumanKeyName(key) . ")"

	Menu, Tray, Add, %label% , %wrapper%

	return key
}

removeHotKey(key, label) {
	Loop, parse, key, |
		Hotkey, % "" A_LoopField, off

	label := JavaEscapedToUnicode(label)
	label := label . " (" . getHumanKeyName(key) . ")"

	Menu, Tray, Delete, %label%
}

addTemporalHotKey(key, label, action, annouceLabel=true) {

	label := JavaEscapedToUnicode(label)

	wrapper := Func("execHotkey").bind(label, action, annouceLabel)

	Loop, parse, key, |
		Hotkey, % "" A_LoopField, %wrapper%

	label := label . " (" . getHumanKeyName(key) . ")"

	return label
}

removeTemporalHotKey(key) {
	disableTemporalHotKey(key)
}

enableTemporalHotKey(key) {
	Loop, parse, key, |
		Hotkey, % "" A_LoopField, on
}

disableTemporalHotKey(key) {
	Loop, parse, key, |
		Hotkey, % "" A_LoopField, off
}

addRemovableHotKey(key, action) {
	wrapper := Func("execHotkey").bind("", action, false)

	Loop, parse, key, |
		Hotkey, % "" A_LoopField, %wrapper%

	return key
}

enableRemovableHotKey(key) {
	enableTemporalHotKey(key)
}

disableRemovableHotKey(key) {
	disableTemporalHotKey(key)
}

execHotkey(label, action, annouceLabel) {
	if(annouceLabel = true) {
		showOSD(label)
	}
	action.Call()
}

getHumanKeyName(key) {
	specials = "Numpad0|NumpadIns|Numpad1|NumpadEnd|Numpad2|NumpadDown|Numpad3|NumpadPgDn|Numpad4|NumpadLeft|Numpad5|NumpadClear|Numpad6|NumpadRight|Numpad7|NumpadHome|Numpad8|NumpadUp|Numpad9|NumpadPgUp|NumpadDot|NumpadDel|NumpadDiv|NumpadMult|NumpadAdd|NumpadSub|NumpadEnter|ScrollLock|Delete|Del|Insert|Ins|Home|End|PgUp|PgDn|Up|Down|Left|Right|CapsLock|Space|Tab|Enter|Return|Escape|Esc|Backspace|BS|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|F13|F14|F15|F16|F17|F18|F19|F20|F21|F22|F23|F24|LWin|RWin|Control|Ctrl|Alt|Shift|LControl|LCtrl|RControl|RCtrl|LShift|RShift|LAlt|RAlt|Browser_Back|Browser_Forward|Browser_Refresh|Browser_Stop|Browser_Search|Browser_Favorites|Browser_Home|Volume_Mute|Volume_Down|Volume_Up|Media_Next|Media_Prev|Media_Stop|Media_Play_Pause|Launch_Mail|Launch_Media|Launch_App1|Launch_App2|AppsKey|PrintScreen|CtrlBreak|Pause|Break|Help|Sleep"
	symbols = "*=|&=<?>|~=|$=|^=Ctrl|#=Win|+=Shift|!=Alt|<!=LAlt|>!=RAlt|<^=LCtrl|>^=RCtrl"
	hkey =

	Loop, parse, symbols, |
	{
		kV := StrSplit(A_LoopField, "=")

		if(InStr(key, kV[1], false) > 0) {
			if(StrLen(hkey) > 0) {
				hkey .= " + "
			}
			hkey .= kV[2]
			key := StrReplace(key, kV[1], "")
		}
	}

	Loop, parse, specials, |
	{
		if(InStr(key, A_LoopField, false) > 0) {
			if(StrLen(hkey) > 0) {
				hkey .= " + "
			}
			hkey .= A_LoopField
			key := StrReplace(key, A_LoopField, "")
		}
	}

	if(StrLen(key) > 0) {
		if(StrLen(hkey) > 0) {
			hkey .= " + "
		}
		hkey .= key
	}

	return hkey
}

getLogFile() {
	static a
	a += 1
	if(a = 1){
		logFile := FileOpen("log.log", "a", "UTF-8")
		FormatTime, MyTime, , yyyy-MM-dd HH:mm:ss
		logFile.Write("\r\n════[ " . MyTime . " ]═════════════════════════════════════════════════════")
	}
}

log(str) {
	FormatTime, MyTime,, yyyy-MM-dd HH:mm:ss
	str := "\r\n[" . MyTime . "]> " . str ; add line feed
	getLogFile()
	FileOpen("log.log", "a", "UTF-8").Write(str)
}

logn(str) {
	FormatTime, MyTime,, yyyy-MM-dd HH:mm:ss
	getLogFile()
	FileOpen("log.log", "a", "UTF-8").Write(str)
}

getShowTimeOfText(TextOfOSD) {
	return StrLen(TextOfOSD) * 150 * -1
}
