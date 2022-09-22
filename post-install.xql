xquery version "3.1";

import module namespace edweb="http://www.bbaw.de/telota/software/ediarum/web/lib";

declare namespace sm="http://exist-db.org/xquery/securitymanager";
declare namespace appconf="http://www.bbaw.de/telota/software/ediarum/web/appconf";

(: The following external variables are set by the repo:deploy function :)

(: file path pointing to the exist installation directory :)
declare variable $home external;
(: path to the directory containing the unpacked .xar package :)
declare variable $dir external;
(: the target collection into which the app is deployed :)
declare variable $target external;

if (doc("appconf.xml")//appconf:project/appconf:status/string()="test") then
    sm:chmod(xs:anyURI($target||"/modules/view.xql"), "rwxr-sr-x")
else (
    sm:chgrp(xs:anyURI($target||"/modules/view.xql"), "website"),
    sm:chmod(xs:anyURI($target||"/modules/view.xql"), "rwsr-x---")
)