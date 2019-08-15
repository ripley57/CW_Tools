""" A more advanced csv module demo

    In this demo the input data file is not particularly 'clean', i.e.:
	* This is a csv file, but some of the field values include an embedded comma.
	* Some fields are quoted even though they don't contain an embedded comma.
	* The first field is empty.

    NOTE: Handling data like this is where the "csv" Python module becomes really handy,
	  because it handles all these problems for us automatically!
"""

import csv

# Note: the default delimiter is a comma.
results = [fields for fields in csv.reader(open("temp_data_dirty.csv", newline=''))]
print(results)
