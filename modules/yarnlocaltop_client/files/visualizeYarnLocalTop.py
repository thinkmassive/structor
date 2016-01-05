#!/usr/bin/python

from Node import Node
from optparse import OptionParser

import sys

try:
	import pygraphviz as pgv
except:
	assert False, "Requires GraphViz and pygraphviz to be installed"

def main():
	example = "visualizeYarnLocalTop.py -n TezChild -t 0.03 -k FutureTask:run -f output.txt"
	parser = OptionParser(epilog=example)
	parser.add_option("-f", "--file")
	parser.add_option("-k", "--killlist")
	parser.add_option("-n", "--threadname")
	parser.add_option("-o", "--output", default="output.png")
	parser.add_option("-t", "--threshold", default=0.01)
	(options, args) = parser.parse_args()
	if options.file == None:
		print "Error: Input file (-f) option is required"
		parser.print_help()
		sys.exit(1)
	if options.threadname == None:
		print "Error: Thread name (-n) option is required"
		parser.print_help()
		sys.exit(1)
	threshold = float(options.threshold)

	ignorePackage = {
		"com.sun.proxy" : 1,
		"java.lang.reflect" : 1,
		"java.net" : 1,
		"java.io" : 1,
		"org.apache.hadoop.hive.cli" : 1,
		"org.apache.hadoop.util" : 1,
		"sun.reflect" : 1,
		"sun.nio.cs" : 1,
	}
	ignorePrefix = [
		"org.apache.thrift.",
		"org.apache.log4j.",
		"org.apache.hadoop.hive.metastore.",
	]
	killList = {
	}

	threadname = options.threadname
	traceTree = Node()
	trace = []
	oldPackage = None
	globalCounts = {}

	# Build a kill list if specified.
	if options.killlist:
		killList = dict([(x, 1) for x in options.killlist.split(",")])

	with open(options.file) as fd:
		for line in fd:
			if not line.startswith(" "):
				addTrace(traceTree, trace, killList, globalCounts)
				trace = []
				oldPackage = None
				continue
			line = line.rstrip()
			(thread, traceInfo) = line.split(",")
			thread = thread.lstrip()
			if threadname and threadname != thread:
				continue
			leftParen = traceInfo.rfind("(")
			traceInfo = traceInfo[:leftParen]
			path = traceInfo.split(".")
			method = path.pop()
			clazz = path.pop()
			package = ".".join(path)
			if package in ignorePackage:
				continue

			addPackage = True
			for prefix in ignorePrefix:
				if package.startswith(prefix):
					addPackage = False

			if addPackage == True and package != oldPackage:
				oldPackage = package
				trace.append((package, clazz, method))

	addPercentages(traceTree)
	dumpTree(traceTree, globalCounts, threshold)

def buildGraph(graph, parent, child, totalCount, globalCounts, threshold=0.01):
	parentNodeName = parent

	myPercent = child.get_attribute("percent")
	if myPercent < threshold:
		return

	childNodeName = child.get_name()
	childNodeCount = child.get_attribute("count")
	strPercent = "%0.2f%%" % (myPercent * 100)
	effectiveNodeName = "%s (%s)" % (childNodeName, strPercent)

	ratio = childNodeCount * 1.0 / globalCounts[childNodeName]
	offsetPercent = 0
	if ratio < 0.75:
		#print "Counts for %s:" % childNodeName, globalCounts[childNodeName], totalCount
		offsetPercent = globalCounts[childNodeName] * 1.0 / totalCount

	graph.add_node(effectiveNodeName, fillcolor=setColor(myPercent, offsetPercent))
	graph.add_edge(parentNodeName, effectiveNodeName)
	for subchild in child.get_children():
		buildGraph(graph, effectiveNodeName, subchild, totalCount, globalCounts, threshold)

def dumpTree(tree, globalCounts, threshold=0.01, outputFile="output.png"):
	A=pgv.AGraph()
	A.node_attr['style']='filled'
	A.node_attr['fillcolor']='white'

	myPercent = tree.get_attribute("percent")
	A.add_node("HEAD", fillcolor=setColor(myPercent, 0))

	totalCount = tree.get_attribute("count")
	for child in tree.get_children():
		buildGraph(A, "HEAD", child, totalCount, globalCounts, threshold)

	# Create the image.
	A.write('.graph.dot')
	B=pgv.AGraph('.graph.dot')
	B.layout(prog="dot")
	B.draw(outputFile)

def getLevel(percent):
	level = hex(255 - int(255 * percent))[2:]
	if len(level) == 1:
		level = "0" + level
	return level

def setColor(percent, offsetPercent):
	if offsetPercent > 1:
		offsetPercent = 1
	green = getLevel(percent)
	if offsetPercent > 0:
		blue = getLevel(offsetPercent)
	else:
		blue = green
	result = "#ff%s%s" % (green, blue)
	return result

def addTrace(traceTree, trace, killList, globalCounts):
	if len(trace) > 0:
		# Build the trace path.
		array = [ "%s:%s" % (t[1], t[2]) for t in trace ]
		array.reverse()

		# Check for a path we are suppressing.
		for step in array:
			if step in killList:
				return

		# Increment this path's count.
		thisNode = traceTree
		increment(thisNode)
		addGlobalCount(globalCounts, thisNode.get_name())
		for step in array:
			try:
				thisNode = thisNode.get_child(step)
			except:
				thisNode = thisNode.add_child(step)
			increment(thisNode)
			addGlobalCount(globalCounts, thisNode.get_name())

def addGlobalCount(globalCounts, name):
	if name in globalCounts:
		globalCounts[name] += 1
	else:
		globalCounts[name] = 1

def addPercentToTree(node, totalCount):
	myCount = node.get_attribute("count")
	node.set_attribute("percent", myCount * 1.0 / totalCount)
	for child in node.get_children():
		addPercentToTree(child, totalCount)

def addPercentages(traceTree):
	totalCount = traceTree.get_attribute("count")
	addPercentToTree(traceTree, totalCount)

def increment(node):
	count = 0
	try:
		count = node.get_attribute("count")
	except:
		pass
	node.set_attribute("count", count + 1)

if __name__ == "__main__":
	main()
