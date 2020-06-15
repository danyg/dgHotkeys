
class HotCorners {
	__New() {
		this.interval := 100
		this.tickMethod := ObjBindMethod(this, "tick")
		this.previousPos := this.getCoord(100,100)
		this.triggering := false

		this.start()
	}

	start() {
		timerFnc := this.tickMethod
		SetTimer % timerFnc, % this.interval
	}

	tick() {
		SysGet, ScreenWidth, 78
		SysGet, ScreenHeight, 79

		SysGet, ScreenLeft, 76
		SysGet, ScreenTop, 77

		ScreenRight := (ScreenLeft + ScreenWidth) - 1 ; -1 as starts in 0
		ScreenBottom := (ScreenTop + ScreenHeight) - 1 ; -1 as starts in 0

		this.cornerTopLeft := this.getCoord(ScreenLeft, ScreenTop)
		this.cornerTopRight := this.getCoord(ScreenRight, ScreenTop)
		this.cornerBottomRight := this.getCoord(ScreenRight, ScreenBottom)
		this.cornerBottomLeft := this.getCoord(ScreenLeft, ScreenBottom)

		CoordMode, Mouse, Screen
		MouseGetPos, mouseX, mouseY

		this.checkHotCorners(mouseX, mouseY)
	}

	checkHotCorners(mouseX, mouseY) {
		mousePos := this.getCoord(mouseX, mouseY)
		posWasKept := this.previousPos = mousePos

		if (!this.triggering) {

			if (this.cornerTopLeft = mousePos AND posWasKept) {
				this.triggering := true
				this.triggerTopLeftCorner()
			}
			if (this.cornerTopRight = mousePos AND posWasKept) {
				this.triggering := true
				this.triggerTopRightCorner()
			}

			if (this.cornerBottomRight = mousePos AND posWasKept) {
				this.triggering := true
				this.triggerBottomRightCorner()
			}

			if (this.cornerBottomLeft = mousePos AND posWasKept) {
				this.triggering := true
				this.triggerBottomLeftCorner()
			}

		}

		if (!posWasKept) {
			this.triggering := false
		}

		this.previousPos := mousePos
	}

	getCoord(x, y) {
		Return x . "," . y
	}

	triggerTopLeftCorner() {
		log("TopLeftCorner")

		Send {LWin down}{Tab down}{Tab up}{LWin up}
	}

	triggerTopRightCorner() {
		log("TopRightCorner")

		Send {LWin down}{Tab down}{Tab up}{LWin up}
	}

	triggerBottomRightCorner() {
		log("BottomRightCorner")
	}

	triggerBottomLeftCorner() {
		log("BottomLeftCorner")
	}
}



hotCornersInstance := New HotCorners
