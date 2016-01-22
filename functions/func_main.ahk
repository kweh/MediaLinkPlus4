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
; ******************************************************************************************

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
	IfWinActive, void ; Om det aktiva fönstret är void
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
; ******************************************************************************************

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
; *  getPrint()
; * ----------------------------------------------------------------------------------------
; * Hämtar och returnerar url till print-pdf och eProof på vald post i MediaLink
; * ----------------------------------------------------------------------------------------
; * INPUT:
; * - Ordernummer utan materialnummer
; * - Materialnummer (valfritt, om inget anges sätts denna till 01)
; *
; * OUTPUT:
; * - Ett objekt med två keys:
; * - - pdf			| sökväg till printannons som pdf
; * - - jpg			| sökväg till eproof-bild
; *
; ******************************************************************************************

getPrint(ordernr, mnr="01")
{
	Gui, void:Default
	obj := Object() ; Gör %obj% till ett tomt objekt
	StringTrimLeft, last_two, ordernr, 8 ; Sätter %last_two% till de sista två siffrorna i ordernumret
	StringTrimLeft, no_leading_zeroes, ordernr, 3 ; Sätter %no_leading_zeroes% till ordernumret exkl. inledande nollor.
	pdf_path = \\nt.se\Adbase\Annonser\Ad\%last_two%\10%no_leading_zeroes%-%mnr%.pdf ; Sätter sökväg för pdf med variabler
	img_path = \\nt.se\Adbase\Annonser\eProof\%ordernr%-%mnr%.jpg ; Sätter sökväg för jpg med variabler

	toLog("Letar efter PDF på " . ordernr)
	toLog("Sökväg: " pdf_path)
	IfExist, %pdf_path% ; Om det finns en pdf på %pdf_path%...
	{
		obj.pdf := pdf_path ; Sätt %obj.pdf% till sökvägen till pdf-filen
		toLog("** PDF hittad")
		toLog("Letar efter JPG på " . ordernr)
		toLog("Sökväg: " . img_path)
		IfExist, %img_path% ; Och om det finns en jpg på %img_path%...
		{
			obj.jpg := img_path ; Sätt %obj.jpg% till sökvägen till jpg-filen
			GuiControl,void:, print_jpg, %img_path% ; Sätt förhandsvisningsbilden i void till denna bild
			toLog("** JPG hittad")
		}
		Else ; Om det inte finns någon jpg...
		{
			obj.jpg := false ; Sätt %obj.jpg% till false
			GuiControl,void:, print_jpg,  ; Sätt förhandsvisningsbilden i void till inget
			toLog("** Ingen JPG hittad")
		}
	}
	Else ; Om det inte finns någon pdf...
	{
		obj.pdf := false ; Sätt %obj.pdf% till false
		obj.jpg := false ; Sätt %obj.jpg% till false
		GuiControl,void:, print_jpg,  ; Sätt förhandsvisningsbilden i void till inget
		toLog("** Ingen PDF hittad")
	}
	return obj ; Returnerar objektet

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
; ******************************************************************************************

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



; ******************************************************************************************
; *  addFoldersToTree
; * ----------------------------------------------------------------------------------------
; * Listar alla filer och mappar i en kundmapp och visar dessa i en TreeView i Void
; * ----------------------------------------------------------------------------------------
; * INPUT:
; * - folder: sökväg till mapp att söka igenom
; * - parentItemID: eventuellt treeview-ID att lägga nya objekt i
; *
; * OUTPUT:
; * - Ingen output, endast append till treeview
; *
; ******************************************************************************************

addFoldersToTree(folder, parentItemID = 0)
{
	Loop %folder%\*.*, 1
	{
		if (A_LoopFileName = "thumbs.db")
			continue
		IfNotInString, A_LoopFileName, . ; om item inte innehåller en punkt (det är med största sannolikhet en mapp)
		{
			addFoldersToTree(A_LoopFileFullPath, TV_Add(A_LoopFileName, ParentItemID, "Icon1"))
			continue
		}
		IfInString, A_LoopFileName, .jpg ; om item innehåller .jpg
		{
			addFoldersToTree(A_LoopFileFullPath, TV_Add(A_LoopFileName, ParentItemID, "Icon2"))
			continue
		}
		IfInString, A_LoopFileName, .png ; om item innehåller .png
		{
			addFoldersToTree(A_LoopFileFullPath, TV_Add(A_LoopFileName, ParentItemID, "Icon2"))
			continue
		}
		IfInString, A_LoopFileName, .gif ; om item innehåller .gif
		{
			addFoldersToTree(A_LoopFileFullPath, TV_Add(A_LoopFileName, ParentItemID, "Icon3"))
			continue
		}
		IfInString, A_LoopFileName, .swf ; om item innehåller .swf
		{
			addFoldersToTree(A_LoopFileFullPath, TV_Add(A_LoopFileName, ParentItemID, "Icon4"))
			continue
		}
		IfInString, A_LoopFileName, .pdf ; om item innehåller .pdf
		{
			addFoldersToTree(A_LoopFileFullPath, TV_Add(A_LoopFileName, ParentItemID, "Icon5"))
			continue
		}
		IfInString, A_LoopFileName, .psd ; om item innehåller .psd
		{
			addFoldersToTree(A_LoopFileFullPath, TV_Add(A_LoopFileName, ParentItemID, "Icon6"))
			continue
		}
		addFoldersToTree(A_LoopFileFullPath, TV_Add(A_LoopFileName, ParentItemID))

	}
}



; ******************************************************************************************
; *  getOrderInfo
; * ----------------------------------------------------------------------------------------
; * Hämtar information om en order ur AdBase-databasen och lägger i ett objekt
; * ----------------------------------------------------------------------------------------
; * INPUT:
; * - ordernr: ordernr inkl. materialnummer att hämta information om
; *
; * OUTPUT:
; * - Ett objekt med följande keys:
; *
; ******************************************************************************************

getOrderInfo(ordernr)
{
	order := Object() ; sätter %order% till ett tomt objekt
	ConnectString := "Provider=SQLOLEDB.1;Password=adops2015;Persist Security Info=True;User ID=adops;Initial Catalog=adbprod;Data Source=adbasedb1.nt.se;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False"
	toLog(connectstring)
	sql_query =
(
SELECT 
	aoincampaign.campaignnumber 		as 'Kampanjnummer', 
	aoincampaign.quantityrequested 	as 'Exponeringar', 
	aoincampaign.startdate 				as 'Startdatum', 
	aoincampaign.enddate 				as 'Stoppdatum', 
	aoproducts.name 						as 'Produkt',
	aoinflight.internetunitid 			as 'Internetenhets-ID',
	CfInUnitType.name 					as 'Internetenhet',
	Customer.AccountNumber 				as 'Kundnummer',
	Customer.Name1 						as 'Kundnamn',	
	Customer.TypeID 						as 'Kundtyp',
	AoAdOrder.NetAmount 					as 'pris ink moms eft. fakt',
	AoSpecialPrice.SpecialPriceValue as 'Specialpris',
	UsrUsers.EmailAddress				as 'Säljarmail',
	CfInUnitType.height 					as 'Höjd',
	CfInUnitType.width 					as 'Bredd',
	aoincampaign.campaigntypeid	 	as 'kampanjtyp-ID',
	convert(varchar(max), convert(varbinary(8000),shblobdata.blobdata)) as 'Interna noteringar',
	AoAdOrder.CreateDate					as 'Skapad datum',
	AoAdOrder.LastEditDate				as 'Senast ändrad'

FROM aoincampaign
LEFT JOIN AoInflight 			ON aoinflight.campaignid 				= aoincampaign.id
LEFT JOIN AoProducts 			ON AoProducts.Id 							= aoinflight.siteID
LEFT JOIN CfInUnitType 			ON CfInUnitType.Id 						= aoinflight.internetunitid
LEFT JOIN AoOrderCustomers 	ON AoOrderCustomers.AdOrderId			= aoinflight.adorderid
LEFT JOIN Customer 				ON Customer.AccountId					= AoOrderCustomers.CustomerId 
LEFT JOIN AoAdOrder 				ON AoAdOrder.Id 							= AoInCampaign.AdOrderId
LEFT JOIN AoSpecialPrice 		ON AoSpecialPrice.AoInFlightId		= AoInflight.Id
LEFT JOIN UsrUsers				ON UsrUsers.UserId						= AoAdOrder.SellerId
LEFT JOIN ShBlobData				ON ShBlobData.Id							= AoInCampaign.InternalNotesID

WHERE 
	campaigntypeid IN (1,4,8)
	AND aoincampaign.campaignnumber = '%ordernr%'
)

	query := ADOSQL(ConnectString, sql_query)
	; Sätter namn på de olika kolumnerna
	c_imps := 2
	c_startdate := 3
	c_enddate := 4
	c_product := 5
	c_unit_id := 6
	c_customer_nr := 8
	c_customer_name := 9
	c_net_price := 11
	c_special_price := 12
	c_email := 13
	c_height := 14
	c_width := 15
	c_internalnotes := 17
	c_createdate := 18
	c_changedate := 19

	; Populerar objektet med keys och values
	order.customer_name 	:= query[2, c_customer_name]
	order.customer_nr 		:= query[2, c_customer_nr]
	order.imps 				:= query[2, c_imps]
	imps 					:= query[2, c_imps]
	order.startdate 		:= query[2, c_startdate]
	order.enddate 			:= query[2, c_enddate]
	unit_id 				:= query[2, c_unit_id]
	order.unit_id 			:= query[2, c_unit_id]
	product 				:= query[2, c_product]
	order.product 			:= query[2, c_product]	
	order.format 			:= getFormat(unit_id)
	product_split 			:= StrSplit(product, A_Space)
	order.paper 			:= product_split[1]
	order.site 				:= product_split[2]
	order.net_price 		:= Round(query[2, c_net_price])
	order.special_price 	:= Round(query[2, c_special_price])
	special_price 			:= Round(query[2, c_special_price])
	order.CPM 				:= Round(special_price/(imps/1000))
	order.email 			:= query[2, c_email]
	order.height 			:= query[2,c_height]
	order.width 			:= query[2,c_width]
	order.internalnotes 	:= query[2,c_internalnotes]
	order.createdate 		:= query[2,c_createdate]
	order.changedate 		:= query[2,c_changedate]

	return order ; returnerar objektet
}



; ******************************************************************************************
; *  getCustomerDir
; * ----------------------------------------------------------------------------------------
; * Returnerar mappstruktur för kund
; * ----------------------------------------------------------------------------------------
; * INPUT:
; * - name: Kundnamn
; * - startdate: Startdatum
; *
; * OUTPUT:
; * - Ett objekt med följande keys:
; * - - year: år för startdatum
; * - - name: kundnamn rensat på ogiltiga tecken
; * - - first: första bokstaven i kundens namn
; * - - path: sökväg till kundens mapp
; *
; ******************************************************************************************

getCustomerDir(name, startdate)
{
	obj := Object()

	; Sätter key 'year' till det år startdatumet är
	StringTrimRight, year, startdate, 6
	obj.year := year

	; Nedanstående rensar och ersätter ogiltiga tecken i kundnamnet och sätter det nya namnet i key 'name'
	StringReplace, name, name, &&, &, All
	StringReplace, name, name, &, %A_SPACE%, All
	StringReplace, name, name, /, %A_SPACE%, All
	StringReplace, name, name, \, %A_SPACE%, All
	StringReplace, name, name, :, %A_SPACE%, All
	obj.name := name

	; Sätter key 'first' till första bokstaven i kundens namn
	StringLen, num_letters, name
	to_remove := num_letters - 1
	StringTrimRight, first, name, %to_remove%
	obj.first := first

	obj.path := "G:\NTM\NTM Digital Produktion\Webbannonser\0-Arkiv\" . year . "\" . first . "\" . name . ""
	toLog(obj.path)
	return obj ; returnerar objektet
}



; ******************************************************************************************
; *  getFormat
; * ----------------------------------------------------------------------------------------
; * Returnerar kortnamn för formatet vars ID ges som inpu
; * ----------------------------------------------------------------------------------------
; * INPUT:
; * - name: format-ID från adBase
; *
; * OUTPUT:
; * - kortnamn för format
; *
; ******************************************************************************************

getFormat(id)
{
	; Lista finns i adbase dbo.CgInUnitType
	format =
	format := id = "139"		? "WID" : format
	format := id = "3"			? "WID" : format
	format := id = "141"		? "OUT" : format
	format := id = "4"			? "OUT" : format
	format := id = "1"			? "PAN" : format
	format := id = "33"			? "PAN" : format
	format := id = "70"			? "PAN" : format
	format := id = "70"			? "PAN" : format
	format := id = "129"		? "PAN" : format
	format := id = "135"		? "PAN" : format
	format := id = "137"		? "PAN" : format
	format := id = "145"		? "PAN" : format
	format := id = "146"		? "PAN" : format
	format := id = "147"		? "PAN" : format
	format := id = "148"		? "PAN" : format
	format := id = "149"		? "PAN" : format
	format := id = "156"		? "PAN" : format
	format := id = "167"		? "PAN" : format
	format := id = "168"		? "PAN" : format
	format := id = "136"		? "PANXL" : format
	format := id = "138"		? "MOD" : format
	format := id = "151"		? "MOD" : format
	format := id = "197"		? "MOD" : format
	format := id = "144"		? "MKMOD" : format
	format := id = "37"			? "180" : format
	format := id = "196"		? "350" : format
	format := id = "34"			? "380" : format
	format := id = "106"		? "380" : format
	format := id = "130"		? "380" : format
	format := id = "112"		? "380" : format
	format := id = "38"			? "580" : format
	format := id = "9"			? "HEL" : format
	format := id = "108"		? "TXT" : format
	format := id = "57"			? "MOB" : format
	format := id = "58"			? "MOB" : format
	format := id = "59"			? "MOB" : format
	format := id = "61"			? "MOB" : format
	format := id = "62"			? "MOB" : format
	format := id = "117"		? "MOB" : format
	format := id = "214"		? "MOB" : format
	format := id = "150"		? "TORGET" : format
	format := id = "118"		? "REACH468" : format
	format := id = "119"		? "REACH250" : format
	format := id = "174"		? "SNURRA" : format
	format := id = "85"			? "SKYLT" : format
	format := id = "98"			? "SKYLT" : format
	format := id = "99"			? "SKYLT" : format
	format := id = "100"		? "SKYLT" : format
	format := id = "101"		? "SKYLT" : format
	format := id = "126"		? "SKYLT" : format
	format := id = "128"		? "SKYLT" : format
	format := id = "128"		? "SKYLT" : format
	format := id = "152"		? "SKYLT" : format
	format := id = "142"		? "ARTIKEL" : format
	format := id = "166"		? "ARTIKEL" : format
	format := id = "200"		? "ARTIKEL" : format

	return format
}