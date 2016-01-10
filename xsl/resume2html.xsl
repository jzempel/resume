<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:resume="http://ns.hr-xml.org/2007-04-15"
  exclude-result-prefixes="resume">
  <xsl:output method="html" indent="yes" omit-xml-declaration="yes"
    doctype-system="about:legacy-compat" />
  <xsl:param name="myLinks" />

  <xsl:template match="resume:StructuredXMLResume">
      <html lang="en">
      <head>
        <title>
          <xsl:call-template name="getPersonName" />
          <xsl:text>'s Resume</xsl:text>
        </title>
        <link href="stylesheets/resume.css" rel="stylesheet" />
      </head>
      <body>
        <div class="content">
          <xsl:apply-templates select="resume:ContactInfo" />
          <div class="resume">
            <xsl:apply-templates select="resume:ExecutiveSummary" />
            <xsl:apply-templates select="resume:Qualifications" />
            <xsl:apply-templates select="resume:EmploymentHistory" />
            <xsl:apply-templates select="resume:Associations" />
            <xsl:apply-templates select="resume:PublicationHistory" />
            <xsl:apply-templates select="resume:EducationHistory" />
            <xsl:apply-templates select="resume:Achievements" />
            <xsl:apply-templates select="resume:PatentHistory" />
            <xsl:apply-templates select="resume:ResumeAdditionalItems" />
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="resume:Achievements">
    <div class="section">
      <p class="sectionTitle">Achievements</p>
      <div class="subSection">
        <ul>
          <xsl:for-each select="resume:Achievement">
            <li>
              <xsl:value-of select="resume:Date/resume:Year | resume:Date/resume:StringDate" />
              <xsl:text>,&#x20;</xsl:text>
              <xsl:value-of select="resume:Description" />
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="resume:Associations">
    <div class="section">
      <p class="sectionTitle">Associations</p>
      <xsl:for-each select="resume:Association">
        <div class="subSection">
          <p class="subSectionTitle">
            <xsl:call-template name="getDateRange">
              <xsl:with-param name="startDate"
                select="resume:StartDate/resume:YearMonth" />
              <xsl:with-param name="endDate" select="resume:EndDate/resume:YearMonth" />
            </xsl:call-template>
            <span class="subTitleHighlight">
              <xsl:value-of select="resume:Name" />
            </span>
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="resume:Link" />
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test="starts-with(resume:Link, 'http://')">
                  <xsl:value-of select="substring-after(resume:Link, 'http://')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="resume:Link" />
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </p>
          <p class="subSectionSubTitle">
            <xsl:apply-templates select="resume:Role" />
          </p>
          <div class="subSubSection">
            <xsl:value-of select="resume:Comments" />
          </div>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="resume:ContactInfo">
    <div class="sidebar">
      <xsl:apply-templates select="resume:PersonName">
        <xsl:with-param name="title"
          select="../resume:EmploymentHistory/resume:EmployerOrg/resume:PositionHistory/resume:Title" />
      </xsl:apply-templates>
      <xsl:apply-templates select="resume:ContactMethod" />
      <xsl:if test="$myLinks">
        <div class="sidebarSection">
          <xsl:call-template name="getLinks">
            <xsl:with-param name="links" select="$myLinks" />
          </xsl:call-template>
        </div>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="resume:ContactMethod">
    <div class="sidebarSection">
      <p>
        <xsl:value-of select="resume:Telephone/resume:FormattedNumber" />
      </p>
      <p>
        <xsl:variable name="email" select="resume:InternetEmailAddress" />
        <a>
          <xsl:attribute name="href">
            <xsl:text>mailto:</xsl:text>
            <xsl:value-of select="$email" />
          </xsl:attribute>
          <xsl:value-of select="$email" />
        </a>
      </p>
      <xsl:apply-templates select="resume:PostalAddress" />
    </div>
  </xsl:template>

  <xsl:template match="resume:ContactMethod" mode="employer">
    <xsl:apply-templates select="resume:PostalAddress" mode="employer" />
  </xsl:template>

  <xsl:template match="resume:EducationHistory">
    <div class="section">
      <p class="sectionTitle">Education</p>
      <xsl:for-each select="resume:SchoolOrInstitution">
        <div class="subSection">
          <xsl:value-of select="resume:Degree/resume:DegreeName" />
          <xsl:text>,&#x20;</xsl:text>
          <xsl:value-of select="resume:Degree/resume:DegreeMajor/resume:Name" />
          <xsl:text>,&#x20;</xsl:text>
          <xsl:value-of select="resume:SchoolName" />
          <xsl:if test="string-length(resume:Comments) > 0">
            <xsl:text>&#x20;(</xsl:text>
            <xsl:value-of select="resume:Comments" />
            <xsl:text>)</xsl:text>
          </xsl:if>
          <xsl:text>,&#x20;</xsl:text>
          <xsl:value-of select="resume:Degree/resume:DegreeDate/resume:Year" />
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="resume:EmployerContactInfo">
    <xsl:apply-templates select="resume:ContactMethod" mode="employer" />
  </xsl:template>

  <xsl:template match="resume:EmploymentHistory">
    <div class="section">
      <p class="sectionTitle">Experience</p>
      <xsl:for-each select="resume:EmployerOrg">
        <div class="subSection">
          <p class="subSectionTitle">
            <xsl:call-template name="getDateRange">
              <xsl:with-param name="startDate"
                select="resume:PositionHistory/resume:StartDate/resume:YearMonth" />
              <xsl:with-param name="endDate"
                select="resume:PositionHistory/resume:EndDate/resume:YearMonth" />
            </xsl:call-template>
            <span class="subTitleHighlight">
              <xsl:value-of select="resume:EmployerOrgName" />
            </span>
            <xsl:apply-templates select="resume:EmployerContactInfo" />
          </p>
          <xsl:apply-templates select="resume:PositionHistory" />
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="resume:ExecutiveSummary">
    <div class="section">
      <p class="sectionTitle">Summary</p>
      <div class="subSection">
        <xsl:value-of select="." />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="resume:OrgName">
    <xsl:if test="string-length(resume:OrganizationName) > 0">
      <xsl:text>,&#x20;</xsl:text>
      <xsl:value-of select="resume:OrganizationName" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="resume:PatentDetail">
    <xsl:param name="link" />
    <xsl:call-template name="getDate">
      <xsl:with-param name="date" select="resume:PatentMilestone/resume:Date" />
    </xsl:call-template>
    <span class="subTitleHighlight">
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$link" />
        </xsl:attribute>
        <xsl:value-of select="resume:IssuingAuthority/@countryCode" />
        <xsl:value-of select="resume:PatentMilestone/resume:Id" />
      </a>
    </span>
    <xsl:variable name="status" select="resume:PatentMilestone/resume:Status" />
    <xsl:choose>
      <xsl:when test="$status = 'PatentPending'">Pending</xsl:when>
      <xsl:when test="$status = 'PatentFiled'">Filed</xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="resume:PatentHistory">
    <div class="section">
      <p class="sectionTitle">Patents</p>
      <xsl:for-each select="resume:Patent">
        <div class="subSection">
          <p class="subSectionTitle">
            <xsl:apply-templates select="resume:PatentDetail">
              <xsl:with-param name="link" select="resume:Link" />
            </xsl:apply-templates>
          </p>
          <p class="subSectionSubTitle">
            <xsl:value-of select="resume:PatentTitle" />
          </p>
          <div class="subSubSection">
            <xsl:value-of select="resume:Description" />
          </div>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="resume:PersonName">
    <xsl:param name="title" />
    <div class="sidebarSection">
      <p class="personName">
        <xsl:call-template name="getPersonName" />
      </p>
      <p>
        <xsl:value-of select="$title" />
      </p>
    </div>
  </xsl:template>

  <xsl:template match="resume:PositionHistory">
    <p class="subSectionSubTitle">
      <xsl:value-of select="resume:Title" />
      <xsl:apply-templates select="resume:OrgName" />
    </p>
    <div class="subSubSection">
      <xsl:value-of select="resume:Description" />
      <ul class="competencies">
        <xsl:for-each select="resume:Competency">
          <li>
            <xsl:value-of select="@description" />
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="resume:PostalAddress">
    <p>
      <xsl:value-of select="resume:DeliveryAddress/resume:AddressLine" />
    </p>
    <p>
      <xsl:value-of select="resume:Municipality" />
      <xsl:text>,&#x20;</xsl:text>
      <xsl:value-of select="resume:Region" />
      <xsl:text>&#x20;</xsl:text>
      <xsl:value-of select="resume:PostalCode" />
    </p>
  </xsl:template>

  <xsl:template match="resume:PostalAddress" mode="employer">
    <xsl:value-of select="resume:Municipality" />
    <xsl:text>,&#x20;</xsl:text>
    <xsl:value-of select="resume:Region" />
  </xsl:template>

  <xsl:template match="resume:PublicationHistory">
    <div class="section">
      <p class="sectionTitle">Publication Contributions</p>
      <xsl:for-each select="resume:OtherPublication">
        <div class="subSection">
          <p class="subSectionTitle">
            <xsl:call-template name="getDate">
              <xsl:with-param name="date"
                select="resume:PublicationDate/resume:AnyDate" />
            </xsl:call-template>
            <span class="subTitleHighlight">
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="resume:Link" />
                </xsl:attribute>
                <xsl:value-of select="resume:Title" />
              </a>
            </span>
          </p>
          <div class="subSubSection">
            <xsl:value-of select="resume:Comments" />
          </div>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="resume:Qualifications">
    <div class="section">
      <p class="sectionTitle">Qualifications</p>
      <div class="subSection">
        <ul>
          <xsl:for-each select="resume:Competency">
            <li>
              <span class="competency">
                <xsl:value-of select="@name" />
                <xsl:text>:&#x20;</xsl:text>
              </span>
              <xsl:for-each select="resume:Competency">
                <xsl:if test="position() > 1">,&#x20;</xsl:if>
                <xsl:value-of select="@name" />
              </xsl:for-each>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="resume:ResumeAdditionalItems">
    <div class="section">
      <p class="sectionTitle">Additional Items</p>
      <div class="subSection">
        <ul>
          <xsl:for-each select="resume:ResumeAdditionalItem">
            <li>
              <xsl:value-of select="resume:Description" />
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="resume:Role">
    <xsl:value-of select="resume:Name" />
    <xsl:text>,&#x20;</xsl:text>
    <xsl:value-of select="resume:Deliverable" />
  </xsl:template>

  <!-- Template Functions -->

  <xsl:template name="getDate">
    <xsl:param name="date" />
    <xsl:call-template name="getMonthName">
      <xsl:with-param name="month" select="substring(substring-after($date, '-'), 1, 2)" />
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
    <xsl:text>&#x20;–&#x20;</xsl:text>
    <xsl:choose>
      <xsl:when test="$endDate">
        <xsl:call-template name="getDate">
          <xsl:with-param name="date" select="$endDate" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>Present</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="getLink">
    <xsl:param name="link" />
    <p>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="substring-before($link, ',')" />
        </xsl:attribute>
        <xsl:value-of select="substring-after($link, ',')" />
      </a>
    </p>
  </xsl:template>

  <xsl:template name="getLinks">
    <xsl:param name="links" />
    <xsl:choose>
      <xsl:when test="contains($links, ';')">
        <xsl:call-template name="getLink">
          <xsl:with-param name="link" select="substring-before($links, ';')" />
        </xsl:call-template>
        <xsl:call-template name="getLinks">
          <xsl:with-param name="links" select="substring-after($links, ';')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="getLink">
          <xsl:with-param name="link" select="$links" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
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

  <xsl:template name="getPersonName">
    <xsl:variable name="parentElement"
      select="/resume:Resume/resume:StructuredXMLResume/resume:ContactInfo/resume:PersonName" />
    <xsl:value-of select="$parentElement/resume:GivenName" />
    <xsl:text>&#x20;</xsl:text>
    <xsl:value-of select="$parentElement/resume:FamilyName" />
  </xsl:template>
</xsl:stylesheet>
