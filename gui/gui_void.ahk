gui_void_check:
	IfWinActive, NewsCycle MediaLink ; Om medialink är aktivt
	{
		IfWinNotExist, void ; Om void inte finns
		{
			gosub, gui_void ; Skapa fönstret
		}
		IfWinExist, void ; Om void finns
		{
			WinGetPos, mlx, mly,,, NewsCycle MediaLink ; Hämta position för Medialink-fönstret
			ControlGetPos, voidx, voidy, voidw, voidh, wxWindowClassNR20, NewsCycle MediaLink ; Hämta positition och dimensioner för void-utrymmet
			; Modifiera dimensionerna
			voidy := voidy - 8
			voidx := (mlx + voidx) + 4
			voidw := voidw - 4
			voidh := voidh - 4
			if (ref_voidy != voidy || ref_voidx != voidx || ref_voidw != voidw || ref_voidh != voidh)
			{
				WinMove, void,, voidx, voidy, voidw, voidh ; sätt dimensioner på void
				toLog("Nya dimensioner på Void: x" . voidx . " y" . voidy . " w" . voidw . " h" . voidh)
			}

			; Sätter referenser för nästa check
			ref_voidy := voidy
			ref_voidx := voidx
			ref_voidw := voidw
			ref_voidh := voidh

		}
	}
	Else
	{
		; Gui, void:Hide
	}
return

gui_void:
	WinGet, mlHWND, ID, NewsCycle MediaLink
	WinGetPos, mlx, mly,,, NewsCycle MediaLink
	ControlGetPos, voidx, voidy, voidw, voidh, wxWindowClassNR20, NewsCycle MediaLink

	voidy := voidy - 10
	voidx := mlx + voidx
	voidw := voidw - 4
	voidh := voidh - 8


	Gui, void:Show, x%voidx% y%voidy% w%voidw% h%voidh% NoActivate, void
	Gui, void:+ToolWindow -Caption +Border +Owner%mlHwnd%
	Gui, void:Color, ffffff
return