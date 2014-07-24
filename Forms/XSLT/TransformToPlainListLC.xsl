<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes"/>
	<!--Traverse all elements and make copy-->
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	<!--When Document element is found create element with same name as variable DocSubType and select values of Pages template inside this newly created element-->
	<xsl:template match="Document">
		<xsl:variable name="Type">
			<xsl:value-of select="//DocSubType"/>
		</xsl:variable>
		<xsl:element name="{$Type}">
			<xsl:apply-templates select="Pages"/>
		</xsl:element>
		<xsl:apply-templates select="DocumentHeader"/>
	</xsl:template>
	<!--When element DocumentHeader is matched copy all values into the structure-->
	<xsl:template match="DocumentHeader">
		<Document>
			<DocumentHeader>
				<xsl:apply-templates select="@* | node()"/>
			</DocumentHeader>
		</Document>
	</xsl:template>
	<!--When Pages are matched copy all elements from this element-->
	<xsl:template match="Pages">
		<Pages>
			<xsl:apply-templates select="@* | node()"/>
		</Pages>
	</xsl:template>
</xsl:stylesheet>
