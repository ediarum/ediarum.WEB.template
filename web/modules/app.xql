xquery version "3.1";

module namespace app="http://www.telota.de/templates";

import module namespace templates="http://exist-db.org/xquery/templates";
import module namespace edweb="http://www.bbaw.de/telota/software/ediarum/web/lib";
import module namespace console="http://exist-db.org/xquery/console";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace functx = "http://www.functx.com";
declare namespace appconf="http://www.bbaw.de/telota/software/ediarum/web/appconf";

declare function app:view-manuscripts-navbar($node as node(), $model as map(*)) as node()* {
    let $views := "index.html:Standardansicht::advanced.html:Erweiterte Ansicht"
    let $selected := edweb:get-exist-resource()
    return edweb:view-navbar($node, $model, $views, $selected)
};

declare function app:view-dokumente-navbar($node as node(), $model as map(*)) as node()* {
    let $views := "index.html:Standardansicht::advanced.html:Erweiterte Ansicht"
    let $selected := edweb:get-exist-resource()
    return edweb:view-navbar($node, $model, $views, $selected)
};

declare function app:add-js($node as node(), $model as map(*)) as node()* {
    edweb:add-js()
};

declare function app:navbar-right($node as node(), $model as map(*)) as node()* {
    let $list :=
        <list>
            <a href="$base-url/vorhaben/index.html">Vorhaben</a>
            <!--a class="search" href="/suche/index.xql">
                <span>Suche</span>
            </a-->
        </list>
    return
        edweb:navbar($list)
};

declare function app:test($node as node(), $model as map(*)) as node()* {
    if (edweb:get-project-status() eq 'test') then
        <div class="test">
            <div class="container">
            <pre>
                {
                    "Status: "||edweb:get-project-status()
                }
            </pre>
            </div>
        </div>
    else ()
};

declare function app:do-if-intern($node as node(), $model as map(*)) as node()* {
    if (edweb:get-project-status()=('intern', 'test')) then
        <div>
            {templates:process($node/node(), $model)}
        </div>
    else ()
};

declare function app:data-path($node as node(), $model as map(*)) as node()* {
    if (edweb:get-project-status() eq 'test') then
        <div class="row">
            <div class="col-md-1"/>
            <div class="col-md-7">
                <div class="intern small text-secondary">
                    Dateipfad: {substring-after(document-uri(root(edweb:get-current($model))), "/db/projects/cagb/data")}
                </div>
            </div>
        </div>
    else ()
};

declare function app:piwik($node as node(), $model as map(*)) as node()* {
    if (contains(edweb:base-url(),"cagb-db.bbaw.de")) then (
        <!-- Piwik -->,
        <script type="text/javascript" src="piwik.js"/>,
        <noscript><img src="https://piwik.bbaw.de/piwik.php?idsite=12&amp;rec=1" style="border:0" alt="" /></noscript>,
        <!-- End Piwik Code -->
        )
    else
        ()
};

declare function app:work-navbar($node as node(), $model as map(*)) as node()* {
    let $list :=
        <list>
            <a href="$base-url/aristWorks/index.html">Aristoteles</a>
            <a href="$base-url/aristComments/index.html">Aristoteles-Kommentare</a>
            <a href="$base-url/works/index.html">Andere Werke</a>
        </list>
    return
        edweb:navbar($list)
};

