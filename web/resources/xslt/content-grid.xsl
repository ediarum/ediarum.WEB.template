<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="tei">
    <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN" indent="yes"/>
    <xsl:param name="filepath"/>
    <xsl:param name="suchbegriff"/>
    <xsl:param name="view"/>
    <xsl:template match="/">
        <div class="grid_11 box whitebox">
            <div class="boxInner transkription">
                <xsl:if test="$view='k'">
                    <xsl:apply-templates select="//tei:body" mode="kritischerText"/>
                </xsl:if>
                <xsl:if test="$view='l'">
                    <xsl:apply-templates select="//tei:body" mode="lesetext"/>
                </xsl:if>
                <xsl:if test="$view='f'">
                    <xsl:apply-templates select="//tei:body" mode="faksimileText"/>
                </xsl:if>
                <xsl:if test="$view='c'">
                    <xsl:apply-templates select="//tei:body" mode="comment"/>
                    <xsl:call-template name="endnotes"/>
                </xsl:if>
            </div>
        </div>
        <div class="grid_5">&#160;</div>
        <!-- <div class="grid_11 filepath">Dateipfad: <xsl:value-of select="$filename"/>
        </div> -->
    </xsl:template>
    <xsl:include href="../../resources/xslt/transcription.xsl"/>
</xsl:stylesheet>