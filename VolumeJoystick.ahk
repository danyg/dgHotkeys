checkVolume() {
	global JOY_SETTINGS
	if(JOY_SETTINGS.JOYSTICK = 0) {
		Return
	}

	static LastValue = 0

	JoyData := getJoystickData( JOY_SETTINGS.JOYSTICK )
	if(JoyData.on)
	{
		Volume := JoyData.U * 1
		diff := Volume - LastValue
		diff := abs(diff)

		; log("Reading J " . JOY_SETTINGS.JOYSTICK . " JoyData.U: " . JoyData.U . " Volume:" . Volume . " LastValue: " . LastValue)
		if (diff > 2) {
			SoundSet, Volume
			LastValue := Volume
			showOSD("New Volume " . Volume . "%")
		}
	}
}
checkVolumeBind := Func("checkVolume").Bind()
SetTimer, %checkVolumeBind%, 100


