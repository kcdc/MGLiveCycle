<?xml version="1.0" encoding="UTF-8"?>
<!-- XLS Transformation for Adobe Output Server -->
<!-- Written by eProcess Consulting AS, Vegard Bakke -->
<!-- Changelog: -->
<!--  * Default target is set to PDF due to bug in Designer 5.7 (Knut Olaf Lien 2010-05-03) -->
<!--  * Inserting DocHeaderBrand (as 'I') if missing. Obsolete Logo function removed. (Vegard Bakke 2011-07-06) -->


<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/">

	<!-- Define how the output file should look like -->
	<xsl:output encoding="UTF-8" version="1.0" method="xml" indent="yes"/>

	<!-- Include common XSLT functions that are common for all documents -->
	<xsl:include href="Common.xslt"/>

	<!--Set values from field to variable -->
	<xsl:template match="Document/HeaderInfo">
		<xsl:element name="{name()}">
			<xsl:copy-of select="./*"/>
		</xsl:element>
	</xsl:template>

	<!-- Variable for DefectInformation string length-->
	<xsl:variable name="DefectInformationLimit" select="80"/>

	<!-- Variable for extracting the remining Options -->
	<xsl:variable name="OptionsLimit" select="42"/>

	<xsl:variable name="remainingoptions">
		<xsl:for-each select="/*/Document/Options/Option">
			<xsl:if test="position() &gt; $OptionsLimit">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="Document/Options">
		<xsl:element name="{name()}">
			<xsl:copy-of select="Option[position() &lt; $OptionsLimit+1]"/>
		</xsl:element>
	</xsl:template>

	<!-- Variable for extracting the remaining Defects -->
	<xsl:variable name="DefectsLimit" select="22"/>

	<xsl:variable name="new_defects">
		<xsl:element name="Defects">
			<xsl:for-each select="/*/Document/Defects/Defect">
				<xsl:variable name="defect_info_basestr">
					<xsl:value-of select="./DefectCtrlPoint"/><xsl:text> </xsl:text><xsl:value-of select="./DefectGrade"/><xsl:text> </xsl:text><xsl:value-of select="./DefectDescription"/>
				</xsl:variable>
				<xsl:variable name="left_str">
					<xsl:call-template name="split_string_left">
						<xsl:with-param name="str" select="normalize-space($defect_info_basestr)"/>
						<xsl:with-param name="limit" select="$DefectInformationLimit"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="create_defect">
					<xsl:with-param name="defect_ctrl_point" select="./DefectCtrlPoint"/>
					<xsl:with-param name="defect_grade" select="./DefectGrade"/>
					<xsl:with-param name="defect_description" select="./DefectDescription"/>
					<xsl:with-param name="defect_price" select="./DefectPrice"/>
					<xsl:with-param name="defect_information">
						<xsl:element name="DefectInformation">
							<xsl:value-of select="normalize-space($left_str)"/>
						</xsl:element>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="create_additional_defects">
					<xsl:with-param name="defect_information">
						<xsl:element name="DefectInformation">
							<xsl:call-template name="split_string_right">
								<xsl:with-param name="str" select="normalize-space($defect_info_basestr)"/>
								<xsl:with-param name="limit" select="$DefectInformationLimit"/>
							</xsl:call-template>
						</xsl:element>									
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:element>		
	</xsl:variable>

	<xsl:variable name="remainingdefects">
		<xsl:for-each select="$new_defects/Defects/Defect">
			<xsl:if test="position() &gt; $DefectsLimit">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:template name="create_defect">
		<xsl:param name="defect_ctrl_point"/>
		<xsl:param name="defect_grade"/>
		<xsl:param name="defect_description"/>
		<xsl:param name="defect_price"/>
		<xsl:param name="defect_information"/>
		<xsl:element name="Defect">
			<xsl:copy-of select="$defect_ctrl_point"/>
			<xsl:copy-of select="$defect_grade"/>
			<xsl:copy-of select="$defect_description"/>
			<xsl:copy-of select="$defect_price"/>
			<xsl:copy-of select="$defect_information"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="create_additional_defects">
		<xsl:param name="defect_information"/>
		<xsl:variable name="additional_defect_info_str">
			<xsl:call-template name="split_string_right">
				<xsl:with-param name="str" select="$defect_information"/>
				<xsl:with-param name="limit" select="$DefectInformationLimit"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="string($defect_information)">
			<xsl:element name="Defect">
				<xsl:element name="DefectInformation">
					<xsl:call-template name="split_string_left">
						<xsl:with-param name="str" select="$defect_information"/>
						<xsl:with-param name="limit" select="$DefectInformationLimit"/>
					</xsl:call-template>
				</xsl:element>
				<xsl:element name="DefectPrice">
								</xsl:element>
			</xsl:element>
		</xsl:if>
		<xsl:if test="string($additional_defect_info_str)">
			<xsl:call-template name="create_additional_defects">
				<xsl:with-param name="defect_information" select="$additional_defect_info_str"/>
			</xsl:call-template>		
		</xsl:if>
	</xsl:template>

	<!-- Recursively find the space position nearest to the limit -->
	<xsl:template name="find_last_space">
		<xsl:param name="str"/>
		<xsl:param name="lastpos" select="1"/>
		<xsl:variable name="newstr" select="substring-before(substring($str,$lastpos),' ')"/>
		<xsl:variable name="newrelativepos" select="string-length($newstr)"/>
		<xsl:choose>
			<xsl:when test="$newrelativepos &gt; 0">
				<xsl:call-template name="find_last_space">
					<xsl:with-param name="str" select="$str"/>
					<xsl:with-param name="lastpos" select="$lastpos+$newrelativepos+1"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$newrelativepos = 0">
				<xsl:value-of select="number($lastpos)-1"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- Returns he positions of the space character nearest to the limit -->
	<xsl:template name="space_divide_pos">
		<xsl:param name="str"/>
		<xsl:variable name="pos">
			<xsl:call-template name="find_last_space">
				<xsl:with-param name="str" select="$str"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$pos"/>
	</xsl:template>
	
	<!-- Return the left half of the string -->
	<!-- Splits the string if it finds a space character nearest the split limit -->
	<!-- or returns the left half at the split, if it is more appropriate to print the whole string -->
	<xsl:template name="split_string_left">
		<xsl:param name="str"/>
		<xsl:param name="limit"/>
		<xsl:variable name="sdp">
			<xsl:call-template name="space_divide_pos">
				<xsl:with-param name="str" select="substring($str,1,$limit)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="number($sdp) = 0">
				<xsl:value-of select="substring($str,1,$limit)"/>
			</xsl:when>
			<xsl:when test="(string-length($str) &lt; $DefectInformationLimit) and (number($sdp) &lt; $DefectInformationLimit)">
				<xsl:value-of select="$str"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($str,1,number($sdp)-1)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Return the right half of the string -->
	<!-- Splits the string if it finds a space character nearest the split limit -->
	<!-- or returns the right half at the split, if it is more appropriate to print the whole string -->
	<xsl:template name="split_string_right">
		<xsl:param name="str"/>
		<xsl:param name="limit"/>
		<xsl:variable name="sdp">
			<xsl:call-template name="space_divide_pos">
				<xsl:with-param name="str" select="substring($str,1,$limit)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="number($sdp) = 0">
				<xsl:value-of select="substring($str, number($limit)+1)"/>
			</xsl:when>
			<xsl:when test="(string-length($str) &lt; $DefectInformationLimit) and (number($sdp) &lt; $DefectInformationLimit)">
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($str, number($sdp)+1)"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>

	<xsl:template match="Document/Defects">
		<xsl:element name="{name()}">
			<xsl:for-each select="$new_defects/Defects/Defect">
				<xsl:if test="position() &lt; ($DefectsLimit + 1)">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
		<!--xsl:apply-templates/-->
	</xsl:template>
	
		
	<!-- Insert ReminingOptions and Remining Defects before the end Document tag -->
	<xsl:template match="Document">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
			<xsl:if test="string($remainingdefects) or string($remainingoptions)">
				<xsl:element name="PAGEBREAK"/>
				<xsl:element name="RemainingDefects">
					<xsl:copy-of select="$remainingdefects"/>
				</xsl:element>			
				<xsl:element name="RemainingOptions">
					<xsl:copy-of select="$remainingoptions"/>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>




</xsl:stylesheet>
