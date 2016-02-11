cx_user = API.User:Pass123

cx_getUrl(url) ; Skickar en GET request till %url% och returnerar DATA
{
	URL = https://%cx_user%@%url%
	DATA := ""
	HEAD = Content-Type: text/xml`nAuthorization: Basic QVBJLlVzZXI6cGFzczEyMw==
	OPTS = 
	HTTPRequest( URL, DATA, HEAD, OPTS )
	return DATA
}

parseXML(xml, xpath)
{
	StringReplace, xml, xml, cx:, , All
	doc := ComObjCreate("MSXML2.DOMDocument.6.0")
	doc.async := false
	doc.loadXML(xml)

	DocNode := doc.selectSingleNode(xpath)
	; DocNode := doc.selectNodes(xpath)
	DocText := DocNode.text
	return DocText
}

cx_get_customer(kundnummer)
{
	xml := cx_getUrl("cxad.cxense.com/api/secure/folder/advertising")
	xpath = //folder/childFolder/name[contains(text(),'- %kundnummer% -')]/../folderId/text()
	folderId := parseXML(xml, xpath)
	return folderId
}