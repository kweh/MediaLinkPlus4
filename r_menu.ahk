get_ordernumber:
	order := getOrdernumber()
	msgbox % "Hela ordernumret: " . order.complete . "`nEndast ordernummer: " . order.stripped . "`nEndast materialnummer: " . order.material . ""
Return

get_print:
	order := getOrdernumber()
	print := getPrint(order.stripped)
	msgbox % "pdf: " . print.pdf . "`njpg: " . print.jpg
return
