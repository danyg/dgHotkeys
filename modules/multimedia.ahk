;####################################################################################################################
;
; STARTS Dany Hotkeys
;
;####################################################################################################################


prev(){
	Send {Media_Prev}
	return
}


playpause(){
	Send {Media_Play_Pause}
	return
}

nextTrack(){
	Send {Media_Next}
	return
}

volUp(){
	Send {Volume_Up}

	return
}

volDown(){
	Send {Volume_Down}

	return
}

addTrayLabelItem("Multimedia")
addHotkey("^#Z",    "`u23EA Previous Track", Func("prev").bind())
addHotkey("^#X",    "`u23EF Play/Pause", Func("playpause").bind())
addHotkey("^#C",    "`u23EF Play/Pause", Func("playpause").bind())
addHotkey("^#V",    "`u23EF Play/Pause", Func("playpause").bind())
addHotkey("^#B",    "`u23E9 Next Track", Func("nextTrack").bind())
addHotkey("^#UP",   "`uD83D`uDD0A Increase Volume", Func("volUp").bind())
addHotkey("^#DOWN", "`uD83D`uDD09 Decrease Volume", Func("volDown").bind())

