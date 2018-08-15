<?xml version="1.0"?>
<!-- 
Description:
    Parse and transform an input EDRM XML file. 
	Generate native and text test file data.

	April 2014
-->
<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" xmlns:cw="cxsl">
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<!-- Documents -->
	<xsl:template match="Batch/Documents">
		<xsl:element name="Documents">
			<xsl:apply-templates/>
			
			<!-- Debugging. 
				 List all the mime types present in input xml file.
				 If we are missing any then we will need to add them to cxsl.java. -->
			<!--
			<xsl:text>MIME TYPES PRESENT</xsl:text>
			<xsl:value-of select="cw:printMimeTypes()" /> 
			-->
		</xsl:element>
	</xsl:template>
		
	<!-- Document -->
	<xsl:template match="Batch/Documents/Document">
		<!-- docid -->
		<xsl:variable name="docid">
			<xsl:value-of select="normalize-space(@DocID)"/>
		</xsl:variable>
		
		<!-- Debugging -->
		<!--<xsl:value-of select="$docid"/>-->
	
		<!-- mimetype -->
		<xsl:variable name="mimetype">
			<xsl:value-of select="normalize-space(@MimeType)"/>
		</xsl:variable>
		
		<!-- #FileExtension -->
		<xsl:variable name="fileextension">
			<xsl:value-of select="normalize-space(Tags/Tag[@TagName='#FileExtension']/@TagValue)"/>
		</xsl:variable>
		
		<!-- Document -->
		<xsl:element name="Document">
			<xsl:copy-of select="@*"/>
			<xsl:param name="docid_param" select="$docid"/>
			<xsl:param name="mimetype_param" select="$mimetype"/>
			<xsl:param name="fileextension_param" select="$fileextension"/>
			<xsl:apply-templates>
			    <xsl:with-param name="docid" select="$docid_param"/>
				<xsl:with-param name="mimetype" select="$mimetype_param"/>
				<xsl:with-param name="fileextension" select="$fileextension_param"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<!-- Files -->
	<!-- NB: We need this in order to pass params down chain. -->
	<xsl:template match="Batch/Documents/Document/Files">
		<xsl:param name="docid" select="UNDEFINED"/>
		<xsl:param name="mimetype" select="UNDEFINED"/>
		<xsl:param name="fileextension" select="UNDEFINED"/>
		<xsl:element name="Files">
			<xsl:apply-templates>
				<xsl:with-param name="docid" select="$docid"/>
				<xsl:with-param name="mimetype" select="$mimetype"/>
				<xsl:with-param name="fileextension" select="$fileextension"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<!-- File -->
	<xsl:template match="Batch/Documents/Document/Files/File">
		<xsl:param name="docid" select="UNDEFINED"/>
		<xsl:param name="mimetype" select="UNDEFINED"/>
		<xsl:param name="fileextension" select="UNDEFINED"/>
		<xsl:variable name="filetype">
			<xsl:value-of select="normalize-space(@FileType)"/>
		</xsl:variable>
		<xsl:element name="File">
			<xsl:copy-of select="@*"/>
			<xsl:element name="ExternalFile">
			    <xsl:for-each select="ExternalFile/@*">
					<xsl:choose>
						<xsl:when test="name() = 'FilePath'">
							<xsl:attribute name="FilePath">
								<xsl:value-of select="cw:getTestFileDir($docid,$mimetype,$filetype,$fileextension)" />
							</xsl:attribute>
						</xsl:when>
						<xsl:when test="name() = 'FileName'">
							<xsl:attribute name="FileName">
								<xsl:value-of select="cw:getFileName($docid,$mimetype,$filetype,.,$fileextension)" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="{name()}">
								<xsl:value-of select="."/>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>
