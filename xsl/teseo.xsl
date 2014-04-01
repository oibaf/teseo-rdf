<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
 xmlns:skos="http://www.w3.org/2004/02/skos/core#"
 xmlns:skosxl="http://www.w3.org/2008/05/skos-xl#"
 version="1.0">
 
 <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
 <xsl:variable name="lns" select="'http://dati.senato.it/teseo/'"/>
 <xsl:variable name="lnsTes" select="concat($lns,'tes')"/>
 <xsl:variable name="lnsRegioni" select="concat($lns,'regioni')"/>
 <xsl:variable name="lnsProvince" select="concat($lns,'province')"/>
 <xsl:variable name="lnsComuni" select="concat($lns,'comuni')"/>
 <xsl:variable name="lnsNom" select="concat($lns,'nom')"/>
 
 <xsl:param name="xl" select="'both'"/>

 <xsl:template match="NOM">
  <rdf:Description rdf:about="{concat($lnsNom,'/',@id)}">
   <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
   
   <skos:inScheme rdf:resource="{$lnsNom}"/>
   
   <xsl:variable name="id" select="@id"/>
   <skos:topConceptOf rdf:resource="{$lnsNom}"/>
   <xsl:apply-templates/>
  </rdf:Description>
  
  <xsl:if test="$xl='yes' or $xl='both'">
   <xsl:if test="name">
    <rdf:Description rdf:about="{concat($lnsNom,'/','xl_it_',@id)}">
     <rdf:type rdf:resource="http://www.w3.org/2008/05/skos-xl#Label"/>
     <skosxl:literalForm xml:lang="it"><xsl:value-of select="name"/></skosxl:literalForm>
    </rdf:Description>
   </xsl:if>
  </xsl:if>
 </xsl:template>
 
 
 <xsl:template match="RP">
  <skos:narrower rdf:resource="{concat($lnsProvince,'/',.)}"/>
 </xsl:template>

 <xsl:template match="PC">
  <skos:narrower rdf:resource="{concat($lnsComuni,'/',.)}"/>
 </xsl:template>
 
 <xsl:template match="PR">
  <skos:broader rdf:resource="{concat($lnsRegioni,'/',.)}"/>
 </xsl:template>
 
 <xsl:template match="CP">
  <skos:broader rdf:resource="{concat($lnsProvince,'/',.)}"/>
 </xsl:template>
 
 <xsl:template match="GEO">
  <xsl:variable name="ns">
   <xsl:choose>
    <xsl:when test="RP"><xsl:value-of select="$lnsRegioni"/></xsl:when>
    <xsl:when test="PC"><xsl:value-of select="$lnsProvince"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="$lnsComuni"/></xsl:otherwise>
   </xsl:choose> 
  </xsl:variable>
 
  <rdf:Description rdf:about="{concat($ns,'/',@id)}">
   <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
   
   <skos:inScheme rdf:resource="{$ns}"/>
   <skos:topConceptOf rdf:resource="{$ns}"/>

   <xsl:apply-templates/>
  </rdf:Description>
  
  <xsl:if test="$xl='yes' or $xl='both'">
   <xsl:if test="name">
    <rdf:Description rdf:about="{concat($ns,'/','xl_it_',@id)}">
     <rdf:type rdf:resource="http://www.w3.org/2008/05/skos-xl#Label"/>
     <skosxl:literalForm xml:lang="it"><xsl:value-of select="name"/></skosxl:literalForm>
    </rdf:Description>
   </xsl:if>
  </xsl:if>
 </xsl:template>
 
 <xsl:template match="TES[US]" priority="2"/>

 <xsl:template match="TES[not(US)]">
  <rdf:Description rdf:about="{concat($lnsTes,'/',@id)}">
   <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
   <xsl:if test="@code">
    <skos:notation rdf:datatype="{concat($lns,'TeseoCode')}"><xsl:value-of select="@code"/></skos:notation>
   </xsl:if>
   
   <skos:inScheme rdf:resource="{$lnsTes}"/>
   
   <xsl:variable name="id" select="@id"/>
   <xsl:if test="../TES[TT=$id]">
    <skos:topConceptOf rdf:resource="{$lnsTes}"/>
   </xsl:if>
   <xsl:apply-templates/>
  </rdf:Description>
  
  <xsl:if test="$xl='yes' or $xl='both'">
   <xsl:if test="name">
    <rdf:Description rdf:about="{concat($lnsTes,'/','xl_it_',@id)}">
     <rdf:type rdf:resource="http://www.w3.org/2008/05/skos-xl#Label"/>
     <skosxl:literalForm xml:lang="it"><xsl:value-of select="name"/></skosxl:literalForm>
    </rdf:Description>
   </xsl:if>
   <xsl:for-each select="UF">
    <xsl:variable name="id" select="."/>
    <rdf:Description rdf:about="{concat($lnsTes,'/','xl_it_',$id)}">
     <rdf:type rdf:resource="http://www.w3.org/2008/05/skos-xl#altLabel"/>
     <skosxl:literalForm xml:lang="it"><xsl:value-of select="../../TES[@id=$id]/name"/></skosxl:literalForm>
    </rdf:Description>
   </xsl:for-each>
  </xsl:if>
  
 </xsl:template>
 
 <xsl:template match="name">
  <xsl:if test="$xl='no' or $xl='both'">
   <skos:prefLabel xml:lang="it"><xsl:value-of select="."/></skos:prefLabel>
  </xsl:if>
  <xsl:if test="$xl='yes' or $xl='both'">
   <skosxl:prefLabel rdf:resource="{concat($lnsTes,'/','xl_it_',../@id)}"/>
  </xsl:if> 
 </xsl:template>
 
 <xsl:template match="UF">
  <xsl:variable name="id" select="."/>
  <xsl:if test="$xl='no' or $xl='both'">
   <skos:altLabel xml:lang="it"><xsl:value-of select="../../TES[@id=$id]/name"/></skos:altLabel>
  </xsl:if> 
  <xsl:if test="$xl='yes' or $xl='both'">
   <skosxl:altLabel rdf:resource="{concat($lnsTes,'/','xl_it_',$id)}"/>
  </xsl:if> 
 </xsl:template>
 
 <xsl:template match="TT"/>
 <!-- 
 <xsl:template match="TT">
  <xsl:variable name="id" select="."/>
  <xsl:if test="not(../BT[.=$id])">
   <skos:broaderTransitive rdf:resource="{concat($lnsTes,'/',.)}"/>
  </xsl:if> 
 </xsl:template>
 -->

 <xsl:template match="BT">
  <skos:broader rdf:resource="{concat($lnsTes,'/',.)}"/>
 </xsl:template>

 <xsl:template match="NT">
  <skos:narrower rdf:resource="{concat($lnsTes,'/',.)}"/>
 </xsl:template>

 <xsl:template match="RT">
  <skos:related rdf:resource="{concat($lnsTes,'/',.)}"/>
 </xsl:template>

 <xsl:template match="note">
  <skos:note xml:lang="it"><xsl:value-of select="."/></skos:note>
 </xsl:template>
 
 <xsl:template match="/">
  
  <rdf:RDF 
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
   xmlns:skos="http://www.w3.org/2004/02/skos/core#">

   <rdf:Description rdf:about="{$lnsTes}">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
    <xsl:for-each select="*/TES[@id=/*/TES/TT]">
     <skos:hasTopConcept rdf:resource="{concat($lnsTes,'/',@id)}"/>
    </xsl:for-each>
   </rdf:Description>

   <rdf:Description rdf:about="{$lnsRegioni}">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
    <xsl:for-each select="*/GEO[RP]">
     <skos:hasTopConcept rdf:resource="{concat($lnsRegioni,'/',@id)}"/>
    </xsl:for-each>
   </rdf:Description>

   <rdf:Description rdf:about="{$lnsProvince}">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
    <xsl:for-each select="*/GEO[PC]">
     <skos:hasTopConcept rdf:resource="{concat($lnsProvince,'/',@id)}"/>
    </xsl:for-each>
   </rdf:Description>

   <rdf:Description rdf:about="{$lnsComuni}">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
    <xsl:for-each select="*/GEO[CP]">
     <skos:hasTopConcept rdf:resource="{concat($lnsComuni,'/',@id)}"/>
    </xsl:for-each>
   </rdf:Description>
   
   <rdf:Description rdf:about="{$lnsNom}">
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>
    <xsl:for-each select="*/NOM">
     <skos:hasTopConcept rdf:resource="{concat($lnsNom,'/',@id)}"/>
    </xsl:for-each>
   </rdf:Description>
   
   <xsl:apply-templates/>
    
  </rdf:RDF> 
  
 </xsl:template>
 
</xsl:stylesheet>
 