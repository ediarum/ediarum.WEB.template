<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/tei:TEI">
        <xsl:apply-templates select="tei:teiHeader"/>
    </xsl:template>

    <xsl:template match="//tei:teiHeader">
        <div class="row">
            <div class="col-md-1"/>
            <div class="col-xs-12 col-md-7">
                <xsl:apply-templates select=".//tei:notesStmt[tei:relatedItem]"/>
                <xsl:apply-templates select=".//tei:sourceDesc/tei:listWit[@n='Textzeugen']"/>
                <xsl:apply-templates select=".//tei:sourceDesc/tei:listWit[@n='Publikationen']"/>
            </div>
            <div class="col-md-4">
                <xsl:call-template name="bearbeitungsdaten"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:listWit[@n='Textzeugen']">
        <div>
          <div role="tab" id="headingTextzeugen">
            <h4>
              <a class="button collapsed" role="button" data-toggle="collapse" href="#collapseTextzeugen" aria-expanded="false" aria-controls="collapseTextzeugen">
                  <xsl:value-of select="tei:head"/>
                  <span>&#160;</span>
                  <i class="fa fa-angle-down collapse-icon-close"></i>
                  <i class="fa fa-angle-up collapse-icon-open"></i>
              </a>
            </h4>
          </div>
          <div id="collapseTextzeugen" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTextzeugen">
            <xsl:for-each select="tei:witness">
                <div>
                    <xsl:attribute name="id" select="@xml:id"/>
                    <xsl:choose>
                        <xsl:when test="count(tei:idno[@type='cagb']) eq 1">
                            <a>
                                <xsl:attribute name="href" select="concat('/handschriften/diktyon-',tei:idno[@type='cagb'][1])"/>
                                <xsl:value-of select="tei:title"/>
                            </a>
                        </xsl:when>
                        <xsl:when test="count(tei:idno[@type='cagb'])">
                            <xsl:value-of select="tei:title"/>
                            <xsl:text> (</xsl:text>
                            <xsl:for-each select="tei:idno[@type='cagb']">
                                <a>
                                    <xsl:attribute name="href" select="concat('/handschriften/diktyon-',.)"/>
                                    <xsl:text>link</xsl:text>
                                </a>
                            </xsl:for-each>
                            <xsl:text>)</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="tei:title"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> = </xsl:text>
                    <span class="sigle">
                        <xsl:apply-templates select="tei:idno[@type='sigle']"/>
                    </span>
                </div>
            </xsl:for-each>
          </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:listWit[@n='Publikationen']">
        <div>
          <div role="tab" id="headingPublikationen">
            <h4>
              <a class="button collapsed" role="button" data-toggle="collapse" href="#collapsePublikationen" aria-expanded="false" aria-controls="collapsePublikationen">
                  <xsl:value-of select="tei:head"/>
                  <span>&#160;</span>
                  <i class="fa fa-angle-down collapse-icon-close"></i>
                  <i class="fa fa-angle-up collapse-icon-open"></i>
              </a>
            </h4>
          </div>
          <div id="collapsePublikationen" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingPublikationen">
            <xsl:for-each select="tei:witness">
                <div>
                    <xsl:attribute name="id" select="@xml:id"/>
                    <xsl:choose>
                        <xsl:when test="tei:idno[@type='cagb']">
                            <a href="$id/{tei:idno[@type='cagb']}">
                                <xsl:value-of select="tei:title"/>
                            </a>
                        </xsl:when>
                        <xsl:when test="tei:idno[@type='cagb_bibl']">
                            <a href="$id/{tei:idno[@type='cagb_bibl']}">
                                <xsl:value-of select="tei:title"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="tei:title"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> = </xsl:text>
                    <span class="sigle">
                        <xsl:apply-templates select="tei:idno[@type='sigle']"/>
                    </span>
                </div>
            </xsl:for-each>
          </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:g[@rend='sup']">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <xsl:template match="tei:notesStmt[tei:relatedItem]">
        <div>
          <div role="tab" id="headingTextbeziehungen">
            <h4>
              <a class="button collapsed" role="button" data-toggle="collapse" href="#collapseTextbeziehungen" aria-expanded="false" aria-controls="collapseTextbeziehungen">
                  <span>Textbeziehungen</span>
                  <span>&#160;</span>
                  <i class="fa fa-angle-down collapse-icon-close"></i>
                  <i class="fa fa-angle-up collapse-icon-open"></i>
              </a>
            </h4>
          </div>
          <div id="collapseTextbeziehungen" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTextbeziehungen">
              <xsl:for-each select="tei:relatedItem/tei:ref">
                  <div>
                      <xsl:value-of select="@type"/>
                      <xsl:text>: </xsl:text>
                      <xsl:text>$id/</xsl:text>
                      <xsl:value-of select="replace(@cRef,' ','-')"/>
                      <xsl:value-of select="replace(@target, '#', '')"/>
                  </div>
              </xsl:for-each>
          </div>
        </div>
    </xsl:template>

    <xsl:template name="bearbeitungsdaten">
        <div class="bearbeitungsdaten">
            <div id="bearbeiter">
                <b>Bearbeiter: </b>
            </div>
            <div>
                <xsl:for-each select=".//tei:editionStmt/tei:respStmt">
                    <div class="reset">
                        <xsl:value-of select="tei:name"/>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="tei:resp"/>
                        <xsl:text>)</xsl:text>
                        <xsl:if test="following-sibling::tei:respStmt">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </div>
                </xsl:for-each>
            </div>
            <div>
                <b>Textsorte: </b>
            </div>
            <div>
                <xsl:value-of select=".//tei:notesStmt/tei:note[@type eq 'Textsorte']"/>
            </div>
            <xsl:for-each select=".//tei:profileDesc/tei:textClass/tei:catRef">
                <xsl:choose>
                    <xsl:when test="starts-with(@target,'#Aufbereitung')">
                        <div>
                            <b>Aufbereitung:</b>
                        </div>
                        <div>
                            <xsl:value-of select="substring-after(@target,':')"/>
                        </div>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            <div>
                <b>Status:</b>
            </div>
            <div>
                <xsl:choose>
                    <xsl:when test=".//tei:revisionDesc/@status eq 'draft'">Entwurf</xsl:when>
                    <xsl:otherwise>Final</xsl:otherwise>
                </xsl:choose>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
