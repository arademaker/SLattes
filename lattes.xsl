<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE rdf:RDF [
 <!ENTITY  xsd "http://www.w3.org/2001/XMLSchema#"> 
 <!ENTITY bibo "http://purl.org/ontology/bibo/">
 <!ENTITY swrc "http://swrc.ontoware.org/ontology#">
 <!ENTITY foaf "http://xmlns.com/foaf/0.1/">
 <!ENTITY  geo "http://www.w3.org/2003/01/geo/wgs84_pos#"> 
 <!ENTITY skos "http://www.w3.org/2004/02/skos/core#">
 <!ENTITY doac "http://ramonantonio.net/doac/0.1/">
 <!ENTITY bio  "http://purl.org/vocab/bio/0.1/">
]>

<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:bio="http://purl.org/vocab/bio/0.1/" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
		xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
		xmlns:foaf="http://xmlns.com/foaf/0.1/" 
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:doac="http://ramonantonio.net/doac/0.1/" 
		xmlns:dcterms="http://purl.org/dc/terms/"
		xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
		xmlns:swrc="http://swrc.ontoware.org/ontology#" 
		xmlns:event="http://purl.org/NET/c4dm/event.owl#" 
		xmlns:gn="http://www.geonames.org/ontology#" 
		xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" 
		xmlns:bibo="http://purl.org/ontology/bibo/" 
		xmlns:lattes="http://www.cnpq.br/2001/XSL/Lattes">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/> 

  <xsl:param name="ID">unknown</xsl:param>

  <xsl:variable name="authorCV">
    <xsl:choose>
      <xsl:when test="string-length(CURRICULO-VITAE/DADOS-GERAIS/ENDERECO/ENDERECO-PROFISSIONAL/@E-MAIL)>0">
	<xsl:value-of select="concat('mailto:',CURRICULO-VITAE/DADOS-GERAIS/ENDERECO/ENDERECO-PROFISSIONAL/@E-MAIL)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="generate-id()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:attribute name="xml:base"><xsl:value-of select="concat('http://www.fgv.br/lattes/',$ID)"/></xsl:attribute>
      <xsl:apply-templates />

      <xsl:apply-templates select="//AUTORES" mode="autores"/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="AUTORES" mode="autores">
    <rdf:Description>
      <xsl:attribute name="rdf:about">
	<xsl:value-of select="concat('#author/',generate-id(.))"/>
      </xsl:attribute>
      <xsl:if test="normalize-space(@NRO-ID-CNPQ) != ''">
	<foaf:identifier><xsl:value-of select="@NRO-ID-CNPQ"/></foaf:identifier>
      </xsl:if>
      <foaf:name><xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/></foaf:name>
      <foaf:citationName><xsl:value-of select="@NOME-PARA-CITACAO"/></foaf:citationName>
      <rdf:type rdf:resource="&foaf;Agent" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="CURRICULO-VITAE">
    <rdf:Description rdf:about="">
      <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document" />
      <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
      <dc:title>CV Lattes de <xsl:value-of select="DADOS-GERAIS/@NOME-COMPLETO"/></dc:title>
      <xsl:choose>
	<xsl:when test="@NUMERO-IDENTIFICADOR">
	  <bibo:identifier> <xsl:value-of select="@NUMERO-IDENTIFICADOR"/> </bibo:identifier>
	</xsl:when>
	<xsl:otherwise>
	  <bibo:identifier> <xsl:value-of select="$ID"/> </bibo:identifier>
	</xsl:otherwise>
      </xsl:choose>
      <dcterms:issued> <xsl:value-of select="@DATA-ATUALIZACAO" /> </dcterms:issued>
      <dc:creator> 
	<xsl:apply-templates select="DADOS-GERAIS"/> 
      </dc:creator>
    </rdf:Description>
    <xsl:apply-templates select="PRODUCAO-BIBLIOGRAFICA|OUTRA-PRODUCAO" />
  </xsl:template>

  <xsl:template match="DADOS-GERAIS">
    <rdf:Description rdf:about="{$authorCV}">
      <foaf:identifier><xsl:value-of select="$authorCV"/></foaf:identifier>
      <rdf:type rdf:resource="&foaf;Agent" />
      <foaf:gender><xsl:value-of select="@SEXO"/></foaf:gender>
      <bio:event>
	<bio:Birth>
	  <bio:date><xsl:value-of select="@DATA-NASCIMENTO"/></bio:date>
	  <bio:place><xsl:value-of select="@CIDADE-NASCIMENTO"/></bio:place>
	  <bio:place><xsl:value-of select="@PAIS-DE-NASCIMENTO"/></bio:place>
	</bio:Birth>
      </bio:event>
      <foaf:name><xsl:value-of select="@NOME-COMPLETO"/></foaf:name>
      <!-- DOES NOT REALLY EXISTS IN FOAF-->
      <foaf:citationName><xsl:value-of select="@NOME-EM-CITACOES-BIBLIOGRAFICAS"/></foaf:citationName>
      <foaf:mbox><xsl:value-of select="ENDERECO/ENDERECO-PROFISSIONAL/@E-MAIL"/></foaf:mbox>
      <xsl:apply-templates select="ENDERECO/ENDERECO-PROFISSIONAL/@HOME-PAGE"/> 
      <xsl:apply-templates select="AREAS-DE-ATUACAO" />
      <xsl:apply-templates select="IDIOMAS" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="AREAS-DE-ATUACAO|IDIOMAS">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="IDIOMA">
    <doac:skill>
      <doac:LanguageSkill>
	<doac:language><xsl:value-of select="@IDIOMA"/></doac:language>
	<doac:language><xsl:value-of select="@DESCRICAO-DO-IDIOMA"/></doac:language>
	<doac:reads><xsl:value-of select="@PROFICIENCIA-DE-LEITURA"/></doac:reads>
	<doac:speaks><xsl:value-of select="@PROFICIENCIA-DE-FALA"/></doac:speaks>
	<doac:writes><xsl:value-of select="@PROFICIENCIA-DE-ESCRITA"/></doac:writes>
	<!-- DOES NOT REALLY EXISTS IN DOAC -->
	<doac:comprehension><xsl:value-of select="@PROFICIENCIA-DE-COMPREENSAO"/></doac:comprehension>
      </doac:LanguageSkill>
    </doac:skill>
  </xsl:template>

  <xsl:template match="AREA-DE-ATUACAO">
    <foaf:topic_interest>
      <xsl:choose>
	<xsl:when test="normalize-space(@NOME-DA-ESPECIALIDADE) != ''">
	  <skos:Concept rdf:nodeID="{generate-id(@NOME-DA-ESPECIALIDADE)}">
	    <skos:prefLabel><xsl:value-of select="@NOME-DA-ESPECIALIDADE"/></skos:prefLabel>
	    <skos:related>
	      <skos:Concept rdf:nodeID="{generate-id(@NOME-DA-SUB-AREA-DO-CONHECIMENTO)}">
		<skos:prefLabel><xsl:value-of select="@NOME-DA-SUB-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		<skos:narrower>
		  <skos:Concept rdf:nodeID="{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		    <skos:prefLabel><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		    <skos:narrower>
		      <skos:Concept rdf:nodeID="{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
			<skos:prefLabel>
			  <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
			</skos:prefLabel>
		      </skos:Concept>
		    </skos:narrower>
		  </skos:Concept>
		</skos:narrower>
	      </skos:Concept>
	    </skos:related>
	  </skos:Concept>
	</xsl:when>
	<xsl:otherwise>
	  <skos:Concept rdf:nodeID="{generate-id(@NOME-DA-SUB-AREA-DO-CONHECIMENTO)}">
	    <skos:prefLabel><xsl:value-of select="@NOME-DA-SUB-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
	    <skos:narrower>
	      <skos:Concept rdf:nodeID="{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		<skos:prefLabel><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		<skos:narrower>
		  <skos:Concept rdf:nodeID="{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
		    <skos:prefLabel>
		      <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
		    </skos:prefLabel>
		  </skos:Concept>
		</skos:narrower>
	      </skos:Concept>
	    </skos:narrower>
	  </skos:Concept>
	</xsl:otherwise>
      </xsl:choose>
    </foaf:topic_interest>
  </xsl:template>
   
  <xsl:template match="TRABALHO-EM-EVENTOS/AUTORES|ARTIGO-PUBLICADO/AUTORES|ARTIGO-ACEITO-PARA-PUBLICACAO/AUTORES|
                       LIVRO-PUBLICADO-OU-ORGANIZADO/AUTORES|CAPITULO-DE-LIVRO-PUBLICADO/AUTORES">
    <dc:creator>
      <xsl:attribute name="rdf:resource">
	<xsl:value-of select="concat('#author/',generate-id(.))"/>
      </xsl:attribute>
    </dc:creator>
  </xsl:template>

  <xsl:template match="TRABALHO-EM-EVENTOS">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&swrc;InProceedings" />
      <rdf:type rdf:resource="&bibo;Article" />
      <dc:title><xsl:value-of select="DADOS-BASICOS-DO-TRABALHO/@TITULO-DO-TRABALHO" /></dc:title>
      <dcterms:issued><xsl:value-of select="DADOS-BASICOS-DO-TRABALHO/@ANO-DO-TRABALHO" /></dcterms:issued>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TRABALHO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TRABALHO/@HOME-PAGE-DO-TRABALHO"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TRABALHO/@DOI"/>

      <bibo:presentedAt>
	<rdf:Description dc:title="{DETALHAMENTO-DO-TRABALHO/@NOME-DO-EVENTO}">
	  <rdf:type rdf:resource="&bibo;Conference"/>
	  <event:place>
	    <rdf:Description gn:name="{DETALHAMENTO-DO-TRABALHO/@CIDADE-DO-EVENTO}"
			     gn:countrycode="{DADOS-BASICOS-DO-TRABALHO/@PAIS-DO-EVENTO}">
	      <rdf:type rdf:resource="&geo;SpatialThing" />
	    </rdf:Description>
	  </event:place>
	</rdf:Description>
      </bibo:presentedAt>

      <dcterms:isPartOf>
	<rdf:Description>
	  <xsl:if test="string-length(DETALHAMENTO-DO-TRABALHO/@ISBN)>0">
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('urn:ISBN:',translate(DETALHAMENTO-DO-TRABALHO/@ISBN,' ','-'))"/>
	    </xsl:attribute>
	  </xsl:if>
	  <rdf:type rdf:resource="&bibo;Proceedings"/>
	  <xsl:apply-templates select="DETALHAMENTO-DO-TRABALHO/@ISBN"/>
	  <dc:title><xsl:value-of select="DETALHAMENTO-DO-TRABALHO/@TITULO-DOS-ANAIS-OU-PROCEEDINGS"/></dc:title>
	  <dcterms:issued><xsl:value-of select="DADOS-BASICOS-DO-TRABALHO/@ANO-DO-TRABALHO"/></dcterms:issued>
	  <xsl:if test="string-length(DETALHAMENTO-DO-TRABALHO/@NOME-DA-EDITORA)>0">
	    <dcterms:publisher>
	      <foaf:Organization foaf:name="{DETALHAMENTO-DO-TRABALHO/@NOME-DA-EDITORA}" />
	    </dcterms:publisher>
	  </xsl:if>
	</rdf:Description>
      </dcterms:isPartOf>

      <xsl:apply-templates select="AUTORES" />
      <bibo:authorList rdf:parseType="Collection">
	<xsl:for-each select="AUTORES">
	  <xsl:sort data-type="number" select="@ORDEM-DE-AUTORIA"/>
	  <rdf:Description>
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('#author/',generate-id(.))"/>
	    </xsl:attribute>
	  </rdf:Description>
	</xsl:for-each>
      </bibo:authorList>
      
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="DETALHAMENTO-DO-ARTIGO">
    <dcterms:isPartOf>
      <rdf:Description>
	<xsl:if test="string-length(@ISSN)>0">
	  <xsl:attribute name="rdf:about"> <xsl:value-of select="concat('urn:ISSN:',translate(@ISSN,' ','-'))"/> </xsl:attribute>
	  <bibo:issn> <xsl:value-of select="@ISSN"/> </bibo:issn>
	</xsl:if>
	<rdf:type rdf:resource="&bibo;Journal" />
	<dc:title> <xsl:value-of select="@TITULO-DO-PERIODICO-OU-REVISTA"/> </dc:title>
      </rdf:Description>
    </dcterms:isPartOf>
    <xsl:if test="normalize-space(@PAGINA-INICIAL) != ''">
      <bibo:pageStart><xsl:value-of select="@PAGINA-INICIAL"/></bibo:pageStart> 
    </xsl:if>
    <xsl:if test="normalize-space(@PAGINA-FINAL) != ''">
      <bibo:pageStart><xsl:value-of select="@PAGINA-FINAL"/></bibo:pageStart> 
    </xsl:if>
    <xsl:if test="string-length(@VOLUME)>0">
      <bibo:volume> <xsl:value-of select="@VOLUME"/> </bibo:volume>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ARTIGO-PUBLICADO|ARTIGO-ACEITO-PARA-PUBLICACAO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Article" />
      <dc:title><xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO" /></dc:title>
      <dcterms:issued><xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@ANO-DO-ARTIGO" /></dcterms:issued>
      <xsl:apply-templates select="DADOS-BASICOS-DO-ARTIGO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-ARTIGO/@HOME-PAGE-DO-TRABALHO"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-ARTIGO/@DOI"/>

      <xsl:apply-templates select="AUTORES|DETALHAMENTO-DO-ARTIGO" />
      <bibo:authorList rdf:parseType="Collection">
	<xsl:for-each select="AUTORES">
	  <xsl:sort data-type="number" select="@ORDEM-DE-AUTORIA"/>
	  <rdf:Description>
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('#author/',generate-id(.))"/>
	    </xsl:attribute>
	  </rdf:Description>
	</xsl:for-each>
      </bibo:authorList>

      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="LIVRO-PUBLICADO-OU-ORGANIZADO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Book" />
      <dc:title> <xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@TITULO-DO-LIVRO" /> </dc:title>
      <dcterms:issued>  <xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@ANO" /> </dcterms:issued>
      <xsl:if test="string-length(DETALHAMENTO-DO-LIVRO/@NOME-DA-EDITORA)>0">
      <dcterms:publisher rdf:parseType="Resource">
	  <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	  <foaf:name><xsl:value-of select="DETALHAMENTO-DO-LIVRO/@NOME-DA-EDITORA" /></foaf:name>
      </dcterms:publisher>
      </xsl:if>
      <xsl:apply-templates select="AUTORES" />
      <bibo:authorList rdf:parseType="Collection">
	<xsl:for-each select="AUTORES">
	  <xsl:sort data-type="number" select="@ORDEM-DE-AUTORIA"/>
	  <rdf:Description>
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('#author/',generate-id(.))"/>
	    </xsl:attribute>
	  </rdf:Description>
	</xsl:for-each>
      </bibo:authorList>

      <xsl:apply-templates select="DADOS-BASICOS-DO-LIVRO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-LIVRO/@DOI"/>
      <xsl:apply-templates select="DETALHAMENTO-DO-LIVRO/@ISBN"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-LIVRO/@HOME-PAGE-DO-TRABALHO"/>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="DETALHAMENTO-DO-CAPITULO">
    <rdf:Description>
      <xsl:if test="string-length(@ISBN)>0">
	<xsl:attribute name="rdf:about"> <xsl:value-of select="concat('urn:ISBN:',translate(@ISBN,' ','-'))"/> </xsl:attribute>
      </xsl:if>
      <rdf:type rdf:resource="&bibo;Book" />
      <dc:title> <xsl:value-of select="@TITULO-DO-LIVRO" /> </dc:title>
      <xsl:apply-templates select="@ISBN"/>
      <xsl:if test="string-length(@NOME-DA-EDITORA)>0">
	<dcterms:publisher rdf:parseType="Resource">
	  <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	  <foaf:name><xsl:value-of select="@NOME-DA-EDITORA"/></foaf:name>
	</dcterms:publisher>
      </xsl:if>
    </rdf:Description>
  </xsl:template>
  
  <xsl:template match="CAPITULO-DE-LIVRO-PUBLICADO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Chapter" />
      <dc:title> <xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@TITULO-DO-CAPITULO-DO-LIVRO" /> </dc:title>
      <dcterms:issued>  <xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@ANO" /> </dcterms:issued>
      <dcterms:isPartOf> 
	<xsl:apply-templates select="DETALHAMENTO-DO-CAPITULO" />
      </dcterms:isPartOf>

      <xsl:apply-templates select="AUTORES" />
      <bibo:authorList rdf:parseType="Collection">
	<xsl:for-each select="AUTORES">
	  <xsl:sort data-type="number" select="@ORDEM-DE-AUTORIA"/>
	  <rdf:Description>
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('#author/',generate-id(.))"/>
	    </xsl:attribute>
	  </rdf:Description>
	</xsl:for-each>
      </bibo:authorList>

      <xsl:apply-templates select="DADOS-BASICOS-DO-CAPITULO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-CAPITULO/@DOI"/>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="OUTRA-PRODUCAO">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="ORIENTACOES-CONCLUIDAS">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="ORIENTACOES-CONCLUIDAS-PARA-MESTRADO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Thesis" />
      <dc:title><xsl:value-of select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@TITULO" /></dc:title>
      <bibo:degree rdf:resource="&bibo;degrees/ms" /> 
      <dcterms:issued><xsl:value-of select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@ANO"/></dcterms:issued>
      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@HOME-PAGE"/>
      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@IDIOMA"/>
      <bibo:issuer> 
	<rdf:Description rdf:about="#I{DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@CODIGO-INSTITUICAO}">
	  <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	  <foaf:name><xsl:value-of select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@NOME-DA-INSTITUICAO"/></foaf:name>
	  <xsl:if test="string-length(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@CODIGO-INSTITUICAO)>0">
	    <foaf:identifier>
	      <xsl:value-of select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@CODIGO-INSTITUICAO"/>
	    </foaf:identifier>
	  </xsl:if>
	</rdf:Description>
      </bibo:issuer>
      <dc:creator>
	<rdf:Description foaf:name="{DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@NOME-DO-ORIENTADO}">
	  <xsl:if test="normalize-space(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@NUMERO-ID-ORIENTADO) != ''">
	    <foaf:identifier>
	      <xsl:value-of select="normalize-space(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@NUMERO-ID-ORIENTADO)"/>
	    </foaf:identifier>
	  </xsl:if>
	  <rdf:type rdf:resource="&foaf;Agent" />
	</rdf:Description>
      </dc:creator>
      <dc:contributor rdf:resource="{$authorCV}"/>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Thesis" />
      <bibo:degree rdf:resource="&bibo;degrees/phd" /> 
      <dc:title><xsl:value-of select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@TITULO" /></dc:title>
      <dcterms:issued><xsl:value-of select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@ANO" /></dcterms:issued>
      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@HOME-PAGE"/>
      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@IDIOMA"/>
      <bibo:issuer> 
	<rdf:Description rdf:about="#I{DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@CODIGO-INSTITUICAO}">
	  <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	  <foaf:name><xsl:value-of select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@NOME-DA-INSTITUICAO"/></foaf:name>
	  <xsl:if test="string-length(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@CODIGO-INSTITUICAO)>0">
	    <foaf:identifier>
	      <xsl:value-of select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@CODIGO-INSTITUICAO"/>
	    </foaf:identifier>
	  </xsl:if>
	</rdf:Description>
      </bibo:issuer>
      <dc:creator>
	<rdf:Description foaf:name="{DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@NOME-DO-ORIENTADO}">
	  <xsl:if test="normalize-space(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@NUMERO-ID-ORIENTADO) != ''">
	    <foaf:identifier>
	      <xsl:value-of select="normalize-space(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@NUMERO-ID-ORIENTADO)"/>
	    </foaf:identifier>
	  </xsl:if>
	  <rdf:type rdf:resource="&foaf;Agent" />
	</rdf:Description>
      </dc:creator>
      <dc:contributor rdf:resource="{$authorCV}"/>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="@HOME-PAGE|@HOME-PAGE-DO-TRABALHO">
    <xsl:if test="normalize-space(.) != ''">
      <foaf:homepage><xsl:value-of select="."/></foaf:homepage>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@DOI">
    <xsl:if test="normalize-space(.) != ''">
      <bibo:doi><xsl:value-of select="."/></bibo:doi>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@ISBN">
    <xsl:if test="normalize-space(.) != ''">
      <bibo:isbn><xsl:value-of select="."/></bibo:isbn>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@IDIOMA">
    <xsl:if test="normalize-space(.) != ''">
      <dc:language><xsl:value-of select="."/></dc:language>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()|@*" priority="-1">
  </xsl:template>

</xsl:stylesheet>
