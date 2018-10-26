<?xml version="1.0"?>
<xsl:stylesheet version = "1.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
								xmlns:msxsl="urn:schemas-microsoft-com:xslt"
								xmlns:cw="http://mycompany.com/mynamespace">

	<!-- Prevent the xml version output line at the start of the output -->
	<xsl:output method="text" indent="yes" omit-xml-declaration="yes" />

	<!-- Mute all text output by default, to prevent unwanted spaces and tabs from the input xml file. -->
	<xsl:template match="text()" />
		
	<xsl:template match="root">
		<xsl:text>&lt;list&gt;</xsl:text><xsl:text>&#10;</xsl:text>
		<xsl:apply-templates>
		</xsl:apply-templates>
		<xsl:text>&lt;/list&gt;</xsl:text><xsl:text>&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="root/custodian">
		
		<xsl:variable name="email">
			<xsl:value-of select="node()"/>
		</xsl:variable>
	
		<xsl:variable name="Traits">
           <m>frdn</m> <!-- FROM -->
           <m>frea</m> <!-- FROM -->
           <m>from</m> <!-- FROM -->
		   <m>rbcc</m> <!-- BCC -->
		   <m>rbdn</m> <!-- BCC -->
		   <m>rbea</m> <!-- BCC -->
		   <m>rcdn</m> <!-- CC -->
		   <m>rcea</m> <!-- CC -->
		   <m>recp</m> <!-- CC -->
		   <m>reto</m> <!-- TO -->
		   <m>rtdn</m> <!-- TO -->
		   <m>rtea</m> <!-- TO -->
		</xsl:variable>
		
		<xsl:for-each select="msxsl:node-set($Traits)/m">
		
<xsl:text>&lt;EVCustomAttribute&gt;</xsl:text><xsl:text>&#10;</xsl:text>
<xsl:text>  &lt;name&gt;</xsl:text><xsl:value-of select="."/><xsl:text>&lt;/name&gt;</xsl:text><xsl:text>&#10;</xsl:text>
<xsl:text>  &lt;value class="string"&gt;</xsl:text><xsl:value-of select="$email"/><xsl:text>&lt;/value&gt;</xsl:text><xsl:text>&#10;</xsl:text>
<xsl:text>  &lt;operator&gt;EQUALS&lt;/operator&gt;</xsl:text><xsl:text>&#10;</xsl:text>
<xsl:text>  &lt;valueType&gt;java.lang.String&lt;/valueType&gt;</xsl:text><xsl:text>&#10;</xsl:text>
<xsl:text>&lt;/EVCustomAttribute&gt;</xsl:text><xsl:text>&#10;</xsl:text>

		</xsl:for-each>

<!-- newline -->
<!--<xsl:text>&#10;</xsl:text>-->

	</xsl:template>

</xsl:stylesheet>
