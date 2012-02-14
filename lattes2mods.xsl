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
 <!ENTITY mods "http://www.loc.gov/mods/v3">
]>

<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:mods="http://www.loc.gov/mods/v3">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:template match="/">
    <mods:modsCollection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			 xsi:schemaLocation="http://www.loc.gov/standards/mods/mods.xsd">
      <xsl:apply-templates />
    </mods:modsCollection>
  </xsl:template>

  <xsl:template match="CURRICULO-VITAE">
    <xsl:apply-templates select="PRODUCAO-BIBLIOGRAFICA|OUTRA-PRODUCAO|DADOS-GERAIS" />
  </xsl:template>

  <xsl:template match="OUTRA-PRODUCAO|PRODUCAO-BIBLIOGRAFICA|TRABALHOS-EM-EVENTOS|ARTIGOS-PUBLICADOS|LIVROS-E-CAPITULOS|
		       LIVROS-PUBLICADOS-OU-ORGANIZADOS|CAPITULOS-DE-LIVROS-PUBLICADOS|TEXTOS-EM-JORNAIS-OU-REVISTAS|DADOS-GERAIS|FORMACAO-ACADEMICA-TITULACAO">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="ORIENTACOES-CONCLUIDAS">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="TRABALHO-EM-EVENTOS/AUTORES|ARTIGO-PUBLICADO/AUTORES|ARTIGO-ACEITO-PARA-PUBLICACAO/AUTORES|
                       LIVRO-PUBLICADO-OU-ORGANIZADO/AUTORES|CAPITULO-DE-LIVRO-PUBLICADO/AUTORES|TEXTO-EM-JORNAL-OU-REVISTA/AUTORES">
    <mods:name type="personal">
      <mods:namePart> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/> </mods:namePart>
      <mods:role>
	<mods:roleTerm authority="marcrelator" type="text">author</mods:roleTerm>
      </mods:role>
    </mods:name>
  </xsl:template>

  <xsl:template match="TRABALHO-EM-EVENTOS">
    <mods:mods ID="publication-{@SEQUENCIA-PRODUCAO}">
      <mods:titleInfo>
	<mods:title> <xsl:value-of select="DADOS-BASICOS-DO-TRABALHO/@TITULO-DO-TRABALHO" /> </mods:title>
      </mods:titleInfo>

      <mods:originInfo>
	<mods:dateIssued> <xsl:value-of select="DADOS-BASICOS-DO-TRABALHO/@ANO-DO-TRABALHO" /> </mods:dateIssued>
      </mods:originInfo>

      <xsl:for-each select="AUTORES">
	<xsl:sort data-type="number" select="@ORDEM-DE-AUTORIA"/>
	<mods:name type="personal">
	  <mods:namePart> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/> </mods:namePart>
	  <mods:role>
            <mods:roleTerm authority="marcrelator" type="text">author</mods:roleTerm>
	  </mods:role>
	</mods:name>
      </xsl:for-each>

      <mods:typeOfResource>text</mods:typeOfResource>

      <mods:relatedItem type="host">
	<mods:titleInfo>
	  <mods:title> <xsl:value-of select="DETALHAMENTO-DO-TRABALHO/@TITULO-DOS-ANAIS-OU-PROCEEDINGS"/> </mods:title>
	</mods:titleInfo>

	<mods:originInfo>
	  <mods:dateIssued> <xsl:value-of select="DADOS-BASICOS-DO-TRABALHO/@ANO-DO-TRABALHO"/> </mods:dateIssued>
	  <xsl:if test="string-length(DETALHAMENTO-DO-TRABALHO/@NOME-DA-EDITORA)>0">
	    <mods:publisher> <xsl:value-of select="DETALHAMENTO-DO-TRABALHO/@NOME-DA-EDITORA" /> </mods:publisher>
	  </xsl:if>
	  <xsl:if test="string-length(DETALHAMENTO-DO-TRABALHO/@CIDADE-DA-EDITORA)>0">
	    <mods:place>
	      <mods:placeTerm type="text"> <xsl:value-of select="DETALHAMENTO-DO-TRABALHO/@CIDADE-DA-EDITORA" /> </mods:placeTerm>
	    </mods:place>
	  </xsl:if>
	</mods:originInfo>

	<mods:genre authority="marcgt">conference publication</mods:genre>
	<xsl:apply-templates select="DETALHAMENTO-DO-TRABALHO/@ISBN"/>
      </mods:relatedItem>

      <xsl:apply-templates select="DADOS-BASICOS-DO-TRABALHO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TRABALHO/@HOME-PAGE-DO-TRABALHO"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TRABALHO/@DOI"/>
      <!-- <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/> -->
    </mods:mods>
  </xsl:template>


  <xsl:template match="TEXTO-EM-JORNAL-OU-REVISTA">
    <mods:mods ID="publication-{@SEQUENCIA-PRODUCAO}">
      <mods:titleInfo>
	<mods:title> <xsl:value-of select="DADOS-BASICOS-DO-TEXTO/@TITULO-DO-TEXTO" /> </mods:title>
      </mods:titleInfo>
      <xsl:if test="normalize-space(@TITULO-DO-TEXTO-INGLES) != ''">
	<mods:titleInfo type="translated">
	  <mods:title lang="en"><xsl:value-of select="DADOS-BASICOS-DO-TEXTO/@TITULO-DO-TEXTO-INGLES" /> </mods:title>
	</mods:titleInfo>
      </xsl:if>

      <xsl:for-each select="AUTORES">
	<xsl:sort data-type="number" select="@ORDEM-DE-AUTORIA"/>
	<mods:name type="personal">
	  <mods:namePart> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/> </mods:namePart>
	  <mods:role>
            <mods:roleTerm authority="marcrelator" type="text">author</mods:roleTerm>
	  </mods:role>
	</mods:name>
      </xsl:for-each>

      <mods:originInfo>
	<mods:dateIssued> <xsl:value-of select="DADOS-BASICOS-DO-TEXTO/@ANO-DO-TEXTO" /> </mods:dateIssued>
	<xsl:if test="normalize-space(DETALHAMENTO-DO-TEXTO/@DATA-DE-PUBLICACAO) != ''">
	  <mods:dateIssued><xsl:value-of select="DETALHAMENTO-DO-TEXTO/@DATA-DE-PUBLICACAO"/> </mods:dateIssued>
	</xsl:if>
      </mods:originInfo>

      <mods:part>
	<mods:extent unit="page">
	  <xsl:if test="normalize-space(DETALHAMENTO-DO-TEXTO/@PAGINA-INICIAL) != ''">
	    <mods:start><xsl:value-of select="DETALHAMENTO-DO-TEXTO/@PAGINA-INICIAL"/></mods:start>
	  </xsl:if>
	  <xsl:if test="normalize-space(DETALHAMENTO-DO-TEXTO/@PAGINA-FINAL) != ''">
	    <mods:end><xsl:value-of select="DETALHAMENTO-DO-TEXTO/@PAGINA-FINAL"/></mods:end>
	  </xsl:if>
	</mods:extent>
	<xsl:if test="string-length(DETALHAMENTO-DO-TEXTO/@VOLUME)>0">
	  <mods:detail type="volume"><mods:number><xsl:value-of select="DETALHAMENTO-DO-TEXTO/@VOLUME"/></mods:number></mods:detail>
	</xsl:if>
      </mods:part>

      <mods:relatedItem type="host">
	<mods:titleInfo> 
	  <mods:title> <xsl:value-of select="DETALHAMENTO-DO-TEXTO/@TITULO-DO-JOURNAL-OU-REVISTA"/> </mods:title>
	</mods:titleInfo>
	<mods:originInfo>
	  <mods:issuance>continuing</mods:issuance>
	</mods:originInfo>
	<mods:genre authority="marcgt">periodical</mods:genre>
	<mods:genre>magazine or newspaper</mods:genre>
	<xsl:apply-templates select="DETALHAMENTO-DO-ARTIGO/@ISSN"/> 
      </mods:relatedItem>

      <xsl:apply-templates select="DADOS-BASICOS-DO-TEXTO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TEXTO/@HOME-PAGE-DO-TRABALHO"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-TEXTO/@DOI"/>
      <!-- <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/> -->
    </mods:mods>
  </xsl:template>

  <xsl:template match="ARTIGO-PUBLICADO|ARTIGO-ACEITO-PARA-PUBLICACAO">
    <mods:mods ID="publication-{@SEQUENCIA-PRODUCAO}">
      <mods:titleInfo>
	<mods:title> <xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@TITULO-DO-ARTIGO" /> </mods:title>
      </mods:titleInfo>

      <xsl:for-each select="AUTORES">
	<xsl:sort data-type="number" select="@ORDEM-DE-AUTORIA"/>
	<mods:name type="personal">
	  <mods:namePart> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/> </mods:namePart>
	  <mods:role>
            <mods:roleTerm authority="marcrelator" type="text">author</mods:roleTerm>
	  </mods:role>
	</mods:name>
      </xsl:for-each>

      <mods:relatedItem type="host">
	<mods:titleInfo> 
	  <mods:title> <xsl:value-of select="DETALHAMENTO-DO-ARTIGO/@TITULO-DO-PERIODICO-OU-REVISTA"/> </mods:title>
	</mods:titleInfo>
	<mods:originInfo>
	  <mods:issuance>continuing</mods:issuance>
	</mods:originInfo>
	<mods:genre authority="marcgt">periodical</mods:genre>
	<mods:genre>academic journal</mods:genre>
	<xsl:apply-templates select="DETALHAMENTO-DO-ARTIGO/@ISSN"/> 
      </mods:relatedItem>

      <mods:originInfo>
	<mods:dateIssued> <xsl:value-of select="DADOS-BASICOS-DO-ARTIGO/@ANO-DO-ARTIGO" /> </mods:dateIssued>
      </mods:originInfo>
      <mods:typeOfResource>text</mods:typeOfResource>

      <mods:part>
	<mods:extent unit="page">
	  <xsl:if test="normalize-space(DETALHAMENTO-DO-ARTIGO/@PAGINA-INICIAL) != ''">
	    <mods:start><xsl:value-of select="DETALHAMENTO-DO-ARTIGO/@PAGINA-INICIAL"/></mods:start>
	  </xsl:if>
	  <xsl:if test="normalize-space(DETALHAMENTO-DO-ARTIGO/@PAGINA-FINAL) != ''">
	    <mods:end><xsl:value-of select="DETALHAMENTO-DO-ARTIGO/@PAGINA-FINAL"/></mods:end>
	  </xsl:if>
	</mods:extent>
	<xsl:if test="string-length(DETALHAMENTO-DO-ARTIGO/@VOLUME)>0">
	  <mods:detail type="volume"><mods:number><xsl:value-of select="DETALHAMENTO-DO-ARTIGO/@VOLUME"/></mods:number></mods:detail>
	</xsl:if>
	<xsl:if test="string-length(DETALHAMENTO-DO-ARTIGO/@FASCICULO)>0">
	  <mods:detail type="issue"><mods:number><xsl:value-of select="DETALHAMENTO-DO-ARTIGO/@FASCICULO"/></mods:number></mods:detail>
	</xsl:if>
	<xsl:if test="string-length(DETALHAMENTO-DO-ARTIGO/@SERIE)>0">
	  <mods:detail type="serie"><mods:number><xsl:value-of select="DETALHAMENTO-DO-ARTIGO/@SERIE"/></mods:number></mods:detail>
	</xsl:if>
      </mods:part>

      <mods:identifier type="citekey"> <xsl:text>#P</xsl:text><xsl:value-of select="@SEQUENCIA-PRODUCAO"/> </mods:identifier>
    </mods:mods>
  </xsl:template>


  <xsl:template match="LIVRO-PUBLICADO-OU-ORGANIZADO">
    <mods:mods ID="publication-{@SEQUENCIA-PRODUCAO}">
      <mods:titleInfo>
	<mods:title> <xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@TITULO-DO-LIVRO" /> </mods:title>
      </mods:titleInfo>

      <xsl:for-each select="AUTORES">
	<xsl:sort data-type="number" select="@ORDEM-DE-AUTORIA"/>
	<mods:name type="personal">
	  <mods:namePart> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/> </mods:namePart>
	  <mods:role>
            <mods:roleTerm authority="marcrelator" type="text">author</mods:roleTerm>
	  </mods:role>
	</mods:name>
      </xsl:for-each>

      <mods:originInfo>
	<mods:dateIssued> <xsl:value-of select="DADOS-BASICOS-DO-LIVRO/@ANO" /> </mods:dateIssued>
	<xsl:if test="string-length(DETALHAMENTO-DO-LIVRO/@NOME-DA-EDITORA)>0">
	  <mods:publisher> <xsl:value-of select="DETALHAMENTO-DO-LIVRO/@NOME-DA-EDITORA" /> </mods:publisher>
	</xsl:if>
	<xsl:if test="string-length(DETALHAMENTO-DO-LIVRO/@CIDADE-DA-EDITORA)>0">
	  <mods:place>
	    <mods:placeTerm type="text"> <xsl:value-of select="DETALHAMENTO-DO-LIVRO/@CIDADE-DA-EDITORA" /> </mods:placeTerm>
	  </mods:place>
	</xsl:if>
      </mods:originInfo>

      <mods:typeOfResource>text</mods:typeOfResource>
      <mods:genre>book</mods:genre>
      <mods:identifier type="citekey"> <xsl:text>#P</xsl:text><xsl:value-of select="@SEQUENCIA-PRODUCAO"/> </mods:identifier>
      <xsl:apply-templates select="DETALHAMENTO-DO-LIVRO/@ISBN"/>
    </mods:mods>
  </xsl:template>


  <xsl:template match="CAPITULO-DE-LIVRO-PUBLICADO">
    <mods:mods ID="publication-{@SEQUENCIA-PRODUCAO}">
      <mods:titleInfo>
	<mods:title> <xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@TITULO-DO-CAPITULO-DO-LIVRO" /> </mods:title>
      </mods:titleInfo>

      <mods:originInfo>
	<mods:dateIssued>  <xsl:value-of select="DADOS-BASICOS-DO-CAPITULO/@ANO" /> </mods:dateIssued>
      </mods:originInfo>

      <xsl:for-each select="AUTORES">
	<xsl:sort data-type="number" select="@ORDEM-DE-AUTORIA"/>
	<mods:name type="personal">
	  <mods:namePart> <xsl:value-of select="@NOME-COMPLETO-DO-AUTOR"/> </mods:namePart>
	  <mods:role>
            <mods:roleTerm authority="marcrelator" type="text">author</mods:roleTerm>
	  </mods:role>
	</mods:name>
      </xsl:for-each>
      
      <mods:relatedItem type="host">
	<mods:titleInfo>
	  <mods:title> <xsl:value-of select="DETALHAMENTO-DO-CAPITULO/@TITULO-DO-LIVRO" /> </mods:title>
	</mods:titleInfo>
	
	<mods:originInfo>
	  <xsl:if test="string-length(DETALHAMENTO-DO-CAPITULO/@NOME-DA-EDITORA)>0">
	    <mods:publisher> <xsl:value-of select="DETALHAMENTO-DO-CAPITULO/@NOME-DA-EDITORA" /> </mods:publisher>
	  </xsl:if>
	  <xsl:if test="string-length(DETALHAMENTO-DO-CAPITULO/@CIDADE-DA-EDITORA)>0">
	    <mods:place>
	      <mods:placeTerm type="text"> <xsl:value-of select="DETALHAMENTO-DO-CAPITULO/@CIDADE-DA-EDITORA" /> </mods:placeTerm>
	    </mods:place>
	  </xsl:if>
	</mods:originInfo>
	<mods:genre>collection</mods:genre>
	<xsl:apply-templates select="DETALHAMENTO-DO-CAPITULO/@ISBN"/>
      </mods:relatedItem>

      <mods:part>
	<mods:extent unit="page">
	  <xsl:if test="normalize-space(DETALHAMENTO-DO-CAPITULO/@PAGINA-INICIAL) != ''">
	    <mods:start><xsl:value-of select="DETALHAMENTO-DO-CAPITULO/@PAGINA-INICIAL"/></mods:start>
	  </xsl:if>
	  <xsl:if test="normalize-space(DETALHAMENTO-DO-CAPITULO/@PAGINA-FINAL) != ''">
	    <mods:end><xsl:value-of select="DETALHAMENTO-DO-CAPITULO/@PAGINA-FINAL"/></mods:end>
	  </xsl:if>
	</mods:extent>
	<xsl:if test="string-length(DETALHAMENTO-DO-CAPITULO/@NUMERO-DA-EDICAO-REVISAO)>0">
	  <mods:detail type="edition"> <mods:number> <xsl:value-of select="DETALHAMENTO-DO-CAPITULO/@NUMERO-DA-EDICAO-REVISAO"/> </mods:number> </mods:detail>
	</xsl:if>
	<xsl:if test="string-length(DETALHAMENTO-DO-CAPITULO/@NUMERO-DA-SERIE)>0">
	  <mods:detail type="serie"> <mods:number> <xsl:value-of select="DETALHAMENTO-DO-CAPITULO/@NUMERO-DA-SERIE"/> </mods:number> </mods:detail>
	</xsl:if>
      </mods:part>
      
      <mods:typeOfResource>text</mods:typeOfResource>
      <xsl:apply-templates select="DADOS-BASICOS-DO-CAPITULO/@IDIOMA"/>
      <xsl:apply-templates select="DADOS-BASICOS-DO-CAPITULO/@DOI"/>
    </mods:mods>
  </xsl:template>


  <xsl:template match="ORIENTACOES-CONCLUIDAS-PARA-MESTRADO">
    <mods:mods ID="publication-{@SEQUENCIA-PRODUCAO}">
      <mods:titleInfo>
	<mods:title> <xsl:value-of select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@TITULO" /> </mods:title>
      </mods:titleInfo>

      <mods:typeOfResource>text</mods:typeOfResource>
      <mods:genre authority="marcgt">thesis</mods:genre>
      <mods:genre>Masters thesis</mods:genre>
      <mods:identifier type="citekey">#P<xsl:value-of select="@SEQUENCIA-PRODUCAO"/></mods:identifier>

      <mods:originInfo>
	<mods:dateIssued> <xsl:value-of select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@ANO"/> </mods:dateIssued>
      </mods:originInfo>

      <mods:name type="corporate">
	<xsl:if test="string-length(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@CODIGO-INSTITUICAO)>0">
	  <xsl:attribute name="ID">
	    <xsl:value-of select="concat('institution-',DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@CODIGO-INSTITUICAO)"/>
	  </xsl:attribute>
	</xsl:if>
	<mods:namePart> <xsl:value-of select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@NOME-DA-INSTITUICAO"/> </mods:namePart>
        <mods:role>
	  <mods:roleTerm authority="marcrelator" type="text">degree grantor</mods:roleTerm>
	</mods:role>
      </mods:name>
      <mods:name type="personal">
	<xsl:if test="string-length(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@NUMERO-ID-ORIENTADO)>0">
	  <xsl:attribute name="ID">
	    <xsl:value-of select="concat('person-',DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@NUMERO-ID-ORIENTADO)"/>
	  </xsl:attribute>
	</xsl:if>
        <mods:namePart><xsl:value-of select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@NOME-DO-ORIENTADO"/></mods:namePart>
        <mods:role>
	  <mods:roleTerm authority="marcrelator" type="text">author</mods:roleTerm>
	</mods:role>
      </mods:name>
      <mods:name type="personal">
	<mods:namePart><xsl:value-of select="/CURRICULO-VITAE/DADOS-GERAIS/@NOME-COMPLETO"/></mods:namePart>
	<mods:role>
	  <mods:roleTerm type="text" authority="marcrelator">thesis advisor</mods:roleTerm>
	</mods:role>
      </mods:name>

      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@HOME-PAGE"/>
      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-MESTRADO/@IDIOMA"/>
      <!-- <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/> -->
    </mods:mods>
  </xsl:template>


  <xsl:template match="MESTRADO">
    <mods:mods ID="{concat('masterthesis-',@SEQUENCIA-FORMACAO)}">
      <mods:titleInfo>
	<mods:title> <xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE" /> </mods:title>
      </mods:titleInfo>
      <mods:titleInfo type="translated">
	<mods:title lang="en"><xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE-INGLES" /> </mods:title>
      </mods:titleInfo>

      <mods:typeOfResource>text</mods:typeOfResource>
      <mods:genre authority="marcgt">thesis</mods:genre>
      <mods:genre>Masters thesis</mods:genre>
      <mods:identifier type="citekey"><xsl:value-of select="concat('#masterthesis','-',@SEQUENCIA-FORMACAO)"/></mods:identifier>

      <mods:originInfo>
	<mods:dateIssued> <xsl:value-of select="@ANO-DE-OBTENCAO-DO-TITULO"/> </mods:dateIssued>
      </mods:originInfo>

      <mods:name type="corporate">
	<xsl:if test="string-length(@CODIGO-INSTITUICAO)>0">
	  <xsl:attribute name="ID">
	    <xsl:value-of select="concat('institution-',@CODIGO-INSTITUICAO)"/>
	  </xsl:attribute>
	</xsl:if>
	<mods:namePart> <xsl:value-of select="@NOME-INSTITUICAO"/> </mods:namePart>
        <mods:role>
	  <mods:roleTerm authority="marcrelator" type="text">degree grantor</mods:roleTerm>
	</mods:role>
      </mods:name>
      <mods:name type="personal">
	<xsl:if test="string-length(@NUMERO-ID-ORIENTADOR)>0">
	  <xsl:attribute name="ID">
	    <xsl:value-of select="concat('person-',@NUMERO-ID-ORIENTADOR)"/>
	  </xsl:attribute>
	</xsl:if>
        <mods:namePart><xsl:value-of select="@NOME-COMPLETO-DO-ORIENTADOR"/></mods:namePart>
	<mods:role>
	  <mods:roleTerm type="text" authority="marcrelator">thesis advisor</mods:roleTerm>
	</mods:role>
      </mods:name>
      <mods:name type="personal">
	<mods:namePart><xsl:value-of select="/CURRICULO-VITAE/DADOS-GERAIS/@NOME-COMPLETO"/></mods:namePart>
        <mods:role>
	  <mods:roleTerm authority="marcrelator" type="text">author</mods:roleTerm>
	</mods:role>
      </mods:name>
    </mods:mods>
  </xsl:template>


  <xsl:template match="ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO">
    <mods:mods ID="publication-{@SEQUENCIA-PRODUCAO}">
      <mods:titleInfo>
	<mods:title> <xsl:value-of select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@TITULO" /> </mods:title>
      </mods:titleInfo>

      <mods:typeOfResource>text</mods:typeOfResource>
      <mods:genre authority="marcgt">thesis</mods:genre>
      <mods:genre>Ph.D. thesis</mods:genre>
      <mods:identifier type="citekey">#P<xsl:value-of select="@SEQUENCIA-PRODUCAO"/></mods:identifier>

      <mods:originInfo>
	<mods:dateIssued> <xsl:value-of select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@ANO"/> </mods:dateIssued>
      </mods:originInfo>

      <mods:name type="corporate">
	<xsl:if test="string-length(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@CODIGO-INSTITUICAO)>0">
	  <xsl:attribute name="ID">
	    <xsl:value-of select="concat('institution-',DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@CODIGO-INSTITUICAO)"/>
	  </xsl:attribute>
	</xsl:if>
	<mods:namePart> <xsl:value-of select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@NOME-DA-INSTITUICAO"/> </mods:namePart>
        <mods:role>
	  <mods:roleTerm authority="marcrelator" type="text">degree grantor</mods:roleTerm>
	</mods:role>
      </mods:name>
      <mods:name type="personal">
	<xsl:if test="string-length(DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@NUMERO-ID-ORIENTADO)>0">
	  <xsl:attribute name="ID">
	    <xsl:value-of select="concat('person-',DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@NUMERO-ID-ORIENTADO)"/>
	  </xsl:attribute>
	</xsl:if>
        <mods:namePart><xsl:value-of select="DETALHAMENTO-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@NOME-DO-ORIENTADO"/></mods:namePart>
        <mods:role>
	  <mods:roleTerm authority="marcrelator" type="text">author</mods:roleTerm>
	</mods:role>
      </mods:name>
      <mods:name type="personal">
	<mods:namePart><xsl:value-of select="/CURRICULO-VITAE/DADOS-GERAIS/@NOME-COMPLETO"/></mods:namePart>
	<mods:role>
	  <mods:roleTerm type="text" authority="marcrelator">thesis advisor</mods:roleTerm>
	</mods:role>
      </mods:name>

      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@HOME-PAGE"/>
      <xsl:apply-templates select="DADOS-BASICOS-DE-ORIENTACOES-CONCLUIDAS-PARA-DOUTORADO/@IDIOMA"/>
      <!-- <xsl:apply-templates select="AREAS-DO-CONHECIMENTO"/> -->
    </mods:mods>
  </xsl:template>


  <xsl:template match="DOUTORADO">
    <mods:mods ID="{concat('phdthesis-',@SEQUENCIA-FORMACAO)}">
      <mods:titleInfo>
	<mods:title> <xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE" /> </mods:title>
      </mods:titleInfo>
      <mods:titleInfo type="translated">
	<mods:title lang="en"><xsl:value-of select="@TITULO-DA-DISSERTACAO-TESE-INGLES" /> </mods:title>
      </mods:titleInfo>

      <mods:typeOfResource>text</mods:typeOfResource>
      <mods:genre authority="marcgt">thesis</mods:genre>
      <mods:genre>Ph.D. thesis</mods:genre>
      <mods:identifier type="citekey"><xsl:value-of select="concat('#phdthesis','-',@SEQUENCIA-FORMACAO)"/></mods:identifier>

      <mods:originInfo>
	<mods:dateIssued> <xsl:value-of select="@ANO-DE-OBTENCAO-DO-TITULO"/> </mods:dateIssued>
      </mods:originInfo>

      <mods:name type="corporate">
	<xsl:if test="string-length(@CODIGO-INSTITUICAO)>0">
	  <xsl:attribute name="ID">
	    <xsl:value-of select="concat('institution-',@CODIGO-INSTITUICAO)"/>
	  </xsl:attribute>
	</xsl:if>
	<mods:namePart> <xsl:value-of select="@NOME-INSTITUICAO"/> </mods:namePart>
        <mods:role>
	  <mods:roleTerm authority="marcrelator" type="text">degree grantor</mods:roleTerm>
	</mods:role>
      </mods:name>
      <mods:name type="personal">
	<xsl:if test="string-length(@NUMERO-ID-ORIENTADOR)>0">
	  <xsl:attribute name="ID">
	    <xsl:value-of select="concat('person-',@NUMERO-ID-ORIENTADOR)"/>
	  </xsl:attribute>
	</xsl:if>
        <mods:namePart><xsl:value-of select="@NOME-COMPLETO-DO-ORIENTADOR"/></mods:namePart>
	<mods:role>
	  <mods:roleTerm type="text" authority="marcrelator">thesis advisor</mods:roleTerm>
	</mods:role>
      </mods:name>
      <mods:name type="personal">
	<mods:namePart><xsl:value-of select="/CURRICULO-VITAE/DADOS-GERAIS/@NOME-COMPLETO"/></mods:namePart>
        <mods:role>
	  <mods:roleTerm authority="marcrelator" type="text">author</mods:roleTerm>
	</mods:role>
      </mods:name>
    </mods:mods>
  </xsl:template>



  <xsl:template match="@HOME-PAGE|@HOME-PAGE-DO-TRABALHO">
    <xsl:if test="normalize-space(.) != ''">
      <mods:location>
	<mods:url displayLabel="electronic full text" access="raw object">
	  <xsl:choose>
	    <xsl:when test="starts-with(.,'[')">
	      <xsl:value-of select="substring(.,2,string-length(.)-2)"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="."/>
	    </xsl:otherwise>
	  </xsl:choose>
	</mods:url>
      </mods:location>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@DOI">
    <xsl:if test="normalize-space(.) != ''">
      <mods:identifier type="doi"><xsl:value-of select="."/></mods:identifier>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@ISBN">
    <xsl:if test="normalize-space(.) != ''">
      <mods:identifier type="isbn"><xsl:value-of select="."/></mods:identifier>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@ISSN">
    <xsl:if test="normalize-space(.) != ''">
      <mods:identifier type="issn"><xsl:value-of select="."/></mods:identifier>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@IDIOMA">
    <xsl:if test="normalize-space(.) != ''">
      <mods:language>
	<mods:languageTerm type= "text" authority="rfc4646"> <xsl:value-of select="."/> </mods:languageTerm>
      </mods:language>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()|@*|node()" priority="-1">
  </xsl:template>

</xsl:stylesheet>
