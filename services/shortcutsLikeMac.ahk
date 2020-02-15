; Copy
!c::
Send ^c
return

; Paste
!v::
Send ^v
return

; Cut
!x::
Send ^x
return

; Select All
!a::
Send ^a
return

; Save
!s::
Send ^s
return

; Undo
!z::
Send ^z
return

; Redo
!+z::
Send ^y
return

; Search
!f::
Send ^f
return

; Close Window
!q::
Send !{F4}
return

; New window
!n::Send ^n

; New Tab
!t::Send ^t

; Text Editing Shortcuts

;following section remaps alt-arrow and command-arrow
;keys to mimic OSX behaviour
!Up::Send {Lctrl down}{Home}{Lctrl up}
!Down::Send {Lctrl down}{End}{Lctrl up}
!Left::Send {Home}
!Right::Send {End}
!+Up::Send {Shift down}{Lctrl down}{Home}{Lctrl up}{Shift up}
!+Down::Send {Shift down}{Lctrl down}{End}{Lctrl up}{Shift up}
!+Left::Send {Shift down}{Home}{Shift up}
!+Right::Send {Shift down}{End}{Shift up}

#Up::Send {PgUp}
#Down::Send {PgDn}
#Left::Send ^{Left}
#Right::Send ^{Right}
#+Up::Send {Shift down}{PgUp}
#+Down::Send {Shift down}{PgDn}
#+Left::Send {Shift down}{Lctrl down}{Left}{Lctrl up}{Shift up}
#+Right::Send {Shift down}{Lctrl down}{Right}{Lctrl up}{Shift up}
#BS::Send ^BS
Alt & Del::Send ^{Del}
