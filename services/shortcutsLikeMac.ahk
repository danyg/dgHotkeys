mac_copy() {
	Send ^c
}

mac_paste() {
	Send ^v
}

mac_cut() {
  Send ^x
}

mac_selectAll() {
  Send ^a
}

mac_save() {
  Send ^s
}

mac_undo() {
  Send ^z
}

mac_redo() {
  Send ^y
}

mac_search() {
  Send ^f
}

mac_closeWindow() {
  Send !{F4}
}

mac_newWindow() {
  Send ^n
}

mac_newTab() {
  Send ^t
}

mac_reopenTab() {
  Send ^+t
}

mac_CmdUp() {
  Send {Lctrl down}{Home}{Lctrl up}
}

mac_CmdDown() {
  Send {Lctrl down}{End}{Lctrl up}
}

mac_CmdLeft() {
  Send {Home}
}

mac_CmdRight() {
  Send {End}
}

mac_CmdShiftUp() {
  Send {Shift down}{Lctrl down}{Home}{Lctrl up}{Shift up}
}

mac_CmdShiftDown() {
  Send {Shift down}{Lctrl down}{End}{Lctrl up}{Shift up}
}

mac_CmdShiftLeft() {
  Send {Shift down}{Home}{Shift up}
}

mac_CmdShiftRight() {
  Send {Shift down}{End}{Shift up}
}

mac_OptionUp() {
  Send {PgUp}
}

mac_OptionDown() {
  Send {PgDn}
}

mac_OptionLeft() {
  Send ^{Left}
}

mac_OptionRight() {
  Send ^{Right}
}

mac_OptionShiftUp() {
  Send {Shift down}{PgUp}
}

mac_OptionShiftDown() {
  Send {Shift down}{PgDn}
}

mac_OptionShiftLeft() {
  Send {Shift down}{Lctrl down}{Left}{Lctrl up}{Shift up}
}

mac_OptionShiftRight() {
  Send {Shift down}{Lctrl down}{Right}{Lctrl up}{Shift up}
}

mac_OptionBackSpace() {
  Send ^{BS}
}

mac_CmdDelete() {
  Send ^{Del}
}

; Enable disable logic

MacHotKeys := []
mackeysEnabled := true

addMacHotKey(key, action) {
	global MacHotKeys

	MacHotKeys.Push(addRemovableHotKey(key, action))
}

defineMacHotKeys() {
	addMacHotKey("!c",        Func("mac_copy").bind())
	addMacHotKey("!v",        Func("mac_paste").bind())
	addMacHotKey("!x",        Func("mac_cut").bind())
	addMacHotKey("!a",        Func("mac_selectAll").bind())
	addMacHotKey("!s",        Func("mac_save").bind())
	addMacHotKey("!z",        Func("mac_undo").bind())
	addMacHotKey("!+z",       Func("mac_redo").bind())
	addMacHotKey("!f",        Func("mac_search").bind())
	addMacHotKey("!q",        Func("mac_closeWindow").bind())
	addMacHotKey("!n",        Func("mac_newWindow").bind())
	addMacHotKey("!t",        Func("mac_newTab").bind())
	addMacHotKey("!+t",       Func("mac_reopenTab").bind())
	; Text Editing Shortcuts

	; following section remaps alt-arrow and command-arrow
	; keys to mimic OSX behaviour
	addMacHotKey("!Up",       Func("mac_CmdUp").bind())
	addMacHotKey("!Down",     Func("mac_CmdDown").bind())
	addMacHotKey("!Left",     Func("mac_CmdLeft").bind())
	addMacHotKey("!Right",    Func("mac_CmdRight").bind())
	addMacHotKey("!+Up",      Func("mac_CmdShiftUp").bind())
	addMacHotKey("!+Down",    Func("mac_CmdShiftDown").bind())
	addMacHotKey("!+Left",    Func("mac_CmdShiftLeft").bind())
	addMacHotKey("!+Right",   Func("mac_CmdShiftRight").bind())
	addMacHotKey("#Up",       Func("mac_OptionUp").bind())
	addMacHotKey("#Down",     Func("mac_OptionDown").bind())
	addMacHotKey("#Left",     Func("mac_OptionLeft").bind())
	addMacHotKey("#Right",    Func("mac_OptionRight").bind())
	addMacHotKey("#+Up",      Func("mac_OptionShiftUp").bind())
	addMacHotKey("#+Down",    Func("mac_OptionShiftDown").bind())
	addMacHotKey("#+Left",    Func("mac_OptionShiftLeft").bind())
	addMacHotKey("#+Right",   Func("mac_OptionShiftRight").bind())
	addMacHotKey("#BS",       Func("mac_OptionBackSpace").bind())
	addMacHotKey("Alt & Del", Func("mac_CmdDelete").bind())
}

disableMacHotKeys() {
	global mackeysEnabled
	global MacHotKeys

	for index, key in MacHotKeys {
		disableRemovableHotKey(key)
	}
	showOSD("Mac Hotkeys Disabled!")
	mackeysEnabled := false
}

enableMacHotKeys() {
	global mackeysEnabled
	global MacHotKeys

	for index, key in MacHotKeys {
		enableRemovableHotKey(key)
	}

	showOSD("Mac Hotkeys Enabled")
	mackeysEnabled := true
}

toggleMacKeys() {
	global mackeysEnabled
	if (mackeysEnabled) {
		disableMacHotKeys()
	} else {
		enableMacHotKeys()
	}
}

; Start module
addTrayLabelItem("Mac shortcuts")
addHotkey("#Esc", "Toggle Mac HotKeys", Func("toggleMacKeys").bind(), false)
defineMacHotKeys()
