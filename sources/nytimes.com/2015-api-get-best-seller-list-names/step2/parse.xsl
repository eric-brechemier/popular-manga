<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output method="text" encoding="UTF-8" />

  <xsl:variable name="NEWLINE" select="'&#xA;'" />
  <xsl:variable name="QUOTE">"</xsl:variable>
  <xsl:variable name="COMMA" select="','" />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>List Name</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>List Display Name</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Encoded List Name</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>First Publication Date</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Latest Publication Date</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Update Frequency</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:apply-templates
      select="result_set/results/result[list_name = 'Manga']"
    />
  </xsl:template>

  <xsl:template match="result">
    <xsl:for-each select="*">
      <xsl:value-of select="." />
      <xsl:if test="position() &lt; last()">
        <xsl:value-of select="$COMMA" />
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

</xsl:stylesheet>
