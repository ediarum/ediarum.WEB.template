<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:telota="http://www.telota.de" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="tei">
    <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN" indent="yes"/>
    
    <xsl:template match="/tei:TEI">
      <div class="row">
        <div class="col-md-1"/>
        <div class="col-md-7">
          <h2>
            <xsl:value-of select="//tei:titleStmt/tei:title"/>
          </h2>
          <xsl:apply-templates select="//tei:notesStmt" mode="p"/>
          <xsl:apply-templates select="//tei:sourceDesc" mode="p"/>
          <xsl:apply-templates select="//tei:profileDesc" mode="p"/>
        </div>
      </div>
    </xsl:template>

    <xsl:template match="*" mode="p">
      <p>
        <xsl:apply-templates mode="p"/>
      </p>
    </xsl:template>
    
    <xsl:template match="tei:p" mode="p">
      <p>
        <xsl:apply-templates />
      </p>
    </xsl:template>
    
</xsl:stylesheet>