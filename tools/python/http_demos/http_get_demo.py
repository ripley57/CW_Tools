""" Demo to retrieve a file via HTTP GET 

	This demo requires the "requests" library. To install:
		python3 -m pip install --user requests
"""

import requests

response = requests.get(" http://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/heathrowdata.txt")

with open("downloaded_file.txt", "w", newline="\n") as f:
	f.write(response.text.replace("\r\n","\n")) 	;# Convert Windows \n\r line-endings to Linux \n
