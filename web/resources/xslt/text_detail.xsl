<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:edweb="http://www.bbaw.de/telota/software/ediarum/edweb/lib" exclude-result-prefixes="xs" version="3.0">

    <xsl:variable name="root" select="/tei:TEI"/>

    <xsl:variable name="labels">
        <scholion-subtype>
            exegetisch => exeg.
            lexikalisch => lex.
            grammatikalisch => gramm.
        </scholion-subtype>
    </xsl:variable>

    <xsl:function name="functx:escape-for-regex" as="xs:string">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence select="replace($arg,'(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')"/>
    </xsl:function>

    <xsl:function name="functx:substring-after-last" as="xs:string">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="delim" as="xs:string"/>
        <xsl:sequence select="replace($arg,concat('^.*',functx:escape-for-regex($delim)),'')"/>
    </xsl:function>

    <xsl:function name="edweb:create-app-crit">
        <xsl:param name="node" as="node()"/>
        <xsl:param name="xsl"/>
        <div class="app-crit-item">
            <xsl:attribute name="id" select="concat('app_',$node/generate-id())"/>
            <a class="app-item-link" href="{concat('#a_',$node/generate-id())}">
                <xsl:sequence select="$xsl"/>
            </a>
            <a class="app-item-x" href="{concat('#x_',$node/generate-id())}">⨯</a>
            <a class="app-item-show" href="{concat('#x_',$node/generate-id())}">+</a>
        </div>
        <xsl:apply-templates select="$node/element()" mode="create-app-crit"/>
    </xsl:function>

    <xsl:function name="edweb:create-app-font">
        <xsl:param name="node" as="node()"/>
        <xsl:param name="xsl"/>
        <div class="app-font-item">
            <xsl:attribute name="id" select="concat('app_',$node/generate-id())"/>
            <a class="app-item-link" href="{concat('#a_',$node/generate-id())}">
                <xsl:value-of select="edweb:short-text($node)"/>
                <xsl:text>] </xsl:text>
                <xsl:sequence select="$xsl"/>
            </a>
        </div>
        <xsl:apply-templates select="$node/element()" mode="create-app-font"/>
    </xsl:function>

    <xsl:function name="edweb:create-rdg">
        <xsl:param name="rdg" as="node()"/>
        <xsl:apply-templates select="$rdg"/>
        <i>
            <xsl:for-each select="$rdg/@wit/tokenize(.,' ')">
                <xsl:text> </xsl:text>
                <span class="sigle">
                    <span class="sigle-text"><xsl:value-of select="edweb:get-sigle(.)"/></span>&#160;
                    <span class="sigle-info">
                        <xsl:value-of select="edweb:get-title(.)"/>
                    </span>
                </span>
            </xsl:for-each>
        </i>
    </xsl:function>

    <xsl:function name="edweb:create-text-crit">
        <xsl:param name="node" as="node()"/>
        <xsl:param name="xsl"/>
        <span class="text-crit-item">
            <xsl:attribute name="id" select="concat('text_',$node/generate-id())"/>
            <span class="text-item-target" id="{concat('a_',$node/generate-id())}"/>
            <xsl:sequence select="$xsl"/>
        </span>
    </xsl:function>

    <xsl:function name="edweb:create-text-font">
        <xsl:param name="node" as="node()"/>
        <xsl:param name="xsl"/>
        <span class="text-font-item quote">
            <xsl:attribute name="id" select="concat('text_',$node/generate-id())"/>
            <span class="text-item-target" id="{concat('a_',$node/generate-id())}"/>
            <span class="text-font-svg" id="{concat('cb_',$node/generate-id())}">
                <svg height="130" width="5">
                    <!--                    <line x1="1" y1="1" x2="1" y2="199"  style="stroke:#006600;"/>-->
                </svg>
            </span>
            <xsl:sequence select="$xsl"/>
            <span class="text-font-svg-end" id="{concat('ce_',$node/generate-id())}"/>
        </span>
    </xsl:function>

    <xsl:function name="edweb:get-label-for">
        <xsl:param name="data-type"/>
        <xsl:param name="data-string"/>
        <xsl:for-each select="$labels/*[name() = $data-type]/tokenize(., '\n')">
            <xsl:if test="contains(., '=>')">
                <xsl:variable name="find">
                    <xsl:value-of select="normalize-space(substring-before(., '=>'))"/>
                </xsl:variable>
                <xsl:if test="contains($data-string, $find)">
                    <xsl:variable name="replace">
                        <xsl:value-of select="normalize-space(substring-after(., '=>'))"/>
                    </xsl:variable>
                    <xsl:value-of select="normalize-space(replace($data-string, $find, $replace))"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="edweb:get-sigle">
        <xsl:param name="witness-id"/>
        <xsl:choose>
            <xsl:when test="starts-with($witness-id, 'cRef:')">
                <xsl:value-of select="substring-after($witness-id, 'cRef:')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$root//tei:witness[@xml:id = substring($witness-id,2)]/tei:idno[@type='sigle']"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="edweb:get-title">
        <xsl:param name="witness-id"/>
        <xsl:value-of select="$root//tei:witness[@xml:id = substring($witness-id,2)]/tei:title"/>
    </xsl:function>

    <xsl:function name="edweb:place-in-latin">
        <xsl:param name="place" as="xs:string"/>
        <xsl:variable name="transl" select="('superlinear', 'supra lin.', 'sublinear', 'sub lin.', 'intralinear', 'intra lin.')"/>
        <xsl:value-of select="$transl[index-of($transl, $place)+1]"/>
    </xsl:function>

    <xsl:function name="edweb:short-text">
        <xsl:param name="node"/>
        <xsl:variable name="text">
            <xsl:apply-templates select="$node"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string-length($text) &gt; 20">
                <xsl:value-of select="substring-before(normalize-space($text),' ')"/>
                <xsl:text> — </xsl:text>
                <xsl:value-of select="functx:substring-after-last(normalize-space($text),' ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="edweb:create-row">
        <xsl:param name="col-1"/>
        <xsl:sequence select="edweb:create-row($col-1, '', '', '')"/>
    </xsl:function>

    <xsl:function name="edweb:create-row">
        <xsl:param name="col-1"/>
        <xsl:param name="col-2"/>
        <xsl:param name="col-3"/>
        <xsl:sequence select="edweb:create-row($col-1, $col-2, $col-3, '')"/>
    </xsl:function>

    <xsl:function name="edweb:create-row">
        <xsl:param name="col-1"/>
        <xsl:param name="col-2"/>
        <xsl:param name="col-3"/>
        <xsl:param name="margin-1"/>
        <div class="row content-row">
            <div class="hidden-xs col-sm-2 col-md-1 content-col-margin">
                <xsl:sequence select="$margin-1"/>
            </div>
            <div class="col-xs-12 col-sm-10 col-md-7 content-col-text pt-3">
                <div class="content-col-text-inner">
                    <xsl:sequence select="$col-1"/>
                </div>
            </div>
            <div class="hidden-xs hidden-sm col-md-2 content-col-app-crit">
                <div class="app-crit-sticky">
                    <xsl:sequence select="$col-2"/>
                </div>
            </div>
            <div class="hidden-xs hidden-sm col-md-2 content-col-app-font">
                <div class="app-crit-sticky">
                    <xsl:sequence select="$col-3"/>
                </div>
            </div>
        </div>
    </xsl:function>

    <xsl:template match="/">
        <div class="body">
            <link rel="stylesheet" href="$base-url/resources/css/text-detail.css"/>
            <script type="text/javascript">
                function setActive(id) {
                    if ( id.startsWith("app_")) {
                    var appid = id.substr(4);
                        $( "#text_"+appid ).addClass('is-active');
                        $( "#cb_"+appid ).addClass('is-active');
                    }
                    if ( id.startsWith("text_")) {
                        var appid = id.substr(5);
                        $( "#app_"+appid ).addClass('is-active');
                        $( "#cb_"+appid ).addClass('is-active');
                    }
                }

                var permanentActive = false;

                function setThisActive($element) {
                    // If one item is permanent selected, forget about it.
                    if (permanentActive) return;
                    //If this item is already selected, forget about it.
                    if ($element.hasClass('is-active')) return;

                    //Find the currently selected item, and remove the style class
                    $('.is-active').removeClass('is-active');

                    //Add the style class to this item
                    $element.addClass('is-active');

                    var id = $element.attr('id');
                    setActive(id);
                }
                function setThisTextActive($element) {
                    // If one item is permanent selected, forget about it.
                    if (permanentActive) return;
                    //If this item is already selected, forget about it.
                    if ($element.hasClass('is-active')) return;

                    //Find the currently selected item, and remove the style class
                    $('.is-active').not($element.parents().add($element.find("*"))).removeClass('is-active');

                    //Add the style class to this item
                    $element.addClass('is-active');

                    $('.text-crit-item.is-active, .text-font-item.is-active').each(function(){
                        var id = $element.attr('id');
                        setActive(id);
                    });
                }

                $(function() {
                    $('.text-crit-item, .text-font-item').mouseleave(function(){
                        // If one item is permanent selected, forget about it.
                        if (permanentActive) return;
                        $(this).removeClass('is-active');
                        $('.is-active').not($(this).parents()).removeClass('is-active');
                        $('.text-crit-item.is-active, .text-font-item.is-active').each(function(){
                            var id = $(this).attr('id');
                            setActive(id);
                        });
                    });
                    $('.text-crit-item, .text-font-item').mouseover(function(){
                        setThisTextActive($(this));
                    });
                    $('.app-crit-item, .app-font-item').mouseleave(function(){
                        // If one item is permanent selected, forget about it.
                        if (permanentActive) return;
                        //Find the currently selected item, and remove the style class
                        $('.is-active').removeClass('is-active');
                    });
                    $('.app-crit-item, .app-font-item').mouseover(function(){
                        setThisActive($(this));
                    });
                    $("a.app-item-link").click(function() {
                        var href=$(this).attr("href");
                        // Animate scroll to anchor tag with offset
                        $('html').animate({ scrollTop: $(href).offset().top - 135 }, 400);
                        if (permanentActive &amp;&amp; $(this).parent().hasClass('is-active')) {
                            permanentActive=false;
                        } else {
                            permanentActive=false;
                            setThisActive($(this).parent());
                            permanentActive=true;
                        };
                    });
                    $(".text-crit-item").click(function() {
                        var id="#a_"+$(this).attr("id").substr(5);
                        $('html').animate({ scrollTop: $(id).offset().top }, 800);
                        if (permanentActive &amp;&amp; $(this).hasClass('is-active')) {
                            permanentActive=false;
                        } else {
                            permanentActive=false;
                            setThisTextActive($(this));
                            permanentActive=true;
                            var id="app_"+$(this).attr("id").substr(5);
                            $("div.app-crit-item[id='"+id+"']").removeClass("hide-item");
                            var textid = "text_"+$(this).attr("id").substr(5);
                            $("span.text-crit-item[id='"+textid+"']").removeClass("hide-app");
                        };
                    });
                    $("a.app-item-x").click(function() {
                        var id="app_"+$(this).attr("href").substr(3);
                        $("div.app-crit-item[id='"+id+"']").toggleClass("hide-item");
                        var textid = "text_"+$(this).attr("href").substr(3);
                        $("span.text-crit-item[id='"+textid+"']").toggleClass("hide-app");
                    });
                    $("a.app-item-show").click(function() {
                        var id="app_"+$(this).attr("href").substr(3);
                        $("div.app-crit-item[id='"+id+"']").toggleClass("hide-item");
                        var textid = "text_"+$(this).attr("href").substr(3);
                        $("span.text-crit-item[id='"+textid+"']").toggleClass("hide-app");
                    });
                    $(".text-font-svg").each(function(i) {
                        var id1 = $(this).attr("id").substr(3);
                        var top1 = $(this).offset().top;
                        var quote_end = $("#ce_"+id1);
                        var top2 = quote_end.offset().top+quote_end.height();
                        var svg=$(this).find("svg");
                        svg.attr("height", top2-top1);
                    });
                });

                //            $(function() {
                //            var c=document.getElementById("canvas");
                //            var ctx=canvas.getContext("2d");
                //            canvas.width=25;
                //            canvas.height=window.innerHeight;
                //
                //            var $canvas=$("#canvas");
                //            var canvasOffset=$canvas.offset();
                //            var offsetX=canvasOffset.left;
                //            var offsetY=canvasOffset.top;
                //
                //
                //            var quote1 = $(".quote-begin").eq(0);
                //            var top1 = quote1.offset().top;
                //            var quote2 = $(".quote-begin").eq(1);
                //            var top2 = quote2.offset().top+quote2.height();
                //
                //            ctx.moveTo(0,top1-offsetY);
                //            ctx.lineTo(0,top2-offsetY+5);
                //            ctx.stroke();
                //            });
            </script>
            <xsl:apply-templates select="//tei:text"/>
        </div>
    </xsl:template>

    <xsl:template match="tei:text">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:body">
        <xsl:variable name="col-1">
            <ul data-template="edweb:view-list" class="nav nav-tabs"/>
        </xsl:variable>
        <div class="container" style="">
            <xsl:sequence select="edweb:create-row($col-1)"/>
        </div>
        <xsl:variable name="col-1">
        </xsl:variable>
        <xsl:variable name="col-2">
            <div class="app-head">App. crit.</div>
        </xsl:variable>
        <xsl:variable name="col-3">
            <div class="app-head">App. font.</div>
        </xsl:variable>
        <div class="container 1content-table content-table-head" style="">
            <xsl:sequence select="edweb:create-row($col-1,$col-2,$col-3)"/>
        </div>
        <div class="container">
            <xsl:apply-templates/>
        </div>
    </xsl:template>


    <xsl:template match="tei:div[@type='scholia_group']">
        <div class="scholien">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:div[@type eq 'scholion']">
        <xsl:variable name="position" select="count(preceding::tei:div)"/>
        <div class="scholion">
            <xsl:variable name="col-1">
                <div class="hr"/>
            </xsl:variable>
            <xsl:variable name="col-2">
                <xsl:apply-templates select="tei:quote/element()" mode="create-app-crit"/>
            </xsl:variable>
            <xsl:variable name="col-3">
                <xsl:apply-templates select="tei:quote/element()" mode="create-app-font"/>
            </xsl:variable>
            <xsl:variable name="margin-1">
                <div class="blue">
                    <xsl:apply-templates select="@n"/>
                    <xsl:if test="@subtype">
                        <xsl:text> (</xsl:text><xsl:value-of select="edweb:get-label-for('scholion-subtype', @subtype)"/><xsl:text>)</xsl:text>
                    </xsl:if>
                </div>
            </xsl:variable>
            <xsl:sequence select="edweb:create-row($col-1, $col-2, $col-3, $margin-1)"/>
            <!-- Einleitung -->
            <xsl:apply-templates select="tei:note[@type eq 'editorial' and @subtype='introduction']"/>
            <!-- Text -->
            <xsl:apply-templates select="*[not(self::tei:note) and not(self::tei:div[@type='scholia_group'])]"/>
            <!-- Textzeugen -->
            <div class="scholion-metadata">
                <div class="scholion-metadata">
                    <xsl:variable name="col-1">
                    <div role="tab" id="headingScholionMetadata{$position}" class="editorial small">
                        <h2>
                            <a class="button collapsed" role="button" data-toggle="collapse" href="#collapseScholionMetadata{$position}" aria-expanded="true" aria-controls="collapseScholionMetadata{$position}">
                                <span>Informationen zum Scholion </span>
                                <i class="fa fa-angle-down collapse-icon-close"/>
                                <i class="fa fa-angle-up collapse-icon-open"/>
                            </a>
                        </h2>
                    </div>
                    </xsl:variable>
                    <xsl:sequence select="edweb:create-row($col-1)"/>
                    <div id="collapseScholionMetadata{$position}" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingScholionMetadata{$position}">
                        <xsl:apply-templates select="tei:note[@type eq 'editorial' and @subtype='witness']"/>
                        <!-- Gedruckter Quellen -->
                        <xsl:apply-templates select="tei:note[@type eq 'editorial' and @subtype='sources']"/>
                        <!-- Personen (Autor, Schreiber, genannt) -->
                        <xsl:apply-templates select="tei:note[@type eq 'editorial' and @subtype='persons'][(.//tei:persName/@role) = 'author']" mode="author"/>
                        <!-- Kommentar -->
                        <xsl:apply-templates select="tei:note[@type eq 'editorial' and @subtype='comment']"/>
                        <!-- Bibliographie -->
                        <xsl:apply-templates select="tei:note[@type eq 'editorial' and @subtype='bibliography']"/>
                        <!-- Bearbeiter -->
                        <xsl:apply-templates select="tei:note[@type eq 'editorial' and @subtype='persons'][(.//tei:persName/@role) = 'editor']" mode="editor"/>
                        <!-- Subscholia -->
                        <xsl:apply-templates select="tei:div[@type='scholia_group']"/>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:note[@type eq 'editorial' and @subtype='persons']" mode="author" priority="50">
        <xsl:variable name="col-1">
            <div class="editorial">
                <h3>Personen</h3>
                <xsl:for-each select="tei:persName[@role eq 'author']">
                    <xsl:choose>
                        <xsl:when test="@role eq 'author'">
                            <p>
                                <xsl:apply-templates select="."/>
                                <xsl:text> (Autor)</xsl:text>
                            </p>
                        </xsl:when>
                        <xsl:when test="@role eq 'writer'">
                            <p>
                                <xsl:apply-templates select="."/>
                                <xsl:text> (Schreiber)</xsl:text>
                            </p>
                        </xsl:when>
                        <xsl:when test="@role eq 'redactor'">
                            <p>
                                <xsl:apply-templates select="."/>
                                <xsl:text> (Redaktor)</xsl:text>
                            </p>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </div>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1)"/>
    </xsl:template>

    <xsl:template match="tei:note[@type eq 'editorial' and @subtype='persons'][(.//tei:persName/@role) eq 'editor']" mode="editor" priority="50">
        <xsl:variable name="col-1">
            <div class="editorial">
                <h3>Bearbeiter</h3>
                <xsl:for-each select="tei:persName[@role eq 'editor']">
                    <p>
                        <xsl:apply-templates select="."/>
                    </p>
                </xsl:for-each>
            </div>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1)"/>
    </xsl:template>

    <xsl:template match="tei:note[@type eq 'editorial' and @subtype='witness']" priority="50">
        <xsl:variable name="col-1">
            <div class="editorial">
                <h3>Textzeugen</h3>
                <xsl:for-each select="tei:witDetail">
                    <p>
                        <xsl:value-of select="edweb:get-title(@wit)"/>
                        <xsl:if test="@n">
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="@n"/>
                        </xsl:if>
                        <xsl:if test="@place">
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="@place"/>
                        </xsl:if>
                        <xsl:text> (</xsl:text>
                        <a href="{@wit}">
                            <xsl:value-of select="edweb:get-sigle(@wit)"/>
                        </a>
                        <xsl:text>)</xsl:text>
                    </p>
                </xsl:for-each>
            </div>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1)"/>
    </xsl:template>

    <xsl:template match="tei:note[@type eq 'editorial' and @subtype='sources']" priority="50">
        <xsl:variable name="col-1">
            <div class="editorial">
                <h3>Gedruckte Quellen</h3>
                <xsl:for-each select="tei:witDetail">
                    <p>
                        <xsl:value-of select="edweb:get-title(@wit)"/>
                        <xsl:if test="@n">
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="@n"/>
                        </xsl:if>
                        <xsl:if test="@place">
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="@place"/>
                        </xsl:if>
                        <xsl:text> (</xsl:text>
                        <a href="{@wit}">
                            <xsl:value-of select="edweb:get-sigle(@wit)"/>
                        </a>
                        <xsl:text>)</xsl:text>
                    </p>
                </xsl:for-each>
            </div>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1)"/>
    </xsl:template>

    <xsl:template match="tei:note[@type eq 'editorial' and @subtype='introduction']" priority="50">
        <xsl:variable name="col-1">
            <div class="editorial">
                <h2 class="editorial">Einleitung</h2>
            </div>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1)"/>
        <xsl:apply-templates mode="editorial"/>
        <xsl:variable name="col-1">
            <div class="hr"/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1)"/>
    </xsl:template>

    <xsl:template match="tei:note[@type eq 'editorial' and @subtype='translation']" priority="50">
        <xsl:variable name="col-1">
            <div class="editorial">
                <h2 class="editorial">Übersetzung</h2>
            </div>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1)"/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:note[@type eq 'editorial' and @subtype='comment']" priority="50">
        <xsl:variable name="col-1">
            <div class="editorial">
                <xsl:if test="not(parent::tei:note)">
                    <h2>Anmerkungen</h2>
                </xsl:if>
            </div>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1)"/>
        <xsl:apply-templates mode="editorial"/>
    </xsl:template>

    <xsl:template match="tei:note[@type eq 'editorial' and @subtype='bibliography']" priority="50">
        <xsl:variable name="col-1">
            <div class="editorial">
                <h3>Bibliographie</h3>
                <xsl:apply-templates/>
            </div>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1)"/>
    </xsl:template>

    <xsl:template match="tei:figure">
        <xsl:variable name="col-1">
            <img class="full-img" src="$image-url/{@facs}">
            </img>
        </xsl:variable>
        <xsl:variable name="col-3">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1, '', $col-3)"/>
    </xsl:template>

    <xsl:template match="tei:figDesc">
        <div class="app-font-item">
            <i>
                <xsl:value-of select="."/>
            </i>
        </div>
    </xsl:template>

    <xsl:template match="tei:div[@type='book']">
