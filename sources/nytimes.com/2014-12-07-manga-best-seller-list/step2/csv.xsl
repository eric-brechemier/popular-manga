<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output method="text" encoding="UTF-8" />

  <xsl:variable name="NEWLINE" select="'&#xA;'" />
  <xsl:variable name="QUOTE">"</xsl:variable>
  <xsl:variable name="COMMA" select="','" />

  <xsl:template mode="csv" priority="2"
    match="@*[ contains(.,'&quot;') ]
     | node()[ contains(.,'&quot;') ]"
  >
    <xsl:value-of select="$QUOTE" />
    <xsl:call-template name="escapeCsv">
      <xsl:with-param name="text" select="." />
    </xsl:call-template>
    <xsl:value-of select="$QUOTE" />
  </xsl:template>

  <!--
  Convert text to be part of a CSV value, escaping quotes by doubling them

  Note:
  this function does not handle the optional wrapping of the whole value
  in quotes, and does not return an indication of whether quotes have been
  replaced or not.

  The presence of a quote and/or comma in the CSV value should be tested
  beforehand, and this function only called when a quote is present.
  -->
  <xsl:template name="escapeCsv">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, $QUOTE)">
        <xsl:value-of select="substring-before($text, $QUOTE)" />
        <!-- double the quote to escape it -->
        <xsl:value-of select="$QUOTE" />
        <xsl:value-of select="$QUOTE" />
        <!-- recursion on right part of the text, after the quote -->
        <xsl:call-template name="escapeCsv">
          <xsl:with-param
            name="text"
            select="substring-after($text, $QUOTE)"
          />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- end recursion -->
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="csv"
    match="@*[ contains(.,',') ]
    | node() [ contains(.,',') ]"
  >
    <xsl:value-of select="$QUOTE" />
    <xsl:value-of select="." />
    <xsl:value-of select="$QUOTE" />
  </xsl:template>

  <xsl:template mode="csv" match="@* | node()">
    <xsl:value-of select="." />
  </xsl:template>

</xsl:stylesheet>
