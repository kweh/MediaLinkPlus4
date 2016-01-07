gui_console:
	IfWinExist, console
	{
		Gui, console:Destroy
	}
	else 
	{
		Gui, console:Add, Text, h240 w800 ReadOnly vconsole, %console_txt%
		Gui, console:+ToolWindow +Border +Owner%mlHwnd% +AlwaysOnTop
		Gui, console:Show,, console
		toLog("Öppnar console...") ; Anropar funktionen tom för att köra läs-funktionen
	}
return

consoleGuiClose:
	Gui, console:Destroy
Return