<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/tei:TEI">
        <xsl:apply-templates select="tei:teiHeader"/>
    </xsl:template>

    <xsl:template match="//tei:teiHeader">
        <div class="row">
            <div class="col-md-1"/>
            <div class="col-xs-12 col-md-7">
            </div>
            <div class="col-md-4">
                <xsl:apply-templates select=".//tei:revisionDesc"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:revisionDesc">
        <div class="bearbeitungsdaten intern">
          <div role="tab" id="headingBearbeitungsgeschichte">
              <b><a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseBearbeitungsgeschichte" aria-expanded="false" aria-controls="collapseBearbeitungsgeschichte">
                  <span>Bearbeitung- geschichte&#160;</span>
                  <i class="fa fa-angle-down collapse-icon-close"></i>
                  <i class="fa fa-angle-up collapse-icon-open"></i>
              </a></b>
          </div>
          <div id="collapseBearbeitungsgeschichte" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingBearbeitungsgeschichte">
            <ul>
                <xsl:for-each select="tei:change">
                    <li>
                        <xsl:value-of select="@when-iso"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="@who"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="text()"/>
                    </li>
                </xsl:for-each>
            </ul>
          </div>
      </div>
    </xsl:template>

</xsl:stylesheet>
