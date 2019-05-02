SetFormat, float, 03  ; Omit decimal point from axis position percentages.

getJoystickData(JoystickNumber) {

    ; log("reading Joystick " + JoystickNumber )

	GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
	GetKeyState, joy_name, %JoystickNumber%JoyName
	GetKeyState, joy_info, %JoystickNumber%JoyInfo
    JoyData := {name: "", info: "", buttonsRaw: "", X: -1, Y: -1, Z: -1, R: -1, U: -1, V: -1, P: -1, buttons: [] }

    JoyData.name := joy_name
    JoyData.info := joy_info
    JoyData.buttonsRaw := joy_buttons

	buttons_down =
    Loop, %joy_buttons%
    {
        GetKeyState, joy%a_index%, %JoystickNumber%joy%a_index%
        if joy%a_index% = D
            JoyData.buttons.Push(a_index)
    }
    GetKeyState, joyx, %JoystickNumber%JoyX
	JoyData.X := joyx
    axis_info = X%joyx%

    GetKeyState, joyy, %JoystickNumber%JoyY
	JoyData.Y := joyy
    axis_info = %axis_info%%a_space%%a_space%Y%joyy%

    IfInString, joy_info, Z
    {
	    GetKeyState, joyz, %JoystickNumber%JoyZ
	    JoyData.Z := joyz
        axis_info = %axis_info%%a_space%%a_space%Z%joyz%
    }

    IfInString, joy_info, R
    {
	    GetKeyState, joyr, %JoystickNumber%JoyR
	    JoyData.R := joyr
        axis_info = %axis_info%%a_space%%a_space%R%joyr%
    }

    IfInString, joy_info, U
    {
        GetKeyState, joyu, %JoystickNumber%JoyU
        JoyData.U := joyu
        axis_info = %axis_info%%a_space%%a_space%U%joyu%
    }

    IfInString, joy_info, V
    {
        GetKeyState, joyv, %JoystickNumber%JoyV
        JoyData.V := joyv
        axis_info = %axis_info%%a_space%%a_space%V%joyv%
    }

    IfInString, joy_info, P
    {
        GetKeyState, joyp, %JoystickNumber%JoyPOV
        JoyData.P := joyp
        axis_info = %axis_info%%a_space%%a_space%POV%joyp%
    }


    ; log( JSON_to(JoyData, 4, "   ") )

    return JoyData
}