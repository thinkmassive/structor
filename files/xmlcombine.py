#!/usr/bin/env python
import os
import sys
from xml.etree import ElementTree

def run(base, module, options):
	elements = {}

	first = ElementTree.parse(base).getroot()
	for c in first.getchildren():
		tag = c[0].text
		elements[tag] = c
	keys = elements.keys()

	files = [ "/vagrant/modules/%s/templates/config-%s.xml" % (module, x) for x in options ]
	for filename in files:
		data = ElementTree.parse(filename).getroot()
		for d in data:
			key = d[0].text
			if key not in keys:
				keys.append(key)
				first.insert(-1, d)
				elements[key] = d
			else:
				first.remove(elements[key])
				first.insert(-1, d)
				elements[key] = d

	if first is not None:
		os.rename(base, base + "." + str(os.getpid()))
		with open(base, "w") as fd:
			fd.write(ElementTree.tostring(first))

if __name__ == "__main__":
	base = sys.argv[1]
	module = sys.argv[2]
	options = sys.argv[3].split(",")
	run(base, module, options)
