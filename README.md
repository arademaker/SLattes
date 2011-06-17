
# Semantic Lattes

The purpose of this project is to bridging the gap between the
Brazilian Curriculum Lattes plataform and semantic web
technologies. We developed a XSLT stylesheet that process XML
Brazilian Curriculum Lattes files [1] generating RDF data [2]. We have
also developed a updated DTD specification for the Lattes XML. The
CNPq DTD specification is not uptated since 2003/2004.


## Status

We have just started the project and we hope to have
contributions. Our first priority will be publications followed by
academic activites and personal information.


## XSLT's usage


    xsltproc --stringparam ID LATTESID lattes.xsl CURRICULIUM.xml > CURRICULIUM.rdf


## DTD usage


You can use the "validate.py" python script. However, in Unix/MacOS
systems you can also run:

    xmllint --dtdvalid LMPLCurriculo.DTD --noout <LATTES-XML> 


## Authors


 * Alexandre Rademaekr (EPGE/FGV, PUC-Rio)
   http://web.me.com/arademaker

 * Edward Hermann Haeusler (PUC-Rio)
   http://www.inf.puc-rio.br/~hermann


## More information


 * http://lattes.cnpq.br/
 * http://www.w3.org/RDF/
 * http://lmpl.cnpq.br/lmpl/ (precisely at http://lmpl.cnpq.br/lmpl/index.jsp?go=cv.jsp)


## Related projects

 * http://www.semanticlattes.com.br/
 * http://scriptlattes.sourceforge.net/

