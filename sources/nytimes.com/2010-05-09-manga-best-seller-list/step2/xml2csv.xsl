<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>
  <!--
  XSLT 1.0 Transformation of XML to CSV

  Input:
    XML without namespace, with the following structure,
    loosely based on the BNF grammar of CSV described in RFC 4180:
    * file - root element, contains an optional header element,
             followed with zero or more record elements
    * header - element, optional header record,
               contains one or more name elements
    * name - element, field name, contains a text value
    * record - element, a single record, contains a list of field elements
    * field - element, field value, contains a text value

  Output:
    Optional header and records convert to CSV as described by RFC 4180:
    * CRLF (0x0D 0x0A) is used as newline separator
    * COMMA (,) is used as field separators
    * fields are quoted with QUOTE (") characters
    * QUOTE characters are doubled for escaping within quoted field values

    Fields are left unquoted unless they contain one of:
    * the field separator COMMA
    * the newline separator or more generally either CR (0x0D) or LF (0x0A)
    * the quoting character QUOTE

    Unless empty, the CSV file ends with a newline character,
    which is not omitted after the last record.

  References:
    RFC 4180
    Common Format and MIME Type for Comma-Separated Values (CSV) Files
    http://tools.ietf.org/html/rfc4180

  Version: 1.0 (2015-04-08)
  -->

  <xsl:output method="text" encoding="UTF-8" />

  <xsl:variable name="CR" select="'&#xD;'" />
  <xsl:variable name="LF" select="'&#xA;'"/>
  <xsl:variable name="COMMA">,</xsl:variable>
  <xsl:variable name="DQUOTE">"</xsl:variable>

  <xsl:variable name="endOfLine" select="concat($CR,$LF)" />
  <xsl:variable name="fieldSeparator" select="$COMMA" />
  <xsl:variable name="quote" select="$DQUOTE" />
  <xsl:variable name="escapedQuote" select="concat($DQUOTE,$DQUOTE)" />

  <xsl:template match="header | record">
    <xsl:apply-templates />
    <xsl:value-of select="$endOfLine" />
  </xsl:template>

  <xsl:template match="name | field">
    <xsl:choose>
      <xsl:when
        test="
             contains(.,$fieldSeparator)
          or contains(.,$CR)
          or contains(.,$LF)
          or contains(.,$quote)
        "
      >
        <xsl:value-of select="$quote" />
        <xsl:call-template name="escapeQuotes">
          <xsl:with-param name="text" select="." />
        </xsl:call-template>
        <xsl:value-of select="$quote" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="." />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="following-sibling::*">
      <xsl:value-of select="$fieldSeparator" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="escapeQuotes">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, $quote)">
        <xsl:value-of select="substring-before($text, $quote)" />
        <xsl:value-of select="$escapedQuote" />
        <!-- recursion on right part of the text, after the quote -->
        <xsl:call-template name="escapeQuotes">
          <xsl:with-param
            name="text"
            select="substring-after($text, $quote)"
          />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- end recursion -->
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ignore other text nodes (indent), otherwise copied by default -->
  <xsl:template match="text()" />

</xsl:stylesheet>
