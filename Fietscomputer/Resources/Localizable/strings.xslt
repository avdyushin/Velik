<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output omit-xml-declaration="yes"/>
<xsl:variable name="defaultLang">
    <xsl:text>en</xsl:text>
</xsl:variable>
<xsl:param name="lang" select="$defaultLang"/>

<xsl:template match="/">
<xsl:text>/// Auto-generated</xsl:text>
<xsl:text>&#xa;</xsl:text>
<xsl:text>/// Language: </xsl:text><xsl:value-of select="$lang"/>
<xsl:text>&#xa;</xsl:text>
<xsl:text>&#xa;</xsl:text>
<xsl:for-each select="strings/string">
    <xsl:if test="normalize-space(./*[name() = $lang]/text()) != ''">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>" = "</xsl:text>
        <xsl:value-of select="./*[name() = $lang]"/>
        <xsl:text>";</xsl:text>
        <xsl:text>&#xa;</xsl:text>
    </xsl:if>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
