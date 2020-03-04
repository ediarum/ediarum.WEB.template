xquery version "3.0";

import module namespace config="http://www.bbaw.de/telota/software/ediarum/WEB" at "modules/config.xqm";
import module namespace edwebcontroller="http://www.bbaw.de/telota/software/ediarum/web/controller";

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
edwebcontroller:view-with-feed("/briefe/index.html", "data-pages/template-list.html", "object-type/briefe"),
edwebcontroller:view-with-feed("/briefe/", "data-pages/template-details.html", "object-type/briefe/id/"),
edwebcontroller:view-with-feed("/briefe1/", "data-pages/briefe-details.html", "object-type/briefe/id/"),

edwebcontroller:view-with-feed("/personen/index.html", "data-pages/personen.html", "object-type/personen"),
edwebcontroller:view-with-feed("/personen/", "data-pages/personen-details.html", "object-type/personen/id/"),

(: API :)
edwebcontroller:generate-api(),
(: Der Rest wird durchgereicht :)
edwebcontroller:pass-through()
