Ths demo uses XSLT v2.0 and shows how to extract records from a XML file as individual html files.
This can be useful when converting a large dataset XML files into multiple small files for testing.

The script is invoked like this:

java -cp saxon9he.jar net.sf.saxon.Transform -s:users.xml -xsl:create-files.xsl -o:out.txt

Where:
	users.xml		-	This is our input XML file containing multiple "row" entries.
	create-files.xsl	-	This is our XSL tranformation script.

(The out.txt file bit is probably not required - since we are generating multiple output files).

I've seen this happily cope with 1m records in the input XML file, before you get a Java heap error. It's possible
that explicitly specifying a large heap size could help here - I think a default heap size is used by default.

NOTE: Apparently, it is difficult to find v2 - compliant XSLT engines, hence I had to use this:
https://www.saxonica.com/html/documentation/using-xsl/commandline/

JeremyC 10-03-2019
