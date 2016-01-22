gui_medialink_mod:
	toLog("kör gui_medialink_mod")
	IfWinActive, NewsCycle MediaLink
	{
		ControlGetPos, x, y, w, h, Edit3, NewsCycle MediaLink ; Hämtar position för textfältet "interna noteringar"
		if (h = 150) ; Om höjd på textfältet redan är 150
		{
			return ; Avbryt - Detta har uppenbarligen redan körts.
		}
		Control, Hide, , Static60, NewsCycle MediaLink 	; Gömmer texten "bokningsmeddelande:"
		Control, Hide, , Edit2, NewsCycle MediaLink 	; Gömmer textfältet för "bokningsmeddelande:"
		Control, Hide, , Button11, NewsCycle MediaLink 	; Gömmer knappen bredvid "bokningsmeddelande:"

		Control, Hide, , Static64, NewsCycle MediaLink 	; Gömmer texten "Annonsinnehåll:"
		Control, Hide, , Edit6, NewsCycle MediaLink 	; Gömmer textfältet för "Annonsinnehåll:"
		Control, Hide, , Button16, NewsCycle MediaLink 	; Gömmer knappen bredvid "Annonsinnehåll:"

		Control, Hide, , Static65, NewsCycle MediaLink 	; Gömmer texten "Manustext:"
		Control, Hide, , Edit7, NewsCycle MediaLink 	; Gömmer textfältet för "Manustext:"
		Control, Hide, , Button15, NewsCycle MediaLink 	; Gömmer knappen bredvid "Manustext:"

		ControlGetPos, x, y, w, h, Static61, NewsCycle MediaLink ; Hämtar position för texten "interna noteringar"
		y := y - 40
		ControlMove, Static61, ,%y%, , , NewsCycle MediaLink  ; Flyttar texten "interna noteringar"
		ControlGetPos, x, y, w, h, Edit3, NewsCycle MediaLink ; Hämtar position för textfältet "interna noteringar"
		y := y - 40
		ControlMove, Edit3, ,%y%, ,150 , NewsCycle MediaLink ; Flyttar och ändrar storlek på textfältet "interna noteringar"
		ControlGetPos, x, y, w, h, Button12, NewsCycle MediaLink ; Hämtar position för knappen "interna noteringar"
		y := y - 40
		ControlMove, Button12, ,%y%, , , NewsCycle MediaLink ; Flyttar på knappen "interna noteringar"

		ControlGetPos, x, y, w, h, Static62, NewsCycle MediaLink ; Hämtar position för texten "Kampanjnoteringar"
		y := y + 90
		ControlMove, Static62, ,%y%, , , NewsCycle MediaLink ; Flyttar på texten "Kampanjnoteringar"
		ControlGetPos, x, y, w, h, Edit4, NewsCycle MediaLink ; Hämtar position för textfältet "Kampanjnoteringar"
		y := y + 90
		ControlMove, Edit4, ,%y%, , , NewsCycle MediaLink ; Flyttar på textfältet "Kampanjnoteringar"
		ControlGetPos, x, y, w, h, Button13, NewsCycle MediaLink ; Hämtar position för knappen "Kampanjnoteringar"
		y := y + 90
		ControlMove, Button13, ,%y%, , , NewsCycle MediaLink ; Flyttar på knappen "Kampanjnoteringar"

		ControlGetPos, x, y, w, h, Static63, NewsCycle MediaLink ; Hämtar position för texten "Fakturatext"
		y := y + 90
		ControlMove, Static63, ,%y%, , , NewsCycle MediaLink ; Flyttar på texten "Fakturatext"
		ControlGetPos, x, y, w, h, Edit5, NewsCycle MediaLink ; Hämtar position för textfältet "Fakturatext"
		y := y + 90
		ControlMove, Edit5, ,%y%, , , NewsCycle MediaLink ; Flyttar på textfältet "Fakturatext"
		ControlGetPos, x, y, w, h, Button14, NewsCycle MediaLink ; Hämtar position för knappen "Fakturatext"
		y := y + 90
		ControlMove, Button14, ,%y%, , , NewsCycle MediaLink ; Flyttar på knappen "Fakturatext"
		
		Control, Add, Print, ComboBox1, NewsCycle MediaLink ; Lägger till "Print" i sökrutan

		SetTimer, gui_medialink_mod, Off
		modtimer := 0
		SetTimer, gui_medialink_mod_change, 500
		toLog("Stängde av timer för medialink_mod")
	}
return

gui_medialink_mod_change:
	IfWinActive, NewsCycle MediaLink
	{
		if (modtimer = 0)
		{
			ControlGetPos, lx, ly, lw, lh, Edit3, NewsCycle MediaLink ; Hämtar position för textfältet "interna noteringar" och sparar denna för att jämföra med nästa körning
			modtimer := 1
			return
		}
		ControlGetPos, x, y, w, h, Edit3, NewsCycle MediaLink ; Hämtar position för textfältet "interna noteringar"
		if (y != ly) ; Om positionen på interna noteringar ändrats sedan senaste kontrollen...
		{
			gosub, gui_medialink_mod ; Kör subrutinen för att flytta kontrollerna igen.
		}
		ControlGetPos, lx, ly, lw, lh, Edit3, NewsCycle MediaLink ; Hämtar position för textfältet "interna noteringar" och sparar denna för att jämföra med nästa körning
	}
return