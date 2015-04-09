<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <xsl:output method="xml" encoding="UTF-8" />

  <xsl:template match="/">
    <file>
      <header>
        <name>List Name</name>
        <name>List Display Name</name>
        <name>Encoded List Name</name>
        <name>First Publication Date</name>
        <name>Latest Publication Date</name>
        <name>Update Frequency</name>
      </header>

      <xsl:apply-templates
        select="result_set/results/result[list_name = 'Manga']"
      />
    </file>
  </xsl:template>

  <xsl:template match="result">
    <record>
      <xsl:for-each select="*">
        <field>
          <xsl:value-of select="." />
        </field>
      </xsl:for-each>
    </record>
  </xsl:template>

</xsl:stylesheet>
