<?xml version="1.0" encoding="UTF-8"?>

<!-- 
LICENSE INFO

This work is licensed under the Creative Commons
Attribution-ShareAlike 3.0 Brazil License. To view a copy of this
license, visit http://creativecommons.org/licenses/by-sa/3.0/br/ or
send a letter to Creative Commons, 444 Castro Street, Suite 900,
Mountain View, California, 94041, USA.
-->

<!DOCTYPE rdf:RDF [
 <!ENTITY  xsd "http://www.w3.org/2001/XMLSchema#"> 
 <!ENTITY bibo "http://purl.org/ontology/bibo/">
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
		xmlns:fgvterms="http://www.fgv.br/terms/"
		xmlns:event="http://purl.org/NET/c4dm/event.owl#" 
		xmlns:gn="http://www.geonames.org/ontology#" 
		xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" 
		xmlns:bibo="http://purl.org/ontology/bibo/" 
		xmlns:lattes="http://www.cnpq.br/2001/XSL/Lattes">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  <xsl:param name="ID" />

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:attribute name="xml:base">      
	<xsl:choose>
	  <xsl:when test="string-length(/CURRICULO-VITAE/@NUMERO-IDENTIFICADOR)>0">
	    <xsl:value-of select="concat('http://www.fgv.br/lattes/',
				  /CURRICULO-VITAE/@NUMERO-IDENTIFICADOR)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="concat('http://www.fgv.br/lattes/',$ID)"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>

      <xsl:apply-templates />
      <xsl:apply-templates select="//AUTORES" mode="full"/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="AUTORES" mode="full">
    <rdf:Description>
      <xsl:attribute name="rdf:about">
	<xsl:value-of select="concat('#author-',generate-id(.))"/>
      </xsl:attribute>
      <xsl:if test="normalize-space(@NRO-ID-CNPQ) != ''">
	<foaf:identifier><xsl:value-of select="@NRO-ID-CNPQ"/></foaf:identifier>
      </xsl:if>
      <foaf:name><xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/></foaf:name>
      <foaf:citationName><xsl:value-of select="@NOME-PARA-CITACAO"/></foaf:citationName>
      <rdf:type rdf:resource="&foaf;Person" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="CURRICULO-VITAE">
    <rdf:Description rdf:about="">
      <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document" />
      <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
      <dc:title>CV Lattes de <xsl:value-of select="DADOS-GERAIS/@NOME-COMPLETO"/></dc:title>
      <xsl:choose>
	<xsl:when test="normalize-space(@NUMERO-IDENTIFICADOR) != ''">
	  <bibo:identifier> <xsl:value-of select="@NUMERO-IDENTIFICADOR"/> </bibo:identifier>
	</xsl:when>
	<xsl:otherwise>
	  <bibo:identifier> <xsl:value-of select="$ID"/> </bibo:identifier>
	</xsl:otherwise>
      </xsl:choose>
      <dcterms:issued><xsl:value-of select="@DATA-ATUALIZACAO" /></dcterms:issued>
      <dc:creator><xsl:apply-templates select="DADOS-GERAIS" mode="ref-resource"/></dc:creator>
    </rdf:Description>
    <xsl:apply-templates select="PRODUCAO-BIBLIOGRAFICA|OUTRA-PRODUCAO|DADOS-GERAIS" />
  </xsl:template>

  <xsl:template match="DADOS-GERAIS" mode="ref">
    <xsl:choose>
      <xsl:when test="string-length(ENDERECO/ENDERECO-PROFISSIONAL/@E-MAIL)>0">
	<xsl:value-of select="concat('mailto:',ENDERECO/ENDERECO-PROFISSIONAL/@E-MAIL)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('#author-', generate-id(.))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="OUTRA-PRODUCAO|PRODUCAO-BIBLIOGRAFICA|TRABALHOS-EM-EVENTOS|ARTIGOS-PUBLICADOS|LIVROS-E-CAPITULOS|
		       LIVROS-PUBLICADOS-OU-ORGANIZADOS|CAPITULOS-DE-LIVROS-PUBLICADOS|TEXTOS-EM-JORNAIS-OU-REVISTAS|DADOS-GERAIS|
                       FORMACAO-ACADEMICA-TITULACAO">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="ORIENTACOES-CONCLUIDAS">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="DADOS-GERAIS" mode="ref-resource">
    <rdf:Description>
      <xsl:attribute name="rdf:about">
	<xsl:apply-templates select="." mode="ref"/>
      </xsl:attribute>
      <rdf:type rdf:resource="&foaf;Person" />
      <xsl:if test="string-length(ENDERECO/ENDERECO-PROFISSIONAL/@E-MAIL)>0">
	<foaf:identifier>
	  <xsl:apply-templates select="." mode="ref"/>
	</foaf:identifier>
      </xsl:if>
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
      <xsl:apply-templates select="ENDERECO/ENDERECO-PROFISSIONAL/@E-MAIL"/> 
      <xsl:apply-templates select="ENDERECO/ENDERECO-PROFISSIONAL/@HOME-PAGE"/> 

      <bio:biography xml:lang="pt">
	<xsl:value-of select="RESUMO-CV/@TEXTO-RESUMO-CV-RH" />
      </bio:biography>
      <xsl:if test="string-length(RESUMO-CV/@TEXTO-RESUMO-CV-RH-EN) > 0">
	<bio:biography xml:lang="en">
	  <xsl:value-of select="RESUMO-CV/@TEXTO-RESUMO-CV-RH-EN" />
	</bio:biography>
      </xsl:if>

      <xsl:apply-templates select="IDIOMAS" mode="ref-resource" />
      <xsl:apply-templates select="AREAS-DE-ATUACAO" mode="ref-resource" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="AREAS-DE-ATUACAO|IDIOMAS" mode="ref-resource">
    <xsl:apply-templates  mode="ref-resource"/>
  </xsl:template>
  <xsl:template match="AREAS-DE-ATUACAO|IDIOMAS" />

  <xsl:template match="AREAS-DO-CONHECIMENTO">
    <xsl:apply-templates />
  </xsl:template>


  <xsl:template match="IDIOMA" mode="ref-resource">
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

  <xsl:template match="AREA-DE-ATUACAO" mode="ref-resource">
    <foaf:topic_interest>
      <xsl:choose>
	<xsl:when test="normalize-space(@NOME-DA-ESPECIALIDADE) != ''">
	  <fgvterms:Especialidade rdf:nodeID="{generate-id(@NOME-DA-ESPECIALIDADE)}">
	    <skos:prefLabel><xsl:value-of select="@NOME-DA-ESPECIALIDADE"/></skos:prefLabel>
	    <skos:related>
	      <fgvterms:subArea rdf:nodeID="{generate-id(@NOME-DA-SUB-AREA-DO-CONHECIMENTO)}">
		<skos:prefLabel><xsl:value-of select="@NOME-DA-SUB-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		<skos:broader>		    
		  <fgvterms:Area rdf:nodeID="{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		    <skos:prefLabel><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		    <skos:broader>
		      <fgvterms:grandeArea rdf:nodeID="{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
			<skos:prefLabel>
			  <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
			</skos:prefLabel>
		      </fgvterms:grandeArea>
		    </skos:broader>
		  </fgvterms:Area>
		</skos:broader>
	      </fgvterms:subArea>
	    </skos:related>
	  </fgvterms:Especialidade>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:choose>
	    <xsl:when test="normalize-space(@NOME-DA-SUB-AREA-DO-CONHECIMENTO) != ''">
	      <fgvterms:subArea rdf:nodeID="{generate-id(@NOME-DA-SUB-AREA-DO-CONHECIMENTO)}">
		<skos:prefLabel><xsl:value-of select="@NOME-DA-SUB-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		<skos:broader>		    
		  <fgvterms:Area rdf:nodeID="{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		    <skos:prefLabel><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		    <skos:broader>
		      <fgvterms:grandeArea rdf:nodeID="{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
			<skos:prefLabel>
			  <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
			</skos:prefLabel>
		      </fgvterms:grandeArea>
		    </skos:broader>
		  </fgvterms:Area>
		</skos:broader>
	      </fgvterms:subArea>
	    </xsl:when>
	    <xsl:otherwise>
	      <fgvterms:Area rdf:nodeID="{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		<skos:prefLabel><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		<skos:broader>
		  <fgvterms:grandeArea rdf:nodeID="{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
		    <skos:prefLabel>
		      <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
		    </skos:prefLabel>
		  </fgvterms:grandeArea>
		</skos:broader>
	      </fgvterms:Area>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:otherwise>
      </xsl:choose>
    </foaf:topic_interest>
  </xsl:template>

  <xsl:template match="AREA-DO-CONHECIMENTO-1|AREA-DO-CONHECIMENTO-2|AREA-DO-CONHECIMENTO-3">
    <dcterms:subject>
      <xsl:choose>
	<xsl:when test="normalize-space(@NOME-DA-ESPECIALIDADE) != ''">
	  <fgvterms:Especialidade rdf:nodeID="{generate-id(@NOME-DA-ESPECIALIDADE)}">
	    <skos:prefLabel><xsl:value-of select="@NOME-DA-ESPECIALIDADE"/></skos:prefLabel>
	    <skos:related>
	      <fgvterms:subArea rdf:nodeID="{generate-id(@NOME-DA-SUB-AREA-DO-CONHECIMENTO)}">
		<skos:prefLabel><xsl:value-of select="@NOME-DA-SUB-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		<skos:broader>		    
		  <fgvterms:Area rdf:nodeID="{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		    <skos:prefLabel><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		    <skos:broader>
		      <fgvterms:grandeArea rdf:nodeID="{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
			<skos:prefLabel>
			  <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
			</skos:prefLabel>
		      </fgvterms:grandeArea>
		    </skos:broader>
		  </fgvterms:Area>
		</skos:broader>
	      </fgvterms:subArea>
	    </skos:related>
	  </fgvterms:Especialidade>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:choose>
	    <xsl:when test="normalize-space(@NOME-DA-SUB-AREA-DO-CONHECIMENTO) != ''">
	      <fgvterms:subArea rdf:nodeID="{generate-id(@NOME-DA-SUB-AREA-DO-CONHECIMENTO)}">
		<skos:prefLabel><xsl:value-of select="@NOME-DA-SUB-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		<skos:broader>		    
		  <fgvterms:Area rdf:nodeID="{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		    <skos:prefLabel><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		    <skos:broader>
		      <fgvterms:grandeArea rdf:nodeID="{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
			<skos:prefLabel>
			  <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
			</skos:prefLabel>
		      </fgvterms:grandeArea>
		    </skos:broader>
		  </fgvterms:Area>
		</skos:broader>
	      </fgvterms:subArea>
	    </xsl:when>
	    <xsl:otherwise>
	      <fgvterms:Area rdf:nodeID="{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		<skos:prefLabel><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></skos:prefLabel>
		<skos:broader>
		  <fgvterms:grandeArea rdf:nodeID="{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
		    <skos:prefLabel>
		      <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
		    </skos:prefLabel>
		  </fgvterms:grandeArea>
		</skos:broader>
	      </fgvterms:Area>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:otherwise>
      </xsl:choose>
    </dcterms:subject>
  </xsl:template>
   
  <xsl:template match="TRABALHO-EM-EVENTOS/AUTORES|ARTIGO-PUBLICADO/AUTORES|ARTIGO-ACEITO-PARA-PUBLICACAO/AUTORES|
                       LIVRO-PUBLICADO-OU-ORGANIZADO/AUTORES|CAPITULO-DE-LIVRO-PUBLICADO/AUTORES|TEXTO-EM-JORNAL-OU-REVISTA/AUTORES">
    <dc:creator>
      <xsl:attribute name="rdf:resource">
	<xsl:value-of select="concat('#author-',generate-id(.))"/>
      </xsl:attribute>
    </dc:creator>
  </xsl:template>

  <xsl:template match="TRABALHO-EM-EVENTOS">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Article" />
      <dc:title><xsl:value-of select="DADOS-BASICOS-DO-TRABALHO/@TITULO-DO-TRABALHO" /></dc:title>
      <dcterms:issued><xsl:value-of select="DADOS-BASICOS-DO-TRABALHO/@ANO-DO-TRABALHO" /></dcterms:issued>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TRABALHO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TRABALHO/@HOME-PAGE-DO-TRABALHO"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TRABALHO/@DOI"/>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>

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
	  <!-- To prevent wrong ISBN to collapse different books all books are now blank nodes -->
	  <!-- <xsl:if test="string-length(DETALHAMENTO-DO-TRABALHO/@ISBN)>0"> -->
	  <!--   <xsl:attribute name="rdf:about"> -->
	  <!--     <xsl:value-of select="concat('urn:ISBN:',translate(DETALHAMENTO-DO-TRABALHO/@ISBN,' ','-'))"/> -->
	  <!--   </xsl:attribute> -->
	  <!-- </xsl:if> -->
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
	      <xsl:value-of select="concat('#author-',generate-id(.))"/>
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
	<!-- to prevent wrong ISSN to collapse different journals, all journals are now blank nodes -->
	<!-- <xsl:if test="string-length(@ISSN)>0"> -->
	<!--   <xsl:attribute name="rdf:about"> <xsl:value-of select="concat('urn:ISSN:',translate(@ISSN,' ','-'))"/> </xsl:attribute> -->
	<!-- </xsl:if> -->
	<rdf:type rdf:resource="&bibo;Journal" />
	<xsl:apply-templates select="@ISSN"/> 
	<dc:title> <xsl:value-of select="@TITULO-DO-PERIODICO-OU-REVISTA"/> </dc:title>
      </rdf:Description>
    </dcterms:isPartOf>
    <xsl:if test="normalize-space(@PAGINA-INICIAL) != ''">
      <bibo:pageStart><xsl:value-of select="@PAGINA-INICIAL"/></bibo:pageStart> 
    </xsl:if>
    <xsl:if test="normalize-space(@PAGINA-FINAL) != ''">
      <bibo:pageEnd><xsl:value-of select="@PAGINA-FINAL"/></bibo:pageEnd>
    </xsl:if>
    <xsl:if test="string-length(@VOLUME)>0">
      <bibo:volume> <xsl:value-of select="@VOLUME"/> </bibo:volume>
    </xsl:if>
  </xsl:template>


  <xsl:template match="DETALHAMENTO-DO-TEXTO">
    <dcterms:isPartOf>
      <rdf:Description>
	<!-- <xsl:if test="string-length(@ISSN)>0"> -->
	<!--   <xsl:attribute name="rdf:about"> <xsl:value-of select="concat('urn:ISSN:',translate(@ISSN,' ','-'))"/> </xsl:attribute> -->
	<!-- </xsl:if> -->
	<xsl:apply-templates select="@ISSN"/>
	<rdf:type rdf:resource="&bibo;Periodical" />
	<dc:title> <xsl:value-of select="@TITULO-DO-JORNAL-OU-REVISTA"/> </dc:title>
      </rdf:Description>
    </dcterms:isPartOf>
    <xsl:if test="normalize-space(@PAGINA-INICIAL) != ''">
      <bibo:pageStart><xsl:value-of select="@PAGINA-INICIAL"/></bibo:pageStart> 
    </xsl:if>
    <xsl:if test="normalize-space(@PAGINA-FINAL) != ''">
      <bibo:pageEnd><xsl:value-of select="@PAGINA-FINAL"/></bibo:pageEnd>
    </xsl:if>
    <xsl:if test="string-length(@VOLUME)>0">
      <bibo:volume> <xsl:value-of select="@VOLUME"/> </bibo:volume>
    </xsl:if>
  </xsl:template>


  <xsl:template match="TEXTO-EM-JORNAL-OU-REVISTA">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Article" />
      <dc:title xml:lang="pt"><xsl:value-of select="DADOS-BASICOS-DO-TEXTO/@TITULO-DO-TEXTO" /></dc:title>
      <xsl:if test="normalize-space(@TITULO-DO-TEXTO-INGLES) != ''">
	<dc:title xml:lang="en"><xsl:value-of select="DADOS-BASICOS-DO-TEXTO/@TITULO-DO-TEXTO-INGLES" /></dc:title>
      </xsl:if>
      <dcterms:issued><xsl:value-of select="DADOS-BASICOS-DO-TEXTO/@ANO-DO-TEXTO" /></dcterms:issued>
      <xsl:if test="normalize-space(DETALHAMENTO-DO-TEXTO/@DATA-DE-PUBLICACAO) != ''">
	<dcterms:issued><xsl:value-of select="DETALHAMENTO-DO-TEXTO/@DATA-DE-PUBLICACAO"/></dcterms:issued>
      </xsl:if>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TEXTO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TEXTO/@HOME-PAGE-DO-TRABALHO"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TEXTO/@DOI"/>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>
      <xsl:apply-templates select="AUTORES|DETALHAMENTO-DO-TEXTO" />

      <bibo:authorList rdf:parseType="Collection">
	<xsl:for-each select="AUTORES">
	  <xsl:sort data-type="number" select="@ORDEM-DE-AUTORIA"/>
	  <rdf:Description>
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('#author-',generate-id(.))"/>
	    </xsl:attribute>
	  </rdf:Description>
	</xsl:for-each>
      </bibo:authorList>

      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="ARTIGO-PUBLICADO|ARTIGO-ACEITO-PARA-PUBLICACAO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Article" />

      <dc:title><xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO" /></dc:title>
      <xsl:if test="normalize-space(DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO-INGLES) != ''">
	<dc:title xml:lang="en"><xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO-INGLES" /></dc:title>
      </xsl:if>

      <dcterms:issued><xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@ANO-DO-ARTIGO" /></dcterms:issued>
      <xsl:apply-templates select="DADOS-BASICOS-DO-ARTIGO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-ARTIGO/@HOME-PAGE-DO-TRABALHO"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-ARTIGO/@DOI"/>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>

      <xsl:apply-templates select="AUTORES|DETALHAMENTO-DO-ARTIGO" />
      <bibo:authorList rdf:parseType="Collection">
	<xsl:for-each select="AUTORES">
	  <xsl:sort data-type="number" select="@ORDEM-DE-AUTORIA"/>
	  <rdf:Description>
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('#author-',generate-id(.))"/>
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
	      <xsl:value-of select="concat('#author-',generate-id(.))"/>
	    </xsl:attribute>
	  </rdf:Description>
	</xsl:for-each>
      </bibo:authorList>

      <xsl:apply-templates select="DADOS-BASICOS-DO-LIVRO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-LIVRO/@DOI"/>
      <xsl:apply-templates select="DETALHAMENTO-DO-LIVRO/@ISBN"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-LIVRO/@HOME-PAGE-DO-TRABALHO"/>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="DETALHAMENTO-DO-CAPITULO">
    <rdf:Description>
      <!-- To prevent wrong ISBN to collapse different books all books are now blank nodes -->
      <!-- <xsl:if test="string-length(@ISBN)>0"> -->
      <!-- 	<xsl:attribute name="rdf:about"> <xsl:value-of select="concat('urn:ISBN:',translate(@ISBN,' ','-'))"/> </xsl:attribute> -->
      <!-- </xsl:if>  -->
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
	      <xsl:value-of select="concat('#author-',generate-id(.))"/>
	    </xsl:attribute>
	  </rdf:Description>
	</xsl:for-each>
      </bibo:authorList>

      <xsl:apply-templates select="DADOS-BASICOS-DO-CAPITULO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-CAPITULO/@DOI"/>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="ORIENTACOES-CONCLUIDAS-PARA-MESTRADO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Thesis" />
      <dc:title><xsl:value-of select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@TITULO" /></dc:title>
      <bibo:degree rdf:resource="&bibo;degrees/ms" /> 
      <dcterms:issued><xsl:value-of select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@ANO"/></dcterms:issued>
      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@HOME-PAGE"/>
      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@IDIOMA"/>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>

      <bibo:issuer> 
	<rdf:Description>
	  <xsl:if test="string-length(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@CODIGO-INSTITUICAO)>0">
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('#I',DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@CODIGO-INSTITUICAO)"/>
	    </xsl:attribute>
	    <foaf:identifier>
	      <xsl:value-of select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@CODIGO-INSTITUICAO"/>
	    </foaf:identifier>
	  </xsl:if>
	  <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	  <foaf:name><xsl:value-of select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@NOME-DA-INSTITUICAO"/></foaf:name>
	</rdf:Description>
      </bibo:issuer>
      <dc:creator>
	<rdf:Description foaf:name="{DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@NOME-DO-ORIENTADO}">
	  <xsl:if test="normalize-space(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@NUMERO-ID-ORIENTADO) != ''">
	    <foaf:identifier>
	      <xsl:value-of select="normalize-space(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@NUMERO-ID-ORIENTADO)"/>
	    </foaf:identifier>
	  </xsl:if>
	  <rdf:type rdf:resource="&foaf;Person" />
	</rdf:Description>
      </dc:creator>
      <dc:contributor>
	<xsl:attribute name="rdf:resource">
	  <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	</xsl:attribute>
      </dc:contributor>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="MESTRADO">
    <rdf:Description rdf:about="{concat('#masterthesis',@SEQUENCIA-FORMACAO)}">
      <rdf:type rdf:resource="&bibo;Thesis" />
      <dc:title><xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE" /></dc:title>
      <xsl:if test="normalize-space(@TITULO-DA-DISSERTACAO-TESE-INGLES) != ''">
	<dc:title xml:lang="en"><xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE-INGLES" /></dc:title>
      </xsl:if>
      <bibo:degree rdf:resource="&bibo;degrees/ms" /> 
      <dcterms:issued><xsl:value-of select="@ANO-DE-OBTENCAO-DO-TITULO"/></dcterms:issued>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>

      <bibo:issuer> 
	<rdf:Description>
	  <xsl:if test="string-length(@CODIGO-INSTITUICAO)>0">
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('#I',@CODIGO-INSTITUICAO)"/>
	    </xsl:attribute>
	    <foaf:identifier>
	      <xsl:value-of select="@CODIGO-INSTITUICAO"/>
	    </foaf:identifier>
	  </xsl:if>
	  <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	  <foaf:name><xsl:value-of select="@NOME-INSTITUICAO"/></foaf:name>
	</rdf:Description>
      </bibo:issuer>
      <dc:creator>
	<xsl:attribute name="rdf:resource">
	  <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	</xsl:attribute>
      </dc:creator>
      <dc:contributor>
	<rdf:Description>
	  <xsl:if test="normalize-space(@NUMERO-ID-ORIENTADOR) != ''">
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('#orientador-',normalize-space(@NUMERO-ID-ORIENTADOR))"/>
	    </xsl:attribute>
	    <foaf:identifier> <xsl:value-of select="normalize-space(@NUMERO-ID-ORIENTADOR)"/> </foaf:identifier>
	  </xsl:if>
	  <foaf:name> <xsl:value-of select="@NOME-COMPLETO-DO-ORIENTADOR"/> </foaf:name>
	  <rdf:type rdf:resource="&foaf;Person" />
	</rdf:Description>
      </dc:contributor>
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
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>

      <bibo:issuer> 
	<rdf:Description>
	  <xsl:if test="string-length(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@CODIGO-INSTITUICAO)>0">
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('#I',DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@CODIGO-INSTITUICAO)"/>
	    </xsl:attribute>
	    <foaf:identifier>
	      <xsl:value-of select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@CODIGO-INSTITUICAO"/>
	    </foaf:identifier>
	  </xsl:if>
	  <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	  <foaf:name><xsl:value-of select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@NOME-DA-INSTITUICAO"/></foaf:name>
	</rdf:Description>
      </bibo:issuer>
      <dc:creator>
	<rdf:Description foaf:name="{DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@NOME-DO-ORIENTADO}">
	  <xsl:if test="normalize-space(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@NUMERO-ID-ORIENTADO) != ''">
	    <foaf:identifier>
	      <xsl:value-of select="normalize-space(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@NUMERO-ID-ORIENTADO)"/>
	    </foaf:identifier>
	  </xsl:if>
	  <rdf:type rdf:resource="&foaf;Person" />
	</rdf:Description>
      </dc:creator>
      <dc:contributor>
	<xsl:attribute name="rdf:resource">
	  <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	</xsl:attribute>
      </dc:contributor>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="DOUTORADO">
    <rdf:Description rdf:about="{concat('#phdthesis',@SEQUENCIA-FORMACAO)}">
      <rdf:type rdf:resource="&bibo;Thesis" />
      <dc:title><xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE" /></dc:title>
      <xsl:if test="normalize-space(@TITULO-DA-DISSERTACAO-TESE-INGLES) != ''">
	<dc:title xml:lang="en"><xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE-INGLES" /></dc:title>
      </xsl:if>
      <bibo:degree rdf:resource="&bibo;degrees/phd" /> 
      <dcterms:issued><xsl:value-of select="@ANO-DE-OBTENCAO-DO-TITULO"/></dcterms:issued>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>

      <bibo:issuer> 
	<rdf:Description>
	  <xsl:if test="string-length(@CODIGO-INSTITUICAO)>0">
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('#I',@CODIGO-INSTITUICAO)"/>
	    </xsl:attribute>
	    <foaf:identifier>
	      <xsl:value-of select="@CODIGO-INSTITUICAO"/>
	    </foaf:identifier>
	  </xsl:if>
	  <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	  <foaf:name><xsl:value-of select="@NOME-INSTITUICAO"/></foaf:name>
	</rdf:Description>
      </bibo:issuer>
      <dc:creator>
	<xsl:attribute name="rdf:resource">
	  <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	</xsl:attribute>
      </dc:creator>
      <dc:contributor>
	<rdf:Description>
	  <xsl:if test="normalize-space(@NUMERO-ID-ORIENTADOR) != ''">
	    <xsl:attribute name="rdf:about">
	      <xsl:value-of select="concat('#orientador-',normalize-space(@NUMERO-ID-ORIENTADOR))"/>
	    </xsl:attribute>
	    <foaf:identifier> <xsl:value-of select="normalize-space(@NUMERO-ID-ORIENTADOR)"/> </foaf:identifier>
	  </xsl:if>
	  <foaf:name> <xsl:value-of select="@NOME-COMPLETO-DO-ORIENTADOR"/> </foaf:name>
	  <rdf:type rdf:resource="&foaf;Person" />
	</rdf:Description>
      </dc:contributor>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>


  <xsl:template match="@HOME-PAGE|@HOME-PAGE-DO-TRABALHO">
    <xsl:if test="normalize-space(.) != ''">
      <foaf:homepage><xsl:value-of select="."/></foaf:homepage>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@E-MAIL">
    <xsl:if test="normalize-space(.) != ''">
      <foaf:mbox><xsl:value-of select="."/></foaf:mbox>
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

  <xsl:template match="@ISSN">
    <xsl:if test="normalize-space(.) != ''">
      <bibo:issn><xsl:value-of select="."/></bibo:issn>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@IDIOMA">
    <xsl:if test="normalize-space(.) != ''">
      <dc:language><xsl:value-of select="."/></dc:language>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()|@*|node()" priority="-1">
  </xsl:template>

</xsl:stylesheet>
