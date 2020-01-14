<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:param name="columns"/>
    <xsl:output method="html" media-type="text/html" omit-xml-declaration="yes" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$columns='12'">
                <div xmlns="http://www.w3.org/1999/xhtml" class="outerLayer" id="content">
                    <div class="container_12">
                        <xsl:copy-of select="transferContainer/child::*"/>
                    </div>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div xmlns="http://www.w3.org/1999/xhtml" class="outerLayer" id="content">
                    <div class="container_16">
                        <xsl:copy-of select="transferContainer/child::*"/>
                    </div>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>