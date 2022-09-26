<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:appconf="http://www.bbaw.de/telota/software/ediarum/web/appconf"
    xmlns:yml="http://www.bbaw.de/telota/software/ediarum/web/yml"
    exclude-result-prefixes="xs appconf yml"
    version="1.0">
    
    <xsl:output method="text"/>
    
    <xsl:template match="/yml:yml" priority="1">
        <xsl:for-each select="*">
            <xsl:call-template name="element">
                <xsl:with-param name="element" select="."/>
                <xsl:with-param name="indent" select="0"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="element">
        <xsl:param name="element"/>
        <xsl:param name="indent"/>
        <xsl:variable name="loop-1">
            <xsl:call-template name="loop">
                <xsl:with-param name="i" select="1"/>
                <xsl:with-param name="to" select="$indent"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="loop-0">
            <xsl:call-template name="loop">
                <xsl:with-param name="i" select="0"/>
                <xsl:with-param name="to" select="$indent"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <!-- Array -->
            <xsl:when test="$element/self::yml:item[not(child::*)]">
                <xsl:text>- </xsl:text>
                <xsl:value-of select="$element"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="$element/self::yml:item">
                <xsl:for-each select="$element/*[1]">
                    <xsl:text>- </xsl:text>
                    <xsl:call-template name="element">
                        <xsl:with-param name="element" select="."/>
                        <xsl:with-param name="indent" select="$indent +1"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="$element/*[position()>1]">
                    <xsl:value-of select="$loop-1"/>
                    <xsl:text>  </xsl:text>
                    <xsl:call-template name="element">
                        <xsl:with-param name="element" select="."/>
                        <xsl:with-param name="indent" select="$indent +1"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <!-- Object -->
            <xsl:when test="$element/self::yml:object">
                <xsl:value-of select="$element/@name"/>
                <xsl:text>:&#xA;</xsl:text>
                <xsl:for-each select="$element/*">
                    <xsl:value-of select="$loop-0"/>
                    <xsl:call-template name="element">
                        <xsl:with-param name="element" select="."/>
                        <xsl:with-param name="indent" select="$indent +1"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <!-- Object -->
            <xsl:when test="$element/child::*">
                <xsl:value-of select="name($element)"/>
                <xsl:text>:&#xA;</xsl:text>
                <xsl:for-each select="$element/*">
                    <xsl:value-of select="$loop-0"/>
                    <xsl:call-template name="element">
                        <xsl:with-param name="element" select="."/>
                        <xsl:with-param name="indent" select="$indent +1"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <!-- String -->
            <xsl:when test="$element/self::yml:string">
                <xsl:value-of select="$element/@name"/>
                <xsl:text>: '</xsl:text>
                <xsl:value-of select="string($element)"/>
                <xsl:text>'&#xA;</xsl:text>
            </xsl:when>
            <!-- Plain yml -->
            <xsl:when test="$element/self::yml:plain">
                <xsl:value-of select="$element/text()"/>
            </xsl:when>
            <!-- Key-Value -->
            <xsl:when test="not($element/child::*)">
                <xsl:value-of select="name($element)"/>
                <xsl:text>: </xsl:text>
                <xsl:choose>
                    <xsl:when test="string($element) =''">''</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="string($element)"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="loop">
        <xsl:param name="i"/>
        <xsl:param name="to"/>
        <xsl:text>  </xsl:text>
        <xsl:if test="$i &lt; $to">
            <xsl:call-template name="loop">
                <xsl:with-param name="i" select="$i +1"/>
                <xsl:with-param name="to" select="$to"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>