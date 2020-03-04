xquery version "3.1";

module namespace app="http://www.telota.de/templates";

import module namespace templates="http://exist-db.org/xquery/templates";
import module namespace edweb="http://www.bbaw.de/telota/software/ediarum/web/lib";
import module namespace edwebcontroller="http://www.bbaw.de/telota/software/ediarum/web/controller";
import module namespace console="http://exist-db.org/xquery/console";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace functx = "http://www.functx.com";
declare namespace appconf="http://www.bbaw.de/telota/software/ediarum/web/appconf";

(:~
 : This function adds the current page/part number/id to the current node.
 : TODO: This function can be generalized as add-attribute, and merged into ediarum.web.
 :
 : @return the current node with children incl. the @id.
 :)
declare function app:add-page-id($node as node(), $model as map(*)) as node() {
    let $id := 'page'||$model?("part")
    return
        element { node-name($node) } {
            attribute id { $id },
            $node/@*[not(starts-with(name(), 'data-template'))] except $node/@id,
            for $child in $node/node() return templates:process($child, $model)
        }  
};

(:~
 : Retrieves the get-parameter page / first value of parts and save it in the model.
 : TODO: This can be generalized. So all the get-parameters are loaded into the model. And then merged into ediarum.web.
 :
 : @return Adds "part" to the model.
 :)
declare function app:load-page($node, $model) as map(*) {
    let $page := request:get-parameter("page", $model?("parts")[1])
    let $map := map{ "part": $page }
    return
        map:merge(($model, $map))
};

(:~
 : This function retrieves the ids of all parts of one type for the current document from the backend.
 : TODO: The object-type as parameter. It can be merged into ediarum.web.
 :
 : @param $part the name/type of defined part in appconf.xml
 : @return Adds "parts" to the $model.
 :)
declare (: %templates:wrap :) function app:load-parts($node as node(), $model as map(*), $part as xs:string) (: as map(*) :) {
    let $id := request:get-attribute("id")
    let $parts := map { "parts": edwebcontroller:api-get("/api/briefe/"||$id||"?output=json&amp;part="||$part)?list }
    return
        map:merge(($model, $parts))
    (: return edweb:api-get("/api/texte/"||$id||"?part="||$part||"&amp;output=json")?list :)
};

(:~
 : Templating an select option for the page.
 : TODO: Maybe merge into ediarum.web.
 :
 : @return XHTML.
 :)
declare function app:select-page($node as node(), $model as map(*)) {
    <select id="page" onchange="location = this.options[this.selectedIndex].value;">
        <option>Seite</option>
        {
            for $part in $model?parts return
                <option value="?page={$part}">{substring-after($part,'-')}</option>
        }
    </select>
};

(:~
 : This function transforms a part of the current document with a XSLT.
 : TODO: It can be split into to functions - one retrieving the xml of an part and one transforming it. Then it can be merged into ediarum.web
 :
 : @param $from the $model key for the part
 : @param $resource the relative path to the xsl
 : @returns XHTML
 :)
declare function app:transform($node as node(), $model as map(*), $from as xs:string, $resource as xs:string) as node() {
    try {
        let $id := request:get-attribute("id")
        let $node := edwebcontroller:api-get("/api/briefe/"||$id||"/"||$model?($from))
        let $view := request:get-attribute("view")
        let $xsl-resource := $resource
        (: let $object-view := edweb:transform-current($node, $model, $resource) :)
        let $path := edwebcontroller:get-exist-root()||edwebcontroller:get-exist-controller()||"/"||$xsl-resource
        let $stylesheet := if (doc($path)) then ( doc($path) ) else ( error(xs:QName("edweb:TMCT001"), $path||" not found.") )
        let $parameters :=
            <parameters>
                <param name="exist:stop-on-error" value="yes"/>
                {
                    for $param in request:get-parameter-names()
                        let $value := request:get-parameter($param, "")
                        return
                            <param name="{$param}" value="{$value}"/>
                }
            </parameters>
        let $result :=
            try {
                transform:transform($node, $stylesheet, $parameters)
            } catch * {
                error(xs:QName("edweb:TMCT002"), "Can't transform "||util:collection-name($node)||"/"||util:document-name($node)||" with "||util:document-name($path))
            }
        return templates:process($result, $model)
    } catch edweb:AIGT001 {
        <div class="alert alert-warning" role="alert">
            <h4 class="alert-heading">Kein Inhalt gefunden</h4>
            <p>Zu den angegeben Parametern existieren keine Inhalte.</p>
        </div>
    }
};

