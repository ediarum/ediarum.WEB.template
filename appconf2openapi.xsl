<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:appconf="http://www.bbaw.de/telota/software/ediarum/web/appconf"
    xmlns:yml="http://www.bbaw.de/telota/software/ediarum/web/yml"
    exclude-result-prefixes="xs appconf yml"
    version="1.0">
    
    <xsl:output method="xml" indent="yes"/>
  
    <xsl:variable name="defaultObjectParams">
      <yml:item><yml:string name="$ref">#/components/parameters/fromParam</yml:string></yml:item>
      <yml:item><yml:string name="$ref">#/components/parameters/limitParam</yml:string></yml:item>
      <yml:item><yml:string name="$ref">#/components/parameters/orderParam</yml:string></yml:item>
      <yml:item><yml:string name="$ref">#/components/parameters/orderModifierParam</yml:string></yml:item>
      <yml:item><yml:string name="$ref">#/components/parameters/showParam</yml:string></yml:item>
      <yml:item><yml:string name="$ref">#/components/parameters/rangeParam</yml:string></yml:item>
      <yml:item><yml:string name="$ref">#/components/parameters/pageParam</yml:string></yml:item>
    </xsl:variable>
  
  <xsl:variable name="defaultSearchParams">
    <yml:item><yml:string name="$ref">#/components/parameters/searchParam</yml:string></yml:item>
    <yml:item><yml:string name="$ref">#/components/parameters/searchTypeParam</yml:string></yml:item>
    <yml:item><yml:string name="$ref">#/components/parameters/searchXpathParam</yml:string></yml:item>
    <yml:item><yml:string name="$ref">#/components/parameters/slopParam</yml:string></yml:item>
    <yml:item><yml:string name="$ref">#/components/parameters/kwicWidthParam</yml:string></yml:item>
  </xsl:variable>
  
    <xsl:template match="/appconf:config">
        <yml:yml>
            <openapi>'3.0.2'</openapi>
            <info>
                <title><xsl:value-of select="appconf:project/appconf:name"/> API <xsl:value-of select="appconf:project/appconf:version"/></title>
                <description>This is the documentation of the <xsl:value-of select="appconf:project/appconf:name"/> API featured by ediarum.WEB (&lt;https://github.com/ediarum/ediarum.WEB&gt;)</description>
                <version>'<xsl:value-of select="appconf:project/appconf:version"/>'</version>
            </info>
            <servers>
                <xsl:for-each select="appconf:project/appconf:server">
                    <yml:item><url><xsl:value-of select="."></xsl:value-of></url></yml:item>
                </xsl:for-each>
            </servers>
            <tags>
                <yml:item>
                    <name>object</name>
                    <description>Information about a single object</description>
                </yml:item>
                <yml:item>
                    <name>object group</name>
                    <description>Endpoint to all objects of a type</description>
                </yml:item>
                <yml:item>
                    <name>search</name>
                    <description>Endpoint to search specified indexes</description>
                </yml:item>
            </tags>
            <paths>
                <xsl:apply-templates select="appconf:object"/>
            </paths>
<!--            <xsl:text>## Data relation table&#xA;&#xA;</xsl:text>-->
<!--            <xsl:text>## Search endpoints&#xA;&#xA;</xsl:text>-->
            <yml:plain>
components:
  schemas:
    ObjectGroup:
      type: object
      properties:
        date-time:
          type: string
          format: date-time
          description: stamp of caching
        filter:
          type: object
          description: list of filters
          additionalProperties:
            $ref: '#/components/schemas/Filter'
        list:
          type: object
          description: of objects
          additionalProperties:
            $ref: '#/components/schemas/Object'
        type:
          type: string
          description: equals "object group"
          example: manuscripts
        results-found:
          type: integer
          description: number of all objects
          example: 704
        results-shown:
          type: integer
          description: number of objects in `list`. Equals to `results-found` if equal or lower then the `limit` parameter
          example: 12
    Filter:
      type: object
      properties:
        id:
          type: string
          description: id of filter
          example: library
        name:
          type: string
          description: description of filter
          example: Library which holds the manuscript
        depends:
          type: string
          description: on which other filter it depends
          example:
        n:
          type: integer
          description: order number of filter
        type:
          type: string
          description: type of filter
          example: single
        xpath:
          type: string
          description: to get the raw filter value
          example: tei:repository
        label-function:
          type: string
          description: function to get the processed filter value
          example: function($string) { $string }
    Object:
      type: object
      properties:
        absolute-resource-id:
          type: integer
          description: object
          example: 7096865764654
        id:
          type: string
          description: of object
          example: M012345
        label:
          type: string
          description: main label of object
          example: Manuscript No. 012345
        label-filter:
          type: array
          description: values if defined
          items:
            type: string
        labels:
          type: array
          description: list of labels of object
          items:
            type: string
          example: [Manuscript No. 012345, Letter to myself]
        filter:
          type: object
          description: list of object properties
          properties:
            id:
              type: string
              example: M012345
          required:
            - "id"
          additionalProperties:
            type: string
        object-type:
          type: string
          description: type of object
          example: manuscripts
        search-results:
          oneOf:
            - type: object
              properties:
                keyword-1:
                  type: string
                  description: first keyword of match
                  example: "whole"
                keyword-2:
                  type: string
                  description: last keyword of match
                  example: "text"
                context:
                  type: string
                  description: context of the match incl. the keywords
                  example: "whole phrase of the search text"
          type: array
          description: contains an array of hits, if a search was triggered.
          items:
            type: object
            properties:
              context-previous:
                type: string
                description: of the found keyword
                example: "...n the text the searched "
              keyword:
                type: string
                description: found by search
                example: "word"
              context-following:
                type: string
                description: of the found keyword
                example: " is be found. And th..."
              score:
                type: number
                format: float
                description: of this single search hit
                example: 0.26706398
              part-id:
                type: string
                description: The ID of the related passage. Only retrieved by object API with `part-def` parameter.
                example: book-1.2.7
        score:
          type: string
          description: score of the search if triggered otherwise '0'
          example: 0
    ObjectExtended:
      allOf:
        - $ref: '#/components/schemas/Object'
        - type: object
          properties:
            inner-nav:
              type: object
              description: list of defined inner navigations
              additionalProperties:
                type: object
                properties:
                  id:
                    type: string
                    description: Where to find the IDs of items (XPath)
                    example: "@xml:id"
                  label-function:
                    type: string
                    description: label function of items (XQuery function)
                    example: function($node) { $node/string() }
                  list:
                    type: array
                    description: List of items.
                    items:
                      type: object
                      properties:
                        id:
                          type: string
                          description: ID of item
                          example: bibliography
                        label:
                          type: string
                          description: of item
                          example: Bibliography
                  name:
                    type: string
                    description: Name of inner-nav
                    example: Content
                  order-by:
                    type: string
                    description: how to order the items. If not set items are ordered by position in xml.
                    enum:
                      - label # order by label
                  xpath:
                    type: string
                    description: Where to find the inner-nav items (XPath)
                    example: tei:div[@type='main']
            parts:
              type: object
              description: part definitions of object
              additionalProperties:
                type: object
                properties:
                  depends:
                    type: string
                    description: On which other part definitions
                    example: book
                  id:
                    type: string
                    description: Definition of part id
                    example: "@n"
                  path:
                    type: string
                    description: Full path to part
                    example: book-&lt;book&gt;.&lt;chapter&gt;
                  root:
                    type: string
                    description: Definition of part root
                    example: "tei:div[@type='chapter']"
                  xmlid:
                    type: string
                    description: xml:id of part
                    example: book-chapter
            views:
              type: object
              description: Contains the defined views of the object.
              additionalProperties:
                type: object
                properties:
                  id:
                    type: string
                    description: ID of view
                    example: simple-view
                  label:
                    type: string
                    description: Label of view
                    example: Simple
                  params:
                    type: string
                    description: Defined parameter names for the view, separated bx ` `.
                    example: hightlight-persons
                  xslt:
                    type: string
                    description: Relative path to view xslt
                    example: resources/xslt/simple-view.xslt
    PartList:
      type: object
      properties:
        root:
          type: string
          description: XPath root of the part
          example: tei:seg
        path:
          type: string
          description: ID template for parts of this type
          example: book-&lt;book&gt;.&lt;book-chapter&gt;.&lt;book-chapter-segment&gt;
        depends:
          type: string
          description: The name of the hierarchical higher part
          example: book-chapter
        xmlid:
          type: string
          description: ID of the part definition
          example: book-chapter-segment
        id:
          type: string
          description: X-Path to the part id
          example: "@n"
        list:
          type: array
          items:
            type: string
            description: ID of an existing part
          example: [ "book-1.1.1", "book-1.1.2", "book-1.1.3" ]
  parameters:
    fromParam:
      name: from
      in: query
      description: Defines which is the first item to be shown. To be used with `range`.
      schema:
        type: integer
    limitParam:
      name: limit
      in: query
      description: Optional parameter. Defines how many (unordered) object entries are retrieved.
      schema:
        type: integer
      default: 10000
    orderParam:
      name: order
      in: query
      description: By which the list should be ordered. Can be `label` or a defined property.
      schema:
        type: string # TODO there are some values
    orderModifierParam:
      name: order-modifier
      in: query
      description: If the list should be ordered `ascending` (default) or `descending`.
      schema:
        type: string
        enum:
          - ascending
          - descending
    pageParam:
      name: page
      in: query
      description: Defines which page of list results should be returned. To be used with `range`.
      schema:
        type: integer
    rangeParam:
      name: range
      in: query
      description: How many items should be return. To be used with `page` or `from`.
      schema:
        type: integer
    showParam:
      name: show
      in: query
      description: What should be retrieved
      schema:
        type: string
        enum:
          - all # show all objects
          - compact # show all objects but in compact form, i.e. without properties
          - filter # show the filter definitions
          - list # show objects matching the filter criteria
          - full # show relations with full objects in 'subject' and 'object'
    searchParam:
      name: search
      in: query
      description: Query expression to search within the object.
      schema:
        type: string
    searchTypeParam:
      name: search-type
      in: query
      description: To be used with `search`. If not set the exact matches are found. Multiple words are separated with a space.
      schema:
        type: string
        enum:
          - regex # for one or more words (separated by space) using regular expressions
          - phrase # for a query of multiple words. With `slop` the distance can be defined (default is 1).
          - lucene # for a lucene query, see &lt;https://lucene.apache.org/core/2_9_4/queryparsersyntax.html&gt;
    searchXpathParam:
      name: search-xpath
      in: query
      description: To be used with `search`. One can specify which xpath-Elements of the object are included in the search. They must be indexed, see [APPCONF.md](APPCONF.md).
      schema:
        type: string
    slopParam:
      name: slop
      in: query
      description: The distance of words in a phrase search. To be used with `search` and `search-type=phrase`.
      schema:
        type: integer
    kwicWidthParam:
      name: kwic-width
      in: query
      description: The range of characters shown before and after the match in the hit.
      schema:
        type: integer
      example: 20            
            </yml:plain>
        </yml:yml>
    </xsl:template>
    
    <xsl:template match="appconf:object">
      <xsl:variable name="has-search" select="count(appconf:lucene) >0"/>
        <yml:object name="/api/{@xml:id}">
            <get>
                <tags>
                    <yml:item>object group</yml:item>
                    <xsl:if test="$has-search">
                      <yml:item>search</yml:item>
                    </xsl:if>  
                </tags>
                <summary>
                    <xsl:value-of select="appconf:name"/>
                </summary>
                <description> |
                    <xsl:value-of select="appconf:description"/>
                </description>
                <parameters>
                    <xsl:apply-templates select="appconf:filters/appconf:filter"/>
                    <xsl:copy-of select="$defaultObjectParams"/>
                    <xsl:if test="$has-search">
                        <xsl:copy-of select="$defaultSearchParams"/>
                    </xsl:if>
                </parameters>
                <responses>
                    <yml:object name="'200'">
                        <description>OK</description>
                        <content>
                            <yml:object name="application/json">
                                <schema>
                                    <yml:string name="$ref">#/components/schemas/ObjectGroup</yml:string>
                                </schema>
                            </yml:object>
                        </content>
                    </yml:object>
                </responses>
            </get>
        </yml:object>
    </xsl:template>
    
    <xsl:template match="appconf:filter">
        <yml:item>
            <name><xsl:value-of select="@xml:id"/></name>
            <in>query</in>
            <description><xsl:value-of select="appconf:name"/></description>
            <schema>
                <type>string</type>
            </schema>
        </yml:item>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:value-of select="name()"/>
    </xsl:template>
    
</xsl:stylesheet>