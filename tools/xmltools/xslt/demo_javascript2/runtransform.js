/*
** Description:
**	Nice XSLT driver demo in JavaScript using MSXML (i.e. to be run on a Windows PC only).
** 	Note: You will need to install MSXML (https://www.microsoft.com/en-gb/download/details.aspx?id=6276).
**
** Example usage:
**	cscript //nologo runtransform.js transform.xsl intput.xml out.txt
**
**	
** JeremyC 26-10-2018
*/

main();

function main()
{
	if ( WScript.Arguments.length != 3 )
	{
		WScript.Echo("Usage: runtransform.js <xslfilename> <xmlfilename> <outputfilename>");
		WScript.Quit();
	}

	var xslfilename = WScript.Arguments.Item(0);
	var xmlfilename = WScript.Arguments.Item(1);
	var outputfilename = WScript.Arguments.Item(2);

	var doc = LoadDOM(xmlfilename);
	
	var xsl = LoadDOM(xslfilename);
	xsl.setProperty("AllowXsltScript", true); 	// See https://msdn.microsoft.com/en-us/library/aa970889(v=vs.85).aspx
  	
	var str = doc.transformNode(xsl);

	var ado = new ActiveXObject("ADODB.Stream");
	ado.Open();
	ado.Position = 0;
	ado.CharSet = "UTF-8";
	ado.WriteText(str);
	ado.SaveToFile(outputfilename, 2)
}

function LoadDOM(file)
{
   var dom;
   try {
     dom = MakeDOM(null);
     dom.load(file);
   }
   catch (e) {
     alert(e.description);
   }
   return dom;
}

function MakeDOM(progID)
{
  if (progID == null) {
    progID = "msxml2.DOMDocument.6.0";
  }

  var dom;
  try {
    /*
    ** If the following line causes the error "Automation server can't create object", then
    ** download and install "Microsoft Core XML Services (MSXML) 6.0 Service Pack 1" from here:
    ** https://www.microsoft.com/en-gb/download/details.aspx?id=6276
    */
    dom = new ActiveXObject(progID);
    dom.async = false;
    dom.validateOnParse = true;
    dom.resolveExternals = false;
  }
  catch (e) {
    alert(e.description);
  }
  return dom;
}

function alert(str)
{
  WScript.Echo(str);
}
