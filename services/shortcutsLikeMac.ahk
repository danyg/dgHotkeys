; Copy
!c::Send ^c

; Paste
!v::Send ^v

; Cut
!x::Send ^x

; Select All
!a::Send ^a

; Save
!s::Send ^s

; Undo
!z::Send ^z

; Redo
!+z::Send ^y

; Search
!f::Send ^f

; Close Window
!q::Send !{F4}

; New window
!n::Send ^n

; New Tab
!t::Send ^t

; Reopen Tab
!+t::Send ^+t

; Text Editing Shortcuts

; following section remaps alt-arrow and command-arrow
; keys to mimic OSX behaviour

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
