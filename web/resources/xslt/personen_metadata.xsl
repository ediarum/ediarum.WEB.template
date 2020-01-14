<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:telota="http://www.telota.de" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="tei">
    <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN" indent="yes"/>
    <xsl:param name="termID"/>
    <xsl:param name="intern"/>
    <xsl:function name="telota:epoche-gruppe">
        <xsl:param name="input"/>
        <xsl:choose>
            <xsl:when test="$input='greek'">Commentarores Graeci</xsl:when>
            <xsl:when test="$input='byzantine'">Commentatores Byzantini</xsl:when>
            <xsl:when test="$input='post-byzantine'">Commentatores Postbyzantini</xsl:when>
            <xsl:when test="$input='other'">Fremdautoren</xsl:when>
            <xsl:when test="$input='modern'">Moderne Aristotelesphilologen</xsl:when>
        </xsl:choose>
    </xsl:function>
    <xsl:template match="/">
        <div class="row">
            <div class="col-md-1"/>
            <div class="col-md-7">
                <xsl:call-template name="status"/>
                <h1>
                    <xsl:value-of select="//tei:div/tei:head[@type='entry']"/>
                </h1>
                <xsl:for-each select="//tei:div/tei:head[@type='entry']/@subtype">
                    <p>Gruppe: 
                        <a href="index.html?group={telota:epoche-gruppe(.)}">
                            <xsl:value-of select="telota:epoche-gruppe(.)"/>
                        </a>
                    </p>
                </xsl:for-each>
                <xsl:if test="//tei:titleStmt/tei:author/normalize-space() != 'AUTOR'">
                    <p>Autor: <xsl:value-of select="//tei:titleStmt/tei:author"/></p>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    <xsl:template name="status">
        <xsl:choose>
            <xsl:when test="//tei:revisionDesc[@status='draft']">
                <div class="alert alert-warning" role="alert">
                    in Bearbeitung
                </div>
            </xsl:when>
            <xsl:when test="//tei:revisionDesc[@status='final'] or //tei:revisionDesc/not(@status)">
                <div class="alert alert-success" role="alert">
                    Vorstufe
                </div>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
