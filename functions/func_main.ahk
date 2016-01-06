; ******************************************************************************************
; *  mlActive
; * ----------------------------------------------------------------------------------------
; * Kontrollerar om Medialink är det aktiva fönstret och om ett klick har skett i en listvy
; * Returnerar 'true' om så är fallet.
; * ----------------------------------------------------------------------------------------
; * INPUT:
; * - Ingenting
; *
; * OUTPUT:
; * - namnet på den control som befinner sig under muspekaren
; * - 'false' om det aktiva fönstret inte är MediaLink eller om control inte är en listvy
; *
; *******************************************************************************************

mlActive(x=false)
{
	IfWinActive, NewsCycle MediaLink ; Om det aktiva fönstrets titelrad innehåller "NewsCycle MediaLink"...
	{
		MouseGetPos, pos_x, pos_y, win_name, control ; Spara namnet på den control som är under muspekaren och lagra det i %control%
		if (InStr(control, "SysListView")) ; Om %control% innehåller "SysListView"...
		{
			return control ; returnera 'true'
		}
		return false ; returnerar 'false'
	}
	return false ; MediaLink är inte det aktiva fönstret.
}



; ******************************************************************************************
; *  getOrdernumber
; * ----------------------------------------------------------------------------------------
; * Hämtar och returnerar ordernummer på vald post i MediaLink
; * ----------------------------------------------------------------------------------------
; * INPUT:
; * - Ingenting
; *
; * OUTPUT:
; * - Ett objekt med tre keys:
; * - - complete	| hela ordernumret inkl. materialnummer
; * - - stripped	| endast ordernumret exkl. materialnummer
; * - - material 	| endast materialnumret
; *
; *******************************************************************************************

getOrdernumber(x=False)
{
	obj := Object() ; Gör %obj% till ett tomt objekt
	control := mlActive() ; sätter %control% till namnet på den control som är under muspekaren
	ControlGet, ordernumber, List, Focused Col1, %control%, NewsCycle MediaLink ; sätter innehållet i den första kolumnen i den markerade raden till %ordernumber%
	StringSplit, ordernumber, ordernumber, `n ; splittar %ordernumber% på `n (radbrytning) för att separera flera ordernummer
	ordernumber := ordernumber1 ; sätter %ordernumber% till den första förekomsten i den splittade listan - alltså första ordernumret

	StringSplit, order_split, ordernumber, - ; splittar %ordernumber% på - (bindestreck) för att dela på ordernummer och materialnummer

	obj.complete := ordernumber ; sätter %obj.complete% till hela ordernumret inkl. materialnummer
	obj.stripped := order_split1 ; sätter %obj.stripped% till endast ordernummer exkl. materialnummer
	obj.material := order_split2 ; sätter %obj.material% till endast materialnummer

	return obj ; returnerar objektet
}

; ******************************************************************************************
; *  toLog
; * ----------------------------------------------------------------------------------------
; * Skriver input till console.txt för att sedan visas i console
; * ----------------------------------------------------------------------------------------
; * INPUT:
; * - Variabel
; * - String
; * - Kombination av ovanstående
; *
; * OUTPUT:
; * - Ingen output, endast append till textfil
; *
; *******************************************************************************************

toLog(txt)
{
	FormatTime, timestamp, ,HH:mm:ss
	FileAppend, `n%timestamp% - %txt%, %dir_main%console.txt ; Lägger till input i console.txt
	IfWinExist, console ; Om console är öppen...
	{
		Loop, Read, %dir_main%console.txt ; Läser innehållet i console.txt - rad för rad
		{
			num_lines := A_Index ; sätter %num_lines% till antalet rader
		}
		from_line := num_lines - 15 ; sätter %from_line% till antalet rader - 10. Ändra här för att välja hur många rader som ska listas.
		Loop, Read, %dir_main%console.txt ; Läser innehållet i console.txt - rad för rad
		{
			if (A_Index > from_line) ; Om det är någon av de tio sista raderna...
			{
				console_txt = %console_txt%%A_LoopReadLine%`n ; Lägg till raden i %console_txt%
			}
		}
		GuiControl, console:, console, %console_txt% ; Ersätter innehållet i textfältet i console-fönstret med det som precis lästes in.
	}
}