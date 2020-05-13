#Include libs\utils.ahk
#Include libs\JSONLib.ahk
#Include services\OSD.ahk

I_Icon = zTestAlarmClock.ico
ICON [I_Icon]
Menu, Tray, NoStandard ; remove standard Menu items
; Menu, Tray, Icon, %I_Icon%, 0, 1 ; No needed when compiled to change tray icon

config={}
VLCTitle := "VLC media player"
watching := false

runVLC() {
	global vlcPath
	global playlistPath
	global VLCTitle

	WinClose, %VLCTitle%

	flagsO := {shuffle: "--random", inLoop: "--loop", autoStart: "--playlist-autostart"}
	flags := ""

	For key, value in flagsO
		flags .= " " . value

	cmd := """" vlcPath """" . flags . " """ playlistPath """"
	log("Run, " . cmd)
	Run, %cmd%
}

loadConfig() {
	global config
	global alarmTime
	global vlcPath
	global playlistPath

	config:=JSON_load("config\\alarm-clock.json")
	alarmTime := config.alarmTime
	vlcPath := config.vlcPath
	playlistPath := config.playlistFile
}

; Define Menu
defineMenu() {
	global alarmTime

	Menu, Tray, DeleteAll

	addTrayLabelItem("Alarm Defined at: " . alarmTime)

	restartF := Func("restart").bind()
	Menu, Tray, Add, Reload Config, %restartF%
	Menu, Tray, Add
	Menu, Tray, Add , E&xit, ExitButton
}

stopedMenu() {
	Menu, Tray, DeleteAll
	addTrayLabelItem("--[ Stoped ]--")
}

start() {
	global alarmTime

	loadConfig()
	defineMenu()

	watching := true

	while watching {
		FormatTime, CurrentTime,, HH:mm

		if (alarmTime == CurrentTime) {
			showOSD("ALARM TIME")
			runVLC()
			Sleep, 60000
		}
		Sleep, 10000
	}
}

stop() {
	watching := false
}

restart() {
	stop()
	start()
}

start()


LabelForMenuTrayLabels:
Return

ExitButton:
ExitApp
