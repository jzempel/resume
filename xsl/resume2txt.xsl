<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:resume="http://ns.hr-xml.org/2007-04-15"
  exclude-result-prefixes="resume">
  <xsl:output method="text" />
  <xsl:strip-space elements="*" />
  <xsl:variable name="lineWidth" select="72" />

  <xsl:template match="resume:StructuredXMLResume">
    <xsl:apply-templates select="resume:ContactInfo" />
    <xsl:text>&#xA;</xsl:text>
    <xsl:apply-templates select="resume:ExecutiveSummary" />
    <xsl:apply-templates select="resume:Qualifications" />
    <xsl:apply-templates select="resume:EmploymentHistory" />
    <xsl:apply-templates select="resume:Associations" />
    <xsl:apply-templates select="resume:PublicationHistory" />
    <xsl:apply-templates select="resume:EducationHistory" />
    <xsl:apply-templates select="resume:Achievements" />
    <xsl:apply-templates select="resume:PatentHistory" />
    <xsl:apply-templates select="resume:ResumeAdditionalItems" />
    <xsl:apply-templates select="resume:ContactInfo" />
  </xsl:template>

	<xsl:template match="resume:Achievements">
		<xsl:call-template name="getHeading">
			<xsl:with-param name="text" select="'ACHIEVEMENTS'" />
		</xsl:call-template>
		<xsl:for-each select="resume:Achievement">
			<xsl:value-of select="resume:Date/resume:Year | resume:Date/resume:StringDate" />
			<xsl:text>,&#x20;</xsl:text>
			<xsl:apply-templates select="resume:Description" />
		</xsl:for-each>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>

  <xsl:template match="resume:Associations">
    <xsl:call-template name="getHeading">
      <xsl:with-param name="text" select="'ASSOCIATIONS'" />
    </xsl:call-template>
    <xsl:for-each select="resume:Association">
      <xsl:value-of select="resume:Name" />
      <xsl:text>&#x20;-&#x20;</xsl:text>
      <xsl:variable name="link">
        <xsl:choose>
          <xsl:when test="starts-with(resume:Link, 'http://')">
            <xsl:value-of select="substring-after(resume:Link, 'http://')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="resume:Link" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="$link" />
      <xsl:text>&#x20;&#x20;(</xsl:text>
      <xsl:call-template name="getDateRange">
        <xsl:with-param name="startDate" select="resume:StartDate/resume:YearMonth" />
        <xsl:with-param name="endDate" select="resume:EndDate/resume:YearMonth" />
      </xsl:call-template>
      <xsl:text>)&#xA;</xsl:text>
      <xsl:apply-templates select="resume:Role" />
      <xsl:text>&#xA;</xsl:text>
      <xsl:apply-templates select="resume:Comments" />
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="resume:Comments">
    <xsl:call-template name="wrapText">
      <xsl:with-param name="text" select="normalize-space()" />
    </xsl:call-template>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="resume:ContactInfo">
    <xsl:apply-templates select="resume:PersonName">
      <xsl:with-param name="title"
        select="../resume:EmploymentHistory/resume:EmployerOrg[1]/resume:PositionHistory[1]/resume:Title" />
    </xsl:apply-templates>
    <xsl:call-template name="getCharacters">
      <xsl:with-param name="character" select="'-'" />
      <xsl:with-param name="length" select="$lineWidth - 1" />
    </xsl:call-template>
    <xsl:text>&#xA;</xsl:text>
    <xsl:apply-templates select="resume:ContactMethod" />
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="resume:ContactMethod">
    <xsl:apply-templates select="resume:InternetEmailAddress" />
    <xsl:call-template name="getCharacters">
      <xsl:with-param name="character" select="' '" />
      <xsl:with-param name="length"
        select="$lineWidth - string-length(resume:InternetEmailAddress) - string-length(resume:InternetWebAddress) - 1" />
    </xsl:call-template>
    <xsl:apply-templates select="resume:InternetWebAddress" />
    <xsl:text>&#xA;</xsl:text>
    <xsl:call-template name="getCharacters">
      <xsl:with-param name="character" select="'-'" />
      <xsl:with-param name="length" select="$lineWidth - 1" />
    </xsl:call-template>
    <xsl:text>&#xA;</xsl:text>
    <xsl:value-of select="resume:Telephone/resume:FormattedNumber" />
    <xsl:apply-templates select="resume:PostalAddress">
      <xsl:with-param name="columnIndex"
        select="string-length(resume:Telephone/resume:FormattedNumber)" />
    </xsl:apply-templates>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="resume:ContactMethod" mode="employer">
    <xsl:apply-templates select="resume:PostalAddress" mode="employer" />
  </xsl:template>

  <xsl:template match="resume:Description">
    <xsl:call-template name="wrapText">
      <xsl:with-param name="text" select="normalize-space()" />
    </xsl:call-template>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="resume:EducationHistory">
    <xsl:call-template name="getHeading">
      <xsl:with-param name="text" select="'EDUCATION'" />
    </xsl:call-template>
    <xsl:for-each select="resume:SchoolOrInstitution">
      <xsl:value-of select="resume:Degree/resume:DegreeName" />
      <xsl:text>,&#x20;</xsl:text>
      <xsl:value-of select="resume:Degree/resume:DegreeMajor/resume:Name" />
      <xsl:text>,&#x20;</xsl:text>
      <xsl:value-of select="resume:SchoolName" />
      <xsl:text>,&#x20;</xsl:text>
      <xsl:value-of select="resume:Degree/resume:DegreeDate/resume:Year" />
      <xsl:text>&#xA;&#xA;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="resume:EmployerContactInfo">
    <xsl:apply-templates select="resume:ContactMethod" mode="employer" />
  </xsl:template>

  <xsl:template match="resume:EmploymentHistory">
    <xsl:call-template name="getHeading">
      <xsl:with-param name="text" select="'EXPERIENCE'" />
    </xsl:call-template>
    <xsl:for-each select="resume:EmployerOrg">
      <xsl:value-of select="resume:EmployerOrgName" />
      <xsl:text>,&#x20;</xsl:text>
      <xsl:apply-templates select="resume:EmployerContactInfo" />
      <xsl:text>&#x20;&#x20;(</xsl:text>
      <xsl:call-template name="getDateRange">
        <xsl:with-param name="startDate"
          select="resume:PositionHistory/resume:StartDate/resume:YearMonth" />
        <xsl:with-param name="endDate"
          select="resume:PositionHistory/resume:EndDate/resume:YearMonth" />
      </xsl:call-template>
      <xsl:text>)&#xA;</xsl:text>
      <xsl:apply-templates select="resume:PositionHistory" />
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="resume:ExecutiveSummary">
    <xsl:call-template name="getHeading">
      <xsl:with-param name="text" select="'SUMMARY'" />
    </xsl:call-template>
    <xsl:call-template name="wrapText">
      <xsl:with-param name="text" select="normalize-space()" />
    </xsl:call-template>
    <xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="resume:OrgName">
    <xsl:if test="string-length(resume:OrganizationName) > 0">
      <xsl:text>,&#x20;</xsl:text>
      <xsl:value-of select="resume:OrganizationName" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="resume:PatentDetail">
    <xsl:value-of select="resume:IssuingAuthority/@countryCode" />
    <xsl:apply-templates select="resume:PatentMilestone[1]" />
  </xsl:template>

  <xsl:template match="resume:PatentHistory">
    <xsl:call-template name="getHeading">
      <xsl:with-param name="text" select="'PATENTS'" />
    </xsl:call-template>
    <xsl:for-each select="resume:Patent">
      <xsl:if test="position() &lt;= 3">
        <xsl:apply-templates select="resume:PatentDetail" />
        <xsl:value-of select="normalize-space(resume:PatentTitle)" />
        <xsl:text>&#xA;&#xA;</xsl:text>
        <xsl:apply-templates select="resume:Description" />
        <xsl:text>&#xA;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="resume:PatentMilestone">
    <xsl:value-of select="resume:Id" />
    <xsl:variable name="status" select="resume:Status" />
    <xsl:choose>
      <xsl:when test="$status = 'PatentPending'">
        <xsl:text>&#x20;-&#x20;Pending</xsl:text>
      </xsl:when>
      <xsl:when test="$status = 'PatentFiled'">
        <xsl:text>&#x20;-&#x20;Filed</xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:text>&#x20;&#x20;(</xsl:text>
    <xsl:call-template name="getDate">
      <xsl:with-param name="date" select="resume:Date" />
    </xsl:call-template>
    <xsl:text>)&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="resume:PersonName">
    <xsl:param name="title" />
    <xsl:variable name="personName">
      <xsl:value-of select="resume:GivenName" />
      <xsl:text>&#x20;</xsl:text>
      <xsl:value-of select="resume:FamilyName" />
    </xsl:variable>
    <xsl:value-of select="$personName" />
    <xsl:call-template name="getCharacters">
      <xsl:with-param name="character" select="' '" />
      <xsl:with-param name="length"
        select="$lineWidth - string-length($personName) - string-length($title) - 1" />
    </xsl:call-template>
    <xsl:value-of select="$title" />
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="resume:PositionHistory">
    <xsl:value-of select="resume:Title" />
    <xsl:apply-templates select="resume:OrgName" />
    <xsl:text>&#xA;&#xA;</xsl:text>
    <xsl:apply-templates select="resume:Description" />
    <xsl:for-each select="resume:Competency">
      <xsl:call-template name="wrapText">
        <xsl:with-param name="text">
          <xsl:text>-&#x20;</xsl:text>
          <xsl:value-of select="@description" />
        </xsl:with-param>
        <xsl:with-param name="hangingIndent" select="2" />
      </xsl:call-template>
    </xsl:for-each>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="resume:PostalAddress">
    <xsl:param name="columnIndex" select="0" />
    <xsl:variable name="postalAddress">
      <xsl:value-of select="resume:DeliveryAddress/resume:AddressLine" />
      <xsl:text>,&#x20;</xsl:text>
      <xsl:value-of select="resume:Municipality" />
      <xsl:text>,&#x20;</xsl:text>
      <xsl:value-of select="resume:Region" />
      <xsl:text>&#x20;</xsl:text>
      <xsl:value-of select="resume:PostalCode" />
    </xsl:variable>
    <xsl:call-template name="getCharacters">
      <xsl:with-param name="character" select="' '" />
      <xsl:with-param name="length"
        select="$lineWidth - $columnIndex - string-length($postalAddress) - 1" />
    </xsl:call-template>
    <xsl:value-of select="$postalAddress" />
  </xsl:template>

  <xsl:template match="resume:PostalAddress" mode="employer">
    <xsl:value-of select="resume:Municipality" />
    <xsl:text>,&#x20;</xsl:text>
    <xsl:value-of select="resume:Region" />
  </xsl:template>

  <xsl:template match="resume:PublicationHistory">
    <xsl:call-template name="getHeading">
      <xsl:with-param name="text" select="'PUBLICATION CONTRIBUTIONS'" />
    </xsl:call-template>
    <xsl:for-each select="resume:OtherPublication">
      <xsl:value-of select="resume:Title" />
      <xsl:text>&#x20;&#x20;(</xsl:text>
      <xsl:call-template name="getDate">
        <xsl:with-param name="date" select="resume:PublicationDate/resume:AnyDate" />
      </xsl:call-template>
      <xsl:text>)&#xA;&#xA;</xsl:text>
      <xsl:apply-templates select="resume:Comments" />
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="resume:Qualifications">
    <xsl:call-template name="getHeading">
      <xsl:with-param name="text" select="'QUALIFICATIONS'" />
    </xsl:call-template>
    <xsl:for-each select="resume:Competency">
      <xsl:call-template name="wrapText">
        <xsl:with-param name="text">
          <xsl:text>-&#x20;</xsl:text>
          <xsl:value-of select="@name" />
          <xsl:text>:&#x20;</xsl:text>
          <xsl:for-each select="resume:Competency">
            <xsl:if test="position() > 1">,&#x20;</xsl:if>
            <xsl:value-of select="@name" />
          </xsl:for-each>
        </xsl:with-param>
        <xsl:with-param name="hangingIndent" select="2" />
      </xsl:call-template>
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

	<xsl:template match="resume:ResumeAdditionalItems">
		<xsl:call-template name="getHeading">
			<xsl:with-param name="text" select="'ADDITIONAL ITEMS'" />
		</xsl:call-template>
		<xsl:for-each select="resume:ResumeAdditionalItem">
			<xsl:text>-&#x20;</xsl:text>
			<xsl:apply-templates select="resume:Description" />
		</xsl:for-each>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>

  <xsl:template match="resume:Role">
    <xsl:value-of select="resume:Name" />
    <xsl:text>,&#x20;</xsl:text>
    <xsl:value-of select="resume:Deliverable" />
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <!-- Template Functions -->

  <xsl:template name="getDate">
    <xsl:param name="date" />
    <xsl:call-template name="getMonthName">
      <xsl:with-param name="month" select="number(substring(substring-after($date, '-'), 1, 2))" />
    </xsl:call-template>
    <xsl:text>&#x20;'</xsl:text>
    <xsl:value-of select="substring(substring-before($date, '-'), 3, 2)" />
  </xsl:template>

  <xsl:template name="getDateRange">
    <xsl:param name="startDate" />
    <xsl:param name="endDate" />
    <xsl:call-template name="getDate">
      <xsl:with-param name="date" select="$startDate" />
    </xsl:call-template>
    <xsl:text>&#x20;-&#x20;</xsl:text>
    <xsl:choose>
      <xsl:when test="$endDate">
        <xsl:call-template name="getDate">
          <xsl:with-param name="date" select="$endDate" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>Present</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="getCharacters">
    <xsl:param name="character" />
    <xsl:param name="length" />
    <xsl:if test="$length > 0">
      <xsl:value-of select="$character" />
      <xsl:call-template name="getCharacters">
        <xsl:with-param name="character" select="$character" />
        <xsl:with-param name="length" select="$length - 1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="getHeading">
    <xsl:param name="text" />
    <xsl:value-of select="$text" />
    <xsl:text>&#xA;</xsl:text>
    <xsl:call-template name="getCharacters">
      <xsl:with-param name="character" select="'-'" />
      <xsl:with-param name="length" select="string-length($text)" />
    </xsl:call-template>
    <xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:template>

  <xsl:template name="getLine">
    <xsl:param name="text" />
    <xsl:if test="contains($text, ' ')">
      <xsl:variable name="temp" select="substring-after($text, ' ')" />
      <xsl:value-of select="substring-before($text, ' ')" />
      <xsl:if test="contains($temp, ' ')">
        <xsl:text>&#x20;</xsl:text>
        <xsl:call-template name="getLine">
          <xsl:with-param name="text" select="$temp" />
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="getMonthName">
    <xsl:param name="month" />
    <xsl:if test="$month = 1">Jan</xsl:if>
    <xsl:if test="$month = 2">Feb</xsl:if>
    <xsl:if test="$month = 3">Mar</xsl:if>
    <xsl:if test="$month = 4">Apr</xsl:if>
    <xsl:if test="$month = 5">May</xsl:if>
    <xsl:if test="$month = 6">Jun</xsl:if>
    <xsl:if test="$month = 7">Jul</xsl:if>
    <xsl:if test="$month = 8">Aug</xsl:if>
    <xsl:if test="$month = 9">Sep</xsl:if>
    <xsl:if test="$month = 10">Oct</xsl:if>
    <xsl:if test="$month = 11">Nov</xsl:if>
    <xsl:if test="$month = 12">Dec</xsl:if>
  </xsl:template>

  <xsl:template name="wrapText">
    <xsl:param name="text" />
    <xsl:param name="hangingIndent" />
    <xsl:param name="width" select="$lineWidth" />
    <xsl:if test="$text">
      <xsl:variable name="line">
        <xsl:choose>
          <xsl:when test="string-length($text) >= $width">
            <xsl:call-template name="getLine">
              <xsl:with-param name="text" select="substring($text, 1, $width)" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$text" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="temp" select="substring($text, string-length($line) + 2)" />
      <xsl:if test="$line">
        <xsl:value-of select="$line" />
        <xsl:text>&#xA;</xsl:text>
        <xsl:if test="$hangingIndent and string-length($temp) > 0">
          <xsl:call-template name="getCharacters">
            <xsl:with-param name="character" select="' '" />
            <xsl:with-param name="length" select="$hangingIndent" />
          </xsl:call-template>
        </xsl:if>
      </xsl:if>
      <xsl:call-template name="wrapText">
        <xsl:with-param name="text" select="$temp" />
        <xsl:with-param name="hangingIndent" select="$hangingIndent" />
        <xsl:with-param name="width">
          <xsl:choose>
            <xsl:when test="$hangingIndent">
              <xsl:value-of select="$lineWidth - $hangingIndent" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$lineWidth" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
