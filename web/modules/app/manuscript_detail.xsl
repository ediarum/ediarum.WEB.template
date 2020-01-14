<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="tei">
    <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN" indent="yes"/>
    <xsl:param name="file"/>
    <xsl:param name="suchbegriff"/>
    <xsl:param name="view"/>
    <xsl:template match="/">
        <div class="col-md-8 box whitebox">
            <div class="boxInner transkription">
                <!-- <xsl:if test="$view='k'"> -->
                    <xsl:apply-templates select="//tei:body" mode="kritischerText"/>
                <!-- </xsl:if>
                <xsl:if test="$view='l'">
                    <xsl:apply-templates select="//tei:body" mode="lesetext"/>
                </xsl:if> -->
            </div>
        </div>
        <div class="col-md-4">&#160;</div>
        <!--<div class="grid_11 filepath">Dateipfad: <xsl:value-of select="$file"/>
        </div>-->
    </xsl:template>
    <xsl:include href="transcription.xsl"/>
</xsl:stylesheet>
