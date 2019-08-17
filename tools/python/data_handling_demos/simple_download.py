""" Simple http download example """

import requests

output_file_name='output.txt'
r = requests.get('http://www.google.com/')
with open(output_file_name, 'w') as file:
	file.write(r.text)
