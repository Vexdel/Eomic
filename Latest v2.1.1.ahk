#SingleInstance Force
#NoEnv
scriptDir := A_ScriptDir
pngFile := "Logo.png"
pngFilePath := scriptDir . "\" . pngFile
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

Menu, Tray, Icon, %pngFilePath%

Gui -MaximizeBox +AlwaysOnTop
Gui Add, CheckBox, hWndhChkQuickHealthboost vskill_1 x8 y72 w132 h25, Quick HB [Q]

Gui Add, Slider, vSlhb x144 y72 w132 h25  ToolTip Range6-9  , 6

Gui Add, CheckBox, vskill_2 x8 y40 w132 h25, AutoReload
Gui Add, Slider, vGunAmount x144 y8 w132 h25 ToolTip Range2-10  , 2

Gui Add, Slider, vPing x416 y40 w132 h25 ToolTip Range120-500  , 250
Gui Add, CheckBox, vskill_3 x8 y8 w132 h25, QuickGun
Gui Add, DropDownList, vGun x416 y8 w132, Handgun|Heavy Pistol|Combat Pistol|Deagle|Automatics|Riot/sawed|Other shotguns|Default
Gui Add, Text, x280 y48 w73 h27, Ping Modifier
Gui Add, Slider, vSlgn x144 y40 w132 h25 ToolTip Range2-10  , 2
Gui Add, Button, gExecute x23 y128 w123 h30, Execute
Gui Add, Button, gPauseScript x279 y128 w123 h30, Pause
Gui Add, Button, gResumeScript x151 y128 w123 h30, Resume
Gui Add, Text, x8 y112 w530 h2 +0x10        
Gui Add, Button, gReloadScript x407 y128 w123 h30, Reload
Gui Add, Text, x280 y8 w132 h25 +0x200 , Choose Weapon
Gui Show, x443 y175 w553 h167, Easy Anomic V2
Gui Add, CheckBox, x280 y72 w120 h26 cRed, AutoHB
Gui Add, Text, x416 y72 w120 h23 +0x200, Uses your 10th slot HB.


Gui Add, Text, x520 y96 w36 h23 +0x200 -Background , V 2.1.1

ResumeScript: 

    Suspend, Off
    Paused := false
    return

PauseScript:
    Suspend, On  
    Paused := true
    return

F2::Gui, Restore
Return

Execute:

   if (Paused) 
        return

    Gui, Submit, NoHide
    Gui, Minimize 

GuiControlGet, isChecked, , AutoHB
    if (isChecked = 1) {
        AutoHBLoop()
    }

Return

GuiClose:
    ExitApp
    return

;AutoHB REQUIRES FULL SCREEN
AutoHBLoop() { 
    c1_color := 0xA7A7A7
    c2_color := 0xA7A7A7
    c3_color := 0xA7A7A7
    tolerance := 20
    counter := 0
    
    Loop {
        
        GuiControlGet, isChecked, , AutoHB
        if (isChecked = 0) {
            return 
        }
        
        PixelGetColor, c1, 1784, 20
        PixelGetColor, c2, 1856, 20
        PixelGetColor, c3, 1847, 20

        
        diff_c1 := ColorDiff(c1, c1_color)
        diff_c2 := ColorDiff(c2, c2_color)
        diff_c3 := ColorDiff(c3, c3_color)

        if (diff_c1 <= tolerance or diff_c2 > tolerance or diff_c3 > tolerance) {
            Sleep 85
        } else {
            BlockInput, on
            Sleep 9
            Send 0
            Click
            BlockInput, off
            Send 1
            Soundbeep
            Sleep 15000
        }
        Sleep 15
    }
}

ColorDiff(color1, color2) {
    r1 := (color1 & 0xFF0000) >> 16
    g1 := (color1 & 0x00FF00) >> 8
    b1 := color1 & 0x0000FF

    r2 := (color2 & 0xFF0000) >> 16
    g2 := (color2 & 0x00FF00) >> 8
    b2 := color2 & 0x0000FF

    return sqrt((r1 - r2)**2 + (g1 - g2)**2 + (b1 - b2)**2)
}

currentKeyHB := 6
initialKeyHB := 6


$*q::

    if (skill_1 = 1 && Slhb >= 6 && Slhb <= 9) {
        SendInput % currentKeyHB
        Click, down, left, 1
        Click, up, left, 1
        currentKeyHB--
        if (currentKeyHB < 6)
            currentKeyHB := Slhb
    }
    return


$XButton1::
    if (skill_2 = 1 && Slgn >= 1 && Slgn <= 10) {
        loop, % Slgn
        {
            SendInput %A_Index%
            SendInput {r}
            PingSleep = %Ping% * 2 + 25
            Sleep, %PingSleep%
        }
    }
    return


LoopCounter := 0
$XButton2::
    if (skill_3 = 1) {
        SleepValue := GetGunSleepValue(Gun)
        
        while (GetKeyState("XButton2", "P"))
        {
            Loop, %GunAmount%
            {
                SendEvent %A_Index%
                Click
                Sleep %SleepValue%
            }
        }
    }
    return


GetGunSleepValue(gun) {
    switch (gun) {
        case "Handgun":
            return 55
        case "Heavy Pistol":
            return 10
        case "Riot/sawed":
            return 10
        case "Other shotguns": 
            return 90
        case "Deagle":
            return 75
        case "Combat Pistol":
            return 9
        case "Default":
            return 15
        case "Automatics":
            return 3
        default:
            return 20
    }
}



ReloadScript: 
    MsgBox, 4,, Reload Easy Anomic?
    IfMsgBox, Yes
    {
        Reload
    }
    Return
