xquery version "3.0";

import module namespace edwebcontroller="http://www.bbaw.de/telota/software/ediarum/web/controller";
declare namespace appconf="http://www.bbaw.de/telota/software/ediarum/web/appconf";
import module namespace dbutil="http://exist-db.org/xquery/dbutil" at "modules/dbutil.xqm";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

edwebcontroller:init-exist-variables($exist:path, $exist:resource, $exist:controller, $exist:prefix, $exist:root),

edwebcontroller:redirect("/", "index.html"),
(: Genaue Seitenverweise :)
edwebcontroller:generate-path("/index.html", "static-pages/index.html"),

(: Verweise mit Feed :)



(: Generisches Frontend :)
edwebcontroller:generate-routing("data-pages/template-list.html","data-pages/template-details.html"),
(: API :)
edwebcontroller:generate-api(),

(: Load media :)
edwebcontroller:load-media(""),

(: Der Rest wird durchgereicht :)
edwebcontroller:pass-through()
