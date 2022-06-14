# Semantic Lattes
Autor e repositórios originais: Alexandre Rademaker (@arademaker) https://github.com/arademaker/SLattes

## Motivação

Os processos de automatização de Currículo são uma atividade importante aos centros de pesquisa. Uma vez que o sistema Lattes permite a exportação em formato XML torna-se possível a extração e conversão de tais dados e informações em formatos mais consensuais como o BibTex

## Objetivo

Portanto o objetivo desse repositório é concentrar as ferramentas e possibilidade de processar e exportar o dados de pesquisadoras e pesquisadores a partir dos seus respectivos XMLs

> É importante considerar que tal exportação pode conter infomações pessoais contendo dados sensíveis e devem ser considerados sob a perspectiva da LGPD, portanto os dados do XML deve estar anonimizados ou removidos antes de publicados. Já outros dados do Currículo não carecem de tal atenção

## Como utlizar

Para os usuários de Linux as seguintes bibliotecas/componentes devem ser instalados:

```
sudo apt install xsltproc
sudo apt install bibutils
```

Depois de instalados os seguintes comandos podem converter o formato XML do Lattes para BibTex:

```
xsltproc -v lattes2mods.xsl cvs/Profa_Mariana_Giannotti.xml > resultados/Profa_Mariana_Giannotti.mods

xml2bib -b -w resultados/Profa_Mariana_Giannotti.mods > resultados/Profa_Mariana_Giannotti.bib
```

## Próximos passos

A partir das possibilidade serão promovidos e documentadas outras formas e técnicas de extração ou conversão de dados, por exemplo, utilizando a Linguagem Python, R e JavaScript pensando em aplicações e formatos Web

## Colaboradores

http://arademaker.github.io - Alexandre Rademaker (EMAp/FGV)

http://www-di.inf.puc-rio.br/~hermann/ - Edward Hermann Haeusler (PUC-Rio)

## Links

http://lattes.cnpq.br/

http://www.w3.org/RDF/

http://lmpl.cnpq.br/lmpl/ 

http://scriptlattes.sourceforge.net/

