""" The csv module can create a dictionary for you """

import csv

results = [fields for fields in csv.DictReader(open("temp_data_dirty.csv", newline=''))]
print(results[0]['State'])
print(results[0])
