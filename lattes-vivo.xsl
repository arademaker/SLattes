<?xml version="1.0" encoding="UTF-8"?>

<!-- 
This work is licensed under the Creative Commons
Attribution-ShareAlike 3.0 Brazil License. To view a copy of this
license, visit http://creativecommons.org/licenses/by-sa/3.0/br/ or
send a letter to Creative Commons, 444 Castro Street, Suite 900,
Mountain View, California, 94041, USA.

Issues:

- melhorar gerador via named template do identificador do lattes e do autor 
  do lattes

- avaliar como melhorar performance. profiling?

- fazer Makefile para melhor desempenho das transformacoes.
-->

<!DOCTYPE rdf:RDF [
 <!ENTITY  xsd  "http://www.w3.org/2001/XMLSchema#"> 
 <!ENTITY bibo  "http://purl.org/ontology/bibo/">
 <!ENTITY foaf  "http://xmlns.com/foaf/0.1/">
 <!ENTITY  geo  "http://www.w3.org/2003/01/geo/wgs84_pos#"> 
 <!ENTITY skos  "http://www.w3.org/2004/02/skos/core#">
 <!ENTITY doac  "http://ramonantonio.net/doac/0.1/">
 <!ENTITY vivo  "http://vivoweb.org/ontology/core#">
 <!ENTITY vcard "http://www.w3.org/2006/vcard/ns#"> 
 <!ENTITY obo   "http://purl.obolibrary.org/obo/">
 <!ENTITY bio   "http://purl.org/vocab/bio/0.1/">
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
		xmlns:vcard="http://www.w3.org/2006/vcard/ns#" 
		xmlns:obo="http://purl.obolibrary.org/obo/" 
		xmlns:vivo="http://vivoweb.org/ontology/core#" 
		xmlns:lattes="http://www.cnpq.br/2001/XSL/Lattes">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  <xsl:param name="LATTES"/> 

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:attribute name="xml:base">
	<xsl:choose>
	  <xsl:when test="string-length(/CURRICULO-VITAE/@NUMERO-IDENTIFICADOR)>0">
	    <xsl:value-of select="concat('http://www.fgv.br/lattes/',
				  /CURRICULO-VITAE/@NUMERO-IDENTIFICADOR)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="concat('http://www.fgv.br/lattes/',$LATTES)"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>

      <xsl:apply-templates />      
      <xsl:apply-templates select="//AUTORES" mode="full"/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="CURRICULO-VITAE">
    <rdf:Description rdf:about="">
      <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Document" />
      <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text" />
      <dc:title>CV Lattes de <xsl:value-of
      select="DADOS-GERAIS/@NOME-COMPLETO"/></dc:title>
      <xsl:choose>
	<xsl:when test="normalize-space(@NUMERO-IDENTIFICADOR) != ''">
	  <bibo:identifier><xsl:value-of select="@NUMERO-IDENTIFICADOR"/></bibo:identifier>
	</xsl:when>
	<xsl:otherwise>
	  <bibo:identifier><xsl:value-of select="$LATTES"/></bibo:identifier>
	</xsl:otherwise>
      </xsl:choose>
      <dcterms:issued><xsl:value-of select="@DATA-ATUALIZACAO" /></dcterms:issued>
      <dc:creator><xsl:apply-templates select="DADOS-GERAIS" mode="ref-resource"/></dc:creator>
    </rdf:Description>
    <xsl:apply-templates select="PRODUCAO-BIBLIOGRAFICA|OUTRA-PRODUCAO|DADOS-GERAIS" />
  </xsl:template>

  <xsl:template match="DADOS-GERAIS" mode="ref">
    <xsl:choose>
      <xsl:when test="string-length(/CURRICULO-VITAE/@NUMERO-IDENTIFICADOR)>0">
	<xsl:value-of select="concat('#author-',/CURRICULO-VITAE/@NUMERO-IDENTIFICADOR)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('#author-',$LATTES)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="OUTRA-PRODUCAO|PRODUCAO-BIBLIOGRAFICA|TRABALHOS-EM-EVENTOS|ARTIGOS-PUBLICADOS|
		       LIVROS-E-CAPITULOS|LIVROS-PUBLICADOS-OU-ORGANIZADOS|CAPITULOS-DE-LIVROS-PUBLICADOS|
		       TEXTOS-EM-JORNAIS-OU-REVISTAS|DADOS-GERAIS|FORMACAO-ACADEMICA-TITULACAO">
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
      <rdfs:label><xsl:value-of select="@NOME-COMPLETO"/></rdfs:label>
      <xsl:apply-templates select="ENDERECO/ENDERECO-PROFISSIONAL/@E-MAIL"/> 
      <xsl:apply-templates select="ENDERECO/ENDERECO-PROFISSIONAL/@HOME-PAGE"/> 

      <vivo:overview xml:lang="pt">
	<xsl:value-of select="RESUMO-CV/@TEXTO-RESUMO-CV-RH" />
      </vivo:overview>
      <xsl:if test="string-length(RESUMO-CV/@TEXTO-RESUMO-CV-RH-EN) > 0">
	<vivo:overview xml:lang="en">
	  <xsl:value-of select="RESUMO-CV/@TEXTO-RESUMO-CV-RH-EN" />
	</vivo:overview>
      </xsl:if>

      <obo:ARG_2000028>
	<rdf:Description rdf:about="#individual-{generate-id(.)}">  
	  <rdf:type rdf:resource="&vcard;Individual"/>
	  <vcard:hasName>
	    <rdf:Description rdf:about="#name-{generate-id(.)}">
	      <rdf:type rdf:resource="&vcard;Name"/>
	      <vcard:fn> <xsl:value-of select="@NOME-COMPLETO"/> </vcard:fn>
	    </rdf:Description>
	  </vcard:hasName>
	  <xsl:call-template name="split">
	    <xsl:with-param name="pText">
	      <xsl:value-of select="@NOME-EM-CITACOES-BIBLIOGRAFICAS"/>
	    </xsl:with-param>
	    <xsl:with-param name="id">#name-<xsl:value-of select="generate-id(.)"/></xsl:with-param>
	  </xsl:call-template>
	</rdf:Description>
      </obo:ARG_2000028>

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
    <vivo:hasResearchArea>
      <xsl:choose>
	<xsl:when test="normalize-space(@NOME-DA-ESPECIALIDADE) != ''">
	  <fgvterms:Especialidade rdf:about="#concept-{generate-id(@NOME-DA-ESPECIALIDADE)}">
	    <rdf:type rdf:resource="&skos;Concept" />
	    <skos:inScheme rdf:resource=""/>
	    <rdfs:label><xsl:value-of select="@NOME-DA-ESPECIALIDADE"/></rdfs:label>
	    <skos:related>
	      <fgvterms:subArea rdf:about="#concept-{generate-id(@NOME-DA-SUB-AREA-DO-CONHECIMENTO)}">
		<rdf:type rdf:resource="&skos;Concept" />
		<skos:inScheme rdf:resource=""/>
		<rdfs:label><xsl:value-of select="@NOME-DA-SUB-AREA-DO-CONHECIMENTO"/></rdfs:label>
		<skos:broader>		    
		  <fgvterms:Area rdf:about="#concept-{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		    <rdf:type rdf:resource="&skos;Concept" />
		    <skos:inScheme rdf:resource=""/>
		    <rdfs:label><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></rdfs:label>
		    <skos:broader>
		      <fgvterms:grandeArea rdf:about="#concept-{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
			<rdf:type rdf:resource="&skos;Concept" />
			<skos:inScheme rdf:resource=""/>
			<rdfs:label>
			  <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
			</rdfs:label>
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
	      <fgvterms:subArea rdf:about="#concept-{generate-id(@NOME-DA-SUB-AREA-DO-CONHECIMENTO)}">
		<rdf:type rdf:resource="&skos;Concept" />
		<skos:inScheme rdf:resource=""/>
		<rdfs:label><xsl:value-of select="@NOME-DA-SUB-AREA-DO-CONHECIMENTO"/></rdfs:label>
		<skos:broader>		    
		  <fgvterms:Area rdf:about="#concept-{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		    <rdf:type rdf:resource="&skos;Concept" />
		    <skos:inScheme rdf:resource=""/>
		    <rdfs:label><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></rdfs:label>
		    <skos:broader>
		      <fgvterms:grandeArea rdf:about="#concept-{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
			<rdf:type rdf:resource="&skos;Concept" />
			<skos:inScheme rdf:resource=""/>
			<rdfs:label>
			  <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
			</rdfs:label>
		      </fgvterms:grandeArea>
		    </skos:broader>
		  </fgvterms:Area>
		</skos:broader>
	      </fgvterms:subArea>
	    </xsl:when>
	    <xsl:otherwise>
	      <fgvterms:Area rdf:about="#concept-{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		<rdf:type rdf:resource="&skos;Concept" />
		<skos:inScheme rdf:resource=""/>
		<rdfs:label><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></rdfs:label>
		<skos:broader>
		  <fgvterms:grandeArea rdf:about="#concept-{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
		    <rdf:type rdf:resource="&skos;Concept" />
		    <skos:inScheme rdf:resource=""/>
		    <rdfs:label>
		      <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
		    </rdfs:label>
		  </fgvterms:grandeArea>
		</skos:broader>
	      </fgvterms:Area>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:otherwise>
      </xsl:choose>
    </vivo:hasResearchArea>
  </xsl:template>

  <xsl:template match="AREA-DO-CONHECIMENTO-1|AREA-DO-CONHECIMENTO-2|AREA-DO-CONHECIMENTO-3">
    <vivo:hasSubjectArea>
      <xsl:choose>
	<xsl:when test="normalize-space(@NOME-DA-ESPECIALIDADE) != ''">
	  <fgvterms:Especialidade rdf:about="#concept-{generate-id(@NOME-DA-ESPECIALIDADE)}">
	    <rdf:type rdf:resource="&skos;Concept" />
	    <skos:inScheme rdf:resource=""/>
	    <rdfs:label><xsl:value-of select="@NOME-DA-ESPECIALIDADE"/></rdfs:label>
	    <skos:related>
	      <fgvterms:subArea rdf:about="#concept-{generate-id(@NOME-DA-SUB-AREA-DO-CONHECIMENTO)}">
		<rdf:type rdf:resource="&skos;Concept" />
		<skos:inScheme rdf:resource=""/>
		<rdfs:label><xsl:value-of select="@NOME-DA-SUB-AREA-DO-CONHECIMENTO"/></rdfs:label>
		<skos:broader>		    
		  <fgvterms:Area rdf:about="#concept-{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		    <rdf:type rdf:resource="&skos;Concept" />
		    <skos:inScheme rdf:resource=""/>
		    <rdfs:label><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></rdfs:label>
		    <skos:broader>
		      <fgvterms:grandeArea rdf:about="#concept-{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
			<rdf:type rdf:resource="&skos;Concept" />
			<skos:inScheme rdf:resource=""/>
			<rdfs:label>
			  <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
			</rdfs:label>
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
	      <fgvterms:subArea rdf:about="#concept-{generate-id(@NOME-DA-SUB-AREA-DO-CONHECIMENTO)}">
		<rdf:type rdf:resource="&skos;Concept" />
		<skos:inScheme rdf:resource=""/>
		<rdfs:label><xsl:value-of select="@NOME-DA-SUB-AREA-DO-CONHECIMENTO"/></rdfs:label>
		<skos:broader>		    
		  <fgvterms:Area rdf:about="#concept-{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		    <rdf:type rdf:resource="&skos;Concept" />
		    <skos:inScheme rdf:resource=""/>
		    <rdfs:label><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></rdfs:label>
		    <skos:broader>
		      <fgvterms:grandeArea rdf:about="#concept-{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
			<rdf:type rdf:resource="&skos;Concept" />
			<skos:inScheme rdf:resource=""/>
			<rdfs:label>
			  <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
			</rdfs:label>
		      </fgvterms:grandeArea>
		    </skos:broader>
		  </fgvterms:Area>
		</skos:broader>
	      </fgvterms:subArea>
	    </xsl:when>
	    <xsl:otherwise>
	      <fgvterms:Area rdf:about="#concept-{generate-id(@NOME-DA-AREA-DO-CONHECIMENTO)}">
		<rdf:type rdf:resource="&skos;Concept" />
		<skos:inScheme rdf:resource=""/>
		<rdfs:label><xsl:value-of select="@NOME-DA-AREA-DO-CONHECIMENTO"/></rdfs:label>
		<skos:broader>
		  <fgvterms:grandeArea rdf:about="#concept-{generate-id(@NOME-GRANDE-AREA-DO-CONHECIMENTO)}">
		    <rdf:type rdf:resource="&skos;Concept" />
		    <skos:inScheme rdf:resource=""/>
		    <rdfs:label>
		      <xsl:value-of select="@NOME-GRANDE-AREA-DO-CONHECIMENTO"/>
		    </rdfs:label>
		  </fgvterms:grandeArea>
		</skos:broader>
	      </fgvterms:Area>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:otherwise>
      </xsl:choose>
    </vivo:hasSubjectArea>
  </xsl:template>


  <xsl:template match="AUTORES" mode="ref">
    <xsl:choose>
      <xsl:when test="normalize-space(@NRO-ID-CNPQ) != ''">
	<xsl:value-of select="concat('#author-',@NRO-ID-CNPQ)"/>
      </xsl:when>
      <xsl:when test="normalize-space(@NRO-ID-CNPQ) = '' and
		      @NOME-COMPLETO-DO-AUTOR = //DADOS-GERAIS/@NOME-COMPLETO">
	<xsl:apply-templates select="//DADOS-GERAIS" mode="ref"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('#author-',generate-id(.))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="TRABALHO-EM-EVENTOS/AUTORES
		       |ARTIGO-PUBLICADO/AUTORES
		       |ARTIGO-ACEITO-PARA-PUBLICACAO/AUTORES
                       |LIVRO-PUBLICADO-OU-ORGANIZADO/AUTORES
		       |CAPITULO-DE-LIVRO-PUBLICADO/AUTORES
		       |TEXTO-EM-JORNAL-OU-REVISTA/AUTORES" mode="full">
    <rdf:Description>
      <xsl:attribute name="rdf:about">
	<xsl:apply-templates select="." mode="ref"/>
      </xsl:attribute>
      <rdfs:label><xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/></rdfs:label>
      <rdf:type rdf:resource="&foaf;Person" />
      <obo:ARG_2000028>
	<rdf:Description rdf:about="#individual-{generate-id(.)}">  
	  <rdf:type rdf:resource="&vcard;Individual"/>
	  <vcard:hasName>
	    <rdf:Description rdf:about="#name-full-{generate-id(.)}">
	      <rdf:type rdf:resource="&vcard;Name"/>
	      <vcard:givenName><xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/></vcard:givenName>
	    </rdf:Description>
	  </vcard:hasName>
	  <xsl:call-template name="split">
	    <xsl:with-param name="pText"><xsl:value-of select="@NOME-PARA-CITACAO"/></xsl:with-param>
	    <xsl:with-param name="id">#name-<xsl:value-of select="generate-id(.)"/></xsl:with-param>
	  </xsl:call-template>
	</rdf:Description>
      </obo:ARG_2000028>
    </rdf:Description>
  </xsl:template>
   
  <xsl:template match="TRABALHO-EM-EVENTOS/AUTORES
		       |ARTIGO-PUBLICADO/AUTORES
		       |ARTIGO-ACEITO-PARA-PUBLICACAO/AUTORES
                       |LIVRO-PUBLICADO-OU-ORGANIZADO/AUTORES
		       |CAPITULO-DE-LIVRO-PUBLICADO/AUTORES
		       |TEXTO-EM-JORNAL-OU-REVISTA/AUTORES">
    <vivo:relatedBy>
      <rdf:Description rdf:about="#authorship-{generate-id(.)}">
	<rdf:type rdf:resource="&vivo;Authorship" />
	<vivo:rank rdf:datatype="&xsd;int"><xsl:value-of select="@ORDEM-DE-AUTORIA"/></vivo:rank>
	<vivo:relates> 
	  <xsl:attribute name="rdf:resource">
	    <xsl:apply-templates select="." mode="ref"/>
	  </xsl:attribute>
	</vivo:relates>
      </rdf:Description>
    </vivo:relatedBy>
  </xsl:template>

  <xsl:template match="TRABALHO-EM-EVENTOS">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;AcademicArticle" />
      <dc:title><xsl:value-of select="DADOS-BASICOS-DO-TRABALHO/@TITULO-DO-TRABALHO" /></dc:title>
      <rdfs:label><xsl:value-of select="DADOS-BASICOS-DO-TRABALHO/@TITULO-DO-TRABALHO" /></rdfs:label>
      <dcterms:issued><xsl:value-of select="DADOS-BASICOS-DO-TRABALHO/@ANO-DO-TRABALHO" /></dcterms:issued>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TRABALHO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TRABALHO/@HOME-PAGE-DO-TRABALHO"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TRABALHO/@DOI"/>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>

      <bibo:presentedAt>
	<rdf:Description rdf:about="#conference-{generate-id(.)}">
          <dc:title><xsl:value-of select="DETALHAMENTO-DO-TRABALHO/@NOME-DO-EVENTO" /></dc:title>
          <rdfs:label><xsl:value-of select="DETALHAMENTO-DO-TRABALHO/@NOME-DO-EVENTO" /></rdfs:label>
	  <rdf:type rdf:resource="&bibo;Conference"/>
	  <event:place>
	    <rdf:Description rdf:about="#place-{generate-id(.)}" 
			     gn:name="{DETALHAMENTO-DO-TRABALHO/@CIDADE-DO-EVENTO}"
			     gn:countrycode="{DADOS-BASICOS-DO-TRABALHO/@PAIS-DO-EVENTO}">
	      <rdf:type rdf:resource="&geo;SpatialThing" />
	    </rdf:Description>
	  </event:place>
	</rdf:Description>
      </bibo:presentedAt>
      <vivo:hasPublicationVenue>
	<rdf:Description rdf:about="#proceedings-{generate-id(.)}">
	  <!-- To prevent wrong ISBN to collapse different books  
	  <xsl:if test="string-length(DETALHAMENTO-DO-TRABALHO/@ISBN)>0"> 
	    <xsl:attribute name="rdf:about"> 
	      <xsl:value-of select="concat('urn:ISBN:',translate(DETALHAMENTO-DO-TRABALHO/@ISBN,' ','-'))"/> 
	    </xsl:attribute> 
	  </xsl:if> 
	  -->
	  <rdf:type rdf:resource="&bibo;Proceedings"/>
	  <xsl:apply-templates select="DETALHAMENTO-DO-TRABALHO/@ISBN"/>
	  <dc:title>
	  <xsl:value-of 
	      select="DETALHAMENTO-DO-TRABALHO/@TITULO-DOS-ANAIS-OU-PROCEEDINGS"/></dc:title>
	  <rdfs:label>
	  <xsl:value-of 
	      select="DETALHAMENTO-DO-TRABALHO/@TITULO-DOS-ANAIS-OU-PROCEEDINGS"/></rdfs:label>
	  <dcterms:issued>
	  <xsl:value-of 
	      select="DADOS-BASICOS-DO-TRABALHO/@ANO-DO-TRABALHO"/></dcterms:issued>
	  <xsl:if test="string-length(DETALHAMENTO-DO-TRABALHO/@NOME-DA-EDITORA)>0">
	    <dcterms:publisher>
	      <rdf:Description rdf:about="#org-{generate-id(.)}">
		<rdf:type rdf:resource="&foaf;Organization" />
		<rdfs:label><xsl:value-of select="DETALHAMENTO-DO-TRABALHO/@NOME-DA-EDITORA"/></rdfs:label>
		<foaf:name><xsl:value-of select="DETALHAMENTO-DO-TRABALHO/@NOME-DA-EDITORA"/></foaf:name>
	      </rdf:Description>
	    </dcterms:publisher>
	  </xsl:if>
	</rdf:Description>
      </vivo:hasPublicationVenue>
      <xsl:apply-templates select="AUTORES" />
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="DETALHAMENTO-DO-ARTIGO">
    <vivo:hasPublicationVenue>
      <rdf:Description rdf:about="journal-{generate-id(.)}">
	<!-- to prevent wrong ISSN to collapse different journals
	<xsl:if test="string-length(@ISSN)>0"> 
	  <xsl:attribute name="rdf:about"> <xsl:value-of select="concat('urn:ISSN:',translate(@ISSN,' ','-'))"/> 
	  </xsl:attribute>
	</xsl:if> -->
	<rdf:type rdf:resource="&bibo;Journal" />
	<dc:title><xsl:value-of select="@TITULO-DO-PERIODICO-OU-REVISTA"/></dc:title>
	<rdfs:label><xsl:value-of select="@TITULO-DO-PERIODICO-OU-REVISTA"/></rdfs:label>
	<xsl:apply-templates select="@ISSN"/> 
      </rdf:Description>
    </vivo:hasPublicationVenue>
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
    <vivo:hasPublicationVenue>
      <rdf:Description rdf:about="#periodical-{generate-id(.)}">
	<!--
	<xsl:if test="string-length(@ISSN)>0"> 
	  <xsl:attribute name="rdf:about"> <xsl:value-of select="concat('urn:ISSN:',translate(@ISSN,' ','-'))"/> 
          </xsl:attribute>
	</xsl:if>
	-->
	<rdf:type rdf:resource="&bibo;Periodical" />
	<dc:title><xsl:value-of select="@TITULO-DO-JORNAL-OU-REVISTA"/></dc:title>
	<rdfs:label><xsl:value-of select="@TITULO-DO-JORNAL-OU-REVISTA"/></rdfs:label>
	<xsl:apply-templates select="@ISSN"/>
      </rdf:Description>
    </vivo:hasPublicationVenue>
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
      <rdfs:label xml:lang="pt"><xsl:value-of select="DADOS-BASICOS-DO-TEXTO/@TITULO-DO-TEXTO" /></rdfs:label>
      <xsl:if test="normalize-space(@TITULO-DO-TEXTO-INGLES) != ''">
	<dc:title xml:lang="en">
	  <xsl:value-of select="DADOS-BASICOS-DO-TEXTO/@TITULO-DO-TEXTO-INGLES" />
	</dc:title>
      </xsl:if>
      <rdfs:label xml:lang="pt"><xsl:value-of select="DADOS-BASICOS-DO-TEXTO/@TITULO-DO-TEXTO" /></rdfs:label>
      <xsl:if test="normalize-space(@TITULO-DO-TEXTO-INGLES) != ''">
	<rdfs:label xml:lang="en">
	  <xsl:value-of select="DADOS-BASICOS-DO-TEXTO/@TITULO-DO-TEXTO-INGLES" />
	</rdfs:label>
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

      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="ARTIGO-PUBLICADO|ARTIGO-ACEITO-PARA-PUBLICACAO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;AcademicArticle" />
      <dc:title><xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO" /></dc:title>
      <rdfs:label><xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO" /></rdfs:label>
      <xsl:if test="normalize-space(DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO-INGLES) != ''">
	<dc:title xml:lang="en">
	  <xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO-INGLES"/>
	</dc:title>
      </xsl:if>
      <dcterms:issued><xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@ANO-DO-ARTIGO" /></dcterms:issued>
      <xsl:apply-templates select="DADOS-BASICOS-DO-ARTIGO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-ARTIGO/@HOME-PAGE-DO-TRABALHO"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-ARTIGO/@DOI"/>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>
      <xsl:apply-templates select="AUTORES|DETALHAMENTO-DO-ARTIGO" />
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="LIVRO-PUBLICADO-OU-ORGANIZADO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Book" />
      <dc:title><xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@TITULO-DO-LIVRO" /></dc:title>
      <rdfs:label><xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@TITULO-DO-LIVRO" /></rdfs:label>
      <dcterms:issued>  <xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@ANO" /> </dcterms:issued>
      <xsl:if test="string-length(DETALHAMENTO-DO-LIVRO/@NOME-DA-EDITORA)>0">
      <dcterms:publisher>
	<rdf:Description rdf:about="#org-{generate-id(.)}">
	  <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	  <foaf:name><xsl:value-of select="DETALHAMENTO-DO-LIVRO/@NOME-DA-EDITORA" /></foaf:name>
	  <rdfs:label><xsl:value-of select="DETALHAMENTO-DO-LIVRO/@NOME-DA-EDITORA" /></rdfs:label>
	</rdf:Description>
      </dcterms:publisher>
      </xsl:if>
      <xsl:apply-templates select="AUTORES" />
      <xsl:apply-templates select="DADOS-BASICOS-DO-LIVRO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-LIVRO/@DOI"/>
      <xsl:apply-templates select="DETALHAMENTO-DO-LIVRO/@ISBN"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-LIVRO/@HOME-PAGE-DO-TRABALHO"/>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="DETALHAMENTO-DO-CAPITULO">
    <rdf:Description rdf:about="book-{generate-id(.)}">
      <!-- 
      To prevent wrong ISBN to collapse different books
      <xsl:if test="string-length(@ISBN)>0"> 
       	<xsl:attribute name="rdf:about"> 
	  <xsl:value-of select="concat('urn:ISBN:',translate(@ISBN,' ','-'))"/> 
	</xsl:attribute> 
       </xsl:if>  
       -->
      <rdf:type rdf:resource="&bibo;Book" />
      <dc:title><xsl:value-of select="@TITULO-DO-LIVRO" /></dc:title>
      <rdfs:label><xsl:value-of select="@TITULO-DO-LIVRO" /></rdfs:label>
      <xsl:apply-templates select="@ISBN"/>
      <xsl:if test="string-length(@NOME-DA-EDITORA)>0">
	<dcterms:publisher>
	  <rdf:Description rdf:about="#org-{generate-id(.)}">
	    <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	    <foaf:name><xsl:value-of select="@NOME-DA-EDITORA"/></foaf:name>
	    <rdfs:label><xsl:value-of select="@NOME-DA-EDITORA"/></rdfs:label>
	  </rdf:Description>
	</dcterms:publisher>
      </xsl:if>
    </rdf:Description>
  </xsl:template>
  
  <xsl:template match="CAPITULO-DE-LIVRO-PUBLICADO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Chapter" />
      <dc:title><xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@TITULO-DO-CAPITULO-DO-LIVRO" /></dc:title>
      <rdfs:label><xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@TITULO-DO-CAPITULO-DO-LIVRO" /></rdfs:label>
      <dcterms:issued> <xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@ANO" /> </dcterms:issued>
      <obo:BFO_0000050>
	<xsl:apply-templates select="DETALHAMENTO-DO-CAPITULO" />
      </obo:BFO_0000050>
      <xsl:apply-templates select="AUTORES" />
      <xsl:apply-templates select="DADOS-BASICOS-DO-CAPITULO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-CAPITULO/@DOI"/>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="MESTRADO">
    <rdf:Description rdf:about="{concat('#masterthesis',@SEQUENCIA-FORMACAO)}">
      <rdf:type rdf:resource="&bibo;Thesis" />
      <dc:title><xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE" /></dc:title>
      <rdfs:label><xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE" /></rdfs:label>
      <xsl:if test="normalize-space(@TITULO-DA-DISSERTACAO-TESE-INGLES) != ''">
	<dc:title xml:lang="en"><xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE-INGLES" /></dc:title>
      </xsl:if>
      <bibo:degree rdf:resource="&bibo;degrees/ms" /> 
      <dcterms:issued><xsl:value-of select="@ANO-DE-OBTENCAO-DO-TITULO"/></dcterms:issued>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>
      <xsl:call-template name="issuer-education"/>
      <xsl:call-template name="authorship-education"/>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>

    <rdf:Description rdf:about="#relationship-{generate-id(.)}"> 
      <rdf:type rdf:resource="&vivo;AdvisingRelationship"/>
      <vivo:relates>
	<xsl:attribute name="rdf:resource">
	  <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	</xsl:attribute>
      </vivo:relates>
      <vivo:relates>
	<xsl:call-template name="orientador" />
      </vivo:relates>
      <vivo:relates>
	<rdf:Description rdf:about="#adviseeRole-{generate-id(.)}">
	  <rdf:type rdf:resource="&vivo;AdviseeRole"/>
	  <obo:RO_0000052>
	    <xsl:attribute name="rdf:resource">
	      <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	    </xsl:attribute>
	  </obo:RO_0000052>
	</rdf:Description>
      </vivo:relates>
      <vivo:relates>
	<rdf:Description rdf:about="#advisorRole-{generate-id(.)}">
	  <rdf:type rdf:resource="&vivo;AdvisorRole"/>
	  <obo:RO_0000052>
	    <xsl:call-template name="orientador-ref" />
	  </obo:RO_0000052>
	</rdf:Description>
      </vivo:relates>
    </rdf:Description>	
  </xsl:template>

  <xsl:template match="DOUTORADO">
    <rdf:Description rdf:about="{concat('#phdthesis',@SEQUENCIA-FORMACAO)}">
      <rdf:type rdf:resource="&bibo;Thesis" />
      <dc:title><xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE" /></dc:title>
      <rdfs:label><xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE" /></rdfs:label>
      <xsl:if test="normalize-space(@TITULO-DA-DISSERTACAO-TESE-INGLES) != ''">
	<dc:title xml:lang="en"><xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE-INGLES" /></dc:title>
      </xsl:if>
      <bibo:degree rdf:resource="&bibo;degrees/phd" /> 
      <dcterms:issued><xsl:value-of select="@ANO-DE-OBTENCAO-DO-TITULO"/></dcterms:issued>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>
      <xsl:call-template name="issuer-education" />
      <xsl:call-template name="authorship-education" />
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>

    <rdf:Description rdf:about="#relationship-{generate-id(.)}">
      <rdf:type rdf:resource="&vivo;AdvisingRelationship"/>
      <vivo:relates>
	<xsl:attribute name="rdf:resource">
	  <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	</xsl:attribute>
      </vivo:relates>
      <vivo:relates>
	<xsl:call-template name="orientador" />
      </vivo:relates>
      <vivo:relates>
	<rdf:Description rdf:about="#adviseeRole-{generate-id(.)}">
	  <rdf:type rdf:resource="&vivo;AdviseeRole"/>
	  <obo:RO_0000052>
	    <xsl:attribute name="rdf:resource">
	      <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	    </xsl:attribute>
	  </obo:RO_0000052>
	</rdf:Description>
      </vivo:relates>
      <vivo:relates>
	<rdf:Description rdf:about="#advisorRole-{generate-id(.)}">
	  <rdf:type rdf:resource="&vivo;AdvisorRole"/>
	  <obo:RO_0000052>
	    <xsl:call-template name="orientador-ref" />
	  </obo:RO_0000052>
	</rdf:Description>
      </vivo:relates>
    </rdf:Description>	
  </xsl:template>

  <xsl:template match="ORIENTACOES-CONCLUIDAS-PARA-MESTRADO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Thesis" />
      <dc:title>
      <xsl:value-of 
	  select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@TITULO"/></dc:title>
      <rdfs:label>
	<xsl:value-of 
	    select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@TITULO" /></rdfs:label>
      <bibo:degree rdf:resource="&bibo;degrees/ms" /> 
      <dcterms:issued>
      <xsl:value-of 
	  select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@ANO"/></dcterms:issued>
      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@HOME-PAGE"/>
      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@IDIOMA"/>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>
      <xsl:call-template name="advising-issuer">
	<xsl:with-param name="node" select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO" />
      </xsl:call-template>
      <vivo:relatedBy>
	<rdf:Description rdf:about="#authorship-{generate-id(.)}">
	  <rdf:type rdf:resource="&vivo;Authorship"/>
	  <vivo:rank rdf:datatype="&xsd;int">1</vivo:rank>
	  <vivo:relates>
	    <xsl:call-template name="thesis-author">
	      <xsl:with-param name="node" select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO" />
	    </xsl:call-template>
	  </vivo:relates>
	</rdf:Description>
      </vivo:relatedBy>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>

    <rdf:Description rdf:about="#relationship-{generate-id(.)}">
      <rdf:type rdf:resource="&vivo;AdvisingRelationship"/>
      <vivo:relates>
	<xsl:attribute name="rdf:resource">
	  <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	</xsl:attribute>
      </vivo:relates>
      <vivo:relates>
	<xsl:call-template name="thesis-author-ref">
	  <xsl:with-param name="node" select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO"/>
	</xsl:call-template>
      </vivo:relates>
      <vivo:relates>
	<rdf:Description rdf:about="#advisseRole-{generate-id(.)}">
	  <rdf:type rdf:resource="&vivo;AdviseeRole"/>
	  <obo:RO_0000052>
	    <xsl:call-template name="thesis-author-ref">
	      <xsl:with-param name="node" select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO"/>
	    </xsl:call-template>
	  </obo:RO_0000052>
	</rdf:Description>
      </vivo:relates>
      <vivo:relates>
	<rdf:Description rdf:about="#advisorRole-{generate-id(.)}">
	  <rdf:type rdf:resource="&vivo;AdvisorRole"/>
	  <obo:RO_0000052>
	    <xsl:attribute name="rdf:resource">
	      <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	    </xsl:attribute>
	  </obo:RO_0000052>
	</rdf:Description>
      </vivo:relates>
    </rdf:Description>	
  </xsl:template>

  <xsl:template match="ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO">
    <rdf:Description rdf:about="#P{@SEQUENCIA-PRODUCAO}">
      <rdf:type rdf:resource="&bibo;Thesis" />
      <bibo:degree rdf:resource="&bibo;degrees/phd" /> 
      <dc:title>
      <xsl:value-of 
	  select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@TITULO"/></dc:title>
      <rdfs:label>
      <xsl:value-of 
	  select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@TITULO"/></rdfs:label>
      <dcterms:issued>
	<xsl:value-of select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@ANO" />
      </dcterms:issued>
      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@HOME-PAGE"/>
      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@IDIOMA"/>
      <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/>
      <xsl:call-template name="advising-issuer">
	<xsl:with-param name="node" select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO" />
      </xsl:call-template>
      <vivo:relatedBy>
	<rdf:Description rdf:about="#authorship-{generate-id(.)}">
	  <rdf:type rdf:resource="&vivo;Authorship"/>
	  <vivo:rank rdf:datatype="&xsd;int">1</vivo:rank>
	  <vivo:relates>
	    <xsl:call-template name="thesis-author">
	      <xsl:with-param name="node" select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO" />
	    </xsl:call-template>
	  </vivo:relates>
	</rdf:Description>
      </vivo:relatedBy>
      <dcterms:isReferencedBy rdf:resource="" />
    </rdf:Description>

    <rdf:Description rdf:about="#relationship-{generate-id(.)}">
      <rdf:type rdf:resource="&vivo;AdvisingRelationship"/>
      <vivo:relates>
	<xsl:attribute name="rdf:resource">
	  <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	</xsl:attribute>
      </vivo:relates>
      <vivo:relates>
	<xsl:call-template name="thesis-author-ref">
	  <xsl:with-param name="node" 
			  select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO"/>
	</xsl:call-template>
      </vivo:relates>
      <vivo:relates>
	<rdf:Description rdf:about="#adviseeRole-{generate-id(.)}">
	  <rdf:type rdf:resource="&vivo;AdviseeRole"/>
	  <obo:RO_0000052>
	    <xsl:call-template name="thesis-author-ref">
	      <xsl:with-param name="node" 
			      select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO"/>
	    </xsl:call-template>
	  </obo:RO_0000052>
	</rdf:Description>
      </vivo:relates>
      <vivo:relates>
	<rdf:Description rdf:about="#advisorRole-{generate-id(.)}">
	  <rdf:type rdf:resource="&vivo;AdvisorRole"/>
	  <obo:RO_0000052>
	    <xsl:attribute name="rdf:resource">
	      <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	    </xsl:attribute>
	  </obo:RO_0000052>
	</rdf:Description>
      </vivo:relates>
    </rdf:Description>	
  </xsl:template>

  <xsl:template name="authorship-education">
    <vivo:relatedBy>
      <rdf:Description rdf:about="#authorship-{generate-id(.)}">
	<rdf:type rdf:resource="&vivo;Authorship"/>
	<vivo:rank rdf:datatype="&xsd;int">1</vivo:rank>
	<vivo:relates>
	  <xsl:attribute name="rdf:resource">
	    <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	  </xsl:attribute>
	</vivo:relates>
      </rdf:Description>
    </vivo:relatedBy>
  </xsl:template>

  <xsl:template name="advising-issuer">
    <xsl:param name="node" />
    <bibo:issuer> 
      <rdf:Description>
	<xsl:if test="string-length($node/@CODIGO-INSTITUICAO)>0">
	  <xsl:attribute name="rdf:about">
	    <xsl:value-of select="concat('#org-',$node/@CODIGO-INSTITUICAO)"/>
	  </xsl:attribute>
	  <foaf:identifier>
	    <xsl:value-of select="$node/@CODIGO-INSTITUICAO"/>
	  </foaf:identifier>
	</xsl:if>
	<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	<foaf:name><xsl:value-of select="$node/@NOME-DA-INSTITUICAO"/></foaf:name>
	<rdfs:label><xsl:value-of select="$node/@NOME-DA-INSTITUICAO"/></rdfs:label>
      </rdf:Description>
    </bibo:issuer>
  </xsl:template>

  <xsl:template name="issuer-education">
    <bibo:issuer> 
      <rdf:Description>
	<xsl:if test="string-length(@CODIGO-INSTITUICAO)>0">
	  <xsl:attribute name="rdf:about">
	    <xsl:value-of select="concat('#org-',@CODIGO-INSTITUICAO)"/>
	  </xsl:attribute>
	  <foaf:identifier>
	    <xsl:value-of select="@CODIGO-INSTITUICAO"/>
	  </foaf:identifier>
	</xsl:if>
	<rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization" />
	<foaf:name><xsl:value-of select="@NOME-INSTITUICAO"/></foaf:name>
	<rdfs:label><xsl:value-of select="@NOME-INSTITUICAO"/></rdfs:label>
      </rdf:Description>
    </bibo:issuer>
  </xsl:template>

  <xsl:template name="thesis-author-ref">
    <xsl:param name="node" />
    <xsl:attribute name="rdf:resource">
      <xsl:choose>
	<xsl:when test="normalize-space($node/@NUMERO-ID-ORIENTADO) != ''">
	  <xsl:value-of select="concat('#author-',$node/@NUMERO-ID-ORIENTADO)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat('#thesis-author-',generate-id($node))"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="rdf:resource">
      <xsl:value-of select="concat('#thesis-author-',generate-id($node))"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="thesis-author">
    <xsl:param name="node" />
    <rdf:Description> 
      <xsl:choose>
	<xsl:when test="normalize-space($node/@NUMERO-ID-ORIENTADO) != ''">
	  <xsl:attribute name="rdf:about">
	    <xsl:value-of select="concat('#author-',$node/@NUMERO-ID-ORIENTADO)"/>
	  </xsl:attribute>
	  <foaf:identifier>
	    <xsl:value-of select="normalize-space($node/@NUMERO-ID-ORIENTADO)"/> 
	  </foaf:identifier>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="rdf:about">
	    <xsl:value-of select="concat('#thesis-author-',generate-id($node))"/>
	  </xsl:attribute>
	</xsl:otherwise>
      </xsl:choose>
      <rdf:type rdf:resource="&foaf;Person"/>
      <rdfs:label><xsl:value-of select="$node/@NOME-DO-ORIENTADO"/></rdfs:label>
      <obo:ARG_2000028>
	<rdf:Description rdf:about="#individual-{generate-id($node)}">  
	  <rdf:type rdf:resource="&vcard;Individual"/>
	  <vcard:hasName>
	    <rdf:Description rdf:about="#name-{generate-id($node)}">
	      <rdf:type rdf:resource="&vcard;Name"/>
	      <vcard:fn> <xsl:value-of select="$node/@NOME-DO-ORIENTADO"/> </vcard:fn>
	    </rdf:Description>
	  </vcard:hasName>
	</rdf:Description>
      </obo:ARG_2000028>
    </rdf:Description>
  </xsl:template>

  <xsl:template name="orientador-ref">
    <xsl:attribute name="rdf:resource">
      <xsl:choose>
	<xsl:when test="normalize-space(@NUMERO-ID-ORIENTADOR) != ''">
	  <xsl:value-of select="concat('#author-',@NUMERO-ID-ORIENTADOR)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat('#orientador-',generate-id(.))"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="orientador">
    <rdf:Description> 
      <xsl:choose>
	<xsl:when test="normalize-space(@NUMERO-ID-ORIENTADOR) != ''">
	  <xsl:attribute name="rdf:about">
	    <xsl:value-of select="concat('#author-',@NUMERO-ID-ORIENTADOR)"/>
	  </xsl:attribute>
	  <foaf:identifier>
	    <xsl:value-of select="normalize-space(@NUMERO-ID-ORIENTADOR)"/> 
	  </foaf:identifier>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="rdf:about">
	    <xsl:value-of select="concat('#orientador-',generate-id(.))"/>
	  </xsl:attribute>
	</xsl:otherwise>
      </xsl:choose>
      <rdf:type rdf:resource="&foaf;Person"/>
      <rdfs:label><xsl:value-of select="@NOME-COMPLETO-DO-ORIENTADOR"/></rdfs:label>
      <obo:ARG_2000028>
	<rdf:Description rdf:about="#individual-{generate-id(.)}">  
	  <rdf:type rdf:resource="&vcard;Individual"/>
	  <vcard:hasName>
	    <rdf:Description rdf:about="#name-{generate-id(.)}">
	      <rdf:type rdf:resource="&vcard;Name"/>
	      <vcard:fn> <xsl:value-of select="@NOME-COMPLETO-DO-ORIENTADOR"/> </vcard:fn>
	    </rdf:Description>
	  </vcard:hasName>
	</rdf:Description>
      </obo:ARG_2000028>
    </rdf:Description>
  </xsl:template>

  <xsl:template match="@HOME-PAGE">
    <xsl:if test="normalize-space(.) != ''">
      <obo:ARG_2000028>
	<rdf:Description rdf:about="#individual-{generate-id(.)}">
	  <rdf:type rdf:resource="&vcard;Individual" />
	  <vcard:hasURL>
	    <rdf:Description rdf:about="#url-{generate-id(.)}">
	      <rdf:type rdf:resource="&vcard;URL" />
	      <rdfs:label>home page</rdfs:label>
	      <vcard:url><xsl:value-of select="."/></vcard:url>
	    </rdf:Description>
	  </vcard:hasURL>
	</rdf:Description>
      </obo:ARG_2000028>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@HOME-PAGE-DO-TRABALHO">
    <xsl:if test="normalize-space(.) != ''">
      <obo:ARG_2000028>
	<rdf:Description rdf:about="#page-{generate-id(.)}">
	  <rdf:type rdf:resource="&vcard;Kind" />
	  <vcard:hasURL>
	    <rdf:Description rdf:about="#url-{generate-id(.)}">
	      <rdf:type rdf:resource="&vcard;URL" />
	      <rdfs:label>full text</rdfs:label>
	      <vcard:url><xsl:value-of select="."/></vcard:url>
	    </rdf:Description>
	  </vcard:hasURL>
	</rdf:Description>
      </obo:ARG_2000028>
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

  <xsl:template name="split">
    <xsl:param name="pText"/>
    <xsl:param name="id"/>
    <xsl:param name="count">1</xsl:param>
    <xsl:if test="string-length($pText)">
      <vcard:hasName>
	<rdf:Description rdf:about="{$id}-{$count}">
	  <rdf:type rdf:resource="&vcard;Name"/>
	  <vcard:familyName>
	    <xsl:value-of 
		select="normalize-space(substring-before(substring-before(concat($pText,';'),';'),','))"/>
	  </vcard:familyName>
	  <vcard:givenName>
	    <xsl:value-of 
		select="normalize-space(substring-after(substring-before(concat($pText,';'),';'),','))"/>
	  </vcard:givenName>
	</rdf:Description>
      </vcard:hasName>
      <xsl:call-template name="split">
	<xsl:with-param name="pText" select="substring-after($pText, ';')"/>
	<xsl:with-param name="id"    select="$id"/>
	<xsl:with-param name="count" select="$count + 1"/>
	</xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()|@*|node()" priority="-1">
  </xsl:template>

</xsl:stylesheet>
