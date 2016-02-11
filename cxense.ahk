cx_test:
	; xml := cx_getUrl("cxad.cxense.com/api/secure/folder/advertising")
	; ; xpath = //folder/childFolder[name/text() = "NTM - Leeads"]/folderId/text()
	; xpath = //folder/childFolder/name[contains(text(),'- 32604 -')]/../folderId/text()
	; msgbox % parseXML(xml, xpath)
	; folderId := cx_get_customer("56395")
	adbase := getOrderInfo(order.complete)
	customer_nr := adbase.customer_nr
	folderId := cx_get_customer(customer_nr)
	Run, https://cxad.cxense.com/adv/folder/%folderId%
	
return