<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
		xmlns:foaf="http://xmlns.com/foaf/0.1/" 
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:dcterms="http://purl.org/dc/terms/"
		xmlns:swrc="http://swrc.ontoware.org/ontology#" 
		xmlns:bibo="http://purl.org/ontology/bibo/" 
		xmlns:lattes="http://www.cnpq.br/2001/XSL/Lattes">

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates />
    </rdf:RDF>
  </xsl:template>
  
  <xsl:template match="CURRICULO-VITAE">       
     <xsl:apply-templates>
        <xsl:with-param name="data" select="DADOS-GERAIS/@NOME-COMPLETO"></xsl:with-param>
     </xsl:apply-templates> 
  </xsl:template>
  
  <xsl:template name="LINGUA">
  <xsl:param name="Idioma"></xsl:param>
  <dc:language> <xsl:choose>
    <xsl:when test="$Idioma='Português'">
      <xsl:text>PT</xsl:text>
    </xsl:when>
    <xsl:when test="$Idioma='Inglês'">
      <xsl:text>EN</xsl:text>
    </xsl:when>
    <xsl:when test="$Idioma='Espanhol'">
      <xsl:text>ES</xsl:text>
    </xsl:when>
    <xsl:when test="$Idioma='Francês'">
      <xsl:text>FR</xsl:text>
    </xsl:when>
    <!-- Outros idiomas podem ser contemplados segundo ISO 639/> -->
    <xsl:otherwise>
      <xsl:text>Other</xsl:text>
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
	<xsl:if test="string-length(@ISSN)>0">
	  <xsl:attribute name="rdf:about"> <xsl:value-of select="concat('urn:ISSN:',@ISSN)"/> </xsl:attribute>
	</xsl:if>
	<rdf:type rdf:resource="http://purl.org/ontology/bibo/Journal" />
	<dc:title> <xsl:value-of select="@TITULO-DO-PERIODICO-OU-REVISTA"/> </dc:title>
	<rdfs:label> <xsl:value-of select="@TITULO-DO-PERIODICO-OU-REVISTA"/> </rdfs:label>
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
    <xsl:param name="data">NoValue</xsl:param>
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <!-- <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document" /> -->
      <rdf:type rdf:resource="http://swrc.ontoware.org/ontology#Article" />
      <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
      <rdfs:label> <xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO" /> </rdfs:label>
      <dc:source><xsl:value-of select="$data"/></dc:source> 
      <xsl:apply-templates />
    </rdf:Description>
  </xsl:template>
      
  <xsl:template match="LIVRO-PUBLICADO-OU-ORGANIZADO">
    <xsl:param name="data">NoValue</xsl:param>
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <!-- <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document" /> -->
      <!-- <rdf:type rdf:resource="http://swrc.ontoware.org/ontology#Book" /> -->
      <rdf:type rdf:resource="http://purl.org/ontology/bibo/Book" />
      <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
      <rdfs:label> <xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@TITULO-DO-LIVRO" /> </rdfs:label>
      <dc:title> <xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@TITULO-DO-LIVRO" /> </dc:title>
      <dc:source><xsl:value-of select="$data"/></dc:source> 
      <dcterms:issued>  <xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@ANO" /> </dcterms:issued>
    <xsl:call-template name="LINGUA">
      <xsl:with-param name="Idioma" select="DADOS-BASICOS-DO-LIVRO/@IDIOMA"></xsl:with-param>
    </xsl:call-template>
       <dcterms:publisher> <xsl:value-of select="DETALHAMENTO-DO-LIVRO/@NOME-DA-EDITORA" /> </dcterms:publisher>
      <xsl:apply-templates />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="DETALHAMENTO-DO-CAPITULO">
    <rdf:Description>
      <xsl:if test="string-length(@ISBN)>0">
	<xsl:attribute name="rdf:about"> <xsl:value-of select="concat('urn:ISBN:',@ISBN)"/> </xsl:attribute>
      </xsl:if>
      
      <rdfs:label> <xsl:value-of select="@TITULO-DO-LIVRO" /> </rdfs:label>
      <dc:title> <xsl:value-of select="@TITULO-DO-LIVRO" /> </dc:title>
      <rdf:type rdf:resource="http://purl.org/ontology/bibo/Book" />
      <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
      <bibo:isbn> <xsl:value-of select="@ISBN"/> </bibo:isbn>
      <dcterms:publisher> <xsl:value-of select="@NOME-DA-EDITORA"/> </dcterms:publisher>
    </rdf:Description>
  </xsl:template>
  
  <xsl:template match="CAPITULO-DE-LIVRO-PUBLICADO">
    <xsl:param name="data">NoValue</xsl:param>
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <!-- <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document" /> -->
      <rdf:type rdf:resource="http://swrc.ontoware.org/ontology#InBook" />
      <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
      <rdfs:label> <xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@TITULO-DO-CAPITULO-DO-LIVRO" /> </rdfs:label>
      <dc:title> <xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@TITULO-DO-CAPITULO-DO-LIVRO" /> </dc:title>
      <dc:source><xsl:value-of select="$data"/></dc:source>
      <dcterms:issued>  <xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@ANO" /> </dcterms:issued>
      <xsl:call-template name="LINGUA">
	<xsl:with-param name="Idioma" select="DADOS-BASICOS-DO-CAPITULO/@IDIOMA"></xsl:with-param>
      </xsl:call-template>
      <dcterms:isPartOf> 
	<xsl:apply-templates select="DETALHAMENTO-DO-CAPITULO" />
      </dcterms:isPartOf>
      <xsl:apply-templates select="AUTORES" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="text()|@*">
  </xsl:template>

</xsl:stylesheet>
