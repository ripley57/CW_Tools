""" cvs module demo - note in particular the use of 'lineterminator' """

import csv

temperature_data = [	['State', 'Month Day, Year Code', 'Avg Daily Max Air Temperature (F)', 'Record Count for Daily Max Air Temp (F)'],
			['Illinois','1979/01/01','17.48','994'],
			['Illinois','1979/01/02','4.64','994']	]

# NOTE: lineterminator is used below to ensure that we get '\n' and not '\r\n' in the output file.
#       Using just "newline='\n'" does not work!
#       See https://stackoverflow.com/questions/3191528/csv-in-python-adding-an-extra-carriage-return-on-windows
with open('output_csv.csv', 'w', newline='\n') as f:
	csv_writer = csv.writer(f, lineterminator='\n')
	csv_writer.writerows(temperature_data)

# Let's now write the data to a file as a dictionary...

# First we'll read our csv file into a dictionary.
results = [fields for fields in csv.DictReader(open("output_csv.csv", newline=''))]
##print(results[0])

# Then get just the field names.
fields = results[0].keys()
##print(fields)

# Now we do the write.
with open('output2','w', newline='') as f:
	dict_writer = csv.DictWriter(f, fieldnames=fields, lineterminator='\n')
	dict_writer.writeheader()
	dict_writer.writerows(results)
