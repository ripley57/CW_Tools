""" Full demo showing downloading and manipulating of tabular data using Python

	Files created by this demo:
		inventory.txt
		stations.txt
		weather_UK000056225.txt
		weather_UK000056225_data.db
		min_temperatures.png
		max_temperatures.png

	NOTE:	If the weather site ever disappears for some reason, real-life examples of
		downloaded files inventory.txt and stations.txt files can be found here:
		"/files/06_eBooks/PYTHON/Quick Python Book/Case_study_page354/"
"""

from collections import namedtuple
import os.path
import matplotlib
import pandas as pd
import requests
import sqlite3

# Create 'inventory.txt' file.
inventory_file_name='inventory.txt'
if not os.path.exists(inventory_file_name):
	r = requests.get('https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-inventory.txt')
	with open(inventory_file_name, 'w') as file:
		file.write(r.text)
with open(inventory_file_name, 'r') as file:
	inventory_txt = file.read()

# Create 'stations.txt' file.
stations_file_name='stations.txt'
if not os.path.exists(stations_file_name):
	r = requests.get('https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt')
	with open(stations_file_name, 'w') as file:
		file.write(r.text)
with open(stations_file_name, 'r') as file:
	stations_txt = file.read()


# Import the "inventory.txt" file.
#
# We'll use "namedtuple" from the "collections" library to create a custom class with each column named.
#	https://www.tutorialspoint.com/namedtuple-in-python
Inventory = namedtuple("Inventory", ['station','latitude','longitude','element','start','end'])
#
# The fields in our "inventory.txt" data file are not delimited, but we know each field size.
# At the same time, we'll also convert the 'latitiude' and 'longtitude' values to floats, and 
# the 'start' and 'end' year values to integers.
inventory = [ Inventory(x[0:11], float(x[12:20]), float(x[21:30]), x[31:35], int(x[36:40]), int(x[41:45]))
		for x in inventory_txt.split("\n") if x.startswith("UK") ]
# Debug: Print the first 4 results.
#for line in inventory[:4]:
#	print(line)


# Extract just temperature recordings, and with a large 'start' -> 'end' range.
#
# We only want to look at temperature recording, so we only want to the lines where the 'element' value
# is 'TMIN' or 'TMIN'. Furthermore, we want a decent range of years in our results, so we'll only use
# lines where the 'start' year is before 1920, and the 'end' year is at least 2015.
inventory_temps = [x for x in inventory if x.element in ['TMIN','TMAX'] and x.end >= 2015 and x.start < 1920]
# Debug: Print the first 5 results.
#for line in inventory_temps[:5]:
#	print(line)


# Determine the 'station' nearest to us, based on our latitude and longitude.
#
# We'll do this my the looking for the shortest differences between our current 
# latitude and longitude values and those in our data.
#
# Our current location, (manually) determined using https://www.whatsmygps.com/:
latitude, longitude = 51.409, -1.337
#
# Sort our results based on closeness to us.
inventory_temps.sort(key=lambda x: abs(latitude-x.latitude) + abs(longitude-x.longitude))
# Debug: Print the first 5 results.
#print("latitude:", latitude, "longtitude:", longitude)
#for line in inventory_temps[:5]:
#print(line)
#
# We'll use the first result, i.e. the closest station to, e.g. 'UK000056225'
station_id = inventory_temps[0].station


# Find the metadata for our chosen station in the "stations.txt" file.
#
# We could loop through the file one line at a time, but instead we'll use the same approach as we used
# for the "inventory.txt" file, and use "namedtuple" to create a class.
Station = namedtuple("Station", ['station_id', 'latitude', 'longitude', 'elevation', 'state', 'name', 'start', 'end'])
stations = [ (x[0:11], float(x[12:20]), float(x[21:30]), float(x[31:37]), x[38:40].strip(), x[41:71].strip())
		for x in stations_txt.split("\n") if x.startswith(station_id) ]
#print(type(stations))	;# This is a 'list'
# Note how we pass an expanded tuple. Note also how we ensure that we have 'start' and 'end' year values.
station = Station(*stations[0] + (inventory_temps[0].start, inventory_temps[0].end))
#print(station)


# Fetch the "weather" data file for our chosen station.
#
# Downlaod and create 'weather_<station_id>.txt' file.
weather_file_name = 'weather_{}.txt'.format(station.station_id)
if not os.path.exists(weather_file_name):
	r = requests.get('https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/all/{}.dly'.format(station.station_id))
	weather_txt = r.text
	with open(weather_file_name, 'w') as weather_file:
		weather_file.write(weather_txt)
