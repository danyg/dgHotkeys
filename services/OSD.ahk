CurrentOSDText=
BackgroundText=
ForegroundText=
created:=false
WITDTH=1870

createOSD(TextOfOSD) {
	global created
	global WIDTH

	global BackgroundText
	global ForegroundText

	if(created = false) {
		; log("Created Window")
		CustomColor = 222222  ; Can be any RGB color (it will be made transparent below).
		TColor = 080808  ; Can be any RGB color (it will be made transparent below).

		Gui, OSD_Background:New
		Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  +E0x20  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
		Gui, Margin, 40, 10
		Gui, Color, %CustomColor%
		Gui, Font, s32, Arial ; Set a large font size (32-point).
		Gui, Add, Text, Center vBackgroundText x12 y12 c%CustomColor% BackgroundTrans, x
		; Gui, Add, Text, x10 y10 c%TColor% BackgroundTrans, %TextOfOSD%

		; Gui, Add, Text, x12 y12 c444444 BackgroundTrans, %TextOfOSD%
		; Gui, Add, Text, x10 y10 cFFFFFF BackgroundTrans, %TextOfOSD%

		WinSet, TransColor, %TColor% 180
		; WinSet, Transparent, 180

		Gui, OSD_Foreground:New
		Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  +E0x20  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
		Gui, Margin, 10, 10
		Gui, Color, %TColor%
		Gui, Font, s32 bold, Arial ; Set a large font size (32-point).

		; Gui, Add, Text, x12 y12 c444444 BackgroundTrans, %TextOfOSD%
		; WinSet, Transparent, 255
		Gui, Add, Text, Center vForegroundText x10 y10 cFFFFFF BackgroundTrans, x

		WinSet, TransColor, %TColor%

		created := true
	}
}

showOSD(TextOfOSD){
	global CurrentOSDText
	global BackgroundText
	global ForegroundText
	global WIDTH

	Top := 20

	DestroyGUI := Func("hideOSD").Bind()
	SetTimer, %DestroyGUI%, Off

	TextOfOSD := JavaEscapedToUnicode(TextOfOSD)

	if(CurrentOSDText = TextOfOSD) {
		SetTimer, %DestroyGUI%, -5000
		return
	}

	CurrentOSDText := TextOfOSD
	hideOSD()
	createOSD(TextOfOSD)

	GuiControl, OSD_Background:Text, BackgroundText, %TextOfOSD%
	GuiControl, OSD_Foreground:Text, ForegroundText, %TextOfOSD%

	tW := StrLen(TextOfOSD) * 28

	GuiControl, OSD_Background:Move, BackgroundText, W%tW%
	GuiControl, OSD_Foreground:Move, ForegroundText, W%tW%

	; prevents see the OSD behind a AlwaysOnTop window
	Gui, OSD_Background:-AlwaysOnTop
	Gui, OSD_Foreground:-AlwaysOnTop
	Gui, OSD_Background:+AlwaysOnTop
	Gui, OSD_Foreground:+AlwaysOnTop

	Gui, OSD_Background:Show, xCenter y%Top% AutoSize NoActivate
	Gui, OSD_Foreground:Show, xCenter y%Top% AutoSize NoActivate

	time := getShowTimeOfText(TextOfOSD)
	; log("OSD: " . TextOfOSD . " Time : " . time . "ms" . " W:" . tW . "px")
	SetTimer, %DestroyGUI%, %time%

	return
}

hideOSD(){
	global CurrentOSDText
	global BackgroundText
	global ForegroundText
	global created

	Gui, OSD_Foreground:Hide
	Gui, OSD_Background:Hide
	; Gui, OSD_Foreground:Destroy
	; Gui, OSD_Background:Destroy

	; created := false


	CurrentOSDText=
}
