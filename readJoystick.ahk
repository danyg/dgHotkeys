SetFormat, float, 03  ; Omit decimal point from axis position percentages.

populateAxis(Axis, JoyData) {
	GetKeyState, joyAxisData, %JoystickNumber%Joy%Axis%
	JoyData[Axis] := joyAxisData
	if(JoyData[Axis] != "")
	{
		JoyData.on := true
	}
}

getJoystickData(JoystickNumber) {
	JoyData := {on: false, name: "", info: "", buttonsRaw: "", X: -1, Y: -1, Z: -1, R: -1, U: -1, V: -1, POV: -1, buttons: [] }
	if(JoystickNumber = 0){
		Return JoyData
	}

    ; log("reading Joystick " + JoystickNumber )

	GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
	GetKeyState, joy_name, %JoystickNumber%JoyName
	GetKeyState, joy_info, %JoystickNumber%JoyInfo

    JoyData.name := joy_name
    JoyData.info := joy_info
    JoyData.buttonsRaw := joy_buttons

	buttons_down =
    Loop, %joy_buttons%
    {
        GetKeyState, joy%a_index%, %JoystickNumber%joy%a_index%
        if joy%a_index% = D
		{
            JoyData.buttons.Push(a_index)
			JoyData.on := true
		}
    }
	populateAxis("X", JoyData)
	populateAxis("Y", JoyData)

    IfInString, joy_info, Z
    {
	    populateAxis("Z", JoyData)
    }

    IfInString, joy_info, R
    {
	    populateAxis("R", JoyData)
    }

    IfInString, joy_info, U
    {
        populateAxis("U", JoyData)
    }

    IfInString, joy_info, V
    {
        populateAxis("V", JoyData)
    }

    IfInString, joy_info, P
    {
        populateAxis("POV", JoyData)
    }

    ; log( JSON_to(JoyData, 4, "   ") )

  	Return JoyData
}
