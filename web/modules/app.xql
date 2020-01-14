xquery version "3.1";

module namespace app="http://www.telota.de/templates";

import module namespace templates="http://exist-db.org/xquery/templates";
import module namespace edweb="http://www.bbaw.de/telota/software/ediarum/web/lib";
import module namespace console="http://exist-db.org/xquery/console";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace functx = "http://www.functx.com";
declare namespace appconf="http://www.bbaw.de/telota/software/ediarum/web/appconf";

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
                    Dateipfad: {substring-after(document-uri(root(edweb:get-current($model))), "/db/projects/swb/data")}
                </div>
            </div>
        </div>
    else ()
};

