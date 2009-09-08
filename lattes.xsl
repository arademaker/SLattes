<?xml version="1.0"?>

<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
		xmlns:foaf="http://xmlns.com/foaf/0.1/" 
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:dcterms="http://purl.org/dc/terms/"
		xmlns:swrc="http://swrc.ontoware.org/ontology" 
		xmlns:lattes="http://www.cnpq.br/2001/XSL/Lattes">

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates />
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="DADOS-BASICOS-DO-ARTIGO">
    <dc:title> <xsl:value-of select="@TITULO-DO-ARTIGO" /> </dc:title>
    <dcterms:issued>  <xsl:value-of select="@ANO-DO-ARTIGO" /> </dcterms:issued>
    <dc:language> <xsl:value-of select="@IDIOMA"/> </dc:language>
  </xsl:template>

<!--         <DETALHAMENTO-DO-ARTIGO TITULO-DO-PERIODICO-OU-REVISTA="Econometrica" -->
<!--         ISSN="00129682" VOLUME="53" FASCICULO="2" SERIE="" -->
<!--         PAGINA-INICIAL="455" PAGINA-FINAL="461" -->
<!--         LOCAL-DE-PUBLICACAO="Estados Unidos" /> -->

  <xsl:template match="DETALHAMENTO-DO-ARTIGO">
    <dcterms:isPartOf>
      <rdf:Description>
	<xsl:choose>
	<xsl:when test="string-length(@ISSN)>0">
	  <xsl:attribute name="rdf:about"> <xsl:value-of select="concat('urn:ISSN:',@ISSN)"/> </xsl:attribute>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="rdf:nodeID"> <xsl:value-of select="generate-id()"/> </xsl:attribute>
	</xsl:otherwise>
	</xsl:choose>
	<dc:title> <xsl:value-of select="@TITULO-DO-PERIODICO-OU-REVISTA"/> </dc:title>
      </rdf:Description>
    </dcterms:isPartOf>
    <swrc:pages> <xsl:value-of select="concat(@PAGINA-INICIAL,'-',@PAGINA-FINAL)"/> </swrc:pages>
    <swrc:volume> <xsl:value-of select="@VOLUME"/> </swrc:volume>
  </xsl:template>

  <xsl:template match="AUTORES">
    <dc:creator>
      <rdf:Description rdf:nodeID="{generate-id()}">
	<foaf:name> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/> </foaf:name>
	<foaf:citation-name> <xsl:value-of select="@NOME-PARA-CITACAO"/> </foaf:citation-name>
	<rdfs:label> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR" /> </rdfs:label>
	<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Agent" />
      </rdf:Description>
    </dc:creator>
  </xsl:template>

  <xsl:template match="ARTIGO-PUBLICADO|ARTIGO-ACEITO-PARA-PUBLICACAO">
    <rdf:Description rdf:about="P{@SEQUENCIA-PRODUCAO}">
      <!-- <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document" /> -->
      <rdf:type rdf:resource="http://swrc.ontoware.org/ontology#Article" />
      <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
      <rdfs:label> <xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO" /> </rdfs:label>

      <xsl:apply-templates />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="text()|@*">
  </xsl:template>

</xsl:stylesheet>
