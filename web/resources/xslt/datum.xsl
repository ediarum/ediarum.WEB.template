<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
    <xsl:output/>
    <xsl:template match="kwberechnung/briefdatum">
        <xsl:for-each select=".">
            <brief>
                <kw>
                    <xsl:value-of select="format-date(., '[Y]-[W]')"/>
                </kw>,<datum>
                    <xsl:value-of select="."/>
                </datum>;</brief>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="root">
        <xsl:for-each-group select="brief" group-by="kw">
            <group>
                <xsl:analyze-string select="current-grouping-key()" regex="(\d\d\d\d)-(\d\d)">
                    <xsl:matching-substring>
                        <kw>
                            <xsl:value-of select="concat(regex-group(1), '-W', regex-group(2))"/>
                        </kw>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:analyze-string select="current-grouping-key()" regex="(\d\d\d\d)-(\d)">
                            <xsl:matching-substring>
                                <kw>
                                    <xsl:value-of select="concat(regex-group(1), '-W0', regex-group(2))"/>
                                </kw>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <kw>Falsche Angabe</kw>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
                <xsl:for-each select="current-group()">
                    <daten>
                        <xsl:value-of select="datum"/>
                    </daten>
                </xsl:for-each>
            </group>
        </xsl:for-each-group>
    </xsl:template>
    <xsl:template match="datum">
        <xsl:value-of select="format-date(., '[F], der [D]. [MNn] [Y]','de',(),())"/>
    </xsl:template>
</xsl:stylesheet>