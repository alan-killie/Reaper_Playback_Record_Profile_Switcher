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

; Default values (fallbacks)
recinputs := 2
recblock := 128
playinputs := 0
playblock := 512

; Load saved values from INI
IniRead, recinputs, settings.ini, Recording, Inputs, %recinputs%
IniRead, recblock, settings.ini, Recording, BlockSize, %recblock%
IniRead, playinputs, settings.ini, Playback, Inputs, %playinputs%
IniRead, playblock, settings.ini, Playback, BlockSize, %playblock%


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
    Gui, Font, s11, Segui UI

    ; Initial icon and label
    Gui, Add, Picture, x10 y10 w30 h30 vProfileIcon, sound.ico
    Gui, Add, Text, x50 y17 w250 h25 cF0F0F0 vTitleLabel, REAPER PLAY/REC Profile Switcher
    Gui, Add, Text, x50 y15 w250 h25 BackgroundTrans vDragOverlay gStartDrag
    GuiControl, +Cursor, DragOverlay, SizeAll

    ; Profile section
    Gui, Add, GroupBox, x10 y50 w380 h145 cF0F0F0, Set and Apply Profiles

    ; Recording profile
    Gui, Add, Button, x20 y75 w175 h30 gSetRecordingDefaults, Set Recording Defaults
    GuiControl, +Cursor, RecHover, Hand
    Gui, Add, Button, x200 y75 w175 h30 gRecordingProfile, Apply Recording Profile

    ; Channels/ Block Size Combobox
    Gui, Add, Text, x25 y118 w80 h20 cF0F0F0, Input Ch:
    Gui, Add, ComboBox, x100 y115 w80 vRecInputDefault, 0|2|4|8|16
    Gui, Add, Text, x205 y118 w80 h20 cF0F0F0, Block Size:
    Gui, Add, ComboBox, x290 y115 w80 vRecBlockDefault, 64|128|256|512|1024

    ; Playback profile
    Gui, Add, Button, x20 y150 w175 h30 gSetPlaybackDefaults, Set Playback Defaults
    Gui, Add, Button, x200 y150 w175 h30 gPlaybackProfile, Apply Playback Profile

    ; Utility buttons
    Gui, Add, Button, x10 y200 w95 h30 gReloadScript, Reload Script
    Gui, Add, Button, x295 y200 w95 h30 gExitScript, Exit
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
IniWrite, %recinputs%, settings.ini, Recording, Inputs
IniWrite, %recblock%, settings.ini, Recording, BlockSize

return

SetPlaybackDefaults:
GuiControlGet, playinputs,, RecInputDefault
GuiControlGet, playblock,, RecBlockDefault
IniWrite, %playinputs%, settings.ini, Playback, Inputs
IniWrite, %playblock%, settings.ini, Playback, BlockSize

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

ExitScript:
ExitApp
return
