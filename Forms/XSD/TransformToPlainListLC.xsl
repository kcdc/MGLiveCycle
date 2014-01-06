<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Document">
		<xsl:variable name="Type">
			<xsl:value-of select="//Type"/>
		</xsl:variable>
		<xsl:element name="{$Type}">
			<xsl:apply-templates select="Pages"/>
		</xsl:element>
		<xsl:apply-templates select="DocumentHeader"/>
	</xsl:template>
	<xsl:template match="DocumentHeader">
		<Document>
			<DocumentHeader>
				<xsl:apply-templates select="@* | node()"/>
			</DocumentHeader>
		</Document>
	</xsl:template>
	<xsl:template match="Pages">
		<Pages>
			<xsl:apply-templates select="@* | node()"/>
		</Pages>
	</xsl:template>
</xsl:stylesheet>
