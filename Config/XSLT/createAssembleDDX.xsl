<?xml version="1.0" encoding="UTF-8"?>

<!-- 
		//
		//  createAssembleDDX.xsl
		//  
		//
		//  Created by Kim Christensen on 24.10.2012
		//
 -->

<!--	
		Stylesheet to transform a set of file definitions within an XML into a Adobe LiveCycle DDX 
		
		Main functions
			
		#	generate a base DDX
		#	map each File within Attachments into a PDF source for Assembler
				
-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ddx="http://ns.adobe.com/DDX/1.0/">
	
	<xsl:template match="/">
		<xsl:apply-templates select="/Attachments"/>
	</xsl:template>

	<xsl:template match="/Attachments">
		<ddx:DDX>
			<xsl:element name="ddx:PDF" >
				<xsl:attribute name="result"><xsl:text>PDFComplete.pdf</xsl:text></xsl:attribute>				

  	      <xsl:for-each select="Attachment">
  	      	<xsl:element name="ddx:PDF">
  	      		<xsl:attribute name="source">{$/process_data/@environmentAttachmentLocation$}<xsl:value-of select="self::node()"></xsl:value-of></xsl:attribute>
  	      	</xsl:element>
  	      </xsl:for-each>	

		</xsl:element>
		</ddx:DDX>
		
	</xsl:template>
	</xsl:stylesheet>
