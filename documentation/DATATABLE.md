# Data table - "Bibelexegese"

Data collection: `/db/projects/bibelexegese/data`

## Data object table

| Name | ID | collection | properties |
| ---- | -- | ---------- |----------- |
|PTA-Texte|pta|`/Patristic-Text-Archive`|Bibelstellen `bible-quote`;<br/>Namespace `namespace`;<br/>Textgruppe `textgroup`;<br/>Werk `work`;<br/>Ausgabe `version`;<br/>Datum `date`;<br/>CPG `CPG`;<br/>BHL `BHL`;<br/>CAHP `CHAP`;<br/>CPL `CPL`;<br/>ClaCla `ClaCla`;<br/>BHGn `BHGn`;<br/>Pinakes-Oeuvre `Pinakes-Oeuvre`;<br/>|
|PTA-Textgruppen|pta-textgroup|`/Patristic-Text-Archive`|Namespace `namespace`;<br/>Name-deu `de`;<br/>Name-eng `en`;<br/>Name-lat `lat`;<br/>Name-grc `gr`;<br/>Textgruppe `textgroup`;<br/>GND `gnd`;<br/>|
|PTA-Werk|pta-work|`/Patristic-Text-Archive`|Textgruppe-ID `group-id`;<br/>Textgruppe `textgroup`;<br/>Textgruppe `work`;<br/>Textgruppe `namespace`;<br/>Editionstext `edition`;<br/>Übersetzung `translation`;<br/>|
|PTA-Version|pta-version|`/Patristic-Text-Archive`|Textgruppe `textgroup`;<br/>Werk `work`;<br/>Version `version`;<br/>Version `isVersionOf`;<br/>hasVersion `hasVersion`;<br/>Teil von `isPartOf`;<br/>Namespace `namespace`;<br/>Typ `type`;<br/>Beschreibung `description`;<br/>Beschreibung `creator`;<br/>Titel `title`;<br/>Beitragende `contributor`;<br/>Publikationsdatum `dateCopyrighted`;<br/>Zitationsform `bibliographicCitation`;<br/>Erstellungsdatum `created`;<br/>Herausgeber `publisher`;<br/>Media-Type `format`;<br/>Media-Type `spatial`;<br/>Media-Type `spatial`;<br/>Type `dct-type`;<br/>Type `rights`;<br/>|
|Handschriften|msdesc|`/Handschriftenbeschreibungen`|Status `status`;<br/>Ort `settlement`;<br/>Bibliothek `repository`;<br/>Sammlung `collection`;<br/>Nr. `idno`;<br/>Diktyon-ID `diktyon`;<br/>Datierung vor `origDateNotBefore`;<br/>Datierung nach `origDateNotAfter`;<br/>Datierung `origDate`;<br/>Links `bibl-url`;<br/>|
|MsItems|msitem|`/Handschriftenbeschreibungen`|PTA `msdesc`;<br/>PTA `corresp`;<br/>Position `n`;<br/>Locus `locus`;<br/>Rubric `rubric`;<br/>Incipit `incipit`;<br/>Explicit `explicit`;<br/>|
|Autoren|author|`/Register/pta_authors.xml`|Textgruppe `pta-textgroup`;<br/>GND `gnd`;<br/>TLG `tlg`;<br/>Name `forename`;<br/>Herkunftsname `toponymic`;<br/>Beiname `epithet`;<br/>floruit `floruit`;<br/>Vor `notBefore`;<br/>Nach `notAfter`;<br/>|
|Autoren|bibl-person|`/Register/bibl_persons.xml`|Name `name-eng`;<br/>Name `name-grc`;<br/>Name `name-heb`;<br/>Beschreibung `descr`;<br/>Vorkommnisse im AT `AT`;<br/>Vorkommnisse im NT `NT`;<br/>|
|PTA Werke (nicht Severin)|pta-other-work|`/Register/pta_works.xml`|Autor `author`;<br/>Textgruppe `incipit`;<br/>Textgruppe `CPG`;<br/>Textgruppe `BHG`;<br/>Textgruppe `Aldama`;<br/>Textgruppe `Pinakes-Oeuvre`;<br/>Textgruppe `date`;<br/>Edition des Werkes `edition`;<br/>|
|Bibelzitate|bible-quotation|`/Zitate/bible-quotations.xml`|Ausgabe `edition`;<br/>Buch `book`;<br/>Kapitel `chapter`;<br/>Vers `versFrom`;<br/>Vers `versTo`;<br/>Zitat `quote`;<br/>|
|PTA-Lexikon|pta-lexicon-grc|`/Lexika/pta_lexicon_grc.xml`||
|word lemma|wordlemma-grc|`/Lexika/wordlemma_grc.xml`|Lemma `lemma`;<br/>Morphology `morphology`;<br/>|


## Data relation table

## Search endpoints

