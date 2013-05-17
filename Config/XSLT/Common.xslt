<?xml version="1.0" encoding="UTF-8"?>
<!-- XLS Transformation for Adobe Output Server -->
<!-- Written by CBA Consultants AS, Vegard Bakke and Knut Olaf Lien -->
<!-- Changelog: -->
<!--  * Default target is set to PDF due to bug in Designer 5.7 (Knut Olaf Lien 2010-05-03) -->
<!--  * Inserting DocHeaderBrand (as 'I') if missing. Obsolete Logo function removed. (Vegard Bakke 2011-07-06) -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/">

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
		<Data>
			<xsl:call-template name="createJobcard"/>
			<xsl:call-template name="createMetaElements"/>
			<!-- Try to match templates for the rest of the xml file -->
			<xsl:apply-templates/>
		</Data>
	</xsl:template>

	<!-- Default template - Create the leaf elements with its value -->
	<xsl:template match="*">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="Header">
		<!-- Insert Default DocHeaderBrand, if it does not exist -->
		<xsl:if test="not(DocHeaderBrand)">
			<xsl:element name="DocHeaderBrand">
				<xsl:value-of select="$DefaultDocHeaderBrand"/>
			</xsl:element>
		</xsl:if>
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
		<xsl:element name="DealerNameMarketing_{$brand}">
			<xsl:value-of select="."/>
		</xsl:element>
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

</xsl:stylesheet>

