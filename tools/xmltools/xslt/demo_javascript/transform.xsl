<?xml version="1.0"?>
<!-- 
Description:
	Nice demo for extracting parts of an XML input file. 
	Note: This demo is dependent on Windows MSXML being present in the driver program.
	
Example usage:
	cscript //nologo runtransform.js transform.xsl input.xml out.txt
	
Example output:
	0000000095b6e9026e396c4d9fe3d9e4ede7b38f44372000,bill_rapp,0.7.66.5134,esa:pst/*:\\edp-app1\d$\CaseData\Enron_Small1\bill_rapp\bill_rapp_000_1_1.pst:Top of Personal Folders\rapp-b\BRAPP (Non-Privileged)\Rapp, Bill\Deleted Items:0000000095b6e9026e396c4d9fe3d9e4ede7b38f44372000
	0000000095b6e9026e396c4d9fe3d9e4ede7b38f840a2000,bill_rapp,0.7.66.5134,esa:pst/*:\\edp-app1\d$\CaseData\Enron_Small1\bill_rapp\bill_rapp_000_1_1.pst:Top of Personal Folders\rapp-b\Rapp, Bill (Non-Privileged)\Rapp, Bill\Deleted Items:0000000095b6e9026e396c4d9fe3d9e4ede7b38f840a2000
	
JeremyC 1-2-2018
-->
<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
								xmlns:msxsl="urn:schemas-microsoft-com:xslt"
								xmlns:cw="http://mycompany.com/mynamespace">
	<!-- 
	See:
	https://stackoverflow.com/questions/4526015/how-to-call-external-javascript-function-in-xsl
	https://msdn.microsoft.com/en-us/library/aa970889(v=vs.85).aspx
	https://stackoverflow.com/questions/24175206/how-to-pass-arguments-when-using-javascript-as-part-of-xslt-transformation/24194643
	-->
	<msxsl:script language="JScript" implements-prefix="cw">
		function getEntryID(s)
		{
			var parts = s.split(":");
			return parts[4];
		}
	</msxsl:script>

	<!-- Prevent the xml version output line at the start of the output -->
	<xsl:output method="text" indent="yes" omit-xml-declaration="yes" />

	<!-- Mute all text output by default, to prevent unwanted spaces and tabs from the input xml file. -->
	<xsl:template match="text()" />
	
	<xsl:template match="Root/Batch/Documents/Document">
		<xsl:variable name="docid">
			<xsl:value-of select="normalize-space(@DocID)"/>
		</xsl:variable>

		<xsl:apply-templates>
			<xsl:with-param name="docid" select="$docid"/>
		</xsl:apply-templates>
	</xsl:template>
		
	<xsl:template match="Root/Batch/Documents/Document/Locations">
		<xsl:param name="docid" select="UNDEFINED"/>
		<xsl:apply-templates>
			<xsl:with-param name="docid" select="$docid"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!--
		Display the bits we want, in this order: entryid,custodian,docid,locationURI
	-->
	<xsl:template match="Root/Batch/Documents/Document/Locations/Location">
		<xsl:param name="docid" select="UNDEFINED"/>
		
		<!-- entryid -->
		<xsl:param name="locationuri" select="LocationURI/node()" />
		<!-- Note: Call to function defined in this file. -->
		<!-- Note: Use of "string()" is required to prevent error. -->
		<xsl:value-of select="cw:getEntryID(string($locationuri))" />
		<xsl:text>,</xsl:text>
		
		<!-- custodian -->
		<xsl:copy-of select="Custodian/node()" />
		<xsl:text>,</xsl:text>
			
		<!-- docid -->
		<xsl:value-of select="$docid"/>
		<xsl:text>,</xsl:text>
		
		<!-- locationURI -->
		<xsl:copy-of select="LocationURI/node()" />
		
		<!-- newline -->
		<xsl:text>&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="Root/Batch/Documents/Document/CustomDocumentInfo">
	</xsl:template>
</xsl:stylesheet>
