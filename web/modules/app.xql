xquery version "3.1";

module namespace app="http://www.telota.de/templates";

import module namespace templates="http://exist-db.org/xquery/templates";
import module namespace edweb="http://www.bbaw.de/telota/software/ediarum/web/lib";
import module namespace console="http://exist-db.org/xquery/console";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace functx = "http://www.functx.com";
declare namespace appconf="http://www.bbaw.de/telota/software/ediarum/web/appconf";

declare function app:data-path($node as node(), $model as map(*)) as node()* {
    if ($model?project?status eq 'test') then
        <div class="row">
            <div class="col-md-1"/>
            <div class="col-md-7">
                <div class="intern small text-secondary">
                    Dateipfad: {substring-after(document-uri(root($model?current-doc)), "/db/projects/swb/data")}
                </div>
            </div>
        </div>
    else ()
};

