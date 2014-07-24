<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml"/>
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<!--More specific template for Node766 that provides custom behavior -->
	<xsl:template match="//Page">
			<CopyAndPage>
		<xsl:variable name="DocSubType" select="//DocSubType"/>
		<xsl:if test="$DocSubType = 'PS02'">
			<Page>
				<xsl:apply-templates select="@*|node()"/>
			</Page>
			<CopyPage>
				<xsl:apply-templates select="@*|node()"/>
			</CopyPage>
		</xsl:if>
				<xsl:if test="$DocSubType = 'PS03'">
			<CopyPage>
				<xsl:apply-templates select="@*|node()"/>
			</CopyPage>
		</xsl:if>
		<xsl:if test="$DocSubType != 'PS02' and $DocSubType != 'PS03'">
			<Page>
				<xsl:apply-templates select="@*|node()"/>
			</Page>
			
		</xsl:if>
		</CopyAndPage>
	</xsl:template>
</xsl:stylesheet>
