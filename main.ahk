#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%

; macOS emulation
!c::Send ^c
!v::Send ^v
!+]::Send {Ctrl Down}{Tab Down}{Tab Up}{Ctrl Up}
!+[::Send {Ctrl Down}{ShiftDown}{Tab Down}{Tab Up}{ShiftUp}{Ctrl Up}

CapsLock::LControl

TAB_PRESSED = 0

$Tab::
  TAB_PRESSED := 1

  KeyWait, Tab, T.1

  If not ErrorLevel { ; Not held
    send {Tab}
    TAB_PRESSED := 0
    Return
  }

  KeyWait, Tab

  TAB_PRESSED := 0

  Return

#If TAB_PRESSED
  h::Send {Left}
  j::Send {Down}
  k::Send {Up}
  l::Send {Right}

  a::Send {Home}
  e::Send {End}
#If