; DENNIS!
; Den här skiten måste kommenteras!
;

impCheck := false ; Ser till att checkboxen för backfill är urkryssad
themecolor := "8800cc" ; Variabel för accentfärg
ico_uncheck := chr(0xf1db) ; ASCII-kod för urkryssad checkbox (FontAwesome)
ico_check := chr(0xf058) ; ASCII-kod för ikryssad checkbox (FontAwesome)

notes = ; Temporär i brist på interna noteringar
(
widescreen, startsidan, en av de tre högst upp i högra hörnet. 31/12  2015
Och under annonstorget längre ner.
100`% SOV (bokat 300 000 exponeringar vilket bör räcka)
Använd tidigare material nr 1738494-05
Länkas till printannons i den här ordern med materialnummer -03
)

Gui, cx:Font, c000000 s24, Open Sans
Gui, cx:Add, Text, x25 yp+15, 0001234567-89
Gui, cx:Font, c%themecolor% s12, Open Sans
Gui, cx:Add, Text, x25 yp+40, Testkundens Bolag AB

Gui, cx:Font, c%themecolor% s7, Open Sans
Gui, cx:Add, Text, x25 yp+40 section, SITE
Gui, cx:Font, c888888 s12, Open Sans
Gui, cx:Add, Text, xs ys+15, NT.se
Gui, cx:Font, c%themecolor% s7, Open Sans
Gui, cx:Add, Text, xs+150 ys, FORMAT
Gui, cx:Font, c888888 s12, Open Sans
Gui, cx:Add, Text, xs+150 ys+15, WID
Gui, cx:Font, c%themecolor% s7, Open Sans
Gui, cx:Add, Text, xp+170 ys, SEKTION
Gui, cx:Font, c888888 s12, Open Sans
Gui, cx:Add, Text, xp ys+15, Start


Gui, cx:Font, c%themecolor% s7, Open Sans
Gui, cx:Add, Text, x25 yp+40 section, STARTDATUM
Gui, cx:Font, c%themecolor% s12, Open Sans
Gui, cx:Add, DateTime, HWNDstart_hwnd vstartdate w130 ys+15 xs-2 ; Sparar kontrollens (startdatum) HWND i %start_hwnd% och sparar innehållet i kontrollen i %startdate%
Gui, cx:Font, c%themecolor% s7, Open Sans
Gui, cx:Add, Text, xs+150 ys , STOPPDATUM
Gui, cx:Font, c%themecolor% s12, Open Sans
Gui, cx:Add, DateTime, HWNDend_hwnd venddate w130 ys+15 xs+148 ; Sparar kontrollens (slutdatum) HWND i %end_hwnd% och sparar innehållet i kontrollen i %enddate%

Gui, cx:Font, c%themecolor% s7, Open Sans
Gui, cx:Add, Text, xp+170 ys, EXPONERINGAR
Gui, cx:Font, c000000 s12, Open Sans
Gui, cx:Add, Edit, HWNDimps_hwnd vimpressions xp-7 ys+15 w100, 120000 ; Sparar kontrollens (impressions) HWND i %imps_hwnd% och sparar innehållet i kontrollen i %impressions%

Gui, cx:Font, c%themecolor% s7, Open Sans
Gui, cx:Add, Text, xp+120 ys, BACKFILL
Gui, cx:Font, c000000 s16, FontAwesome
Gui, cx:Add, Text, xp ys+19 gCheckBackfill vCheckBackfill,%ico_uncheck%

Gui, cx:Font, c%themecolor% s7, Open Sans
Gui, cx:Add, Text, x25 yp+60, NOTERINGAR
Gui, cx:Font, c777777 s8, Open Sans
Gui, cx:Add, Edit, HWNDnotes_hwnd vnotes x20 yp+15 w485, %notes% ; Sparar kontrollens (notes) HWND i %notes_hwnd% och sparar innehållet i kontrollen i %notes%


Gui, cx:Color, FFFFFF

; Hämtar mått och position på kontroller för att kunna beskära dem. Kontroller specas med respektive variabel
GuiControlGet, start, cx:pos, startdate
GuiControlGet, end, cx:pos, enddate
GuiControlGet, imps, cx:pos, impressions
GuiControlGet, note, cx:pos, notes

; Beskär kontroller så att endast nedre kantlinjen syns. Kontroller specas med respektive HWND
WinSet, region, % "2-2 w" startw-4 " h" starth-2, % "ahk_id " start_hwnd
WinSet, region, % "2-2 w" endw-4 " h" endh-2, % "ahk_id " end_hwnd
WinSet, region, % "2-2 w" impsw-4 " h" impsh-2, % "ahk_id " imps_hwnd
WinSet, region, % "2-2 w" notew-4 " h" noteh-2, % "ahk_id " notes_hwnd

Gui, cx:Show, center w530 h500, Bokning
ControlFocus, , ahk_id %notes_hwnd% ; Sätter fokus på noteringar-kontrollen. Annars blir fokus på startdatum, vilket ser fult ut.
return 


checkBackfill:
	if (impCheck = 0)
	{
		GuiControl, , checkBackfill, %ico_check%
		GuiControl, Disable, impressions
		impCheck = true
		return
	} 
	else
	{
		GuiControl, , checkBackfill, %ico_uncheck%
		GuiControl, Enable, impressions
		impCheck := 0
	}
return