<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output method="xml" encoding="UTF-8" />

  <xsl:template match="/">
    <file>
      <header>
        <name>List Name</name>
        <name>Bestsellers Date</name>
        <name>Published Date</name>
        <name>Rank</name>
        <name>Rank Last Week</name>
        <name>Weeks on List</name>
        <name>Asterisk</name>
        <name>Dagger</name>
        <name>Primary ISBN10</name>
        <name>Primary ISBN13</name>
        <name>Publisher</name>
        <name>Description</name>
        <name>Price</name>
        <name>Title</name>
        <name>Author</name>
        <name>Contributor</name>
        <name>Contributor Note</name>
        <name>Book Image</name>
        <name>Amazon Product URL</name>
        <name>Age Group</name>
        <name>Book Review Link</name>
        <name>First Chapter Link</name>
        <name>Sunday Review Link</name>
        <name>Article Chapter Link</name>
      </header>

      <xsl:apply-templates
        select="result_set/results/books/book"
      />
    </file>
  </xsl:template>

  <xsl:template match="book">
    <record>
      <field><xsl:value-of select="../../list_name" /></field>
      <field><xsl:value-of select="../../bestsellers_date" /></field>
      <field><xsl:value-of select="../../published_date" /></field>

      <xsl:for-each select="*">
        <xsl:apply-templates />
      </xsl:for-each>
    </record>
  </xsl:template>

  <xsl:template match="book/*">
    <field>
      <xsl:value-of select="." />
    </field>
  </xsl:template>

  <!-- ignore (redundant) -->
  <xsl:template match="book/isbns" />

  <!-- disable copy of text node, done by default -->
  <xsl:template match="text()" />

</xsl:stylesheet>
