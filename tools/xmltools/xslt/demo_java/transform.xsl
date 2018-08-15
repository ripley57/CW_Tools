<?xml version="1.0"?>
<!-- 
Description:
	A really useful xsl transform starter for extracting only bits you need from (EDRM) xml file.
	The main purpoose of this example is to extract the MAPI email PR_ENTRYID values, so that they
	can be compared with the values displayed by my PSTLister.exe tool. 

JeremyC 31-1-2018
-->
<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" xmlns:cw="cxsl">
	<!-- Prevent the xml version output line at the start of the output -->
	<xsl:output method="text" indent="yes" omit-xml-declaration="yes" />

	<!-- Mute all text output by default, to prevent unwanted spaces and tabs from the input xml file. -->
	<xsl:template match="text()" />
	
	<xsl:template match="Root/Batch/Documents/Document">
		<!-- DocID -->
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
	
	<xsl:template match="Root/Batch/Documents/Document/Locations/Location">
		<!--
			Display the bits we want, in this order:
			
			entryid,custodian,docid,locationURI
		-->
		
		<!-- entryid -->
		<xsl:param name="locationuri" select="LocationURI/node()" />
		<!-- Note: Uses callback into Java function in the driver program. -->
		<xsl:value-of select="cw:getEntryID($locationuri)" />
		<xsl:text>,</xsl:text>
		
		<!-- custodian -->
		<xsl:copy-of select="Custodian/node()" />
		<xsl:text>,</xsl:text>
			
		<!-- docid -->
		<xsl:param name="docid" select="UNDEFINED"/>
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
