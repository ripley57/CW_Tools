Description:

I wanted a program that would convert a csv-style input file (i.e. rows of fields)
into an XML file. The way I decided to do this was first to convert the input file 
to XML then run an XSLT transform, XML -> XML.

genxml.sh	This script creates the input XML file.

Then to run the transform:

java cxsl transform.xml input.xml > out.xml


NOTE:	This is a good example of a transform that includes some 'raw' template html/xml,
	to which the transform adds additional content.

NOTE:	For some, currently unknown, reason, this same transform.xsl does not work with
	a transform using MSXML, i.e. using VBscript, as in the demo_javascript dirs.


NOTE: 	I did find the following online tool to be very good at doing the same thing, BUT
	my web browser simply hung when I had thousands of rows in my input file:

	http://convertcsv.com/csv-to-template-output.htm


JeremyC 26-2-2020
