<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/tei:TEI">
        <xsl:apply-templates select="tei:teiHeader"/>
    </xsl:template>

    <xsl:template match="//tei:teiHeader">
        <div class="row">
            <div class="col-md-1"/>
            <div class="col-md-7">
                <h1>
                    <xsl:value-of select="//tei:titleStmt/tei:title"/>
                </h1>
            </div>
        </div>
        <div class="row">
            <div class="col-md-1"/>
            <div class="col-xs-12 col-md-7">
                <xsl:call-template name="status"/>
                <xsl:call-template name="ms-group"/>
                <div class="grid" id="section/msIdentifier">
                    <div><b>Nachweis:</b></div>
                    <div>
                        <xsl:apply-templates select="//tei:msDesc/tei:msIdentifier" />
                    </div>
                    <div><b>Datierung:</b></div>
                    <div>
                        <xsl:apply-templates select="//tei:p[@n='origDate']"/>
                    </div>
                    <div><b>Beschreibstoff:</b></div>
                    <div>
                        <xsl:apply-templates select="//tei:p[@n='supportMaterial']"/>
                    </div>
                    <div><b>Format:</b></div>
                    <div>
                        <xsl:apply-templates select="//tei:measure[@type='leafsize']"/>
                    </div>
                    <xsl:if test="//tei:measure[@type='numleaves']">
                        <div><b>Folienzahl:</b></div>
                        <div>
                            <xsl:apply-templates select="//tei:measure[@type='numleaves']"/>
                        </div>
                    </xsl:if>
                </div>
            </div>
            <div class="col-md-4">
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:note[@resp='cagb']">
        <span class="text-danger font-italic"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="tei:msDesc/tei:msIdentifier">
        <xsl:for-each select="./child::*[not(local-name()='altIdentifier')][not(local-name()='idno')]">
            <xsl:apply-templates select="."/>, </xsl:for-each>
        <xsl:apply-templates select="tei:idno"/>
        <xsl:for-each select="tei:altIdentifier">
           <xsl:text> (</xsl:text>
           <xsl:value-of select="tei:idno"/>
           <xsl:if test="tei:idno/@type">
               <xsl:text>, </xsl:text>
               <i>
                   <xsl:value-of select="tei:idno/@type"/>
               </i>
           </xsl:if>
           <xsl:text>) </xsl:text>
       </xsl:for-each>
    </xsl:template>

    <xsl:template name="status">
        <xsl:choose>
            <xsl:when test="//tei:revisionDesc[@status='draft']">
                <div class="alert alert-danger" role="alert">
                    <span>in Bearbeitung</span>
                </div>
            </xsl:when>
            <xsl:when test="//tei:revisionDesc[@status='final'] or //tei:revisionDesc/not(@status)">
                <div class="alert alert-warning" role="alert">
                    <span>Vorstufe</span>
                </div>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="ms-group">
        <xsl:if test="//tei:profileDesc//tei:keywords/tei:term">
            <p>Gruppe: <xsl:for-each select="//tei:profileDesc//tei:keywords/tei:term">
                <a href="index.xql?letter=Alle&amp;gruppe={.};">
                    <xsl:value-of select="."/>
                </a>
                <xsl:if test="following-sibling::tei:term">, </xsl:if>
            </xsl:for-each>
            </p>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:p[@n='supportMaterial']">
        <xsl:if test="preceding-sibling::tei:p[@n='supportMaterial']">
            <xsl:text> / </xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
