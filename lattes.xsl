<?xml version="1.0"?>

<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
		xmlns:foaf="http://xmlns.com/foaf/0.1/" 
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:swrc="http://swrc.ontoware.org/ontology" 
		xmlns:lattes="http://www.cnpq.br/2001/XSL/Lattes">

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates />
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO">
    <dc:title> <xsl:value-of select="@TITULO-DO-ARTIGO" /> </dc:title>
  </xsl:template>

  <xsl:template match="DADOS-BASICOS-DO-ARTIGO/@ANO-DO-ARTIGO">
    <dc:date>  <xsl:value-of select="@ANO-DO-ARTIGO" /> </dc:date>
  </xsl:template>

  <xsl:template match="DADOS-BASICOS-DO-ARTIGO">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="DETALHAMENTO-DO-ARTIGO">
    <xsl:apply-templates />
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

  <xsl:template match="ARTIGO-PUBLICADO">
    <rdf:Description rdf:about="P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document" />
      <rdf:type rdf:resource="http://swrc.ontoware.org/ontology#Article" />
      <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
      <rdfs:label> <xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO" /> </rdfs:label>

      <xsl:apply-templates />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="text()|@*">
  </xsl:template>

</xsl:stylesheet>
