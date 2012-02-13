<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE rdf:RDF [
 <!ENTITY mods "http://www.loc.gov/mods/v3">
]>

<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:mods="http://www.loc.gov/mods/v3">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:template match="/">
    <mods:modsCollection>
      <xsl:apply-templates />
    </mods:modsCollection>
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
      <rdf:type rdf:resource="&foaf;Agent" />
    </rdf:Description>
  </xsl:template>

  <xsl:template match="CURRICULO-VITAE">
    <xsl:apply-templates select="PRODUCAO-BIBLIOGRAFICA|OUTRA-PRODUCAO" />
  </xsl:template>

  <xsl:template match="OUTRA-PRODUCAO|PRODUCAO-BIBLIOGRAFICA|TRABALHOS-EM-EVENTOS|ARTIGOS-PUBLICADOS|LIVROS-E-CAPITULOS|
		       LIVROS-PUBLICADOS-OU-ORGANIZADOS|CAPITULOS-DE-LIVROS-PUBLICADOS|TEXTOS-EM-JORNAIS-OU-REVISTAS">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="ORIENTACOES-CONCLUIDAS">
    <xsl:apply-templates />
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
    <mods:mods ID="#P{@SEQUENCIA-PRODUCAO}">
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
      <identifier type="citekey"> <xsl:text>#P</xsl:text><xsl:value-of select="@SEQUENCIA-PRODUCAO"/> </identifier>
    </mods:mods>
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
      <dc:contributor>
	<xsl:attribute name="rdf:resource">
	  <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	</xsl:attribute>
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
      <dc:contributor>
	<xsl:attribute name="rdf:resource">
	  <xsl:apply-templates select="//DADOS-GERAIS" mode="ref" />
	</xsl:attribute>
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
