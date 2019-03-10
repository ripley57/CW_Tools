<?xml version="1.0"?>
<!-- 
     	Description:

	Read records from an xml file and create an output file for each one.

	The purpose of this script is for generating a large volume of files, given an input xml file.
	Many free data sets (e.g. https://archive.org/details/stackexchange) are in xml format.
 
	Example usage:
	    java -cp saxon9he.jar net.sf.saxon.Transform -s:input.xml -xsl:create-files.xsl -o:output.txt

	This example will will use "create-files.xsl" to read input file "input.xml" and create output
	html files in the "output" directory.

	The "create-files.xsl" should be easy to manually change for different intput xml files.

	This transform file uses "xsl:result-document", which is XSLT version 2.0. Apparently there aren't
	many XSLT processors that support XSLT 2.0, hence why we are using "Saxon" here. See:
	https://www.saxonica.com/html/documentation/using-xsl/commandline/

	JeremyC 7/3/2019 v1.00
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Prevent the xml version output line at the start of the output -->
	<xsl:output method="text" indent="yes" omit-xml-declaration="yes" />

	<!-- Mute all text output by default. -->
	<xsl:template match="text()" />
	
	<!-- This will match the "users" root entry in the input xml file. -->
	<xsl:template match="users">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- This will be invoked for each "row" sub-entry in the input xml file. -->
	<xsl:template match="users/row">
		<!-- We will use these attributes to form a unique output filename. -->
		<xsl:variable name="id" select="normalize-space(@Id)"/>
		<xsl:variable name="displayname" select="normalize-space(@DisplayName)"/>

		<!-- The unique output filename for this "row". -->
		<xsl:variable name="filename" select="concat($id,' ',$displayname,'.html')" />

		<!-- We will use the contents of the "AboutMe" attribute for our file content,
		     but in case this is blank, we will also add some other fields too. -->
		<xsl:variable name="creationdate" select="normalize-space(@CreationDate)"/>
		<xsl:variable name="accountid" select="normalize-space(@AccountId)"/>
		<xsl:variable name="location" select="normalize-space(@Location)"/>
		<xsl:variable name="profileimageurl" select="normalize-space(@ProfileImageUrl)"/>
		<xsl:variable name="websiteurl" select="normalize-space(@WebsiteUrl)"/>

		<xsl:result-document method="html" href="output/{$filename}">
			<html><body>

			<!-- Note: Using "disable-output-escaping" decodes encoded html stuff like "&lt;" back to html. -->

			CreationDate: <xsl:value-of select="$creationdate"/><br/>
			AccountId: <xsl:value-of select="$accountid"/><br/>
			Location: <xsl:value-of select="$location"/><br/>
			ProfileImageUrl: <xsl:value-of disable-output-escaping="yes" select="$profileimageurl"/><br/>
			WebsiteUrl: <xsl:value-of disable-output-escaping="yes" select="$websiteurl"/><br/><br/>

			<!-- Here's the main 'body' of our document. -->
			<xsl:value-of disable-output-escaping="yes" select="@AboutMe"/>

			</body></html>
		</xsl:result-document>    
	</xsl:template>
	
</xsl:stylesheet>
