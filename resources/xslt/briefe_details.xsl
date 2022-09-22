<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:telota="http://www.telota.de" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="tei">
    <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN" indent="yes"/>
    
    <xsl:template match="/tei:TEI">
      <div class="row">
        <div class="col-md-12">
          <xsl:apply-templates select="tei:text"/>

        </div>
      </div>
    </xsl:template>

    <xsl:template match="tei:p">
      <p>
          <xsl:apply-templates/>
      </p>
    </xsl:template>


    <xsl:template match="tei:choice[tei:reg]">
        <span style="cursor: context-menu; position:relative;" data-toggle="tooltip" data-placement="top" title="normalisiert aus {tei:orig}">
            <span style="position:absolute; top:-14px;left:-2px;color: #ccc;"><i class="fa fa-caret-down"></i> </span>
            <span style="position:absolute; left:-2px; width: 10px;"></span>
            <span style="color: #666;">
              <xsl:apply-templates select="tei:reg"/>
            </span>
        </span>
    </xsl:template>

    <xsl:template match="tei:choice[tei:corr[not(@type)]]">
        <span style="cursor: context-menu; position:relative;" data-toggle="tooltip" data-placement="top" title="korrigiert aus {tei:sic}">
            <span style="position:absolute; top:-14px;left:-2px;color: #ccc;"><i class="fa fa-exclamation" aria-hidden="true"></i> </span>
            <span style="position:absolute; left:-2px; width: 10px;"></span>
            <span style="color: #666;">
              <xsl:apply-templates select="tei:corr"/>
            </span>
        </span>
    </xsl:template>

    <xsl:template match="tei:choice[tei:corr/@type='deleted']">
        <span style="cursor: context-menu; position:relative;" data-toggle="tooltip" data-placement="top" title="{tei:sic} gestrichen">
            <span style="position:absolute; top:-14px;left:-2px;color: #ccc;"><i class="fa fa-exclamation" aria-hidden="true"></i> </span>
            <span style="position:absolute; left:-2px; width: 10px;"></span>
            <span style="color: #666;">
              <xsl:apply-templates select="tei:corr"/>
            </span>
        </span>
    </xsl:template>

    <xsl:template match="tei:choice[tei:abbr]">
        <span style="cursor: context-menu; position:relative;" data-toggle="tooltip" data-placement="top" title="{tei:expan}">
            <span style="position:absolute; top:-14px;left:-2px;color: #ccc;"><i class="fa fa-question" aria-hidden="true"></i> </span>
            <span style="position:absolute; left:-2px; width: 10px;"></span>
            <span style="color: #666;">
              <xsl:apply-templates select="tei:abbr"/>
            </span>
        </span>
    </xsl:template>

    <xsl:template match="tei:seg[@type='comment']">
        <span style="cursor: context-menu; position:relative;" data-toggle="tooltip" data-placement="top" title="{tei:note}">
            <span style="color: #666; text-decoration: underline wavy #ccc;">
              <xsl:apply-templates select="tei:orig"/>
            </span>
        </span>
    </xsl:template>


    <xsl:template match="tei:persName">
      <a href="$base-url/personen/{@key}"> 
          <xsl:apply-templates/>
      </a>
    </xsl:template>

</xsl:stylesheet>