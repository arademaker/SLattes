<?xml version="1.0" encoding="ISO-8859-1"?>

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
  
  <xsl:template name="LINGUA">
  <xsl:param name="Idioma"></xsl:param>
  <dc:language> <xsl:choose>
    <xsl:when test="$Idioma='Português'">
      PT
    </xsl:when>
    <xsl:when test="$Idioma='Inglês'">
      EN
    </xsl:when>
    <xsl:when test="$Idioma='Espanhol'">
      ES
    </xsl:when>
    <xsl:when test="$Idioma='Francês'">
      FR
    </xsl:when>
 <!-- Outros idiomas podem ser contemplados segundo ISO 639/> -->
    <xsl:otherwise>
      Outros
    </xsl:otherwise>
    </xsl:choose>
    </dc:language>
</xsl:template>


  <xsl:template match="DADOS-BASICOS-DO-ARTIGO">
    <dc:title> <xsl:value-of select="@TITULO-DO-ARTIGO" /> </dc:title>
    <dcterms:issued>  <xsl:value-of select="@ANO-DO-ARTIGO" /> </dcterms:issued>
    <xsl:call-template name="LINGUA">
      <xsl:with-param name="Idioma" select="@IDIOMA"></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

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

  <xsl:template match="CAPITULO-DE-LIVRO-PUBLICADO/AUTORES">
    <dc:creator>
      <rdf:Description rdf:nodeID="{generate-id()}">
	<foaf:name> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/> </foaf:name>
	<foaf:citation-name> <xsl:value-of select="@NOME-PARA-CITACAO"/> </foaf:citation-name>
	<rdfs:label> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR" /> </rdfs:label>
	<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Agent" />
      </rdf:Description>
    </dc:creator>
  </xsl:template>
  
  <xsl:template match="ARTIGO-PUBLICADO/AUTORES">
    <dc:creator>
      <rdf:Description rdf:nodeID="{generate-id()}">
	<foaf:name> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/> </foaf:name>
	<foaf:citation-name> <xsl:value-of select="@NOME-PARA-CITACAO"/> </foaf:citation-name>
	<rdfs:label> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR" /> </rdfs:label>
	<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Agent" />
      </rdf:Description>
    </dc:creator>
  </xsl:template>
  
  <xsl:template match="ARTIGO-ACEITO-PARA-PUBLICACAO/AUTORES">
    <dc:creator>
      <rdf:Description rdf:nodeID="{generate-id()}">
	<foaf:name> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/> </foaf:name>
	<foaf:citation-name> <xsl:value-of select="@NOME-PARA-CITACAO"/> </foaf:citation-name>
	<rdfs:label> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR" /> </rdfs:label>
	<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Agent" />
      </rdf:Description>
    </dc:creator>
  </xsl:template>
  
  <xsl:template match="LIVRO-PUBLICADO-OU-ORGANIZADO/AUTORES">
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
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <!-- <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document" /> -->
      <rdf:type rdf:resource="http://swrc.ontoware.org/ontology#Article" />
      <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
      <rdfs:label> <xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO" /> </rdfs:label>
      <xsl:apply-templates />
    </rdf:Description>
  </xsl:template>
      
  <xsl:template match="LIVRO-PUBLICADO-OU-ORGANIZADO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <!-- <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document" /> -->
      <rdf:type rdf:resource="http://swrc.ontoware.org/ontology#Book" />
      <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
      <rdfs:label> <xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@TITULO-DO-LIVRO" /> </rdfs:label>
      <dc:title> <xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@TITULO-DO-LIVRO" /> </dc:title>
      <dcterms:issued>  <xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@ANO" /> </dcterms:issued>
    <xsl:call-template name="LINGUA">
      <xsl:with-param name="Idioma" select="DADOS-BASICOS-DO-LIVRO/@IDIOMA"></xsl:with-param>
    </xsl:call-template>
       <dc:publisher> <xsl:value-of select="DETALHAMENTO-DO-LIVRO/@NOME-DA-EDITORA" /> </dc:publisher>
      <xsl:apply-templates />
    </rdf:Description>
  </xsl:template>
  
   <xsl:template match="CAPITULO-DE-LIVRO-PUBLICADO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <!-- <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document" /> -->
      <rdf:type rdf:resource="http://swrc.ontoware.org/ontology#InBook" />
      <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
      <rdfs:label> <xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@TITULO-DO-CAPITULO-DO-LIVRO" /> </rdfs:label>
      <dc:title> <xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@TITULO-DO-CAPITULO-DO-LIVRO" /> </dc:title>
      <dcterms:issued>  <xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@ANO" /> </dcterms:issued>
    <xsl:call-template name="LINGUA">
      <xsl:with-param name="Idioma" select="DADOS-BASICOS-DO-CAPITULO/@IDIOMA"></xsl:with-param>
    </xsl:call-template>
       <dcterms:isPartOf> 
         <rdf:Description>
            <dc:title> <xsl:value-of select="DETALHAMENTO-DO-CAPITULO/@TITULO-DO-LIVRO" /> </dc:title>
         </rdf:Description>
       </dcterms:isPartOf>
      <xsl:apply-templates />
    </rdf:Description>
  </xsl:template>


  <xsl:template match="text()|@*">
  </xsl:template>

</xsl:stylesheet>
