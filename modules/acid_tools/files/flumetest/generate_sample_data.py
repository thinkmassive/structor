import inflect

p = inflect.engine()

count = 25000
for i in xrange(1, count+1):
	if (i % 10 < 7):
		bucket = 0
	elif (i % 10 < 9):
		bucket = 1
	else:
		bucket = 2
	w = "number " + p.number_to_words(i)
	w = w.replace(",", "")
	w = w.replace(" ", "_")
	d = i + 0.1
	f = i + 0.2
	de = i + 0.3
	print "%s,%s,%s,%s,%f,%f,%0.2f,,%s,%s,%s" % (bucket, count, i, w, d, f, de, i, i, i)
