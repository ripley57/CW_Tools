""" A simple csv module demo 

	In this demo, the input data file is said to be 'clean', i.e. easy to handle.

	We could write our own code to read the fields, e.g.:

	results = []
	for line in open("temp_data_clean.txt"):
		fields = line.strip().split("|")
		results.append(fields)

	But we'll use the "csv" Python module instead.

"""

import csv

results = [fields for fields in csv.reader(open("temp_data_clean.txt", newline=''), delimiter="|")]
print(results)
