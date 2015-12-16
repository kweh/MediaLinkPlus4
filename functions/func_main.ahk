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
; * - 'true' om sant
; * - namnet på den control som är under muspekaren om klick inte skett i en listvy
; * - 'false' om det aktiva fönstret inte är MediaLink
; *
; *******************************************************************************************

mlActive(x=false)
{
	IfWinActive, NewsCycle MediaLink ; Om det aktiva fönstrets titelrad innehåller "NewsCycle MediaLink"
	{
		MouseGetPos, pos_x, pos_y, win_name, control ; Spara namnet på den control som är under muspekaren och lagra det i %control%
		if (InStr(control, "SysListView") ; Om %control% innehåller "SysListView"
		{
			return true ; returnera 'true'
		}
		return control ; returnerar namnet på den control som är under muspekaren
	}
	return false ; MediaLink är inte det aktiva fönstret.
}