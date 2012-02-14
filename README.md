
# Semantic Lattes

The purpose of this project is to bridging the gap between the
Brazilian Curriculum Lattes plataform and semantic web
technologies. We developed:

1. A XSLT stylesheet that process XML Brazilian Curriculum Lattes
   files [1] generating RDF data [2]. 

2. An updated version of the DTD specification for the Lattes XML. The
   original DTD provided by CNPq was last updated in 2004.

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
    
The second command above is not necessary. It is how one can validate
the MODS XML produced by the transformation. To run this command, you
will need to download the
[mods.xsd](http://www.loc.gov/standards/mods/mods-schemas.html) first.

Using bibtool command, you can also fix the citekeys and sort the
entries. In the command below, the output in the STDOUT will be
generated with keys like "2012:Rademaker.Hermann" and the entries will
be sorted in the inverse order by these keys.

    bibtool -f "%4d(year):%n(author)" -s LATTES.bib


## Authors

* Alexandre Rademaker (EMAp/FGV), http://arademaker.github.com
* Edward Hermann Haeusler (PUC-Rio), http://www.inf.puc-rio.br/~hermann


## License

<p></p>
<a rel="license"
href="http://creativecommons.org/licenses/by-sa/3.0/br/"><img
alt="Creative Commons License" style="border-width:0"
src="http://i.creativecommons.org/l/by-sa/3.0/br/88x31.png" /></a><br
/><span xmlns:dct="http://purl.org/dc/terms/"
href="http://purl.org/dc/dcmitype/Dataset" property="dct:title"
rel="dct:type">SLattes</span> by <a
xmlns:cc="http://creativecommons.org/ns#" href="http://emap.fgv.br"
property="cc:attributionName" rel="cc:attributionURL">EMAp, Getulio
Vargas Foundation</a> is licensed under a <a rel="license"
href="http://creativecommons.org/licenses/by-sa/3.0/br/">Creative
Commons Attribution-ShareAlike 3.0 Brazil License</a>.<br />Based on a
work at <a xmlns:dct="http://purl.org/dc/terms/"
href="https://github.com/arademaker/SLattes"
rel="dct:source">github.com</a>.

Take a look in the file LICENSE. 


## More information

* http://lattes.cnpq.br/
* http://www.w3.org/RDF/
* http://lmpl.cnpq.br/lmpl/ (precisely at http://lmpl.cnpq.br/lmpl/index.jsp?go=cv.jsp)


## Related projects

* http://www.semanticlattes.com.br/
* http://scriptlattes.sourceforge.net/

