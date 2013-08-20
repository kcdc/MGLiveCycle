<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template match="/">
		<xsl:variable name="defects" select="count(/ValuationReport/Document/Defects/Defect)"/>
		<xsl:variable name="options" select="count(/ValuationReport/Document/Options/Option)"/>
		<ValuationReport>
			<meta>
				<defects>
					<xsl:value-of select="$defects"/>
				</defects>
				<options>
					<xsl:value-of select="$options"/>
				</options>
			</meta>
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
				<part1>
					<xsl:call-template name="part1">
						<xsl:with-param name="line" select="1"/>
					</xsl:call-template>
				</part1>
				<part2>
					<xsl:call-template name="part2">
						<xsl:with-param name="line" select="22"/>
					</xsl:call-template>
				</part2>
				<part3>
					<xsl:call-template name="part3">
						<xsl:with-param name="line" select="22"/>
						<xsl:with-param name="defects" select="$defects"/>
						<xsl:with-param name="options" select="$options"/>
					</xsl:call-template>
				</part3>
			</Document>
		</ValuationReport>
	</xsl:template>
	<xsl:template name="part1">
		<xsl:param name="line"/>
		<row>
			<DefectCtrlPoint>
				<xsl:value-of select="/ValuationReport/Document/Defects/Defect[$line]/DefectCtrlPoint"/>
			</DefectCtrlPoint>
			<DefectGrade>
				<xsl:value-of select="/ValuationReport/Document/Defects/Defect[$line]/DefectGrade"/>
			</DefectGrade>
			<DefectDescription>
				<xsl:value-of select="/ValuationReport/Document/Defects/Defect[$line]/DefectDescription"/>
			</DefectDescription>
			<DefectPrice>
				<xsl:value-of select="/ValuationReport/Document/Defects/Defect[$line]/DefectPrice"/>
			</DefectPrice>
			<OptionDesc>
				<xsl:value-of select="/ValuationReport/Document/Options/Option[$line]/OptionDesc"/>
			</OptionDesc>
		</row>
		<xsl:if test="$line != 21">
			<xsl:call-template name="part1">
				<xsl:with-param name="line" select="$line + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="part2">
		<xsl:param name="line"/>
		<row>
			<OptionDesc>
				<xsl:value-of select="/ValuationReport/Document/Options/Option[$line]/OptionDesc"/>
			</OptionDesc>
		</row>
		<xsl:if test="$line != 42">
			<xsl:call-template name="part2">
				<xsl:with-param name="line" select="$line + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="part3">
		<xsl:param name="line"/>
		<xsl:param name="defects"/>
		<xsl:param name="options"/>
		<row>
			<DefectCtrlPoint>
				<xsl:value-of select="/ValuationReport/Document/Defects/Defect[$line]/DefectCtrlPoint"/>
			</DefectCtrlPoint>
			<DefectGrade>
				<xsl:value-of select="/ValuationReport/Document/Defects/Defect[$line]/DefectGrade"/>
			</DefectGrade>
			<DefectDescription>
				<xsl:value-of select="/ValuationReport/Document/Defects/Defect[$line]/DefectDescription"/>
			</DefectDescription>
			<DefectPrice>
				<xsl:value-of select="/ValuationReport/Document/Defects/Defect[$line]/DefectPrice"/>
			</DefectPrice>
			<OptionDesc>
				<xsl:value-of select="/ValuationReport/Document/Options/Option[$line + 21]/OptionDesc"/>
			</OptionDesc>
		</row>
		<xsl:if test="$line &lt; $defects or $line &lt; ($options - 21)">
			<xsl:call-template name="part3">
				<xsl:with-param name="line" select="$line + 1"/>
				<xsl:with-param name="defects" select="$defects"/>
				<xsl:with-param name="options" select="$options"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
