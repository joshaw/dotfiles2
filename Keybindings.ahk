; Settings {{{1
VIM = C:\Program Files (x86)\Vim\vim80\gvim.exe
SetWorkingDir, C:\home\JoshWainwright\

; General Keybindings {{{1
#a::
	Run, %VIM%
return

#n::
	Run, C:\home\JoshWainwright\Tools\SysinternalsSuite\ZoomIt.exe

#s::
	Run, C:\cygwin\bin\mintty.exe -i /Cygwin-Terminal.ico -
return

#w::
	Run, C:\progs\locate32_x64-3.1.11.7100\locate32.exe
return

F1::return

#F2::
	Run, %VIM% ~\Documents\Details\times\times.txt
return

#F12::
	Run, %VIM% -c EditReport
return

; Reload this script
^!r::
	MsgBox, Reloaded
	Reload
return

; Windows explorer active
#IfWinActive ahk_class CabinetWClass
^l::
	SendInput, {F4}^a
return

^h::
	SendInput, {F4}^aH:{Enter}
return

^t::
	SendInput, {F4}^aC:\tmp{Enter}
return

^d::
	SendInput, {F4}^aL:\FAE\Documentation{Enter}
return

^p::
	SendInput, {F4}^aC:\progs{Enter}
return
#IfWinActive

; Abbreviations {{{1
::vimpath::C:\Program Files (x86)\vim\vim74\gvim.exe
::dtyd::
	SendInput, %A_YYYY%-%A_MM%-%A_DD% `
return

; Key Configuration
; set the default state of the lock keys
SetCapsLockState, off
SetNumLockState, on
SetScrollLockState, off

; disable them
;$NumLock::Return
$ScrollLock::Return
$CapsLock::Return
; make Caps Lock key do Control
CapsLock::Ctrl
