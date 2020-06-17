<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output omit-xml-declaration="yes"/>

<xsl:template match="/">
    <xsl:text>/// Auto-generated</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>import Localizable</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>enum Strings {</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:for-each select="strings/string">
        <xsl:text>    @Localizable static var </xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text> = "</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>"</xsl:text>
        <xsl:text>&#xa;</xsl:text></xsl:for-each>}
</xsl:template>
</xsl:stylesheet>
