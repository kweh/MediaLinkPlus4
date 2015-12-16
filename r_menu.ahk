get_ordernumber:
	order := getOrdernumber()
	msgbox % "Hela ordernumret: " . order.complete . "`nEndast ordernummer: " . order.stripped . "`nEndast materialnummer: " . order.material . ""
Return
