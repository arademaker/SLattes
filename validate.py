
import sys
from StringIO import StringIO
from lxml import etree

try:
    dtd = etree.DTD(sys.argv[1])
    root = etree.parse(sys.argv[2])
    if dtd.validate(root) == False:
        print dtd.error_log.filter_from_errors()
except:
    print 'USE:\n\t validate.py <arquivo> \n'
    sys.exit(1)

