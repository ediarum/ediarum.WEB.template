<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="2.0">
    <xsl:preserve-space elements="*"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:quote">
        <span class="quote"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:reg"/>
    <xsl:template match="tei:corr"/>
    <xsl:template match="tei:expan"/>
    <xsl:template match="tei:note[parent::tei:seg]"/>
</xsl:stylesheet>