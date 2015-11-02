class Node:
	name = None
	children = {}
	attributes = {}

	def __init__(self):
		self.children = {}
		self.attributes = {}
		self.name = "HEAD"

	def __str__(self):
		me  = self.name + ":"
		me += str(self.attributes)
		for child in self.children.values():
			me += "\n%s -> %s: " % (self.name, child.name) + str(child)
		return me

	def set_name(self, name):
		self.name = name

	def get_name(self):
		return self.name

	def set_attribute(self, key, val):
		self.attributes[key] = val

	def get_attribute(self, key):
		return self.attributes[key]

	def get_child(self, name):
		return self.children[name]

	def get_children(self):
		return self.children.values()

	def add_child(self, name):
		self.children[name] = Node()
		self.children[name].set_name(name)
		return self.children[name]
