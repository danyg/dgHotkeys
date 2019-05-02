checkVolume() {
	global JOY_SETTINGS

	static LastValue = 0
	if(JOY_SETTINGS.JOYSTICK = 0){
		Return
	}

	JoyData := getJoystickData( JOY_SETTINGS.JOYSTICK )
	Volume := JoyData.U * 1
	diff := Volume - LastValue
	diff := abs(diff)

	if (diff > 2) {

		; log("Reading J " . JOY_SETTINGS.JOYSTICK . " JoyData.U: " . JoyData.U . " Volume:" . Volume . " LastValue: " . LastValue)

		SoundSet, Volume
		LastValue := Volume
		showOSD("New Volume " . Volume . "%")
	}
}
checkVolumeBind := Func("checkVolume").Bind()
SetTimer, %checkVolumeBind%, 100