<!--        <div class="book">-->
            <xsl:apply-templates/>
            <xsl:variable name="col-1">
                <div class="hr"/>
            </xsl:variable>
            <xsl:sequence select="edweb:create-row($col-1)"/>
        <!--</div>-->
    </xsl:template>

    <xsl:template match="tei:div[@type='chapter']">
<!--        <div class="book">-->
            <xsl:apply-templates/>
            <xsl:variable name="col-1">
                <div class="hr"/>
            </xsl:variable>
            <xsl:sequence select="edweb:create-row($col-1)"/>
        <!--</div>-->
    </xsl:template>

    <xsl:template match="tei:head">
        <xsl:variable name="col-1">
            <h3>
                <xsl:apply-templates/>
            </h3>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1)"/>
    </xsl:template>

    <xsl:template match="tei:div[@type='section']">
<!--        <div class="section">-->
            <xsl:apply-templates/>
        <!--</div>-->
    </xsl:template>

    <xsl:template match="tei:cit[@type eq 'lemma']">
        <xsl:variable name="col-1">
            <p class="lemma margin-top-1">
                <xsl:choose>
                    <xsl:when test="@subtype eq 'rekonstruiert'">
                        <xsl:text>〈</xsl:text>
                        <xsl:apply-templates select="tei:quote/node()"/>
                        <xsl:text>〉</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="tei:quote/node()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </p>
        </xsl:variable>
        <xsl:variable name="col-2">
            <xsl:apply-templates select="tei:quote/element()" mode="create-app-crit"/>
        </xsl:variable>
        <xsl:variable name="col-3">
            <xsl:apply-templates select="tei:quote/element()" mode="create-app-font"/>
        </xsl:variable>
        <xsl:variable name="margin-1">
            <div class="margin-top-1">
                <span class="blue small">
                    <xsl:apply-templates select="tei:ref/@cRef"/>
                </span>
            </div>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1, $col-2, $col-3, $margin-1)"/>
    </xsl:template>

    <xsl:template match="tei:p">
        <xsl:variable name="col-1">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:variable name="col-2">
            <xsl:apply-templates select="*" mode="create-app-crit"/>
        </xsl:variable>
        <xsl:variable name="col-3">
            <xsl:apply-templates select="*" mode="create-app-font"/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1, $col-2, $col-3)"/>
    </xsl:template>

    <xsl:template match="tei:p" mode="editorial">
        <xsl:variable name="col-1">
            <div class="editorial">
                <xsl:apply-templates/>
            </div>
        </xsl:variable>
        <xsl:variable name="col-2">
            <xsl:apply-templates select="*" mode="create-app-crit"/>
        </xsl:variable>
        <xsl:variable name="col-3">
            <xsl:apply-templates select="*" mode="create-app-font"/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-row($col-1, $col-2, $col-3)"/>
    </xsl:template>

    <xsl:template match="tei:abbr">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:add">
        <xsl:variable name="xsl">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-text-crit(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:add" mode="create-app-crit">
        <xsl:variable name="xsl">
            <i>
                <xsl:value-of select="edweb:place-in-latin(@place)"/>
            </i>
        </xsl:variable>
        <xsl:sequence select="edweb:create-app-crit(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:app">
        <xsl:variable name="xsl">
            <xsl:choose>
                <xsl:when test="tei:lem">
                    <xsl:apply-templates select="tei:lem"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="tei:rdg[1]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="edweb:create-text-crit(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:app" mode="create-app-crit">
        <xsl:variable name="xsl">
            <xsl:choose>
                <xsl:when test="tei:lem">
                    <!--                    <xsl:value-of select="edweb:short-text(tei:lem)"/>-->
                    <!--                    <xsl:text>] </xsl:text>-->
                    <xsl:sequence select="edweb:create-rdg(tei:rdg[1])"/>
                    <xsl:for-each select="tei:rdg[position()&gt;1]">
                        <xsl:text> : </xsl:text>
                        <xsl:sequence select="edweb:create-rdg(.)"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="edweb:create-rdg(tei:rdg[1])"/>
                    <xsl:for-each select="tei:rdg[position()&gt;1]">
                        <xsl:text> : </xsl:text>
                        <xsl:sequence select="edweb:create-rdg(.)"/>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="edweb:create-app-crit(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:choice">
        <xsl:variable name="xsl">
            <xsl:apply-templates select="tei:abbr"/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-text-crit(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:choice" mode="create-app-crit">
        <xsl:variable name="xsl">
            <xsl:apply-templates select="tei:expan"/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-app-crit(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:ex">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>

    <xsl:template match="tei:expan">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:g[@ref='#typoHyphen']">
        <xsl:text>-</xsl:text>
    </xsl:template>

    <xsl:template match="tei:gap">
        <span class="illegible">
            <xsl:for-each select="1 to @quantity">
                <span class="illegible-block"/>
            </xsl:for-each>
        </span>
    </xsl:template>

    <xsl:template match="tei:hi[@rendition eq '#sup']">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <xsl:template match="tei:hi[@rendition eq '#red']">
        <span class="hi_red">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:hi[@rendition eq '#u']">
        <span class="underline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:lb">
        <span class="gray"> | </span>
    </xsl:template>

    <xsl:template match="tei:lem">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:list[@type='ordered']">
        <ol>
            <xsl:for-each select="tei:item">
                <li>
                    <xsl:apply-templates/>
                </li>
            </xsl:for-each>
        </ol>
    </xsl:template>

    <xsl:template match="tei:note">
        <span>
            <xsl:text>*</xsl:text>
            <div class="note">
                <xsl:apply-templates/>
            </div>
        </span>
    </xsl:template>

    <xsl:template match="tei:note[parent::tei:rdg]">
        <xsl:text> </xsl:text>
        <i>
            <xsl:apply-templates/>
        </i>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="tei:note[@type='number']">
        <div class="content-row">
            <div class="margin-right blue">
                <xsl:text> (</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>)</xsl:text>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:note[@type='editorial']">
        <span class="editorial">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:orig">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:persName">
        <xsl:choose>
            <xsl:when test="@key">
                <a href="$base-url/{@key}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:pb">
        <span class="gray">|<sup>
                <xsl:value-of select="@n"/>
            </sup>
        </span>
    </xsl:template>

    <xsl:template match="tei:quote">
        <xsl:variable name="xsl">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-text-font(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:quote" mode="create-app-font">
        <xsl:variable name="xsl">
            <xsl:choose>
                <xsl:when test="@type eq 'Zitation'">=</xsl:when>
                <xsl:when test="@type eq 'Simile'">≈</xsl:when>
                <xsl:when test="@type eq 'Paraphrasis'">~</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@type"/>
                </xsl:otherwise>
            </xsl:choose>
            <i class="sigle">
                <span class="sigle-text"><xsl:value-of select="edweb:get-sigle(@source)"/></span>&#160;
                <span class="sigle-info">
                    <xsl:value-of select="edweb:get-title(@source)"/>
                </span>
            </i>
            <xsl:text> </xsl:text>
            <xsl:value-of select="@corresp"/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-app-font(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:rdg">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:ref">
        <a>
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="tei:seg[@subtype='apparatus_criticus']">
        <xsl:variable name="xsl">
            <xsl:apply-templates select="tei:orig"/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-text-crit(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:seg[@subtype='apparatus_criticus']" mode="create-app-crit">
        <xsl:variable name="xsl">
            <xsl:apply-templates select="tei:note"/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-app-crit(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:seg[@subtype='apparatus_fontium']">
        <xsl:variable name="xsl">
            <xsl:apply-templates select="tei:orig"/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-text-font(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:seg[@subtype='apparatus_fontium']" mode="create-app-font">
        <xsl:variable name="xsl">
            <xsl:apply-templates select="tei:note"/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-app-font(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:subst">
        <xsl:variable name="xsl">
            <xsl:apply-templates select="tei:add/node()"/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-text-crit(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:subst" mode="create-app-crit">
        <xsl:variable name="xsl">
            <xsl:apply-templates select="tei:add/node()"/>
            <i> ex </i>
            <xsl:apply-templates select="tei:del/node()"/>
            <i> corr.</i>
        </xsl:variable>
        <xsl:sequence select="edweb:create-app-crit(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template match="tei:supplied[@cert='high']">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>

    <xsl:template match="tei:unclear">
        <xsl:variable name="xsl">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:sequence select="edweb:create-text-crit(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="tei:unclear" mode="create-app-crit">
        <xsl:variable name="xsl">
            <i>
                <xsl:choose>
                    <xsl:when test="@reason='illegible' and @cert='high'">
                        <xsl:text>ut vid. (vix legitur)</xsl:text>
                    </xsl:when>
                    <xsl:when test="@reason='illegible' and @cert='low'">
                        <xsl:text>fort. (vix legitur)</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@reason"/>
                        <xsl:text> (cert: </xsl:text>
                        <xsl:value-of select="@cert"/>
                        <xsl:text>)</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </i>
        </xsl:variable>
        <xsl:sequence select="edweb:create-app-crit(.,$xsl)"/>
    </xsl:template>

    <xsl:template match="element()">
        <span class="unbearbeitet">
            <xsl:text>&lt;</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:for-each select="@*">
                <xsl:text> </xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>="</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
            </xsl:for-each>
            <xsl:text>&gt;</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="element()" mode="create-app-crit">
        <xsl:apply-templates select="element()" mode="create-app-crit"/>
    </xsl:template>

    <xsl:template match="element()" mode="create-app-font">
        <xsl:apply-templates select="element()" mode="create-app-font"/>
    </xsl:template>

</xsl:stylesheet>
