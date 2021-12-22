<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:appconf="http://www.bbaw.de/telota/software/ediarum/web/appconf"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text"/>
    
    <xsl:template match="/appconf:config">
        <xsl:text># Data table - "</xsl:text>
        <xsl:value-of select="appconf:project/appconf:name"/>
        <xsl:text>"&#xA;&#xA;</xsl:text>
        <xsl:text>Data collection: `</xsl:text>
        <xsl:value-of select="appconf:project/appconf:collection"/>
        <xsl:text>`&#xA;&#xA;</xsl:text>
        
        <xsl:text>## Data object table&#xA;&#xA;</xsl:text>
        <xsl:text>| Name | ID | collection | properties |&#xA;</xsl:text>
        <xsl:text>| ---- | -- | ---------- |----------- |&#xA;</xsl:text>
        <xsl:apply-templates select="appconf:object"/>
        <xsl:text>&#xA;&#xA;</xsl:text>
        
        <xsl:text>## Data relation table&#xA;&#xA;</xsl:text>

        <xsl:text>## Search endpoints&#xA;&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="appconf:object">
        <xsl:text>|</xsl:text>
        <xsl:value-of select="appconf:name"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="@xml:id/string()"/>
        <xsl:text>|`</xsl:text>
        <xsl:value-of select="appconf:collection"/>
        <xsl:text>`|</xsl:text>
        <xsl:apply-templates select="appconf:filters/appconf:filter"/>
        <xsl:text>|&#xA;</xsl:text>
    </xsl:template>
    
    <xsl:template match="appconf:filter">
      <!--  <xsl:text>|&#xA;</xsl:text>
        <xsl:text>||||</xsl:text>
        <xsl:value-of select="appconf:name"/>
-->
        <xsl:text></xsl:text>
        <xsl:value-of select="appconf:name"/>
        <xsl:text> `</xsl:text>
        <xsl:value-of select="@xml:id/string()"/>
        <xsl:text>`;&lt;br/></xsl:text>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:value-of select="name()"/>
    </xsl:template>
    
</xsl:stylesheet>