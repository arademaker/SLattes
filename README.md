
# Semantic Lattes

The purpose of this project is to bridging the gap between the
Brazilian Curriculum Lattes plataform and semantic web
technologies. We developed:

1. A XSLT stylesheet that process XML Brazilian Curriculum Lattes
   files [1] generating RDF data [2]. 

2. An updated DTD specification for the Lattes XML. The CNPq DTD
   specification is not uptated since 2003/2004.

3. A XSLT stylesheet that process XML Latttes and generate an MODS XML
   file.

## Status

We started the project in 2009 and we hope to have contributions. Our
first priority will be publications followed by academic activites and
personal information.


## Lattes to RDF

Usage:

    xsltproc --stringparam ID LATTESID lattes.xsl CURRICULIUM.xml > CURRICULIUM.rdf


## Latttes validation agains the DTD 

In Unix/MacOS systems you can also run:

    xmllint --dtdvalid LMPLCurriculo.DTD --noout <LATTES-XML> 


## Lattes to BibTeX

We developed a XSLT stylesheet that transforms a XML Lattes into a XML
in [MODS](http://www.loc.gov/standards/mods/) format.

You will need the following tools to actually obtain a BibTeX file
from your XML Lattes:

- [xsltproc](http://xmlsoft.org/XSLT/xsltproc2.html): to execute the
  xsl stylesheet.
- [xmllint](http://xmlsoft.org/xmllint.html): to validate the MODS XML
  generated (optional).
- [BibUtils](http://sourceforge.net/p/bibutils/): to transform the
  MODS XML in BibTeX file.
- [BibTool](http://www.gerd-neugebauer.de/software/TeX/BibTool/): to
  fix the keys and sort the entries in the final BibTeX file
  (optional).

To transform Lattes to BibTeX:

    xsltproc lattes2mods.xsl LATTES.xml > LATTES.mods
    xmllint --schema mods.xsd LATTTES.mods
    xml2bib -b -w LATTES.mods > LATTES.bib

Using bibtool command, you can also fix the citekeys and sort the
entries. In the command below, the output in the STDOUT will be
generated with keys like "2012:Rademaker.Hermann" and the entries will
be sorted in the inverse order by these keys.

    bibtool -f "%4d(year):%n(author)" -s LATTES.bib


## Authors

 * Alexandre Rademaker (EMAp/FGV), http://web.me.com/arademaker
 * Edward Hermann Haeusler (PUC-Rio), http://www.inf.puc-rio.br/~hermann


## More information

 * http://lattes.cnpq.br/
 * http://www.w3.org/RDF/
 * http://lmpl.cnpq.br/lmpl/ (precisely at http://lmpl.cnpq.br/lmpl/index.jsp?go=cv.jsp)


## Related projects

 * http://www.semanticlattes.com.br/
 * http://scriptlattes.sourceforge.net/

