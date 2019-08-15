""" REST examples using Python 


	NOTE: The following is a good website for free API services to test:
	https://jsonplaceholder.typicode.com/

	For example:
	https://jsonplaceholder.typicode.com/todos/1


	To install the "requests" Python library:
	python3 -m pip install --user requests
	(The "--user" option installs under ~/ rather than into the Python system installation files)
"""

import requests
import json


#response = requests.get("https://jsonplaceholder.typicode.com/todos/1")
#print(response.text)


# Some Chicago crime data
#
# NOTE: Our url string get automatically encoded by the "requests" library, e.g. space characters are replaced with %20 etc.
# 
response = requests.get("https://data.cityofchicago.org/resource/6zsd-86xi.json?$where=date between '2015-01-10T12:00:00' and '2015-01-10T13:00:00'&arrest=true")
#print(json.dumps(response.json(), indent=4))	;# pretty print - see https://www.simplifiedpython.net/python-json-pretty-print/


# Let's convert the json into a Python object.
#
# NOTE: If you look at the json output, it is an array of json objects. When converted to a Python
#       object, this gives us a Python list or dictionaries.
#
obj = response.json()	;# Note: "json.loads(response.text)" is the same as "response.json()". We're using the simpler code.
print(type(obj))	;# 'list'
print(type(obj[0]))	;# 'dict'. Each list entry is a 'dict', i.e. one 'dict' per crime details.
# As a test, print the description of a single crime:
print(obj[0]['description'])	;# When I ran this it returned "TELEPHONE THREAT" as the crime!
# Print all the crime descriptions:
descs = [ x['description'] for x in obj ]
print(descs) 

# We can also write the json response to a file (Note how the "indent=2" option gives us a "pretty print" output):
with open("crime_data.json", "w") as f:
	json.dump(obj, f, indent=2)

# Here are different ways to get a "pretty print":
from pprint import pprint as pp
pp(obj)
print(json.dumps(obj, indent=2))	;# Note this method appears to give more readable output.


# NOTE: A comment about writing JSON-formatted objects to a file.
#
# Say you have two separate JSON objects that you want too save in the same output file as JSON.
# If you use "json.dump()" to save each object, the combined final file will not be valid JSON.
# However, if you're aware of this, you can read each object like this from the file:
#	for line in open('data.json'):
#		objs.append(json.loads(line)
#
# An alternative approach is to first create a list of your JSON objects and write then to your
# output file in one go. BUT, apparently there is a possible vulnerability with using a top-level
# array/list in JSON like this, so it's recommended to put your list into a dictionary and save
# that to your output file, e.g.:
#	outfile = open('data.json', 'w')
#	obj_to_save = {'items':objs, 'count':2}
#	json.dump(obj_to_save, outfile)
#	outfile.close()
# 
# And because the output file is now valid JSON, you can load it in one go:
#	with open('data.json', 'r') as infile:
#		obj = json.load(infile)
#

