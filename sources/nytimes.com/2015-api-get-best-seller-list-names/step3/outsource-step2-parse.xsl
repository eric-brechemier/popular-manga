<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>
  <xsl:import href="csv.xsl" />

  <xsl:template match="/">
    <!-- print headers -->
    <xsl:text>List Name</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Bestsellers Date</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Published Date</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Rank</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Rank Last Week</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Weeks on List</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Asterisk</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Dagger</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Primary ISBN10</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Primary ISBN13</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Publisher</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Description</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Price</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Title</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Author</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Contributor</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Contributor Note</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Book Image</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Amazon Product URL</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Age Group</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Book Review Link</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>First Chapter Link</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Sunday Review Link</xsl:text>
    <xsl:value-of select="$COMMA" />
    <xsl:text>Article Chapter Link</xsl:text>
    <xsl:value-of select="$NEWLINE" />

    <xsl:apply-templates
      select="result_set/results/books/book"
    />
  </xsl:template>

  <xsl:template match="book">
    <xsl:value-of select="../../list_name" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="../../bestsellers_date" />
    <xsl:value-of select="$COMMA" />
    <xsl:value-of select="../../published_date" />
    <xsl:value-of select="$COMMA" />

    <xsl:for-each select="*">
      <xsl:apply-templates mode="csv" select="." />
      <xsl:if test="position() &lt; last()">
        <xsl:value-of select="$COMMA" />
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="$NEWLINE" />
  </xsl:template>

</xsl:stylesheet>
