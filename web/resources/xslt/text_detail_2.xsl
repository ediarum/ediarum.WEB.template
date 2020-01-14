<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:edweb="http://www.bbaw.de/telota/software/ediarum/edweb/lib" exclude-result-prefixes="xs" version="3.0">

    <xsl:import href="text_detail.xsl"/>

    <xsl:function name="edweb:create-row">
        <xsl:param name="col-1"/>
        <xsl:param name="col-2"/>
        <xsl:param name="col-3"/>
        <xsl:param name="margin-1"/>
        <div class="row content-row hidden-sm hidden-md hidden-lg">
            <div class="col-xs-12 content-col-margin">
                <xsl:sequence select="$margin-1"/>
            </div>
        </div>
        <div class="row content-row">
            <div class="hidden-xs col-sm-2 col-md-1 content-col-margin">
                <xsl:sequence select="$margin-1"/>
            </div>
            <div class="col-xs-12 col-sm-10 col-md-7 content-col-text">
                <div class="content-col-text-inner">
                    <xsl:sequence select="$col-1"/>
                </div>
            </div>
            <div class="hidden-xs hidden-sm col-md-4 content-col-app-crit">
                <div class="app-crit-sticky">
                    <xsl:sequence select="$col-2"/>
                </div>
            </div>
        </div>
    </xsl:function>

</xsl:stylesheet>