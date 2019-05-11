JOY_SETTINGS := {JOYSTICK: 1}

JOY_SETTINGS := JSON_load("config\\joySettings.json")

toggleJoystick() {
	global JOY_SETTINGS
	WatchedJoystick := JOY_SETTINGS.JOYSTICK

	if(!JOY_SETTINGS.JOYSTICK) {
		WatchedJoystick := 0
	}
	WatchedJoystick++

	if( WatchedJoystick = 5) {
		WatchedJoystick := 0
	}

	setWatchedJoystick(WatchedJoystick)
}

turnOffJoystick() {
	setWatchedJoystick(0)
}

setWatchedJoystick(WatchedJoystick) {
	global JOY_SETTINGS

	JOY_SETTINGS.JOYSTICK := WatchedJoystick
	JSON_save(JOY_SETTINGS, "config\\joySettings.json")

	if(JOY_SETTINGS.JOYSTICK = 0) {
		showOSD("Not Listening for Joystick")
	} else {
		showOSD("Watching Joystick " + JOY_SETTINGS.JOYSTICK)
	}
}

addTrayLabelItem("Joystick")
addHotkey("^#N",    "`u21ea Toggle Watched Joystick", Func("toggleJoystick").bind())
addHotkey("^#+N",   "`u21ea Turn off Watched Joystick", Func("turnOffJoystick").bind())
