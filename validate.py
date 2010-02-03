import sys
from xml.parsers.xmlproc import xmlproc
from xml.parsers.xmlproc import xmlval
from xml.parsers.xmlproc import xmldtd

# XML file and corresponding DTD definition
try:
    file = sys.argv[1]
except:
    print '''USE: validate.py <arquivo>
    python validate.py 10801-5378246377632366.xml'''
    sys.exit(1)

dtd  = 'LMPLCurriculo.DTD'

d = xmldtd.load_dtd(dtd)
p = xmlval.XMLValidator()
p.parse_resource(file)
