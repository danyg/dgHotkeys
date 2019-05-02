JOY_SETTINGS := {JOYSTICK: 1}

JOY_SETTINGS := JSON_load("joySettings.json")

toggleJoystick() {
	global JOY_SETTINGS

	if(!JOY_SETTINGS.JOYSTICK) {
		JOY_SETTINGS.JOYSTICK := 0
	}
	JOY_SETTINGS.JOYSTICK++

	if( JOY_SETTINGS.JOYSTICK = 4) {
		JOY_SETTINGS.JOYSTICK := 0
	}

	if(JOY_SETTINGS.JOYSTICK = 0) {
		showOSD("Not Listening for Joystick")
	} else {
		showOSD("Watching Joystick " + JOY_SETTINGS.JOYSTICK)
	}

	JSON_save(JOY_SETTINGS, "joySettings.json")

}

addHotkey("^#N",    "`u21ea Toggle Watched Joystick", Func("toggleJoystick").bind())