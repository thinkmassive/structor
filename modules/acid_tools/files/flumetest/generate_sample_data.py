import inflect

p = inflect.engine()

for i in xrange(1, 25001):
	w = p.number_to_words(i)
	w = w.replace(",", "")
	d = i + 0.1
	f = i + 0.2
	de = i + 0.3
	print "%s,%s,%f,%f,%0.2f,,%s,%s,%s" % (i, w, d, f, de, i, i, i)