# Open the weather data file.
with open(weather_file_name, 'r') as file:
	weather_txt = file.readlines()


# Parse the weather data file.
#
def parse_line(line):
	""" parses one line of weather data (i.e. data for one month). """
	if not line:
		return None

	# Split our first 4 fields, and the string containing temperature values for each day of the month.
	record, temperature_string = (line[:11], int(line[11:15]), int(line[15:17]), line[17:21]), line[21:]

	# raise exception if temperature_stirng is too short.
	if len(temperature_string) < 248:
		raise ValueError("String not long enough - {} {}".format(temperature_string, str(line)))

	# Use a list comprehension on temperature_string to extract and convert the values.
	# Notice how we use "range()" to extract each value. 
	# Each numeric value is 5 characters, and they are each 8 characters apart.
	# Missing values for any day are indicated by a valud of "-9999".
	values = [ float(temperature_string[i:i+5])/10 for i in range(0, 248, 8) if not temperature_string[i:i+5].startswith("-9999") ]

	# Calculate values based on all the days of the month.
	count = len(values)
	tmax = round(max(values),1)
	tmin = round(min(values),1)
	mean = round(sum(values)/count,1)

	# Add our calculated values to the fields extracted earlier, and return them.
	return record + (tmax, tmin, mean, count)
#
# Test out function.
#print(parse_line(weather_txt[18]))
#
# Read the weather data using our function.
weather_data = [parse_line(x) for x in weather_txt if x]
#print(len(weather_data))
# Debug: Print first 5 lines:
#for line in weather_data[:5]:
#	print(line)


# [OPTIONAL] Save our weather data to an SQLite database.
# (This isn't required for this demo to complete).
#
weather_database_file = 'weather_{}_data.db'.format(station.station_id)
if not os.path.exists(weather_database_file):
	conn = sqlite3.connect(weather_database_file)
	cursor = conn.cursor()

	# Create the 'weather' table.
	create_weather = """CREATE TABLE "weather" (
				"id" text NOT NULL,
				"year" integer NOT NULL,
				"month" integer NOT NULL,
				"element" text NOT NULL,
				"max" real,
				"min" real,
				"mean" real,
				"count" integer)"""
	cursor.execute(create_weather)
	conn.commit()

	# Store the weather data.
	for record in weather_data:
		cursor.execute("""INSERT INTO weather (id, year, month, element, max, min, mean, count) values (?,?,?,?,?,?,?,?)""", record)
	conn.commit()
else:
	conn = sqlite3.connect(weather_database_file)
	cursor = conn.cursor()
#
# Example usage of our database: fetch only TMAX records.
cursor.execute("""SELECT * FROM weather where element='TMAX' order by year, month""")
tmax_data = cursor.fetchall()
# Debug: Print first 5 results.
#for line in tmax_data[:5]:
#	print(line)


# Select only the temperature records from our weather data.
#
tmax_data = [x for x in weather_data if x[3] == 'TMAX']
tmin_data = [x for x in weather_data if x[3] == 'TMIN']
# Debug: Print first 5 results.
#for line in tmin_data[:5]:
#	print(line)


# Graph our data and create png images.
#
# Use pandas.
tmin_df = pd.DataFrame(tmin_data, columns=['Station', 'Year', 'Month', 'Element', 'Max', 'Min', 'Mean', 'Days'])
tmax_df = pd.DataFrame(tmax_data, columns=['Station', 'Year', 'Month', 'Element', 'Max', 'Min', 'Mean', 'Days'])
#
# We have daily temperature readings for each day of the month, for over 100 years. That's a lot of values
# to plot. Because of this, we'll average the monthly min/max/mean values into yearly values, and plot these.
# We'll use pandas to this, because the grouping feature is perfect for this.
tmin_plot = tmin_df[['Year','Min','Mean','Max']].groupby('Year').mean().plot(kind='line',figsize=(16,4))
tmin_plot.set_title("Min temperatures")
tmin_fig = tmin_plot.get_figure()
tmin_fig.savefig("min_temperatures.png")
tmax_plot = tmax_df[['Year','Min','Mean','Max']].groupby('Year').mean().plot(kind='line',figsize=(16,4))
tmax_plot.set_title("Max temperatures")
tmax_fig = tmax_plot.get_figure()
tmax_fig.savefig("max_temperatures.png")

