<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- Define how the output file should look like -->
	<xsl:output encoding="UTF-8" version="1.0" method="xml" indent="yes"/>
  
	<xsl:template match="/">
		<xsl:variable name="defects" select="count(/ValuationReport/Document/Defects/Defect)"/>
		<xsl:variable name="options" select="count(/ValuationReport/Document/Options/Option)"/>
		<xsl:variable name="line" select="1"/>
		<!-- Variable for DefectInformation string length-->
		<xsl:variable name="DefectInformationLimit" select="80"/>
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
				<Defects>
          <xsl:apply-templates select="/ValuationReport/Document/Defects/Defect" />
        </Defects>        
        <RemainingDefects>         
          <xsl:apply-templates select="/ValuationReport/Document/Defects/Defect" />
        </RemainingDefects>
        <xsl:apply-templates select="/ValuationReport/Document/Options"/>
		<xsl:variable name="OptionsLimit" select="45"/>
		<RemainingOptions>
		<xsl:for-each select="/*/Document/Options/Option">
			<xsl:if test="position() &gt; $OptionsLimit">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:for-each>
		</RemainingOptions>
			</Document>
		</ValuationReport>
	</xsl:template>

	<xsl:variable name="OptionsLimit" select="45"/> 
	
	<xsl:template match="/ValuationReport/Document/Options">
		<xsl:element name="{name()}">
			<xsl:copy-of select="Option[position() &lt;= $OptionsLimit]"/>
		</xsl:element>
	</xsl:template>


  <xsl:template match="/ValuationReport/Document/Defects/Defect">
   
    <xsl:variable name="defectInformation">
      <xsl:value-of select="DefectCtrlPoint"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="DefectGrade"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="DefectDescription"/>
    </xsl:variable>

    <xsl:if test="string-length($defectInformation) &lt;= 80">
      <Defect>
        <DefectCtrlPoint>
          <xsl:value-of select="DefectCtrlPoint"/>
        </DefectCtrlPoint>
        <DefectGrade>
          <xsl:value-of select="DefectGrade"/>
        </DefectGrade>
        <DefectDescription>
          <xsl:value-of select="DefectDescription"/>
        </DefectDescription>
        <DefectPrice>
          <xsl:value-of select="DefectPrice"/>
        </DefectPrice>
        <DefectInformation>
          <xsl:value-of select="DefectCtrlPoint"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="DefectGrade"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="DefectDescription"/>
        </DefectInformation>
      </Defect>
    </xsl:if>

    <xsl:if test="string-length($defectInformation) &gt; 80">
      <Defect>
        <DefectCtrlPoint>
          <xsl:value-of select="DefectCtrlPoint"/>
        </DefectCtrlPoint>
        <DefectGrade>
          <xsl:value-of select="DefectGrade"/>
        </DefectGrade>
        <DefectDescription>
          <xsl:value-of select="DefectDescription"/>
        </DefectDescription>
        <DefectPrice>
          <xsl:value-of select="DefectPrice"/>
        </DefectPrice>
        <DefectInformation>
          <xsl:call-template name="split_string_left">
            <xsl:with-param name="str" select="normalize-space($defectInformation)"/>
            <xsl:with-param name="limit" select="80"/>
            <xsl:with-param name="DefectInformationLimit" select="80"/>
          </xsl:call-template>
        </DefectInformation>
      </Defect>
      <xsl:variable name="rightSide">
        <xsl:call-template name="split_string_right">
          <xsl:with-param name="str" select="normalize-space($defectInformation)"/>
          <xsl:with-param name="limit" select="80"/>
          <xsl:with-param name="DefectInformationLimit" select="80"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:call-template name="addDefectElement">
        <xsl:with-param name="element" select="."/>
        <xsl:with-param name="line" select="1"/>
        <xsl:with-param name="rightSide" select="$rightSide"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>
  
  
	<xsl:template name="addDefectElement">
		<xsl:param name="element"/>
		<xsl:param name="line"/>
		<xsl:param name="rightSide"/>
		<xsl:if test="$line != 25">
		  <Defect>
			  <DefectPrice>
			  </DefectPrice>
			  <DefectInformation>
				  <xsl:variable name="leftSide">
					  <xsl:call-template name="split_string_left">
						  <xsl:with-param name="str" select="normalize-space($rightSide)"/>
						  <xsl:with-param name="limit" select="80"/>
						  <xsl:with-param name="DefectInformationLimit" select="80"/>
					  </xsl:call-template>
				  </xsl:variable>
				  <xsl:value-of select="$leftSide"/>
			  </DefectInformation>
		  </Defect>
		</xsl:if>
		<xsl:if test="string-length($rightSide) &gt; 80">
			<xsl:variable name="recurRightSide">
				<xsl:call-template name="split_string_right">
					<xsl:with-param name="str" select="normalize-space($rightSide)"/>
					<xsl:with-param name="limit" select="80"/>
					<xsl:with-param name="DefectInformationLimit" select="80"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="addDefectElement">
				<xsl:with-param name="element" select="$element"/>
				<xsl:with-param name="line" select="$line+1"/>				
				<xsl:with-param name="rightSide" select="$recurRightSide"/>
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
		<xsl:param name="DefectInformationLimit"/>
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
		<xsl:param name="DefectInformationLimit"/>
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
</xsl:stylesheet>
