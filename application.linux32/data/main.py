import csv

def main():


	foutput = open('nestegg-index', 'w')
	codes = {}

	# get codes for every state
	statecodes = open('statecodes.txt')
	reader = csv.reader(statecodes, delimiter="\t")

	# skip header lines
	next(reader, None)

	# create the codes dictionary
	for row in reader:
		name = row[0]
		code = row[3]
		codes[name] = code
	statecodes.close()

	# merge the codes with the data file
	datafile = open('nestegg-index-2012')
	reader = csv.reader(datafile, delimiter="\t")

	# skip header lines
	next(reader, None)

	# write to the final output file
	for row in reader:
		name = row[1]
		code = codes[name]
		amount = row[2]
		foutput.write("%s\t%s\t%s\n" % (code, name, amount))

	datafile.close()
	foutput.close()

if __name__ == '__main__':
	main()