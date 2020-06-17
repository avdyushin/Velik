<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output omit-xml-declaration="yes"/>
<xsl:key name="lang_id" match="/strings/string/node()" use="name(.)"/>

<xsl:template match="/">
    <xsl:for-each select="strings/string/node()[generate-id() = generate-id(key('lang_id',name(.))[1])]">
        <xsl:value-of select="name(.)"/><xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
</xsl:template>
</xsl:stylesheet>
