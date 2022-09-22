<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:telota="http://www.telota.de" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="tei">
    <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN" indent="yes"/>
    
    <xsl:template match="/tei:person">
      <div class="row">
        <div class="col-md-12">
         <h3>Grunddaten</h3>
           <div class="row">
              <label class="col-sm-2">Vorname</label>
              <div class="col-sm-10">
                 <xsl:value-of select="tei:persName[@type='reg']/tei:forename" />
              </div>
           </div>
           <div class="row">
              <label class="col-sm-2">Nachname</label>
              <div class="col-sm-10">
                 <xsl:value-of select="tei:persName[@type='reg']/tei:surname" />
              </div>
           </div>
           <div class="row">
              <label class="col-sm-2">Geburt</label>
              <div class="col-sm-10">
                 <xsl:value-of select="tei:birth" />
              </div>
           </div>
           <div class="row">
              <label class="col-sm-2">Tod</label>
              <div class="col-sm-10">
                 <xsl:value-of select="tei:death" />
              </div>
           </div>
           <xsl:if test="tei:persName[not(@type='reg')]">
             <h3>Namensvarianten</h3>
             <ul>
               <xsl:apply-templates select="tei:persName[not(@type='reg')]"/>
               </ul>
           </xsl:if>
          <h3>Verweise</h3>
          <ul>
              <xsl:apply-templates select="tei:idno[@type='uri']"/>
          </ul>
        </div>
      </div>
    </xsl:template>
    
    <xsl:template match="tei:persName">
      <li><xsl:value-of select="."/></li>
    </xsl:template>

    <xsl:template match="tei:idno">
      <li><a href="{.}"><xsl:value-of select="."/></a></li>
    </xsl:template>
    
    <xsl:template match="element()" mode="serialize">
        <xsl:text>&lt;</xsl:text><xsl:value-of select="name(.)" />
        <xsl:for-each select="@*">
          <xsl:text> </xsl:text>
          <xsl:value-of select="name()"/>
          <xsl:text>="</xsl:text>
          <xsl:value-of select="string()"/>
          <xsl:text>"</xsl:text>
        </xsl:for-each>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates mode="serialize" />
    <xsl:text>&lt;/</xsl:text><xsl:value-of select="name(.)" />
    <xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="text()" mode="serialize">
    <xsl:value-of select="." />
</xsl:template>

</xsl:stylesheet>