declare %templates:wrap function app:get-teaser($node as node(), $model as map(*)) as xs:string {
    (: if ($model("item")//tei:body//text() or $model("item")//tei:abstract//text())
    then (
        if ($model("item")//tei:abstract//text())
        then (<p class="summary">{transform:transform($model("item")//tei:abstract, doc('../resources/xslt/transcr-teaser.xsl'), ())}</p>)
        else (<p>{substring(transform:transform($model("item")//tei:body/tei:div[1]//tei:p, doc('../resources/xslt/transcr-teaser.xsl'), ()), 1, 300)} [...]</p>))
    else () :)
    let $current := edweb:get-current($model)
    return
    if ($current//tei:body//text()) then (
        substring($current//tei:text[1]/string(), 1, 300)||" [...]"
    ) else if ($current//tei:abstract//text()) then (
        substring($current//tei:abstract[1]/string(), 1, 300)||" [...]"
    )
    else ""
};

(: AN, für Testzwecke, 15.01.2019 :)
declare variable $app:deptnames := map {
"ACC": "Accessories",
"WMN": "Women's",
"MEN": "Men's"
};

(:~
 : AN, für Album, in Arbeit (seit Mai 2018)
 :
 : Generiert aus einem übergebenen Folio die Anzeige von Bild und ausgewählten Metadaten in zwei cols.
 : HTML nach gestalterischen Informationsstrukturierungsüberlegungen aufgebaut.
 : Mit Aufruf von OpenSeadragon als Viewer aus einer externen Datei (javascript).
 :
 : @param $node the node of the current request.
 : @param $model the model of the current request.
 :)
declare %templates:wrap function app:get-folios ($node as node(), $model as map(*)) as node()* {

    (:
    console:log("app:get-folios"),
    console:log($node),
    console:log(exists($model)),
    if (exists($model)) then
        console:log(map:keys($model))
    else (),
    console:log($model("item-pos")),
    console:log($model("item-pos")("id")),
    :)

(: ----- Folio-XML holen ----- :)

    let $fID := $model("item-pos")("id")
    let $fobject-type := $model("item-pos")("object-type")

    (: Folio-XML aus der übergebenen Map holen:)

    let $object := edweb:api-get-object($fobject-type, $fID)
    let $item := $object("xml")
    let $c := console:log("$item (= XML aus dem übergebenen Folio-Objekt:")
    let $c := console:log($item)

    (: Variante B für Folio-XML: per API-Request holen:

    let $currentObjectXML := edweb:api-get("/api/"||$fobject-type||"/"||$fID||"?output=xml")
    let $c := console:log("$currentObjectXML:")
    let $c := console:log($currentObjectXML)
    :)

 (: ----- Zum Folio gehörige HS holen ----- :)

    (: TODO: Wird nicht per API geholt. Ggf. für API-Abruf umschreiben.
    Frage: Wie würde ich da den Identitätsvergleich schreiben? :)
    let $hs-items := collection('/db/projects/cagb/data/Handschriften')
    let $hsIDs := $hs-items//tei:msIdentifier
    let $hs := $hs-items//tei:TEI[.//tei:msIdentifier/tei:idno = $item//ispartof/ref]

    (: Reste, aus dem Programmierstand vor dem Merge, Nov 2019
    let $fID := $item//idno
    let $refFolioToHS := $item//ispartof/ref
    let $refHStoFolio := $hs-items//tei:additional/tei:surrogates/tei:folio/tei:ref
    :)

 (: ----- Anzuzeigende Daten holen ----- :)

    let $fDesc := $item//fDesc/desc

    let $pic := $item//image

    let $hsRefID := string(root($hs)/tei:TEI/@xml:id)

    let $hsID := $hs//tei:msIdentifier
    let $hsIDcountry:= $hsID//tei:country
    let $hsIDsettlement:= $hsID//tei:settlement
    let $hsIDrepo:= $hsID//tei:repository
    let $hsIDcoll:= $hsID//tei:collection
    let $hsIDinfos:= string-join(($hsIDcountry, $hsIDsettlement, $hsIDrepo, $hsIDcoll), ", ")
    (: Folgendes würde auch gehen, aber dann ändert sich die Anzeige mit der evtl. XML-Änderungen, und ich kann die Signatur nicht zum Fett-Machen extra auslesen:
    let $hsIDinfos:= string-join(($hsID/*), ", ")
    :)

    let $hsIDidno:= string($hsID//tei:idno)

    let $origin := $hs//tei:origin
    let $suppMat := $hs//tei:p[@n="supportMaterial"]

    let $measureData := $hs//tei:extent/tei:measure[@type="leafsize"]
    let $measureHeight := $measureData/tei:dimensions/tei:height
    let $measureWidth := string($measureData/tei:dimensions/tei:width)
    let $measureUnit := $measureData/tei:dimensions/@unit

    (: Den Fall abfangen, dass Angaben zu den Maßen fehlen:)
    let $measure :=
    if ($measureHeight and $measureWidth)
        then(string-join(($measureHeight, $measureWidth), " x "))
        else()
    let $measureWithUnit :=
    if ($measure)
        then (string-join(($measure, $measureUnit), " "))
        else()
    let $matInfos := string-join(($origin, $suppMat, $measureWithUnit), ", ")

    let $surrogates := $hs//tei:surrogates/(* except tei:folio)
    let $shortDesc := $hs//tei:msContents/tei:summary
    let $picTitle := string($item//title) (: String, nicht Element:)
    let $picOrig := $pic//originator
    let $picCR := $pic//copyright
    let $picLink := string($pic//img) (:String, nicht Element. Als Viewer-Aufruf-Parameter:)
    let $fDesc := $item//fDesc/desc
    let $osID := string($fID) (:In String umgewandelte Folio-ID für Viewer-Aufbau. Achtung: Ein Folio könnte auch mehrere Digitalisate enthalten:)

    let $c := console:log("$osID:")
    let $c := console:log($osID)
    let $c := console:log("$picLink:")
    let $c := console:log($picLink)

 (: Reste vom ersten schrittweisen programmiererischen Herantasten, Jan 2019:

    let $c := console:log("map:keys($fItem) :")
    let $c := console:log(map:keys($fItem))
    let $c := console:log("$fItem:")
    let $c := console:log($fItem)
    let $c := console:log("$fItem(xml) :")
    let $c := console:log($fItem("xml"))

    let $currentObjectRaw := $model("item-pos")
    let $currentObject := edweb:load-current-object($node, $currentObjectRaw)
    let $c := console:log("$currentObjectRaw:")
    let $c := console:log($currentObjectRaw)
    let $c := console:log("$currentObject:")
    let $c := console:log($currentObject)

    :)

return

<div class="row" id="{$osID}">
  <div class="col-md-9">
  <div class="box whitebox">
    <div class="row">
         <div class="col-md-4">
           <!-- TO DO: Schönen Standard-Rundum-Abstand für die Box/Row. Besonders Abstand oben fehlt im Moment. -->
           <div>
               <div id="openseadragon_{$osID}" style="width: 250px; height: 350px;"></div>
               <script>
               createOSDviewer('openseadragon_{$osID}',{$picLink});
               </script>
           </div>

           <div style="width: 250px; height: 50px;">
                 <ul>
                    <li><b>Quelle:</b> {$picOrig}</li>
                    <li><b>Bildrechte:</b> {$picCR}</li>
                 </ul>
           </div>

        </div>

    <div class="col-md-8">

        <div>
           <h2>{$picTitle}</h2>
           <p>{$fDesc}</p>
        </div>
        <div>
            <p>{$hsIDinfos}, <b>{$hsIDidno}</b></p>
            <p>{$matInfos}</p>
        </div>

        <div>
            <p>{$shortDesc}</p>
            <p><a href="$base-url/handschriften/{$hsRefID}"> Zur Handschriftenbeschreibung</a></p>
            <!--TODO: URL per Parameter anstatt hardcodiert herstellen (Handschriftenverzeichnis anhand Objekttyp herleiten?):
            <p><a href="$baseurl/$id">Zur Handschriftenbeschreibung</a></p>-->
        </div>

        <!-- TO DO: Seitenstruktur/Layout erstellen, das fixe Box-Höhe sicherstellt.
        Falls enthaltener Text mehr ist, soll nur das angezeigt werden, was Platz hat, plus "Ausklapp"-Link o.ä.
        Dann das folgende div löschen: -->
        <div>
            <p>  .</p>
            <p>  .</p>
        </div>

    </div>
    </div>

  </div>
  </div>
  </div>

};



declare %templates:wrap function app:get-ms-label-with-filter($node as node(), $model as map(*)) as xs:string {
    let $filter-city := request:get-parameter("city", "")
    let $filter-repository := request:get-parameter("repository", "")
    let $label-city := substring-after(", "||$model("item")?("label"), $filter-city||", ")
    let $label-repository := substring-after(", "||$label-city, $filter-repository||", ")
    return $label-repository
};

declare function app:get-work-title($node as node(), $model as map(*)) as node() {
    let $title := edweb:template-get-string($node, $model, "item?label")
    let $author := substring-before($title, ", ")
    let $label := substring-after($title, ", ")
    return
        if ($author != "") then
            <span><i>{$author}, </i>{$label}</span>
        else
            <span>{$title}</span>
};

declare function app:template-link-to-prev-object($node as node(), $model as map(*)) {
    let $labelled-ids := $model?labelled[?label-pos=1]?id
    let $position := index-of( $labelled-ids, $model?id )
    return
        if ($labelled-ids[$position -1]) then
            <a href="$id/{$labelled-ids[$position -1]}" class="nav-link"><i class="fa fa-arrow-left"></i></a>
        else
            ()
};

declare function app:template-link-to-next-object($node as node(), $model as map(*)) {
    let $labelled-ids := $model?labelled[?label-pos=1]?id
    let $position := index-of( $labelled-ids, $model?id )
    return
        if ($labelled-ids[$position +1]) then
            <a href="$id/{$labelled-ids[$position +1]}" class="nav-link"><i class="fa fa-arrow-right"></i></a>
        else
            ()
};

declare function app:template-breadcrumb-items ($node as node(), $model as map(*), $filter as xs:string) {
    let $object-type := request:get-attribute("object-type")
    let $object-id := $model?id
    let $object-type-label := edweb:get-config-xml()//appconf:object[@xml:id = $object-type]/appconf:name
    let $breadcrumb-items := 
        for $f in tokenize($filter, " ")
            let $filter-values := $model?all[?id = $object-id]?filter?($f)
            let $filter-depends := edweb:get-config-xml()//appconf:object[@xml:id = $object-type]//appconf:filter[@xml:id= $f]/@depends/string()
            let $other-filter := for $f in tokenize($filter-depends, " ") return $f||"="||$model?all[?id = $object-id]?filter?($f)
            let $filter-value := if ($filter-values instance of array(*)) then
                    $filter-values?*[1]
                else $filter-values
            let $href := string-join(($other-filter, $f||"="||$filter-value), "&amp;")
            return
                if ($filter-value) then
                    <li class="breadcrumb-item">
                        <a href="$base-url/{$object-type}/index.html?{$href}">{$filter-value}</a>
                    </li>
                else ()

    let $c := console:log($model?all)
    return
        <ol class="breadcrumb p-0 m-0 mr-auto">
            <li class="breadcrumb-item">
                <a href="$base-url/{$object-type}/index.html">{$object-type-label}</a>
            </li>
            { $breadcrumb-items }
        </ol>
};

declare function functx:sort ($seq as item()*) as item()* {
    for $item in $seq
        order by $item
        return $item
};

declare %templates:wrap function app:load-relation-for-subject-filter($node as node(), $model as map(*), $relation as xs:string) as map(*) {
    let $object-type := request:get-attribute("object-type")
    let $relations := distinct-values(edweb:api-get("/api/roles")?list?*?predicate)
    (: let $predicates := $relations :)
    let $c:= console:log("development", "load-relation-for-subject-filter")
    let $c:= console:log("development", $relations)
    let $filter-name := "relation-"||$relation
    let $filter := map:new((
        map:entry("depends", ()),
        map:entry("name", $filter-name),
        map:entry("n", 0),
        map:entry("label-function", "function($string) { $string }"),
        map:entry("type", "union"),
        map:entry("xpath", ())
    ))
    let $filter-type := "union"
    let $map-entries :=
        for $filter in $model?("filters")?*
            return
                if (contains(" "||$filter("depends")||" ", " "||$filter-name||" ")) then
                    map:entry($filter?("id"), "")
                else ()
    let $labels :=
        for $l in $relations
            let $this-label := $l
            let $add-label := 
                string-join(
                    distinct-values((
                        tokenize(
                            $model("params")($filter-name), 
                            edweb:get-param-separator()
                        ),
                        $l                        
                    )),
                    edweb:get-param-separator()
                )
            let $remove-label := string-join(distinct-values(tokenize($model("params")($filter-name), edweb:get-param-separator())[not(.=$l)]), edweb:get-param-separator())
            let $selected := ""
            let $count-select := 1
            let $filter-params := 
                let $type := $filter-type return
                if ($type eq "single" or $type eq "greater-than" or $type eq "lower-than") then
                    edweb:get-params($model("params"),map:new((map:entry($filter-name, $this-label), $map-entries)))
                else if ($selected) then
                    edweb:get-params($model("params"),map:new((map:entry($filter-name, $remove-label),$map-entries)))
                else
                    edweb:get-params($model("params"),map:new((map:entry($filter-name, $add-label),$map-entries)))
            order by $l return
                map:new((
                        map:entry("label", $l),
                        map:entry("selected", $selected),
                        map:entry("count-select", $count-select),
                        map:entry("href", request:get-uri()||"?"||$filter-params)
                    ))
    let $add-map := map:new((
        map:entry("filter", $filter),
        map:entry("filter-items", ($labels))
    ))
    return
        map:merge(($model, $add-map))
};
declare function app:template-incipit-link($node as node(), $model as map(*), $from as xs:string) as node() {
    let $object-type := $model?($from)?("filter")?("work-type")
    let $id := $model?($from)?("id")
    return
        <a href="{edweb:base-uri()}/{$object-type}/{$id}">
            {templates:process($node/node(), $model)}
        </a>
};

declare function app:template-incipit-title($node as node(), $model as map(*)) as node() {
    let $title := edweb:template-get-string($node, $model, "item?label")
    let $author := substring-before($title, ", ")
    let $label := substring-after($title, ", ")
    let $title := substring-before($label, ": ")
    let $incipit := substring-after($label, ": ")
    return
        if ($author != "" and $title != "") then
            <span><i>{$author}, </i>{$title}: <br/> {$incipit}</span>
        else if ($author != "") then
            <span><i>{$author}, </i>: <br/> {$incipit}</span>
        else
            <span>{$title} <br/> {$incipit}</span>
};
