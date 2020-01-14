<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:edweb="http://www.bbaw.de/telota/software/ediarum/edweb/lib" exclude-result-prefixes="xs" version="3.0">

    <xsl:import href="text_detail.xsl"/>

    <xsl:template match="tei:lb[not(@ed)]">
        <br/>
        <span class="gray margin-left"><xsl:value-of select="@n"/></span>
    </xsl:template>

    <xsl:template match="tei:pb[not(@ed)]">
        <br/>
        <br/>
        <span class="gray margin-left">
                [<xsl:value-of select="@n"/>]
        </span>
        <br/>
    </xsl:template>

        <xsl:template match="tei:pb">
        <span class="gray">[<xsl:value-of select="edweb:get-sigle(@ed)"/>:
                <xsl:value-of select="@n"/>]</span>
    </xsl:template>

    <xsl:template match="tei:lb">
        <span class="gray"> |<sup>(<xsl:value-of select="edweb:get-sigle(@ed)"/>:
            <xsl:value-of select="@n"/>)</sup> </span>
    </xsl:template>

</xsl:stylesheet>