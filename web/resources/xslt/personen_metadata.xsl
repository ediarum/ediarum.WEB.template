<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:telota="http://www.telota.de" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="tei">
    <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN" indent="yes"/>
    
    <xsl:template match="/tei:person">
      <div class="row">
        <div class="col-md-1"/>
        <div class="col-md-7">
          <h2>
            <xsl:value-of select="tei:persName[@type='reg']/normalize-space()"/>
          </h2>
        </div>
      </div>
    </xsl:template>
    
</xsl:stylesheet>