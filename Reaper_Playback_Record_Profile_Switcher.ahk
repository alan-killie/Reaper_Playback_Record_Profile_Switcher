; Reaper-Record/Playback Profile Switcher

#NoEnv
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 1
SetTitleMatchMode, fast
DetectHiddenWindows, On
DetectHiddenText, On
SetControlDelay, -1

; Default values
recinputs := 2
recblock := 128
playinputs := 0
playblock := 512

; Control variables
InputBox :=
BlockSize :=
sourcevar :=

GuiVisible := false
GuiInitialized := false

F11::
if (!GuiInitialized) {
    Gui, +AlwaysOnTop +ToolWindow -Caption
    Gui, Color, 1E1E1E, F0F0F0
    Gui, Font, s10, Segui UI

    ; Initial icon and label
    Gui, Add, Picture, x10 y10 w30 h30 vProfileIcon, sound.ico
    Gui, Add, Text, x50 y15 w250 h25 cF0F0F0 vTitleLabel, REAPER PLAY/REC Profile Switcher
    Gui, Add, Text, x50 y15 w250 h25 BackgroundTrans vDragOverlay gStartDrag
    GuiControl, +Cursor, DragOverlay, SizeAll

    ; Profile section
    Gui, Add, GroupBox, x10 y50 w380 h180, Profiles

    ; Recording profile
    Gui, Add, Button, x20 y70 w180 h30 gRecordingProfile, Apply Recording Profile
    Gui, Add, Text, x210 y75 w80 h20 cF0F0F0, Input Ch:
    Gui, Add, ComboBox, x290 y70 w80 vRecInputDefault, 0|2|4|8|16

    Gui, Add, Text, x210 y100 w80 h20 cF0F0F0, Block Size:
    Gui, Add, ComboBox, x290 y100 w80 vRecBlockDefault, 64|128|256|512|1024

    Gui, Add, Button, x210 y130 w160 h25 gSetRecordingDefaults, Set Recording Defaults

    ; Playback profile
    Gui, Add, Button, x20 y170 w180 h30 gPlaybackProfile, Apply Playback Profile
    Gui, Add, Button, x210 y170 w160 h25 gSetPlaybackDefaults, Set Playback Defaults

    ; Utility buttons
    Gui, Add, Button, x10 y240 w95 h30 gReloadScript, Reload Script
    Gui, Add, Button, x115 y240 w95 h30 gExitScript, Exit

    GuiInitialized := true
}

if (GuiVisible := !GuiVisible)
    Gui, Show,, REAPER P/R Switcher
else
    Gui, Hide
return

SetRecordingDefaults:
GuiControlGet, recinputs,, RecInputDefault
GuiControlGet, recblock,, RecBlockDefault
return

SetPlaybackDefaults:
GuiControlGet, playinputs,, RecInputDefault
GuiControlGet, playblock,, RecBlockDefault
return

RecordingProfile:
GuiControl,, ProfileIcon, recordbutton.png
GuiControl,, ProfileLabel, Current Mode: Record
WinActivate, ahk_class REAPERwnd
WinWaitActive, ahk_class REAPERwnd, , 2
PostMessage, 0x111, 1016
PostMessage, 0x111, 40345
PostMessage, 0x111, 40099
WinWaitActive, REAPER Preferences, Audio device settings, 2
WinHide, REAPER Preferences, Audio device settings
ControlGet, InputBox, Hwnd,, Edit2, REAPER Preferences, Audio device settings
ControlGet, BlockSize, Hwnd,, Edit4, REAPER Preferences, Audio device settings
ControlSetText,, %recinputs%, ahk_id %InputBox%
ControlSetText,, %recblock%, ahk_id %BlockSize%
Sleep, 1
ControlClick, Button2, REAPER Preferences, OK
return

PlaybackProfile:
GuiControl,, ProfileIcon, sound.png
GuiControl,, ProfileLabel, Current Mode: Playback
WinActivate, ahk_class REAPERwnd
WinWaitActive, ahk_class REAPERwnd, , 2
PostMessage, 0x111, 1016
PostMessage, 0x111, 40345
PostMessage, 0x111, 40099
WinWaitActive, REAPER Preferences, Audio device settings, 2
WinHide, REAPER Preferences, Audio device settings
ControlGet, InputBox, Hwnd,, Edit2, REAPER Preferences, Audio device settings
ControlGet, BlockSize, Hwnd,, Edit4, REAPER Preferences, Audio device settings
ControlSetText,, %playinputs%, ahk_id %InputBox%
ControlSetText,, %playblock%, ahk_id %BlockSize%
Sleep, 1
ControlClick, Button2, REAPER Preferences, OK
return

StartDrag:
PostMessage, 0xA1, 2,,, A
return

ReloadScript:
Reload
return

ExitScript:
ExitApp
return