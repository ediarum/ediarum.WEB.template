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
        <xsl:choose>
            <xsl:when test=".//tei:revisionDesc/@status='draft' and $intern='false'">
                <xsl:apply-templates select="//tei:div/tei:head[@type='entry']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="//tei:div[@type='entry']"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$intern='true'">
            <xsl:apply-templates select="//telota:comments"/>
        </xsl:if>
    </xsl:template>
    <!-- Name nicht im Content anzeigen -->
    <xsl:template match="tei:head[@type='entry']"/>
    <xsl:template name="status">
        <xsl:choose>
            <xsl:when test="//tei:revisionDesc[@status='draft']">
                <div class="hinweis status draft">
                    <span>in Bearbeitung</span>
                </div>
            </xsl:when>
            <xsl:when test="//tei:revisionDesc[@status='final'] or //tei:revisionDesc/not(@status)">
                <div class="hinweis status final">
                    <span>Vorstufe</span>
                </div>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:div[@type='section']
        [@subtype='life' or @subtype='sources' or @subtype='depictions' or @subtype='legacy' or
                 @subtype='literature' or @subtype='singleDetails'][.//tei:p[./text()]]" priority="5">
        <div id="section/{./tei:head/string()}">
            <h3>
                <xsl:value-of select="./tei:head"/>
            </h3>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div[@type='section'][@subtype='publications'][./tei:p[./text()]]" priority="5">
        <div id="section/{./tei:head/string()}">
            <h3>
                <xsl:value-of select="./tei:head"/>
            </h3>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div[./tei:p[./text()]]">
        <div id="section/{./tei:head/string()}">
            <h3>
                <xsl:value-of select="./tei:head"/>
            </h3>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:p[./text()]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:div/tei:head[@type='family']">
        <h3>Familie</h3>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:ref[@type='straighturl']">
        <a href="{@target}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="telota:comments">
        <div id="comments">
            <h3>Bearbeitungsbemerkungen</h3>
            <xsl:for-each select="telota:p">
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template match="tei:ref[@type='otherms' and @cRef]">
        <a href="$id/diktyon-{@cRef}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="tei:ref[@type='andereWerke' and @target]">
        <a href="$id/{substring-after(@target, '#')}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul class="square-list">
            <xsl:for-each select="tei:label">
                <li>
                    <xsl:value-of select="."/>: <xsl:value-of select="./following-sibling::*[1]"/>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template match="tei:persName">
        <xsl:choose>
            <!--xsl:when test="@ref[contains(., 'gnd:')] and @evidence">
                <xsl:variable name="gnd">
                    <xsl:value-of select="./replace(replace(@ref, '(gnd:\d{1,9}-?(\d|X)?)|( gnd:\d{1,9}-?(\d|X)?)|(viaf:\d{1,9})', '$1'), 'gnd:', '')"/>
                </xsl:variable>
                <a href="../register/personen.xql?gnd={$gnd}">
                    <span class="conjecture">
                        <xsl:apply-templates/>
                    </span>
                </a>
            </xsl:when>
            <xsl:when test="@ref[contains(., 'gnd:')]">
                <xsl:variable name="gnd">
                    <xsl:value-of select="./replace(replace(@ref, '(gnd:\d{1,9}-?(\d|X)?)|( gnd:\d{1,9}-?(\d|X)?)|(viaf:\d{1,9})', '$1'), 'gnd:', '')"/>
                </xsl:variable>
                <a href="../register/personen.xql?gnd={$gnd}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:when test="@ref[contains(., 'http://d-nb.info/gnd/')] and @evidence">
                <a href="../register/personen.xql?gnd={./substring-after(@ref, 'http://d-nb.info/gnd/')}">
                    <span class="conjecture">
                        <xsl:apply-templates/>
                    </span>
                </a>
            </xsl:when>
            <xsl:when test="@ref[contains(., 'http://d-nb.info/gnd/')]">
                <a href="../register/personen.xql?gnd={./substring-after(@ref, 'http://d-nb.info/gnd/')}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when-->
            <xsl:when test="@ref[contains(., 'cagb:')] and @evidence">
                <xsl:variable name="cagbid">
                    <xsl:value-of select="replace(@ref, '(cagb:\S+)', '$1')"/>
                </xsl:variable>
                <a href="$id/{$cagbid}">
                    <span class="conjecture">
                        <xsl:apply-templates/>
                    </span>
                </a>
            </xsl:when>
            <xsl:when test="@ref[contains(., 'cagb:')]">
                <xsl:variable name="cagbid">
                    <xsl:value-of select="replace(@ref, '(cagb:\S+)', '$1')"/>
                </xsl:variable>
                <a href="$id/{$cagbid}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:when test="@evidence">
                <span class="conjecture">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
        <!-- Kontextrolle der Person -->
        <!--xsl:if test="@role">
            <sup class="info">
                <i class="fa fa-info" info="{telota:roleName(@role)}">
                    <span>(<xsl:value-of select="telota:roleName(@role)"/>)</span>
                </i>
            </sup>
        </xsl:if-->
    </xsl:template>
    <!-- CAGB-Ergänzungen -->
    <xsl:template match="tei:note[@resp='cagb']">
        <span class="text-danger font-italic"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:term">
        <xsl:choose>
            <xsl:when test="@key=$termID">
                <a href="$id/{@key}">
                    <span class="highlight">
                        <xsl:apply-templates/>
                    </span>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <a href="$id/{@key}">
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- nicht auf der Website erscheinende Elemente -->
    <xsl:template match="tei:teiHeader"/>
    <xsl:template match="tei:div/tei:head[not(./@type='entry') and not(@type='family')]"/>
    <xsl:template match="tei:listPerson"/>
    <xsl:template match="tei:g[@rend='sup']">
        <span class="sup"><xsl:apply-templates /></span>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='sup']">
        <span class="sup"><xsl:apply-templates /></span>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='italic']">
        <span class="it"><xsl:apply-templates /></span>
    </xsl:template>
</xsl:stylesheet>
