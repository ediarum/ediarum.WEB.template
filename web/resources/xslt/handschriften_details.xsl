<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:telota="http://www.telota.de" xmlns:tei="http://www.tei-c.org/ns/1.0" version="3.0" exclude-result-prefixes="tei telota exist">
    <xsl:preserve-space elements="*"/>
    <xsl:param name="file"/>
    <xsl:param name="suchbegriff"/>
    <xsl:param name="persNameRef"/>
    <xsl:param name="termID"/>
    <xsl:param name="cRef"/>
    <xsl:param name="target"/>
    <!-- Entwicklungsumgebung: false/true -->
    <xsl:param name="intern"/>
    <xsl:param name="urlWerkregister"/>
    <xsl:function name="telota:persNameRef">
        <!-- Diese Funktion ersetzt für die Suche nach IDs in persName/@ref URL-Teile mit dem entsprechenden Präfix.
        Das ist nötig, da im Personenregister z.B. gnd:00000000 notiert wurde, in den Dateien aber manchmal (nicht immer) die DNB-URL vor die
        Nummer gesetzt wurde. -->
        <xsl:param name="input"/>
        <xsl:variable name="replacedTerm1">
            <xsl:value-of select="replace($input, 'http://d-nb.info/gnd/', 'gnd:')"/>
        </xsl:variable>
        <!-- Die folgenden Funktionsteile sorgen dafür, dass mehrere Whitespace-separierte IDs sauber
        in mit einer Pipe getrennt ausgegeben werden. Wichtig nachher für den Vergleich in tei:persName -->
        <xsl:variable name="strippedLeadingEndingWhitespace">
            <xsl:value-of select="normalize-space($replacedTerm1)"/>
        </xsl:variable>
        <xsl:variable name="replacedWhitespace">
            <xsl:value-of select="replace($strippedLeadingEndingWhitespace, ' ', '|')"/>
        </xsl:variable>
        <!-- Letzte Pipe, um ID abgrenzen und unten mit contains arbeiten zu können -->
        <xsl:variable name="addedLastPipe">
            <xsl:value-of select="concat($replacedWhitespace, '|')"/>
        </xsl:variable>
        <xsl:value-of select="$addedLastPipe"/>
    </xsl:function>
    <xsl:function name="telota:roleName">
        <xsl:param name="roleName"/>
        <xsl:choose>
            <xsl:when test="$roleName='author-contained'">Autor, in dieser Handschrift enthalten</xsl:when>
            <xsl:when test="$roleName='author-similar'">Autor ähnlicher Texte</xsl:when>
            <xsl:when test="$roleName='author-referred'">Autor, kommentiert etc.</xsl:when>
            <xsl:when test="$roleName='author-attested'">Autor, bezeugt</xsl:when>
            <xsl:when test="$roleName='author'">Autor</xsl:when>
            <xsl:when test="$roleName='annotator'">Annotator</xsl:when>
            <xsl:when test="$roleName='scribe'">Schreiber</xsl:when>
            <xsl:when test="$roleName='corrector'">Korrektor</xsl:when>
            <xsl:when test="$roleName='owner'">Besitzer</xsl:when>
            <xsl:when test="$roleName='patron'">Auftraggeber</xsl:when>
            <xsl:when test="$roleName='editor'">Editor</xsl:when>
            <xsl:when test="$roleName='redactor'">Redaktor</xsl:when>
            <xsl:when test="$roleName='user'">Benutzer</xsl:when>
            <xsl:when test="$roleName='none'">unbestimmt</xsl:when>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <div>
            <xsl:if test="//tei:revisionDesc/@status!='draft' or //tei:revisionDesc/not(@status) or $intern='true'">
                <xsl:apply-templates select="//tei:body"/>
                <xsl:apply-templates select="//telota:transcriptions"/>
                <xsl:apply-templates select="//telota:comments"/>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="tei:msDesc/tei:msIdentifier"/>

    <xsl:template match="tei:g[@rend='sup']">
        <sup>
            <xsl:value-of select="."/>
        </sup>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='sub']">
        <sub>
            <xsl:value-of select="."/>
        </sub>
    </xsl:template>
    <xsl:template match="tei:note[@resp='cagb']">
        <span class="text-danger font-italic"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="tei:msContents">
        <div id="section/msContents">
            <h3>Inhalt</h3>
            <ul class="disc-list">
                <xsl:apply-templates select="tei:msItem[not(@n='empty' or @n='secondary' or @n='filiation')]"/>
                <xsl:apply-templates select="tei:msItem[@n='empty']"/>
                <xsl:apply-templates select="tei:msItem[@n='secondary']"/>
                <xsl:apply-templates select="tei:msItem[@n='filiation']"/>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="tei:msContents/tei:msItem">
        <xsl:for-each select=".">
            <xsl:choose>
                <xsl:when test="@n='empty'">
                    <li class="empty">
                        <h4>Leer</h4>
                        <br/>
                        <xsl:for-each select="tei:p">
                            <xsl:apply-templates/>
                            <br/>
                        </xsl:for-each>
                    </li>
                </xsl:when>
                <xsl:when test="@n='filiation'">
                    <li class="empty">
                        <h4>Textgeschichtliches</h4>
                        <br/>
                        <xsl:for-each select=".//tei:p">
                            <xsl:apply-templates/>
                            <br/>
                        </xsl:for-each>
                    </li>
                </xsl:when>
                <xsl:when test="@n='secondary'">
                    <li class="empty">
                        <h4>Annotationen</h4>
                        <br/>
                        <xsl:for-each select=".//tei:p">
                            <xsl:apply-templates/>
                            <br/>
                        </xsl:for-each>
                    </li>
                </xsl:when>
                <xsl:otherwise>
                    <li>
                        <xsl:for-each select="tei:p">
                            <xsl:apply-templates/>
                            <br/>
                        </xsl:for-each>
                    </li>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:physDesc">
        <div id="section/physDesc">
            <h3>Physische Beschaffenheit</h3>
            <xsl:apply-templates select="tei:objectDesc/tei:supportDesc/tei:support"/>
            <xsl:apply-templates select="tei:objectDesc/tei:supportDesc/tei:extent"/>
            <xsl:apply-templates select="tei:objectDesc/tei:supportDesc/tei:foliation"/>
            <xsl:apply-templates select="tei:objectDesc/tei:supportDesc/tei:collation"/>
            <xsl:apply-templates select="tei:objectDesc/tei:layoutDesc"/>
            <xsl:apply-templates select="tei:handDesc"/>
            <xsl:apply-templates select="tei:decoDesc"/>
            <xsl:apply-templates select="tei:additions"/>
            <xsl:apply-templates select="tei:bindingDesc"/>
            <xsl:apply-templates select="tei:objectDesc/tei:supportDesc/tei:condition"/>
        </div>
    </xsl:template>
    <xsl:template match="tei:p[@n='supportMaterial']">
        <xsl:choose>
            <xsl:when test="not(preceding-sibling::tei:p[@n='supportMaterial'])">
                <h4>Beschreibstoff</h4>
                <xsl:for-each select=".">
                    <p>
                        <xsl:apply-templates/>
                    </p>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select=".">
                    <p>
                        <xsl:apply-templates/>
                    </p>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:p[@n='supportMaterialAdditions']">
        <xsl:choose>
            <xsl:when test="not(preceding-sibling::tei:p[@n='supportMaterialAdditions'])">
                <h4>Anmerkungen zum Beschreibstoff</h4>
                <xsl:for-each select=".">
                    <p>
                        <xsl:apply-templates/>
                    </p>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select=".">
                    <p>
                        <xsl:apply-templates/>
                    </p>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:extent">
        <h4>Format</h4>
        <xsl:for-each select="//tei:measure[@type='leafsize']">
            <p>
                <xsl:apply-templates />
            </p>
        </xsl:for-each>
        <xsl:if test="//tei:measure[@type='numleaves']">
            <h4>Folienzahl</h4>
            <p>
                <xsl:apply-templates select="//tei:measure[@type='numleaves']"/>
            </p>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:objectDesc">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:p[@n='watermarkDesc']">
        <div id="watermarkDesc">
            <h4>Wasserzeichen</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:foliation">
        <div id="foliation">
            <h4>Foliierung</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:collation">
        <div id="collation">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:collation/tei:p[@n='quire-structure']">
        <div id="quire-structure">
            <xsl:choose>
                <xsl:when test="not(preceding-sibling::tei:p[@n='quire-structure'])">
                    <h4>Lagen</h4>
                    <xsl:for-each select=".">
                        <p>
                            <xsl:apply-templates/>
                        </p>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select=".">
                        <p>
                            <xsl:apply-templates/>
                        </p>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="tei:collation/tei:p[@n='sign-other']">
        <div id="sign-other">
            <xsl:choose>
                <xsl:when test="not(preceding-sibling::tei:p[@n='sign-other'])">
                    <h4>Lagensignierung</h4>
                    <xsl:for-each select=".">
                        <xsl:apply-templates/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select=".">
                        <xsl:apply-templates/>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="tei:collation//tei:signatures">
        <p>
            <xsl:apply-templates />
        </p>
    </xsl:template>
    <xsl:template match="tei:collation/tei:p[@n='sign-greek']">
        <div id="sign-greek">
            <xsl:choose>
                <xsl:when test="not(preceding-sibling::tei:p[@n='sign-greek'])">
                    <h4>Griechische Kustoden</h4>
                    <xsl:for-each select=".">
                        <p>
                            <xsl:apply-templates/>
                        </p>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select=".">
                        <p>
                            <xsl:apply-templates/>
                        </p>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    <xsl:template match="tei:collation/tei:p[@n='catchwords']">
        <div id="catchwords">
            <h4>Reklamanten</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:condition">
        <div id="condition">
            <h4>Erhaltungszustand</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:layout[@n='numlines']">
        <div id="numlines">
            <h4>Anzahl der Linien</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:layout[@n='ruling']">
        <div id="ruling">
            <h4>Liniierung</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:handDesc">
        <div id="handDesc">
            <h4>Kopist</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:decoDesc">
        <div id="decoDesc">
            <h4>Illumination</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:additions">
        <div id="additions">
            <h4>Ergänzungen zum Textbestand</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:bindingDesc">
        <div id="bindingDesc">
            <h4>Einband</h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:history">
        <div id="section/history">
            <h3>Geschichte</h3>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:history/tei:origin">
        <h4>Datierung</h4>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:measure">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:dimensions">
        <xsl:value-of select="tei:height"/>
        <xsl:text> × </xsl:text>
        <xsl:value-of select="tei:width"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@unit"/>
    </xsl:template>
    <!-- Entstehung aus Datierung ausblenden: -->
    <xsl:template match="tei:p[@n='primary']">
        <xsl:choose>
            <xsl:when test="not(preceding-sibling::tei:p[@n='primary'])">
                <h4>Entstehung</h4>
                <xsl:for-each select=".">
                    <p>
                        <xsl:apply-templates/>
                    </p>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select=".">
                    <p>
                        <xsl:apply-templates/>
                    </p>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:provenance/tei:p[@n='formercondition'][1]">
        <div id="formercondition">
            <h4>Ursprünglicher Zustand</h4>
            <xsl:for-each select=".">
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template match="tei:provenance/tei:p[@n='provenance'][1]">
        <div id="provenance">
            <h4>Provenienz</h4>
            <xsl:for-each select=".">
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template match="tei:additional">
        <!-- <h3>Weitere Angaben</h3> -->
        <div id="section/additional">
            <xsl:apply-templates select="tei:surrogates"/>
            <xsl:apply-templates select="tei:listBibl"/>
            <xsl:apply-templates select="tei:adminInfo"/>
        </div>
    </xsl:template>
    <xsl:template match="tei:recordHist">
        <div id="recordHist">
            <h3>Quelle</h3>
            <ul class="disc-list">
                <xsl:for-each select="tei:p">
                    <li>
                        <xsl:apply-templates/>
                    </li>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="tei:custodialHist">
        <div id="custodialHist">
            <h3>Dokumentation</h3>
            <p>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>
    <xsl:template match="tei:surrogates">
        <div id="surrogates">
            <h3>Reproduktionen und Digitalisate</h3>
            <ul>
                <xsl:apply-templates select="tei:p/child::*"/>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="tei:additional/tei:listBibl">
        <div id="bibliography">
            <h3>Bibliographie</h3>
            <xsl:apply-templates/>
        </div>
    </xsl:template>




    <!-- ************************** COMMON BLOCKLEVEL ELEMENTS ******************** -->
    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:listBibl|tei:list">
        <xsl:if test="tei:head">
            <h4>
                <xsl:value-of select="tei:head"/>
            </h4>
        </xsl:if>
        <ul class="disc-list">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:item|tei:listBibl/tei:bibl|tei:surrogates/tei:p/tei:bibl">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:listBibl/tei:head"/>

    <!-- **************************** INLINE ************************************** -->
    <xsl:template match="tei:locus">
        <xsl:choose>
            <xsl:when test="contains(., 'RV')">
                <span class="locus">
                    <span>
                        <xsl:value-of select="text()"/>
                    </span>
                    <sup>RV</sup>
                </span>
            </xsl:when>
            <xsl:when test="contains(., 'V')">
                <span class="locus">
                    <span>
                        <xsl:value-of select="text()"/>
                    </span>
                    <sup>V</sup>
                </span>
            </xsl:when>
            <xsl:when test="contains(., 'R')">
                <span class="locus">
                    <span>
                        <xsl:value-of select="text()"/>
                    </span>
                    <sup>R</sup>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="locus">
                    <span>
                        <xsl:value-of select="text()"/>
                    </span>
                </span>
            </xsl:otherwise>
        </xsl:choose>
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
    <xsl:template match="tei:placeName">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:persName">
        <!-- ######## Abgleich der IDs in persName/@ref mit denen die im Parameter übergeben worden sind ############ -->
        <!-- IDs aus dem Parameter auslesen und in einer Liste ausgeben -->
        <xsl:variable name="tokenizedParamRefs">
            <ul xmlns="http://www.telota.de">
                <xsl:for-each select="tokenize($persNameRef, '\|')">
                    <li>
                        <xsl:value-of select="."/>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:variable>
        <!-- IDs aus persName/@ref auslesen und in einer Liste ausgeben -->
        <xsl:variable name="tokenizedRefs">
            <ul xmlns="http://www.telota.de">
                <xsl:for-each select="tokenize(telota:persNameRef(@ref), '\|')">
                    <xsl:if test=".!=''">
                        <li>
                            <xsl:value-of select="."/>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ul>
        </xsl:variable>
        <!-- Prüfen, ob eine der persName/@ref mit einer aus den übergebenen IDs über einstimmt,
        wenn ja "true" ausgeben -->
        <xsl:variable name="reftest">
            <!-- Der genaue Abgleich mit Hilfe von "=" ist nötig, weil sonst Teilzeichenketten zu
            Treffern und somit zu falschen Highlights führen würden -->
            <xsl:for-each select="$tokenizedRefs//telota:li[.=$tokenizedParamRefs//telota:li]">
                <xsl:text>true</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <!-- Erster Fall nur, wenn mindestens ein Treffer des reftest vorliegt -->
            <xsl:when test="$persNameRef and matches($reftest, 'true')">
                <span class="highlight">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <!-- <xsl:when test="@ref[contains(., 'gnd:')] and @evidence">
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
            </xsl:when> -->
            <xsl:when test="@ref[matches(., '^C\d{7}')] and @evidence">
                <a href="$id/{@ref}">
                    <span class="conjecture">
                        <xsl:apply-templates/>
                    </span>
                </a>
            </xsl:when>
            <xsl:when test="@ref[matches(., '^C\d{7}')]">
                <a href="$id/{@ref}">
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
    <xsl:template match="tei:q">
        <span class="quote">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:note">
        <xsl:choose>
            <xsl:when test=".[@resp='cagb']">
                <span class="note cagb">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="note"> (<xsl:apply-templates/>) </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:ref[index-of(('AristWerk', 'Diagramme', 'Exzerpte', 'Fragment', 'Kommentar', 'Paraphrase', 'Paratext', 'Redaktion', 'Rekonstruktion', 'Scholien', 'Simile', 'Teile', 'Varianten', '[nicht spezifiziert]'), @type) and @cRef]">
        <xsl:choose>
            <xsl:when test="@cRef=$cRef">
                <a href="$id/{translate(@cRef, ' ', '-')}">
                    <span class="highlight">
                        <xsl:apply-templates/>
                    </span>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <a href="$id/{translate(@cRef, ' ', '-')}">
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:ref[index-of(('AristWerk', 'Diagramme', 'Exzerpte', 'Fragment', 'Kommentar', 'Paraphrase', 'Paratext', 'Redaktion', 'Rekonstruktion', 'Scholien', 'Simile', 'Teile', 'Varianten', '[nicht spezifiziert]', 'EnthaltenesWerk'), @type) and @target]">
        <xsl:choose>
            <xsl:when test="@target=$target">
                <a href="$id/{substring-after(@target, '#')}">
                    <span class="highlight">
                        <xsl:apply-templates/>
                    </span>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <a href="$id/{substring-after(@target, '#')}">
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:ref[@type='straighturl']">
        <a href="{@target}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="tei:ref[@type='watermark']">
        <xsl:choose>
            <xsl:when test="matches(@cRef, 'Br')">
                <a class="extern" href="http://www.ksbm.oeaw.ac.at/_scripts/php/loadRepWmark.php?rep=briquet&amp;lang=de&amp;refnr={replace(@cRef, 'Br ', '')}" target="_blank">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:ref[@type='otherms' and @cRef]">
        <xsl:variable name="cRef" select="@cRef"/>
        <span class="anchor" id="a{@cRef}_{count(preceding::tei:ref[@type='otherms' and @cRef eq $cRef])+1}"/>
        <xsl:variable name="id">
            <xsl:choose>
                <xsl:when test="count(//tei:ref[@type='otherms' and @cRef eq $cRef]) eq 1">
                    <xsl:value-of select="'ms/'||@cRef"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'ms/'||@cRef||'_'||count(preceding::tei:ref[@type='otherms' and @cRef eq $cRef])+1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="matches(@cRef, '^C\d{7}')">
                <a href="$id/{@cRef}" id="{$id}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when> 
            <xsl:otherwise>
                <a href="$id/diktyon-{@cRef}" id="{$id}">
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Ansatz eines möglichen automatisches Linkparsing:
    <xsl:template match="*[text()[contains(.,'http://')]]">
        <xsl:variable name="url">http://<xsl:value-of select="substring-before(substring-after(., 'http://'), ' ')" /></xsl:variable>
        <a href="{$url}"><xsl:value-of select="." /></a>
    </xsl:template>
    -->
    <!-- *************************** TELOTA *************************************** -->
    <xsl:template match="telota:transcriptions[telota:div]">
        <xsl:if test="./telota:div[@status='final'] or $intern='true'">
            <div id="transcriptions">
                <h3>Transkriptionen</h3>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="telota:transcriptions/telota:div">
        <xsl:if test="./@status='final' or $intern='true'">
            <div class="fragment">
                <a class="jumpmark" id="{./@xml:id}">s</a>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>
    <!-- ######## FUNCTION um Autornamen samt Trenner oder alles nicht anzeigen zu können ############ -->
    <xsl:function name="telota:author">
        <xsl:param name="input"/>
        <xsl:if test="$input//text()">
            <xsl:value-of select="normalize-space($input/text())"/>
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:function>
    <!-- ######## FUNCTION um Anzeige der verschiedenen Relationstypen zu steuern ############ -->
    <xsl:function name="telota:relationType">
        <xsl:param name="input"/>
        <xsl:choose>
            <xsl:when test="$input='Exzerpte'">
                <xsl:value-of select="$input"/>
                <xsl:text> aus </xsl:text>
            </xsl:when>
            <xsl:when test="$input='Gruppe'">
                <xsl:text>Gruppe </xsl:text>
            </xsl:when>
            <xsl:when test="$input='[nicht spezifiziert]'">
                <!-- wird nicht angezeigt -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$input"/>
                <xsl:text> zu </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:template match="telota:relationGrp">
        <div>
            <h4>Relationen</h4>
            <ul>
                <xsl:for-each select="telota:ref">
                    <xsl:variable name="cagbid">
                        <xsl:if test="@target">
                            <xsl:value-of select="substring-after(@target, '#')"/>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="link">
                        <xsl:choose>
                            <xsl:when test="@cRef">
                                <xsl:text>$id/</xsl:text>
                                <xsl:value-of select="@cRef"/>
                            </xsl:when>
                            <xsl:when test="@type='Gruppe'">
                                <xsl:text>$id/</xsl:text>
                                <xsl:value-of select="$cagbid"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>$id/</xsl:text>
                                <xsl:value-of select="$cagbid"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="urlTranskriptGruppen">
                        <xsl:choose>
                            <xsl:when test="$intern='true'">
                                <xsl:text>/db/projects/cagb/data/Register/transkriptGruppen.xml</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>/db/projects/cagb/data/Register/transkriptGruppen.xml</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <li>
                        <a href="{$link}">
                            <xsl:choose>
                                <xsl:when test="@cRef">
                                    <xsl:value-of select="telota:relationType(@type)"/>
                                    <i>
                                        <xsl:value-of select="@cRef"/>
                                    </i>
                                </xsl:when>
                                <xsl:when test="@type='Exzerpte'">
                                    <xsl:value-of select="telota:relationType(@type)"/>
                                    <i>
                                        <xsl:value-of select="telota:author(doc($urlWerkregister)//werk[@cagbid=$cagbid]/autor)"/>
                                    </i>
                                    <xsl:value-of select="doc($urlWerkregister)//werk[@cagbid=$cagbid]/titel/text()"/>
                                </xsl:when>
                                <xsl:when test="@type='Gruppe' and $intern='true'">
                                    <xsl:value-of select="telota:relationType(@type)"/>
                                    <xsl:value-of select="doc($urlTranskriptGruppen)//gruppe[@cagbid=$cagbid]/bezeichnung"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="telota:relationType(@type)"/>
                                    <i>
                                        <xsl:value-of select="telota:author(doc($urlWerkregister)//werk[@cagbid=$cagbid]/autor)"/>
                                    </i>
                                    <xsl:value-of select="doc($urlWerkregister)//werk[@cagbid=$cagbid]/titel/text()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </li>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="telota:comments">
        <xsl:if test="$intern='true'">
            <div id="comments" class="alert alert-secondary">
                <h3 class="alert-heading">Bearbeitungsnotizen</h3>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="telota:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="telota:lb">
        <xsl:text> | </xsl:text>
        <!--xsl:choose>
            <xsl:when test="@n">
                <br/>
                <xsl:value-of select="@n"/>&#160; </xsl:when>
            <xsl:otherwise>
                <br/>
            </xsl:otherwise>
        </xsl:choose-->
    </xsl:template>
    <xsl:template match="telota:supplied">
        <xsl:text> 〈</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>〉 </xsl:text>
    </xsl:template>
    <xsl:template match="telota:hi[@rend='underline']">
        <span class="underline">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <xsl:template match="telota:hi[@rend='sup']">
        <span class="sup">
            <xsl:value-of select="." />
        </span>
    </xsl:template>
    <xsl:template match="telota:hi[@rend/contains(., 'color')]">
        <xsl:choose>
            <xsl:when test="./@rend/contains(., 'red')">
                <span class="color red">
                    <xsl:value-of select="."/>
                </span>
            </xsl:when>
            <xsl:when test="./@rend/contains(., 'blue')">
                <span class="color blue">
                    <xsl:value-of select="."/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="color black">
                    <xsl:value-of select="."/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="telota:del">
        <span class="del">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="telota:add">
        <xsl:choose>
            <xsl:when test="./@place">
                <span class="add" data-place="{./@place}">
                    <xsl:value-of select="."/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="add">
                    <xsl:value-of select="."/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="telota:unclear">
        <span class="unclear">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="telota:gap">
        <span class="gap">&#160;</span>
    </xsl:template>
    <xsl:template match="telota:ex">
        <span class="ex">〈<xsl:value-of select="."/>〉</span>
    </xsl:template>
    <xsl:template match="telota:note">
        <xsl:choose>
            <xsl:when test="./@resp='kopist'">
                <span class="note kopist"> (Kopist: <xsl:apply-templates/>) </span>
            </xsl:when>
            <xsl:when test="./@resp='altera manus'">
                <span class="note kopist"> (Altera Manus: <xsl:apply-templates/>) </span>
            </xsl:when>
            <xsl:when test="matches(./@resp, 'cagb:')">
                <span class="note person"> (<a href="../register/personen.xql?id={./@resp/data(.)}">Identifizierte Person: </a>
                    <xsl:apply-templates/>) </span>
            </xsl:when>
            <xsl:when test="./@resp='cagb'">
                <span class="note cagb">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="telota:surplus">
        <span class="surplus"> [<xsl:apply-templates/>] </span>
    </xsl:template>
    <xsl:template match="telota:choice">
        <span class="sic">
            <xsl:value-of select="./telota:sic"/> [sic]</span>
        <span class="corr">〈<xsl:value-of select="./telota:corr"/>〉</span>
    </xsl:template>
    <!-- Suchbegriffe hervorheben -->
    <xsl:template match="exist:match">
        <span class="highlight">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- nicht auf der Website erscheinende Elemente -->
</xsl:stylesheet>
