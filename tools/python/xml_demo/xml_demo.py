""" Handling XML data using Python 

	NOTE:
	The Python standad library includes modules to help parse and handle
	XML data, but they're not particularly convenient to use.
	An easier tool to use is "xmltodict", which apparently uses the
	standard library's "expat" XML parser behind the scenes.
	You can use this to convert from and to a dictionary representation
	of an XML document.
		
	Short "xmltodict" intro here:
	https://omz-software.com/pythonista/docs/ios/xmltodict.html

	To install:
	pip install xmltodict
	or
	python3 -m pip install --user xmltodict		(this installs the library under ~/ and does not interfere with the python system installation)


	The example XML file in this demo looks like the following composition of dictionaries after importing into Python:

	'dwml' : {
			'@version', '1.0', 
			'@xmlns:xsd', 'http://www.w3.org/2001/XMLSchema', 
			'@xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance', 
			'@xsi:noNamespaceSchemaLocation', 'http://www.nws.noaa.gov/forecasts/xml/DWMLgen/schema/DWML.xsd', 
		'head' : {
			'product' : {
				'@srsName', 'WGS 1984', 
				'@concise-name', 'glance', 
				'@operational-mode', 'official', 
				'title' : "NOAA's National Weather Service Forecast at a Glance", 
				'field' : 'meteorological', 
				'category' : 'forecast', 
				'creation-date' : {
					'@refresh-frequency' : 'PT1H', 
					'#text', '2017-01-08T02:52:41Z'
				}
			},
			'source' : {
				'more-information' : 'http://www.nws.noaa.gov/forecasts/xml/',
				'production-center' : {
					'sub-center' : 'Product Generation Branch', 
					'#text' : 'Meteorological Development Laboratory'
				},
				'disclaimer' : 'http://www.nws.noaa.gov/disclaimer.html', 
				'credit' : 'http://www.weather.gov/', 
				'credit-logo'  : 'http://www.weather.gov/images/xml_logo.gif', 
				'feedback' :  'http://www.weather.gov/feedback.php'
			}
		},
		'data' : {
			'location' : [
				{
					'location-key' : 'point1', 
					'point'  : {
						'@latitude' : '41.78', 
						'@longitude' : '-88.65'
					}
				},
				{
					'location-key' : 'point2', 
					'point'  : {
						'@latitude' : '10.50', 
						'@longitude' : '-20.00'
					}
				}
			]
		}
	}
"""

import xmltodict

data = xmltodict.parse(open("observations_01.xml").read())

# Let's print a few values from the XML file...

print(data['dwml']['head']['product']['title'])				;# "NOAA's National Weather Service Forecast at a Glance",
print(data['dwml']['@version'])						;# "1.0"
# If an element includes both a text value and a sub-element, the text value is named '#text':
print(data['dwml']['head']['source']['production-center']['#text'])	;# "Meteorological Development Laboratoy"
# A repeated element becomes a list:
print(data['dwml']['data']['location'][1]['location-key'])		;# "point2"

