<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:telota="http://www.telota.de" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei exist telota" version="2.0">
    <!-- ##### Strukturelemente ##### -->
    <xsl:param name="id"/>
    <xsl:param name="filename"/>
    <xsl:param name="print"/>
    <xsl:param name="cacheLetterIndex"/>
    <xsl:function name="telota:labels">
        <xsl:param name="string"/>
        <xsl:param name="quantity"/>
        <xsl:variable name="cleanedString">
            <xsl:choose>
                <xsl:when test="matches($string, '#')">
                    <xsl:value-of select="substring-after($string, '#')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$string"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$cleanedString='char' and $quantity='1'">
                <xsl:text>Ein Buchstabe</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='char' and $quantity&gt;'1'">
                <xsl:value-of select="$quantity"/>
                <xsl:text> Buchstaben</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='words' and $quantity='1'">
                <xsl:text>Ein Wort</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='words' and $quantity&gt;'1'">
                <xsl:value-of select="$quantity"/>
                <xsl:text> Wörter</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='lines' and $quantity='1'">
                <xsl:text>Eine Zeile</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='lines' and $quantity&gt;'1'">
                <xsl:value-of select="$quantity"/>
                <xsl:text> Zeilen</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='pages' and $quantity='1'">
                <xsl:text>Eine Seite</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='pages' and $quantity&gt;'1'">
                <xsl:value-of select="$quantity"/>
                <xsl:text> Seiten</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='superlinear'">
                <xsl:text>über der Zeile</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='sublinear'">
                <xsl:text>unter der Zeile</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='intralinear'">
                <xsl:text>innerhalb der Zeile</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='across'">
                <xsl:text>über den ursprünglichen Text geschrieben</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='left'">
                <xsl:text>am linken Rand</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='right'">
                <xsl:text>am rechten Rand</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='mTop'">
                <xsl:text>am oberen Rand</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='mBottom'">
                <xsl:text>am unteren Rand</xsl:text>
            </xsl:when>
            <xsl:when test="$cleanedString='inline'">
                <xsl:text>innerhalb der Zeile</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    <xsl:template mode="kritischerText lesetext faksimileText" match="tei:p">
        <p>
            <xsl:apply-templates mode="#current"/>
        </p>
    </xsl:template>
    <xsl:template mode="kritischerText lesetext faksimileText" match="tei:p[ancestor::tei:p or ancestor::tei:note]">
        <span class="p">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    <xsl:template mode="kritischerText faksimileText" match="tei:p[@rendition='#mMM']">
        <p class="randstrich">
            <xsl:apply-templates mode="#current"/>
        </p>
    </xsl:template>
    <xsl:template mode="kritischerText faksimileText" match="tei:p[@rendition='#mMM' and (ancestor::tei:p or ancestor::tei:note)]">
        <span class="p randstrich">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    <xsl:template mode="lesetext kritischerText" match="tei:pb">
        <xsl:choose>
            <xsl:when test="following-sibling::tei:div">
                <div class="grid_16">
                    <p class="folio">
                        <a name="{./@n}">
                            <xsl:value-of select="./@n"/>
                        </a>
                        <xsl:if test="./@facs">
                            <br/>
                            <a class="facs" href="detail.xql?id={$id}&amp;view=f#{@facs}"></a>
                        </xsl:if>
                    </p>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="class">
                    <xsl:choose>
                        <xsl:when test="matches(@ed, 'Druck')">
                            <xsl:text>folio druck</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>folio</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="title">
                    <xsl:choose>
                        <xsl:when test="matches(@ed, 'Druck')">
                            <xsl:text>Seitenangabe der Druckausgabe</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Foliierung des Archivs</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                | <xsl:if test="@n!=''">
                    <span id="{./@n}" class="{$class}" title="{$title}">
                        <xsl:value-of select="./@n"/>
                    </span>
                </xsl:if>
                <xsl:if test="following-sibling::*[1][self::tei:fw]">
                    <span class="folio fw" title="Seitenangabe des Autors">
                        <xsl:value-of select="following-sibling::*[1][self::tei:fw]/text()"/>
                    </span>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template mode="#all" match="tei:fw"/>
    <xsl:template mode="faksimileText" match="tei:pb">
        <xsl:variable name="scalerURL">
            <xsl:text>http://digilib.bbaw.de/digitallibrary/servlet/Scaler?fn=silo10/avhr</xsl:text>
        </xsl:variable>
        <xsl:variable name="skinURL">
            <xsl:text>http://digilib.bbaw.de/digitallibrary/greyskin/diginew.jsp?fn=silo10/avhr</xsl:text>
        </xsl:variable>
        <xsl:variable name="facsPath">
            <xsl:choose>
                <xsl:when test="$id='avhr_vwc_lsf_1w'">
                    <xsl:text>/kuba/</xsl:text>
                    <xsl:value-of select="@n"/>
                    <xsl:text>.tif</xsl:text>
                </xsl:when>
                <xsl:when test="matches($id, 'avhr_dzb_b1n_fw|avhr_jhn_znn_fw|avhr_ujk_xbg_fw|avhr_anm_fwg_fw')">
                    <xsl:text>/dokumente/</xsl:text>
                    <xsl:value-of select="substring-before($filename, '.xml')"/>
                    <xsl:text>/&amp;pn=</xsl:text>
                    <xsl:value-of select="count(preceding::tei:pb)+1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>/briefe/</xsl:text>
                    <xsl:value-of select="substring-before($filename, '.xml')"/>
                    <xsl:text>/&amp;pn=</xsl:text>
                    <xsl:value-of select="count(preceding::tei:pb)+1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        | <xsl:if test="@n!=''">
            <span id="{./@n}" class="folio">
                <xsl:value-of select="./@n"/>
            </span>
        </xsl:if>
        <span id="faksimile">
            <span class="faksimileHead">Faksimile <xsl:value-of select="./@n"/>
            </span>
            <a class="faksimile" href="{$scalerURL}{$facsPath}&amp;dw=1200">
                <img src="{$scalerURL}{$facsPath}&amp;dw=200" title="Faksimile von Folio {./@facs}"/>
            </a>
            <span class="faksimileCaption">
                <a href="{$skinURL}{$facsPath}" target="_blank">
                    <i class="fa fa-search-plus" aria-hidden="true">&#160;</i>Große Ansicht</a> | <a href="../impressum.xql#bildnachweis">
                    <i class="fa fa-copyright" aria-hidden="true">&#160;</i>Bildnachweis</a>
            </span>
        </span>
    </xsl:template>
    <xsl:template mode="kritischerText faksimileText" match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template mode="lesetext" match="tei:lb"/>
    <xsl:template mode="kritischerText faksimileText" match="tei:milestone[@unit='section' and @rendition='#hr']">
        <hr class="section" title="Abschnittsstrich durch Autor gesetzt"/>
    </xsl:template>
    <xsl:template mode="#all" match="tei:list">
        <ul>
            <xsl:apply-templates mode="#current"/>
        </ul>
    </xsl:template>
    <xsl:template mode="#all" match="tei:item">
        <li>
            <xsl:apply-templates mode="#current"/>
        </li>
    </xsl:template>
    <xsl:template mode="kritischerText lesetext faksimileText" match="tei:note[@resp]">
        <xsl:variable name="sticked">
            <xsl:if test="@rend='sticked'">
                <xsl:text> sticked</xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="collapsed">
            <xsl:choose>
                <xsl:when test=".//*[self::tei:ref[@type='siglum']]"/>
                <xsl:otherwise>
                    <xsl:text> collapsedNote</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="resp">
            <xsl:choose>
                <xsl:when test="@resp='#author'">
                    des Autors
                </xsl:when>
                <xsl:when test="@resp='#addressee'">
                    des Empfängers
                </xsl:when>
                <xsl:when test="@resp='#humboldt'">
                    von Humboldt
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@resp"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <span class="autorenfussnote{$sticked}">
            <span class="label{$collapsed}">
                <xsl:choose>
                    <xsl:when test="@rend='sticked'">
                        <i class="fa fa-sticky-note" aria-hidden="true">&#160;</i>Aufgeklebte Notiz <xsl:value-of select="$resp"/>
                    </xsl:when>
                    <xsl:when test="@rend='sticked' and @type='auxCalc'">
                        <i class="fa fa-sticky-note" aria-hidden="true">&#160;</i>Aufgeklebte Notiz mit Nebenrechnung <xsl:value-of select="$resp"/>
                    </xsl:when>
                    <xsl:when test="@type='auxCalc'">
                        <i class="fa fa-chevron-circle-down" aria-hidden="true">&#160;</i>Nebenrechnung <xsl:value-of select="$resp"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <i class="fa fa-chevron-circle-down" aria-hidden="true">&#160;</i>Anmerkung <xsl:value-of select="$resp"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="@place">(<xsl:value-of select="telota:labels(@place, ())"/>)</xsl:if>
            </span>
            <span class="text">
                <xsl:apply-templates mode="#current"/>
            </span>
        </span>
    </xsl:template>
    <xsl:template mode="#all" match="tei:salute|tei:address">
        <span class="p">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    <xsl:template mode="#all" match="tei:addrLine">
        <xsl:apply-templates mode="#current"/>
        <br/>
    </xsl:template>
    <xsl:template mode="#all" match="tei:dateline">
        <p style="text-align: right">
            <xsl:apply-templates mode="#current"/>
        </p>
    </xsl:template>
    <xsl:template mode="#all" match="tei:table">
        <table>
            <xsl:if test="@rend='drawn'">
                <xsl:attribute name="class">
                    <xsl:text>drawn</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:for-each select="tei:row">
                <tr>
                    <xsl:choose>
                        <xsl:when test="@role='label'">
                            <xsl:for-each select="tei:cell">
                                <th>
                                    <xsl:if test="@rendition='#right'">
                                        <xsl:attribute name="class">
                                            align-right
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:apply-templates mode="#current"/>
                                </th>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="tei:cell">
                                <td>
                                    <xsl:if test="@rendition='#right'">
                                        <xsl:attribute name="class">
                                            align-right
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:apply-templates mode="#current"/>
                                </td>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>
    <xsl:template match="tei:hi[@rendition='#u']" mode="#all">
        <span class="unterstrichen">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:hi[@rendition='#uu']" mode="#all">
        <span class="doppeltunterstrichen">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:hi[@rendition='#i']" mode="#all">
        <span class="kursiv">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:hi[@rendition='#mMM']" mode="kritischerText faksimileText">
        <span class="randstrich">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:hi[@rendition='#sup']" mode="#all">
        <span class="hochgestellt">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    <xsl:template mode="#all" match="tei:foreign">
        <span>
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    <!-- ##### Textbearbeitungen durch den Autor ##### -->
    <xsl:template mode="kritischerText faksimileText " match="tei:del">
        <span class="del">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    <xsl:template mode="lesetext" match="tei:del"/>
    <xsl:template mode="kritischerText faksimileText" match="tei:add">
        <xsl:choose>
            <xsl:when test="$print='yes'">
                <span class="add tooltip">
                    <xsl:apply-templates mode="#current"/>
                    <xsl:variable name="target">
                        <xsl:number format="1" level="any"/>
                    </xsl:variable>
                    <xsl:variable name="nr">
                        <xsl:number format="a" level="any"/>
                    </xsl:variable>
                    <a id="cchar{$target}" href="#cnote{$target}">[<xsl:value-of select="$nr"/>]</a>
                </span>
            </xsl:when>
            <xsl:when test="@place!=''">
                <span class="add tooltip">
                    <span class="place fussnote">
                        <span class="fussnotenpfeil">&#160;</span>
                        <xsl:value-of select="telota:labels(@place, ())"/>
                    </span>
                    <xsl:apply-templates mode="#current"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="add">
                    <xsl:apply-templates mode="#current"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template mode="lesetext" match="tei:add">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    <xsl:template mode="kritischerText faksimileText" match="tei:metamark[not(@function='used')]">
        <xsl:text>⎡</xsl:text>
    </xsl:template>

    <!-- ##### Textbearbeitungen durch den Herausgeber ##### -->
    <!-- DEPRACATED: ex -->
    <xsl:template mode="kritischerText faksimileText lesetext" match="tei:ex">
        <em>
            <xsl:value-of select="."/>
        </em>
    </xsl:template>
    <xsl:template mode="kritischerText faksimileText" match="tei:unclear">
        <xsl:choose>
            <xsl:when test="child::*|text()">
                <span class="unclear">
                    <xsl:apply-templates mode="#current"/>
                    <span class="symbol">(?)</span>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="unclear">
                    [...]<span class="symbol">(?)</span>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template mode="lesetext" match="tei:unclear">
        <xsl:choose>
            <xsl:when test="child::*|text()">
                <span class="unclear">
                    <xsl:apply-templates mode="#current"/>
                    <span class="symbol">(?)</span>
                </span>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template mode="kritischerText faksimileText" match="tei:gap">
        <xsl:choose>
            <xsl:when test="@quantity!='' and @unit!=''">
                <span class="gap tooltip">
                    <span class="place fussnote">
                        <span class="fussnotenpfeil">&#160;</span>
                        <xsl:value-of select="telota:labels(@unit, @quantity)"/> unleserlich
                    </span>
                    [...]
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="gap">
                    [...]
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template mode="lesetext" match="tei:gap">
        <span class="gap"> [...] </span>
    </xsl:template>
    <xsl:template mode="kritischerText faksimileText" match="tei:supplied">
        <span class="supplied">[<xsl:apply-templates mode="#current"/>]</span>
    </xsl:template>
    <xsl:template mode="lesetext" match="tei:supplied">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    <xsl:template mode="kritischerText faksimileText" match="tei:surplus">
        <span class="surplus">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    <xsl:template mode="lesetext" match="tei:surplus"/>
    <xsl:template mode="kritischerText faksimileText" match="tei:choice[./tei:sic]">
        <span class="choice">
            <span class="sic">
                <xsl:apply-templates mode="#current" select="tei:sic"/>
                <xsl:text> [sic]</xsl:text>
            </span>
        </span>
    </xsl:template>
    <xsl:template mode="lesetext" match="tei:choice[./tei:sic]">
        <span>
            <xsl:apply-templates mode="#current" select="tei:corr"/>
        </span>
    </xsl:template>
    <xsl:template mode="kritischerText faksimileText" match="tei:choice[./tei:abbr]">
        <span>
            <xsl:apply-templates mode="#current" select="tei:abbr"/>
        </span>
    </xsl:template>
    <xsl:template mode="lesetext" match="tei:choice[./tei:abbr]">
        <span>
            <xsl:apply-templates mode="#current" select="tei:expan"/>
        </span>
    </xsl:template>
    <xsl:template mode="kritischerText faksimileText" match="tei:choice[./tei:reg]">
        <span>
            <xsl:apply-templates mode="#current" select="tei:orig"/>
        </span>
    </xsl:template>
    <xsl:template mode="lesetext" match="tei:choice[./tei:reg]">
        <span>
            <xsl:apply-templates mode="#current" select="tei:reg"/>
        </span>
    </xsl:template>
    <xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>
    <xsl:template mode="lesetext kritischerText faksimileText" match="tei:quote">
        <span class="quote">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>

    <!-- ##### Indizierungen ##### -->
    <!-- <xsl:template mode="#all" match="tei:measure">
        <xsl:variable name="unit">
            <xsl:value-of select="@unit"/>
        </xsl:variable>
        <xsl:variable name="item" as="node()">
            <xsl:copy-of select="doc('xmldb:///db/projects/avhr/data/Register/Maße.xml')//tei:item[@xml:id=$unit]"/>
        </xsl:variable>
        <xsl:variable name="result">
            <xsl:value-of select="(@quantity/data(.) * $item/tei:measure/@quantity/data(.))"/>
        </xsl:variable>
        <span class="tooltip measure">
            <span class="fussnote">
                <span class="fussnotenpfeil">&#160;</span>
                <xsl:value-of select="$item/tei:label"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="$item/tei:desc"/>
                <xsl:if test="$item//tei:measure/@quantity">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="concat(format-number(@quantity, '###.###,##', 'european'), ' ', $item/tei:label)"/>
                    <xsl:text> entsprechen </xsl:text>
                    <xsl:if test="$item/tei:measure/@ana='#circa'">
                        <xsl:text> etwa </xsl:text>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="$item/tei:measure/@unit='kg' and ($result &gt; 1000) and $item/tei:measure/@ana='#circa'">
                            <xsl:value-of select="concat(format-number(($result div 1000), '###.###', 'european'), ' ', 'Tonnen')"/>
                        </xsl:when>
                        <xsl:when test="$item/tei:measure/@unit='kg' and ($result &gt; 1000)">
                            <xsl:value-of select="concat(format-number(($result div 1000), '###.###,00', 'european'), ' ', 'Tonnen')"/>
                        </xsl:when>
                        <xsl:when test="$item/tei:measure/@unit='kg' and $item/tei:measure/@ana='#circa'">
                            <xsl:value-of select="concat(format-number($result, '###.###', 'european'), ' ', $item/tei:measure/@unit/data(.))"/>
                        </xsl:when>
                        <xsl:when test="$item/tei:measure/@unit='m' and ($result &gt; 1000) and $item/tei:measure/@ana='#circa'">
                            <xsl:value-of select="concat(format-number(($result div 1000), '###.###', 'european'), ' ', 'km')"/>
                        </xsl:when>
                        <xsl:when test="$item/tei:measure/@unit='m' and ($result &gt; 1000)">
                            <xsl:value-of select="concat(format-number(($result div 1000), '###.###,00', 'european'), ' ', 'km')"/>
                        </xsl:when>
                        <xsl:when test="$item/tei:measure/@unit='m' and $item/tei:measure/@ana='#circa'">
                            <xsl:value-of select="concat(format-number($result, '###.###', 'european'), ' ', $item/tei:measure/@unit/data(.))"/>
                        </xsl:when>
                        <xsl:when test="$item/tei:measure/@unit='m2' and ($result &gt; 1000) and $item/tei:measure/@ana='#circa'">
                            <xsl:value-of select="concat(format-number(($result div 1000), '###.###', 'european'), ' ', 'km²')"/>
                        </xsl:when>
                        <xsl:when test="$item/tei:measure/@unit='m2' and ($result &gt; 1000)">
                            <xsl:value-of select="concat(format-number(($result div 1000), '###.###,00', 'european'), ' ', 'km²')"/>
                        </xsl:when>
                        <xsl:when test="$item/tei:measure/@unit='m2' and $item/tei:measure/@ana='#circa'">
                            <xsl:value-of select="concat(format-number($result, '###.###', 'european'), ' ', $item/tei:measure/@unit/data(.))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat(format-number($result, '###.##0,00', 'european'), ' ', $item/tei:measure/@unit/data(.))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </span>
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    <xsl:template mode="#all" match="tei:persName">
        <xsl:variable name="id">
            <xsl:value-of select="@key"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@cert='low'">
                <span class="tooltip">
                    <span class="fussnote">
                        <span class="fussnotenpfeil">&#160;</span>
                        <xsl:text>Identifizierung der Person unsicher</xsl:text>
                    </span>
                    <a href="../register/personen/detail.xql?id={$id}">
                        <xsl:apply-templates mode="#current"/>
                    </a>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <a href="../register/personen/detail.xql?id={$id}">
                    <xsl:apply-templates mode="#current"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template mode="#all" match="tei:orgName">
        <a href="../register/einrichtungen/detail.xql?id={./@key}">
            <xsl:apply-templates mode="#current"/>
        </a>
    </xsl:template>
    <xsl:template mode="#all" match="tei:placeName">
        <a href="../register/orte/detail.xql?id={./@key}">
            <xsl:apply-templates mode="#current"/>
        </a>
    </xsl:template>
    <xsl:template mode="#all" match="tei:rs[@type='place']">
        <a href="../register/orte/detail.xql?id={./@key}">
            <xsl:apply-templates mode="#current"/>
        </a>
    </xsl:template>
    <xsl:template mode="#all" match="tei:rs[@type='person']">
        <xsl:variable name="id">
            <xsl:value-of select="@key"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@cert='low'">
                <span class="tooltip">
                    <span class="fussnote">
                        <span class="fussnotenpfeil">&#160;</span>
                        <xsl:text>Identifizierung der Person unsicher</xsl:text>
                    </span>
                    <a href="../register/personen/detail.xql?id={$id}">
                        <xsl:apply-templates mode="#current"/>
                    </a>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <a href="../register/personen/detail.xql?id={$id}">
                    <xsl:apply-templates mode="#current"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template mode="#all" match="tei:bibl[@sameAs and not(ancestor::tei:seg and ancestor::tei:note)]">
        <a href="../register/werke/detail.xql?id={./@sameAs}">
            <xsl:apply-templates mode="#current"/>
        </a>
    </xsl:template>
    <xsl:template mode="#all" match="tei:bibl[@sameAs and ancestor::tei:seg and ancestor::tei:note]">
        <a class="bibl" href="../register/werke/detail.xql?id={./@sameAs}">
            <xsl:apply-templates mode="#current"/>
        </a>
    </xsl:template>
    <xsl:template mode="#all" match="tei:date">
        <a href="../zeit/zeitsuche_ergebnis.xql?datum={./@when}">
            <xsl:apply-templates mode="#current"/>
        </a>
    </xsl:template>
    <xsl:template mode="#all" match="tei:g[@ref='#U2002']"> -->
        <!-- DEPRACATED -->
        <!-- <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template mode="kritischerText faksimileText" match="tei:g[@ref='#typoHyphen']">
        <xsl:text>-</xsl:text>
    </xsl:template> -->
    <!-- ##### Verweise -->
    <xsl:template mode="#all" match="tei:rs[@type='letter']">
        <xsl:choose>
            <xsl:when test="@type='erschlossenerBrief'">
                <span class="rs">
                    <xsl:apply-templates mode="#current"/>
                    <a class="erschlossenerBrief" href="../briefe/detail.xql?id={@key}" title="Zum erschlossenen Brief">
                        <span>Zum erschlossenen Brief</span></a>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="rs">
                    <xsl:apply-templates mode="#current"/>
                    <a class="brief" href="../briefe/detail.xql?id={@key}" title="Zum Volltext des Briefes">
                        <span>Zum Volltext des Briefes</span></a>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template mode="#all" match="tei:ref[not(@type='siglum')]">
        <xsl:variable name="class">
            <xsl:if test="matches(@target, 'zotero')">
                <xsl:text>zotero</xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="target">
            <xsl:choose>
                <xsl:when test="matches(@target, 'http://') or matches(@target, 'https://')">
                    <xsl:value-of select="@target"/>
                </xsl:when>
                <xsl:when test="matches(@target, '/')">
                    <xsl:text>detail.xql?id=</xsl:text>
                    <xsl:value-of select="substring-before(@target, '/')"/>
                    <xsl:value-of select="substring-after(@target, '/')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>detail.xql?id=</xsl:text>
                    <xsl:value-of select="@target"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="letterTitle">
            <!-- TODO: cacheIndex aktivieren -->
            <!-- <xsl:value-of select="doc($cacheLetterIndex)//entry[@id=$letterID]/text()"/> -->
        </xsl:variable>
        <a class="{$class}" href="{$target}">
            <xsl:apply-templates mode="#current"/>
        </a>
    </xsl:template>
    <xsl:template mode="#all" match="tei:ref[@type='siglum']">
        <a id="{@xml:id}" class="ref-siglum" href="../register/siglen/index.xql"><xsl:apply-templates mode="#current"/></a>
    </xsl:template>
    <xsl:template mode="#all" match="tei:anchor[@type='verweisziel']">
        <a name="{@xml:id}">&#160;</a>
    </xsl:template>
    <!-- ##### Sachanmerkungen ##### -->
    <xsl:template mode="#all" match="tei:seg">
        <xsl:choose>
            <xsl:when test="$print='yes'">
                <span class="tooltip">
                    <xsl:apply-templates select="tei:orig" mode="#current"/>
                </span>
                <xsl:variable name="sanmnr">
                    <xsl:number level="any"/>
                </xsl:variable>
                <a id="fchar{$sanmnr}" href="#fnote{$sanmnr}">[<xsl:value-of select="$sanmnr"/>]</a>
            </xsl:when>
            <xsl:otherwise>
                <span class="tooltip">
                    <span class="fussnote">
                        <span class="fussnotenpfeil">&#160;</span>
                        <xsl:apply-templates select="tei:note" mode="#current"/>
                        <br/>
                        <a class="close">
                            <i class="fa fa-times-circle">&#160;</i>[Schließen]</a>
                    </span>
                    <xsl:apply-templates select="tei:orig" mode="#current"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- gesuchte Begriffe, die durch die Suchfunktion von exist markiert worden sin -->
    <xsl:template mode="#all" match="exist:match">
        <span class="highlight">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- ##### nicht auf der Website erscheinende Elemente ##### -->
    <xsl:template mode="#all" match="tei:index"/>
    <xsl:template mode="#all" match="tei:comment"/>

    <!-- Einführungstexte -->
    <xsl:template mode="comment" match="tei:head">
        <xsl:variable name="headid">
            <xsl:value-of select="count(preceding::tei:head)+1"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@type='h2'">
                <h2 id="section{$headid}">
                    <xsl:apply-templates mode="#current"/>
                </h2>
            </xsl:when>
            <xsl:when test="@type='h3'">
                <h3 id="section{$headid}">
                    <xsl:apply-templates mode="#current"/>
                </h3>
            </xsl:when>
            <xsl:when test="@type='h4'">
                <h4 id="section{$headid}">
                    <xsl:apply-templates mode="#current"/>
                </h4>
            </xsl:when>
            <xsl:otherwise>
                <p style="color: red;">
                    <xsl:apply-templates mode="#current"/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template mode="comment" match="tei:p">
        <p>
            <xsl:call-template name="paragraphNumber"/>
            <xsl:apply-templates mode="#current"/>
        </p>
    </xsl:template>
    <xsl:template name="paragraphNumber">
        <xsl:variable name="nr">
            <xsl:value-of select="count(preceding::tei:p[ancestor::tei:text and not(parent::tei:note)]) + 1"/>
        </xsl:variable>
        <span class="paragraphNumber" title="Absatznummer">
            <a name="{./@n}">
                <xsl:value-of select="$nr"/>
            </a>
        </span>
    </xsl:template>
    <xsl:template mode="comment" match="tei:p[.//tei:note[not(ancestor::tei:quote)]/@place='foot']">
        <p>
            <xsl:call-template name="paragraphNumber"/>
            <xsl:apply-templates mode="#current"/>
            <span class="footnoteContainer">
                <xsl:apply-templates select=".//tei:note[not(ancestor::tei:quote)]" mode="footnote"/>
            </span>
        </p>
    </xsl:template>
    <xsl:template mode="comment" match="tei:note[@place='foot' and matches(@xml:id, 'ftn')]">
        <span class="number">[<xsl:value-of select="@n"/>]</span>
    </xsl:template>
    <xsl:template mode="footnote" match="tei:note">
        <span class="footnote">
            <span class="number">[<xsl:value-of select="@n"/>]</span>
            <span id="{@n}" class="truncate">
                <xsl:apply-templates mode="comment"/>
            </span>
        </span>
    </xsl:template>
    <xsl:template mode="comment" match="tei:p[parent::tei:note/@place='foot']">
        <xsl:apply-templates mode="comment"/>
    </xsl:template>
    <xsl:template mode="comment" match="tei:author/tei:note">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    <xsl:template name="endnotes">
        <xsl:if test="//tei:text//tei:note">
            <div id="endnotes">
                <h3>Anmerkungen</h3>
                <ul>
                    <xsl:for-each select="//tei:text//tei:note">
                        <li id="endnote{@n}">
                            <span class="number">
                                <a href="#{@n}">[<xsl:value-of select="@n"/>]</a>
                            </span>
                            <xsl:apply-templates select="child::node()" mode="comment"/>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template mode="comment" match="tei:quote">
        <p class="{@type}">
            <xsl:apply-templates mode="#current"/>
            <xsl:if test=".//tei:note">
                <span class="footnoteContainer">
                    <xsl:apply-templates select=".//tei:note" mode="footnote"/>
                </span>
            </xsl:if>
        </p>
    </xsl:template>
    <xsl:template mode="comment" match="tei:hi[@rendition='#bold']">
        <span class="bold"><xsl:apply-templates mode="#current"/></span>
    </xsl:template>
    <xsl:template match="tei:g[@ref='#fa-file-text']" mode="comment">
        <i class="fa fa-file-text" aria-hidden="true"/>
    </xsl:template>

    <!-- Tests -->
    <xsl:template mode="kritischerText faksimileText" match="tei:anchor[@type='used']">
        <xsl:variable name="id">
            <xsl:value-of select="@xml:id"/>
        </xsl:variable>
        <xsl:variable name="lines">
            <xsl:variable name="note">
                <xsl:choose>
                    <xsl:when test="preceding::tei:note[./preceding::tei:metamark[@spanTo=concat('#', $id)]]">
                        <xsl:for-each select="preceding::tei:note[./preceding::tei:metamark[@spanTo=concat('#', $id)]]">
                            3
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        0
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="sum(count((preceding::tei:lb|preceding::tei:p)[./preceding::tei:metamark[@spanTo=concat('#', $id)]]|preceding::tei:p[.//tei:metamark[@spanTo=concat('#', $id)]]), number($note))"/>
        </xsl:variable>
        <a class="used" style="height: {$lines}em; margin-top: -{$lines}em;" title="Textpassage als erledigt markiert">
            <i class="fa fa-check">&#160;</i>
        </a>
    </xsl:template>
</xsl:stylesheet>
