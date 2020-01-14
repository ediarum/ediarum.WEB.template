xquery version "3.0";

import module namespace config="http://www.bbaw.de/telota/software/ediarum/WEB" at "modules/config.xqm";
import module namespace edweb="http://www.bbaw.de/telota/software/ediarum/web/lib";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

edweb:init-exist-variables($exist:path, $exist:resource, $exist:controller, $exist:prefix, $exist:root),
edweb:set-project("sbw"),
edweb:redirect("/", "index.html"),
(: Genaue Seitenverweise :)
edweb:generate-path("/index.html", "static-pages/index.html"),

(: Verweise mit Feed :)
edweb:forward-view-with-feed("/briefe/index.html", "data-pages/briefe.html", "object-type/briefe"),
edweb:forward-view-with-feed("/personen/index.html", "data-pages/personen.html", "object-type/personen"),
edweb:forward-view-with-feed("/briefe/", "data-pages/briefe_detail.html", "object-type/briefe/id/"),
edweb:forward-view-with-feed("/personen/", "data-pages/personen_details.html", "object-type/personen/id/"),

(: API :)
edweb:generate-api(),
(: Der Rest wird durchgereicht :)
edweb:pass-through()
