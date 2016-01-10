<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/XSL/Format"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:resume="http://ns.hr-xml.org/2007-04-15"
  exclude-result-prefixes="resume">
  <xsl:output method="xml" />

  <xsl:template match="resume:StructuredXMLResume">
    <root xmlns="http://www.w3.org/1999/XSL/Format">
      <layout-master-set>
        <simple-page-master master-name="first" margin-bottom="12mm" margin-left="24mm"
          margin-right="24mm" margin-top="12mm">
          <region-body margin-top="36mm" />
          <region-before extent="36mm" />
        </simple-page-master>
        <simple-page-master master-name="default" margin-bottom="6mm" margin-left="12mm"
          margin-right="10mm" margin-top="18mm">
          <region-body margin-bottom="12mm" margin-left="12mm" margin-right="12mm" />
          <region-after extent="6mm" />
        </simple-page-master>
        <page-sequence-master master-name="resume">
          <single-page-master-reference master-reference="first" />
          <repeatable-page-master-reference master-reference="default" />
        </page-sequence-master>
      </layout-master-set>
      <declarations>
        <xmp:xmpmeta xmlns:xmp="adobe:ns:meta/">
          <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">
              <dc:title><xsl:call-template name="getPersonName" />'s Resume</dc:title>
                  <dc:creator><xsl:call-template name="getPersonName" /></dc:creator>
            </rdf:Description>
          </rdf:RDF>
        </xmp:xmpmeta>
      </declarations>
      <page-sequence master-reference="resume">
        <static-content flow-name="xsl-region-before">
          <block font-family="Times Roman" font-size="12pt" text-align="center">
            <xsl:apply-templates select="resume:ContactInfo" mode="header" />
          </block>
        </static-content>
        <static-content flow-name="xsl-region-after">
          <block font-family="Times Roman" font-size="9pt">
            <xsl:apply-templates select="resume:ContactInfo" mode="footer" />
          </block>
        </static-content>
        <flow flow-name="xsl-region-body">
          <block font-family="Times Roman" font-size="11pt">
            <xsl:apply-templates select="resume:ExecutiveSummary" />
            <xsl:apply-templates select="resume:Qualifications" />
            <xsl:apply-templates select="resume:EmploymentHistory" />
            <xsl:apply-templates select="resume:Associations" />
            <xsl:apply-templates select="resume:PublicationHistory" />
            <xsl:apply-templates select="resume:EducationHistory" />
            <xsl:apply-templates select="resume:Achievements" />
            <xsl:apply-templates select="resume:PatentHistory" />
            <xsl:apply-templates select="resume:ResumeAdditionalItems" />
          </block>
        </flow>
      </page-sequence>
    </root>
  </xsl:template>

  <xsl:template match="resume:Achievements">
    <block margin-bottom="25pt">
      <xsl:call-template name="getTitleBlock">
        <xsl:with-param name="title" select="string('Achievements')" />
      </xsl:call-template>
      <block font-size="90%" line-height="150%" margin-bottom="10pt" margin-left="20pt">
        <list-block>
          <xsl:for-each select="resume:Achievement">
            <list-item>
              <list-item-label>
                <block font-size="150%">&#x2022;</block>
              </list-item-label>
              <list-item-body>
                <block margin-left="10pt">
                  <xsl:value-of select="resume:Date/resume:Year | resume:Date/resume:StringDate" />
                  <xsl:text>,&#x20;</xsl:text>
                  <xsl:value-of select="resume:Description" />
                </block>
              </list-item-body>
            </list-item>
          </xsl:for-each>
        </list-block>
      </block>
    </block>
  </xsl:template>

  <xsl:template match="resume:Associations">
    <block margin-bottom="25pt">
      <xsl:call-template name="getTitleBlock">
        <xsl:with-param name="title" select="string('Associations')" />
      </xsl:call-template>
      <xsl:for-each select="resume:Association">
        <block font-size="90%" margin-bottom="10pt" margin-left="20pt">
          <block font-weight="bold" margin-bottom="5pt">
            <table table-layout="fixed" width="100%">
              <table-column column-width="75%" />
              <table-column column-width="25%" />
              <table-body>
                <table-row>
                  <table-cell>
                    <block margin-left="-20pt">
                      <xsl:value-of select="resume:Name" />
                      <inline font-weight="normal">
                        <xsl:text>&#x20;–&#x20;</xsl:text>
                        <xsl:call-template name="getLink">
                          <xsl:with-param name="link"
                            select="resume:Link" />
                          <xsl:with-param name="text">
                            <xsl:choose>
                              <xsl:when
                                test="starts-with(resume:Link, 'http://')">
                                <xsl:value-of
                                  select="substring-after(resume:Link, 'http://')" />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="resume:Link" />
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:with-param>
                        </xsl:call-template>
                      </inline>
                    </block>
                  </table-cell>
                  <table-cell>
                    <block text-align="right">
                      <xsl:call-template name="getDateRange">
                        <xsl:with-param name="startDate"
                          select="resume:StartDate/resume:YearMonth" />
                        <xsl:with-param name="endDate"
                          select="resume:EndDate/resume:YearMonth" />
                      </xsl:call-template>
                    </block>
                  </table-cell>
                </table-row>
              </table-body>
            </table>
          </block>
          <block font-style="italic" margin-bottom="5pt">
            <xsl:apply-templates select="resume:Role" />
          </block>
          <block margin-left="20pt" margin-bottom="15pt">
            <xsl:value-of select="resume:Comments" />
          </block>
        </block>
      </xsl:for-each>
    </block>
  </xsl:template>

  <xsl:template match="resume:ContactInfo" mode="footer">
    <xsl:variable name="url" select="resume:ContactMethod/resume:InternetWebAddress" />
    <table table-layout="fixed" width="100%">
      <table-column column-width="50%" />
      <table-column column-width="50%" />
      <table-body>
        <table-row>
          <table-cell>
            <block>
              <xsl:call-template name="getPersonName" />
            </block>
          </table-cell>
          <table-cell>
            <block text-align="right">
              <xsl:call-template name="getLink">
                <xsl:with-param name="link" select="$url" />
                <xsl:with-param name="text" select="$url" />
              </xsl:call-template>
            </block>
          </table-cell>
        </table-row>
      </table-body>
    </table>
  </xsl:template>

  <xsl:template match="resume:ContactInfo" mode="header">
    <block font-size="150%" letter-spacing="3pt" text-transform="uppercase">
      <xsl:call-template name="getPersonName" />
    </block>
    <xsl:apply-templates select="resume:ContactMethod" />
  </xsl:template>
  <xsl:template match="resume:ContactMethod">
    <block>
      <xsl:apply-templates select="resume:PostalAddress" />
    </block>
    <block>
      <xsl:value-of select="resume:Telephone/resume:FormattedNumber" />
    </block>
    <xsl:variable name="email" select="resume:InternetEmailAddress" />
    <block>
      <xsl:call-template name="getLink">
        <xsl:with-param name="link">
          <xsl:text>mailto:</xsl:text>
          <xsl:value-of select="$email" />
        </xsl:with-param>
        <xsl:with-param name="text" select="$email" />
      </xsl:call-template>
    </block>
  </xsl:template>

  <xsl:template match="resume:ContactMethod" mode="employer">
    <xsl:apply-templates select="resume:PostalAddress" mode="employer" />
  </xsl:template>

  <xsl:template match="resume:EducationHistory">
    <block margin-bottom="25pt">
      <xsl:call-template name="getTitleBlock">
        <xsl:with-param name="title" select="string('Education')" />
      </xsl:call-template>
      <xsl:for-each select="resume:SchoolOrInstitution">
        <block font-size="90%" keep-with-previous="always" margin-bottom="10pt" margin-left="20pt">
          <xsl:value-of select="resume:Degree/resume:DegreeName" />
          <xsl:text>,&#x20;</xsl:text>
          <xsl:value-of select="resume:Degree/resume:DegreeMajor/resume:Name" />
          <xsl:text>,&#x20;</xsl:text>
          <xsl:value-of select="resume:SchoolName" />
          <xsl:text>,&#x20;</xsl:text>
          <xsl:value-of select="resume:Degree/resume:DegreeDate/resume:Year" />
        </block>
      </xsl:for-each>
    </block>
  </xsl:template>

  <xsl:template match="resume:EmployerContactInfo">
    <xsl:apply-templates select="resume:ContactMethod" mode="employer" />
  </xsl:template>

  <xsl:template match="resume:EmploymentHistory">
    <block margin-bottom="25pt">
      <xsl:call-template name="getTitleBlock">
        <xsl:with-param name="title" select="string('Experience')" />
      </xsl:call-template>
      <xsl:for-each select="resume:EmployerOrg">
        <xsl:if test="position() &lt;= 3">
          <block font-size="90%" margin-bottom="10pt" margin-left="20pt">
            <block font-weight="bold" margin-bottom="5pt">
              <table table-layout="fixed" width="100%">
                <table-column column-width="75%" />
                <table-column column-width="25%" />
                <table-body>
                  <table-row>
                    <table-cell>
                      <block margin-left="-20pt">
                        <xsl:value-of select="resume:EmployerOrgName" />
                        <xsl:text>,&#x20;</xsl:text>
                        <xsl:apply-templates
                          select="resume:EmployerContactInfo" />
                      </block>
                    </table-cell>
                    <table-cell>
                      <block text-align="right">
                        <xsl:call-template name="getDateRange">
                          <xsl:with-param name="startDate"
                            select="resume:PositionHistory/resume:StartDate/resume:YearMonth" />
                          <xsl:with-param name="endDate"
                            select="resume:PositionHistory/resume:EndDate/resume:YearMonth" />
                        </xsl:call-template>
                      </block>
                    </table-cell>
                  </table-row>
                </table-body>
              </table>
            </block>
            <xsl:apply-templates select="resume:PositionHistory" />
          </block>
        </xsl:if>
      </xsl:for-each>
    </block>
  </xsl:template>

  <xsl:template match="resume:ExecutiveSummary">
    <block margin-bottom="25pt">
      <xsl:call-template name="getTitleBlock">
        <xsl:with-param name="title" select="string('Summary')" />
      </xsl:call-template>
      <block font-size="90%" margin-bottom="10pt" margin-left="20pt">
        <xsl:value-of select="." />
      </block>
    </block>
  </xsl:template>

  <xsl:template match="resume:OrgName">
    <xsl:if test="string-length(resume:OrganizationName) > 0">
      <xsl:text>,&#x20;</xsl:text>
      <xsl:value-of select="resume:OrganizationName" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="resume:PatentDetail">
    <xsl:param name="link" />
    <table table-layout="fixed" width="100%">
      <table-column column-width="75%" />
      <table-column column-width="25%" />
      <table-body>
        <table-row>
          <table-cell>
            <block margin-left="-20pt">
              <xsl:call-template name="getLink">
                <xsl:with-param name="link" select="$link" />
                <xsl:with-param name="text">
                  <xsl:value-of select="resume:IssuingAuthority/@countryCode" />
                  <xsl:value-of select="resume:PatentMilestone/resume:Id" />
                </xsl:with-param>
              </xsl:call-template>
              <inline font-weight="normal">
                <xsl:variable name="status"
                  select="resume:PatentMilestone/resume:Status" />
                <xsl:choose>
                  <xsl:when test="$status = 'PatentPending'">
                    <xsl:text>&#x20;–&#x20;Pending</xsl:text>
                  </xsl:when>
                  <xsl:when test="$status = 'PatentFiled'">
                    <xsl:text>&#x20;–&#x20;Filed</xsl:text>
                  </xsl:when>
                </xsl:choose>
              </inline>
            </block>
          </table-cell>
          <table-cell>
            <block text-align="right">
              <xsl:call-template name="getDate">
                <xsl:with-param name="date"
                  select="resume:PatentMilestone/resume:Date" />
              </xsl:call-template>
            </block>
          </table-cell>
        </table-row>
      </table-body>
    </table>
  </xsl:template>

  <xsl:template match="resume:PatentHistory">
    <block margin-bottom="25pt">
      <xsl:call-template name="getTitleBlock">
        <xsl:with-param name="title" select="string('Patents')" />
      </xsl:call-template>
      <xsl:for-each select="resume:Patent">
        <xsl:if test="position() &lt;= 3">
          <block font-size="90%" margin-bottom="10pt" margin-left="20pt">
            <block font-weight="bold" margin-bottom="5pt">
              <xsl:apply-templates select="resume:PatentDetail">
                <xsl:with-param name="link" select="resume:Link" />
              </xsl:apply-templates>
            </block>
            <block font-style="italic" margin-bottom="5pt">
              <xsl:value-of select="resume:PatentTitle" />
              <xsl:apply-templates select="resume:OrgName" />
            </block>
            <block margin-left="20pt" margin-bottom="15pt">
              <xsl:value-of select="resume:Description" />
            </block>
          </block>
        </xsl:if>
      </xsl:for-each>
    </block>
  </xsl:template>

  <xsl:template match="resume:PositionHistory">
    <block keep-with-previous="always">
      <block font-style="italic" margin-bottom="5pt">
        <xsl:value-of select="resume:Title" />
        <xsl:apply-templates select="resume:OrgName" />
      </block>
      <block keep-with-previous="always" margin-left="20pt" margin-bottom="15pt">
        <xsl:value-of select="resume:Description" />
        <block margin-left="20pt" margin-top="5pt">
          <list-block keep-with-previous="always">
            <xsl:for-each select="resume:Competency">
              <list-item>
                <list-item-label>
                  <block>&#x2022;</block>
                </list-item-label>
                <list-item-body>
                  <block margin-left="10pt">
                    <xsl:value-of select="@description" />
                  </block>
                </list-item-body>
              </list-item>
            </xsl:for-each>
            <list-item>
              <list-item-label>
                <block />
              </list-item-label>
              <list-item-body>
                <block />
              </list-item-body>
            </list-item>
          </list-block>
        </block>
      </block>
    </block>
  </xsl:template>

  <xsl:template match="resume:PostalAddress">
    <xsl:value-of select="resume:DeliveryAddress/resume:AddressLine" />
    <xsl:text>,&#x20;</xsl:text>
    <xsl:value-of select="resume:Municipality" />
    <xsl:text>,&#x20;</xsl:text>
    <xsl:value-of select="resume:Region" />
    <xsl:text>&#x20;</xsl:text>
    <xsl:value-of select="resume:PostalCode" />
  </xsl:template>

  <xsl:template match="resume:PostalAddress" mode="employer">
    <xsl:value-of select="resume:Municipality" />
    <xsl:text>,&#x20;</xsl:text>
    <xsl:value-of select="resume:Region" />
  </xsl:template>

  <xsl:template match="resume:PublicationHistory">
    <block margin-bottom="25pt">
      <xsl:call-template name="getTitleBlock">
        <xsl:with-param name="title" select="string('Publication Contributions')" />
      </xsl:call-template>
      <xsl:for-each select="resume:OtherPublication">
        <block font-size="90%" margin-bottom="10pt" margin-left="20pt">
          <block font-weight="bold" margin-bottom="5pt">
            <table table-layout="fixed" width="100%">
              <table-column column-width="75%" />
              <table-column column-width="25%" />
              <table-body>
                <table-row>
                  <table-cell>
                    <block margin-left="-20pt">
                      <xsl:call-template name="getLink">
                        <xsl:with-param name="link" select="resume:Link" />
                        <xsl:with-param name="text" select="resume:Title" />
                      </xsl:call-template>
                    </block>
                  </table-cell>
                  <table-cell>
                    <block text-align="right">
                      <xsl:call-template name="getDate">
                        <xsl:with-param name="date"
                          select="resume:PublicationDate/resume:AnyDate" />
                      </xsl:call-template>
                    </block>
                  </table-cell>
                </table-row>
              </table-body>
            </table>
          </block>
          <block margin-left="20pt" margin-bottom="15pt" keep-with-previous="always">
            <xsl:value-of select="resume:Comments" />
          </block>
        </block>
      </xsl:for-each>
    </block>
  </xsl:template>

  <xsl:template match="resume:Qualifications">
    <block margin-bottom="25pt">
      <xsl:call-template name="getTitleBlock">
        <xsl:with-param name="title" select="string('Qualifications')" />
      </xsl:call-template>
      <block font-size="90%" line-height="150%" margin-bottom="10pt" margin-left="20pt">
        <list-block>
          <xsl:for-each select="resume:Competency">
            <list-item>
              <list-item-label>
                <block font-size="150%">&#x2022;</block>
              </list-item-label>
              <list-item-body>
                <block margin-left="10pt">
                  <inline font-style="italic">
                    <xsl:value-of select="@name" />
                    <xsl:text>:&#x20;</xsl:text>
                  </inline>
                  <xsl:for-each select="resume:Competency">
                    <xsl:if test="position() > 1">,&#x20;</xsl:if>
                    <xsl:value-of select="@name" />
                  </xsl:for-each>
                </block>
              </list-item-body>
            </list-item>
          </xsl:for-each>
          <list-item>
            <list-item-label>
              <block />
            </list-item-label>
            <list-item-body>
              <block />
            </list-item-body>
          </list-item>
        </list-block>
      </block>
    </block>
  </xsl:template>

  <xsl:template match="resume:ResumeAdditionalItems">
    <block margin-bottom="25pt">
      <xsl:call-template name="getTitleBlock">
        <xsl:with-param name="title" select="string('Additional Items')" />
      </xsl:call-template>
      <block font-size="90%" line-height="150%" margin-bottom="10pt" margin-left="20pt"
        keep-with-previous="always">
        <list-block>
          <xsl:for-each select="resume:ResumeAdditionalItem">
            <list-item>
              <list-item-label>
                <block font-size="150%">&#x2022;</block>
              </list-item-label>
              <list-item-body>
                <block margin-left="10pt">
                  <xsl:value-of select="resume:Description" />
                </block>
              </list-item-body>
            </list-item>
          </xsl:for-each>
        </list-block>
      </block>
    </block>
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
    <xsl:param name="text" />
    <basic-link>
      <xsl:attribute name="external-destination">
        <xsl:value-of select="$link" />
      </xsl:attribute>
      <inline color="darkBlue">
        <xsl:value-of select="$text" />
      </inline>
    </basic-link>
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

  <xsl:template name="getTitleBlock">
    <xsl:param name="title" />
    <block-container border-bottom-style="solid" border-width=".5pt" margin-bottom="10pt">
      <block font-weight="bold">
        <xsl:value-of select="$title" />
      </block>
    </block-container>
  </xsl:template>
</xsl:stylesheet>
