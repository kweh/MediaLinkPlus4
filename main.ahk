
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
toLog("MedialinkPlus startat - funktioner inladdade.")

; ************************************************************
; * Timers
; ************************************************************

SetTimer, gui_void_check, 500
toLog("Startade timer för Void.")

; ************************************************************
; * Huvudscript
; ************************************************************

#if (mlActive()) ; Nedanstående körs endast om mlActive är 'true'

Rbutton:: ; Vid klick på höger musknapp
	if (menu) ; om menyn redan visats en gång (menu = true), ta bort allt innehåll och populera menyn på nytt
	{
		Menu, r_menu, DeleteAll
		menu := false
	}
	Menu, r_menu, Add, Ordernummer, get_ordernumber
	Menu, r_menu, Add, Test, get_ordernumber
	toLog("Öppnar högerklicksmeny.")
	Menu, r_menu, Show
	menu := true ; Sätter %menu% till 'true'. Dvs att menyn har visats en gång
Return

#if ; Slut på mlActive-ifsats

^#!c::
	gosub, gui_console
return


; ************************************************************
; * Inkluderar subrutiner sist för att undvika return-stopp
; ************************************************************

return

; GUI-filer
#include gui/gui_cxense_post.ahk
#include gui/gui_void.ahk

; Console
#include gui/gui_console.ahk

#include r_menu.ahk