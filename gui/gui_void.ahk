gui_void_check:
	IfWinActive, NewsCycle MediaLink ; Om medialink är aktivt
	{
		IfWinNotExist, void ; Om void inte finns
		{
			Gui, void:Show
			Sleep, 100
			IfWinNotExist, void
			{
				Gui, void:Destroy
				gosub, gui_void
			}
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
			picw := voidw - 10
			pich := voidh - 10

			if (ref_voidy != voidy || ref_voidx != voidx || ref_voidw != voidw || ref_voidh != voidh) ; Om någon av dimensionerna har ändrats sedan senaste kontrollen...
			{
				WinMove, void,, voidx, voidy, voidw, voidh ; sätt nya dimensioner på void
				GuiControl, void:MoveDraw, print_jpg, w%picw% ; Sätt nya dimensioner på print-bilden
				GuiControl, void:MoveDraw, treeview, w%picw% ; Sätt nya dimensioner på treeview
				toLog("Nya dimensioner på Void: x" . voidx . " y" . voidy . " w" . voidw . " h" . voidh)
			}

			GuiControlGet, pic_size, void:Pos, print_jpg ; Hämta storlek på print-bilden
			if (pic_sizew > picw) ; om print-bilden är bredare än void...
			{
				GuiControl, void:MoveDraw, print_jpg, w%picw% h-1 ; sätt rätt storlek på bild
			}
			if (pic_sizeh > pich) ; om print-bilden är högre än void...
			{
				GuiControl, void:MoveDraw, print_jpg, h%pich% ; sätt rätt storlek på bild
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
	ImageListID := IL_Create(10)  ; Create an ImageList with initial capacity for 10 icons.
	icon_gif = %A_ScriptDir%\gui\ico\gif.ico
	icon_jpg = %A_ScriptDir%\gui\ico\jpg.ico
	icon_swf = %A_ScriptDir%\gui\ico\swf.ico
	icon_pdf = %A_ScriptDir%\gui\ico\pdf.ico
	icon_psd = %A_ScriptDir%\gui\ico\psd.ico

	toLog("++ IKON: " . icon_jpg)

	IL_Add(ImageListID, "shell32.dll", 4)
	IL_Add(ImageListID, icon_jpg)
	IL_Add(ImageListID, icon_gif)
	IL_Add(ImageListID, icon_swf)
	IL_Add(ImageListID, icon_pdf)
	IL_Add(ImageListID, icon_psd)


	WinGet, mlHWND, ID, NewsCycle MediaLink
	WinGetPos, mlx, mly,,, NewsCycle MediaLink
	ControlGetPos, voidx, voidy, voidw, voidh, wxWindowClassNR20, NewsCycle MediaLink

	voidy := voidy - 10
	voidx := mlx + voidx
	voidw := voidw - 4
	voidh := voidh - 8
	picw := voidw - 10
	pich := voidh - 40

	Gui, void:Add, Tab2, Buttons, Print|Webb
	Gui, void:Add, Picture, x4 y33 w%picw% h-1 vprint_jpg,

	Gui, void:Tab, 2
	Gui, void:Font, s7
	Gui, void:Add, Text, x4 y33 w800 vc_name, 
	Gui, void:Add, TreeView, vTreeView gTreeViewClick r15 x4 y50 w%picw% h%pich% ImageList%ImageListID%
	Gui, void:Show, x%voidx% y%voidy% w%voidw% h%voidh% NoActivate, void
	Gui, void:+ToolWindow -Caption +Border +Owner%mlHwnd%
	Gui, void:Color, ffffff
return

web_tree:
	Gui, void:Default ; Sätter void till default-fönster. Detta för att kunna använda treeview
	TV_Delete()
	order := getOrderInfo(order.complete) ; Hämtar information om aktuellt ordernummer och stoppar in den i objektet %order%
	customer_name := order.customer_name
	GuiControl, void:, c_name, %customer_name%
	startdate := order.startdate
	customer := getCustomerDir(customer_name, startdate)
	root := customer.path
	IfNotExist, %root%
	{
		TV_Add("Hittade inget här...")
		return
	}
	IfInString, root, \\\
	{
		TV_Add("Detta verkar inte vara en webbannons...")
		return
	}
	addFoldersToTree(root) ; Skannar igenom efter mappar på första nivån
	item_id := 0 ; För att börja räkna från toppen av trädet
	Loop
	{
		item_id := TV_GetNext(item_id, "Full") ; kollar om det finns något item efter denna
		if not item_id ; om det inte finns...
			break ; bryt loopen
		TV_GetText(item_text, item_id) ; Hämta text och ID på nästa item
		; new_root = %root%\%item_text% ; Sätter en ny sökväg i %new_root% att skanna efter mappar
		; addFoldersToTree(new_root, item_id) ; söker efter undermappar och filer i %new_root% och lägger till dem i trädet.
	}
return

treeViewClick:
	if (A_GuiEvent = "DoubleClick")
	{
		TV_GetText(item, A_EventInfo)
		parent_id := TV_GetParent(A_EventInfo)
		TV_GetText(parent, parent_id)
		file = %root%\%parent%\%item%
		toLog("Dubbelklickade på '" . file . "' i TreeView")
		run, %file%
	}
return