
; ************************************************************
; * Initial setup
; ************************************************************
#SingleInstance force ; Endast en instans av MediaLinkPlus kan vara aktiv i taget.
#Persistent ; Scriptet fortsätter ligga aktivt även när det körts klart



; ************************************************************
; * Inkluderar filer
; ************************************************************

; GUI-filer
#include gui/gui_cxense_post.ahk

; Funktioner
#include functions/func_main.ahk




; ************************************************************
; * Huvudscript
; ************************************************************

#if (mlActive()) ; Nedanstående körs endast om mlActive är 'true' eller

Rbutton:: ; Vid klick på höger musknapp
Return

#if ; Slut på mlActive-ifsats