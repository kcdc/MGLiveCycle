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
	
	<!-- Define how the output file should look like -->
	<xsl:output encoding="UTF-8" version="1.0" method="xml" indent="yes"/>

	<!-- Default value for DocHeaderBrand, if element is missing -->
	<xsl:variable name="DefaultDocHeaderBrand">I</xsl:variable>

	<!-- Variable for building the DESIGN MDF file name -->
	<xsl:variable name="DesignFilename">
		<xsl:value-of select="/*/Header/DocType"/>
		<!-- Extract LangCode -->
		<xsl:choose>
			<xsl:when test="/*/Header/LangCode/text()='NO'">
				<xsl:text>_NO</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>_BA</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Variable for building the LANGUAGE PREAMBLE file name -->
	<xsl:variable name="PreambleFilename">
			<xsl:text>LANG_</xsl:text>
			<xsl:value-of select="/*/Header/LangCode"/>
			<xsl:text>.pre</xsl:text>
	</xsl:variable>

	<!--Match and create root element -->
	<xsl:template match="/*">
		<!--Data xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"-->
		<ValuationReport>
			<!--<xsl:call-template name="createJobcard"/>-->
<!--			<xsl:call-template name="createMetaElements"/>-->
			<!-- Try to match templates for the rest of the xml file -->
			<xsl:apply-templates/>
--	</ValuationReport>
	</xsl:template>

	<!-- Default template - Create the leaf elements with its value -->
	<xsl:template match="*">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="Header">
		<!-- Insert Default DocHeaderBrand, if it does not exist -->
		<!--<xsl:if test="not(DocHeaderBrand)">
			<xsl:element name="DocHeaderBrand">
				<xsl:value-of select="$DefaultDocHeaderBrand"/>
			</xsl:element>
		</xsl:if>-->
		<!-- Continue by leaving the rest of the contant as it is -->
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Set DealerNameMarkering for the specific Brand to let the font follow the logo -->
	<!-- If Brand does not exist, use 'I' for 'Ingen' -->
	<xsl:template match="Document/DocumentHeader/DealerNameMarketing">
		<xsl:variable name="brand">
			<xsl:choose>
				<xsl:when test="not(/*/Header/DocHeaderBrand)">
					<xsl:value-of select="$DefaultDocHeaderBrand"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/*/Header/DocHeaderBrand"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--<xsl:element name="DealerNameMarketing_{$brand}">
			<xsl:value-of select="."/>
		</xsl:element>-->
	</xsl:template>

	<!-- "Function" for creating the job card -->
	<xsl:template name="createJobcard">
		<xsl:element name="JF_JOB_CARD">
			<!-- Extract output media -->
			<xsl:choose>
				<xsl:when test="/*/Header/MediaControl/OutputTargets/Mail/MailTo and /*/Header/MediaControl/OutputTargets/Mail/MailFrom">
					<xsl:text>PGMAIL</xsl:text>
				</xsl:when>
				<xsl:when test="/*/Header/MediaControl/OutputTargets/Archive/ARKIVNR">
					<xsl:text>ARCHIVE</xsl:text>
				</xsl:when>
				<xsl:when test="/*/Header/MediaControl/OutputTargets/Print/PrinterName">
					<xsl:text>PGPRINT</xsl:text>
				</xsl:when>
				<xsl:when test="/*/Header/MediaControl/OutputTargets/Preview/ClientAddress">
					<xsl:text>PGPREVIEW</xsl:text>
				</xsl:when>
				<xsl:when test="/*/Header/MediaControl/OutputTargets/File/FileName">
					<xsl:text>PGPRINT</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>FILE</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Base job card on extracted language code -->
			<xsl:text> -f</xsl:text>
			<xsl:value-of select="$DesignFilename"/>
			<xsl:text>.MDF</xsl:text>
			<!-- Extract output target -->
			<xsl:choose>
				<xsl:when test="/*/Header/MediaControl/OutputTargets/Mail/MailTo and /*/Header/MediaControl/OutputTargets/Mail/MailFrom">
					<xsl:text> -emfrom=</xsl:text><xsl:value-of select="/*/Header/MediaControl/OutputTargets/Mail/MailFrom"/>
                                        <xsl:text> -emto=</xsl:text><xsl:value-of select="/*/Header/MediaControl/OutputTargets/Mail/MailTo"/>
                                        <xsl:text> -emcc=</xsl:text><xsl:value-of select="/*/Header/MediaControl/OutputTargets/Mail/MailCC"/>
                                        <xsl:text> -emsub="</xsl:text><xsl:value-of select="/*/Header/MediaControl/OutputTargets/Mail/MailSubject"/><xsl:text>"</xsl:text>
                                        <xsl:text> -emtext="</xsl:text><xsl:value-of select="/*/Header/MediaControl/OutputTargets/Mail/MailBody"/><xsl:text>"</xsl:text>
					<xsl:text> -asppdf</xsl:text>
				</xsl:when>
				<xsl:when test="/*/Header/MediaControl/OutputTargets/Print/PrinterName">
					<xsl:text> -z</xsl:text><xsl:value-of select="/*/Header/MediaControl/OutputTargets/Print/PrinterName"/><xsl:text> -asplex1650</xsl:text>
				</xsl:when>
				<xsl:when test="/*/Header/MediaControl/OutputTargets/Preview/ClientAddress">
					<xsl:text> -host=</xsl:text><xsl:value-of select="/*/Header/MediaControl/OutputTargets/Preview/ClientAddress"/><xsl:text> -asppdf</xsl:text>
				</xsl:when>
				<xsl:when test="/*/Header/MediaControl/OutputTargets/File/FileName">
					<xsl:text> -z</xsl:text><xsl:value-of select="/*/Header/MediaControl/OutputTargets/File/FileName"/><xsl:text> -asppdf</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> -zNoOutputSpecified,u.pdf -asppdf</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Import language preamable file -->
			<xsl:text> -apr</xsl:text>
			<xsl:value-of select="$PreambleFilename"/>
			<!-- Get tray numbers -->
			<xsl:choose>
				<xsl:when test="/*/Header/StdTray">
					<xsl:text> -agvSTDTRAY="</xsl:text><xsl:value-of select="/*/Header/StdTray"/><xsl:text>"</xsl:text>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="/*/Header/ExtraTray">
					<xsl:text> -agvEXTRATRAY="</xsl:text><xsl:value-of select="/*/Header/ExtraTray"/><xsl:text>"</xsl:text>
				</xsl:when>
			</xsl:choose>
			<!-- Get number of copies -->
             <xsl:choose>
                <xsl:when test="/*/Header/Copies">
                    <xsl:text> -C</xsl:text><xsl:value-of select="/*/Header/Copies"/>
                </xsl:when>
             </xsl:choose>
			<!-- Duplex printing -->
			<xsl:choose>
				<xsl:when test="/*/Header/TwoSided/text()='yes'">
					<xsl:text> -aduON</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> -aduOFF</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<!-- "Function" for creating the extra meta xml elements -->
	<xsl:template name="createMetaElements">
		<xsl:element name="DesignFilename"><xsl:value-of select="$DesignFilename"/></xsl:element>
		<xsl:element name="PreambleFilename"><xsl:value-of select="$PreambleFilename"/></xsl:element>
	</xsl:template>
				
	<xsl:template name="makeGlobal">
		<xsl:element name="{name()}">
			<xsl:attribute name="xfa:match">many</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

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
