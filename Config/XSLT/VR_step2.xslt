<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- Define how the output file should look like -->
	<xsl:output encoding="UTF-8" version="1.0" method="xml" indent="yes"/>
	<xsl:template match="/">
		<xsl:variable name="DefectsLimit" select="21"/>
		<ValuationReport>
			<xsl:copy>
				<xsl:copy-of select="descendant-or-self::Header"/>
			</xsl:copy>
			<Document>
				<xsl:copy>
					<xsl:copy-of select="descendant-or-self::DocumentHeader"/>
				</xsl:copy>
				<xsl:copy>
					<xsl:copy-of select="descendant-or-self::HeaderInfo"/>
				</xsl:copy>
				<Defects>
					<xsl:for-each select="/ValuationReport/Document/Defects/Defect">
						<xsl:if test="position() &lt;= $DefectsLimit">
							<xsl:copy-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</Defects>
				<RemainingDefects>
					<xsl:for-each select="/ValuationReport/Document/Defects/Defect">
						<xsl:if test="position() &gt; $DefectsLimit">
							<xsl:copy-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</RemainingDefects>
				<xsl:copy>
					<xsl:copy-of select="descendant-or-self::Options"/>
				</xsl:copy>
				<xsl:copy>
					<xsl:copy-of select="descendant-or-self::RemainingOptions"/>
				</xsl:copy>
			</Document>
		</ValuationReport>
	</xsl:template>
</xsl:stylesheet>
