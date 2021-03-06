; ************************************************************
; * Initial setup
; ************************************************************
#SingleInstance force ; Endast en instans av MediaLinkPlus kan vara aktiv i taget.
#Persistent ; Scriptet fortsätter ligga aktivt även när det körts klart



; ************************************************************
; * Inkluderar filer
; ************************************************************

; Funktioner
#include functions/func_main.ahk
#include functions/func_fx.ahk
#include functions/func_cxense.ahk
#include safe.ahk
#include includes/httpreq.ahk
toLog("MedialinkPlus startat - funktioner inladdade.") 

; ************************************************************
; * Timers
; ************************************************************

; SetTimer, gui_void_check, 500
; toLog("Startade timer för Void.")

; SetTimer, gui_medialink_mod, 500
; toLog("Startade timer för medialink_mod")

; ************************************************************
; * Splash
; ************************************************************

; SplashImage, splash.png, B CW18ff00,,,Splash1
; WinSet, TransColor, 000000 255, Splash1
; Sleep, 2000
; SplashImage, Off

; ************************************************************
; * Huvudscript
; ************************************************************

#if (mlActive()) ; Nedanstående körs endast om mlActive är 'true'
; \/--------------------------------------------------------\/

Rbutton:: ; Vid klick på höger musknapp
	if (menu) ; om menyn redan visats en gång (menu = true), ta bort allt innehåll och populera menyn på nytt
	{
		Menu, r_menu, DeleteAll
		menu := false
	}
	order := getOrdernumber() ; Hämtar ordernummer från lista
	print := getPrint(order.stripped) ; Kontrollerar om det finns en printannons på ordernumret
	Menu, r_menu, Add, Print finns, gui_cxense_post
	Menu, r_menu, Icon, Print finns, ico/print_exists.png,,0 ; ",,0" behövs för att transparens ska fungera
	Menu, r_menu, Add, Ordernummer, get_ordernumber
	Menu, r_menu, Add, Test, cx_test
	toLog("Öppnar högerklicksmeny.")
	Menu, r_menu, Color, ddeeFF
	Menu, r_menu, Show
	menu := true ; Sätter %menu% till 'true'. Dvs att menyn har visats en gång
Return

~Lbutton::
	order := getOrdernumber()
	print := getPrint(order.stripped)
	gosub, web_tree
return

#if ; Slut på mlActive-ifsats
; []--------------------------------------------------------[]


#IfWinActive, NewsCycle MediaLink

Enter::
	ControlGetFocus, focus_ctrl, NewsCycle MediaLink
	if (focus_ctrl = "Edit1")
	{
		ControlGet, focus_list, Choice,, ComboBox1, NewsCycle MediaLink
		if (focus_list = "Print")
		{
			ControlGetText, edit_text, Edit1, NewsCycle MediaLink
			StringSplit, edit_split, edit_text, -
			ordernr := getPrint(edit_split1, edit_split2)
			if (ordernr.pdf = 0)
			{
				msgbox % "Ingen PDF hittad."
			}
			Else
			{
				file_pdf := ordernr.pdf
				Run, %file_pdf%
			}

		}
	}
return

#If

^#!c::
	gosub, gui_console
return

#!x::
	gosub, cx_test
return

; ************************************************************
; * Inkluderar subrutiner sist för att undvika return-stopp
; ************************************************************

return

; GUI-filer
#include gui/gui_cxense_post.ahk
#include gui/gui_void.ahk
#include gui/gui_medialink_mod.ahk

; Console
#include gui/gui_console.ahk

; Externa
#include includes/adosql.ahk

; Cxense-subrutiner
#include cxense.ahk

#include r_menu.ahk