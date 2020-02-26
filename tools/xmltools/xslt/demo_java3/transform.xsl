<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Suppress all text output unless we explicitly display it -->
<xsl:template match="text()" />


<xsl:template match="Root">
<AgentPool name="AgentCluster1">	<xsl:text>&#10;</xsl:text>
	<xsl:apply-templates/>
</AgentPool>				<xsl:text>&#10;</xsl:text>
</xsl:template>


<xsl:template match="Root/Agent">
<xsl:variable name="id"><xsl:value-of select="normalize-space(@id)"/></xsl:variable>
<xsl:variable name="IpAddress"><xsl:value-of select="normalize-space(@IpAddress)"/></xsl:variable>

<Agent id="{$id}">									<xsl:text>&#10;</xsl:text>
<ConnProperty name="IpAddress"><xsl:value-of select="$IpAddress"/></ConnProperty>	<xsl:text>&#10;</xsl:text>
<ConnProperty name="LastConnectStatus">5</ConnProperty>					<xsl:text>&#10;</xsl:text>
<ConnProperty name="UseAuthentication">false</ConnProperty>				<xsl:text>&#10;</xsl:text>
<Capability maxVU="1566" name=".Net"></Capability>					<xsl:text>&#10;</xsl:text>
<Capability maxVU="40" name="Browser-driven"></Capability>				<xsl:text>&#10;</xsl:text>
<Capability maxVU="20" name="Citrix"></Capability>					<xsl:text>&#10;</xsl:text>
<Capability maxVU="4700" name="General"></Capability>					<xsl:text>&#10;</xsl:text>
<Capability maxVU="15" name="GuiLTest"></Capability>					<xsl:text>&#10;</xsl:text>
<Capability maxVU="1566" name="Java"></Capability>					<xsl:text>&#10;</xsl:text>
<Capability maxVU="783" name="ODBC"></Capability>					<xsl:text>&#10;</xsl:text>
<Capability maxVU="671" name="Oracle OCI"></Capability>					<xsl:text>&#10;</xsl:text>
<Capability maxVU="40" name="SAPGUI"></Capability>					<xsl:text>&#10;</xsl:text>
<Capability maxVU="671" name="Tuxedo"></Capability>					<xsl:text>&#10;</xsl:text>
<SysInfo name="AgentRAC">17006900</SysInfo>						<xsl:text>&#10;</xsl:text>
<SysInfo name="AgentVersion">17.0.0.7107</SysInfo>					<xsl:text>&#10;</xsl:text>
<SysInfo name="Memory">4096 MB</SysInfo>						<xsl:text>&#10;</xsl:text>
<SysInfo name="ProcType">advanced Intel</SysInfo>					<xsl:text>&#10;</xsl:text>
<SysInfo name="ProcessorCount">2</SysInfo>						<xsl:text>&#10;</xsl:text>
<SysInfo name="ProcessorSpeed">2594 MHz</SysInfo>					<xsl:text>&#10;</xsl:text>
<SysInfo name="ServicePack"></SysInfo>							<xsl:text>&#10;</xsl:text>
<SysInfo name="SysVersion">10.0</SysInfo>						<xsl:text>&#10;</xsl:text>
<SysInfo name="System">WinNT</SysInfo>							<xsl:text>&#10;</xsl:text>
</Agent>										<xsl:text>&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
