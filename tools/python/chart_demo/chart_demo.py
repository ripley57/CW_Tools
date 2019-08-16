""" Creating a chart using Python matplotlib, with pandas, and with Jupyter Notebook.

	"Python pandas" was created to help you manipulate, clean and filter tabular data.

		http://pandas.pydata.org
		
	Apparently, it has methods for importing data from various different sources.
	pandas can import data from delimited text files, spreadsheets, JSON, XML and 
	HTML. It can also import data from SQL databases.

	While the same data manipulation could be done without using pandas, pandas 
	makes it a whole lot easier. On the downside, learning to use pandas is a lot 
	like learning a new language, because the syntax is not pure Python; the syntax 
	is specifically designed for manipulating data. For this reason, pandas is more
	like an extension to Python rather than a simple Python library.

	NOTE:	pandas also works with "Jupyter Notebooks". From what I have seen, a nice
		workflow is to first cleanse/filter/aggregate/chart your data visually in Jupyter
		Notebook and then automate the same approach using the same code but inside a 
		regular python script. What is cool is that, after cleansing your data, you can 
		then either save this to a new tabular output file, or generate a chart and save 
		that. And all this can also be automated using the same code inside a regular 
		Python script.

	Installing pandas:
		pip install pandas matplotlib

		If you want to do this from inside Jupyter Notebook:
		!pip install pandas matplotlib

		Using this inside Jupyter Notebook enables you to see the charts you create inline:
		%matplotlib inline

	Installing Jupter Notebook (not needed to run this demo):
		See jupyter_notebook.py

	Using pandas:
		It is common to always import these:
		import matplotlib
		import pandas as pd
		import numpy as np

	Plotting charts using matplotlib:
		https://realpython.com/python-matplotlib-guide/
"""

# In this demo we will merge, and chart, the data from two related CSV data files.
#
# File "sales_calls.csv" contains the number of sales calls made per employee, per terrtory, per month:
#
#	Team member,Territory,Month,Calls
#	Jorge,3,1,107
#	Jorge,3,2,88
#	Jorge,3,3,84
#	Jorge,3,4,113
#	Ana,1,1,91
#	Ana,1,2,129
#	Ana,1,3,96
#	Ana,1,4,128
#	Ali,2,1,120
#	Ali,2,2,85
#	Ali,2,3,87
#	Ali,2,4,87
#
# File "sales_revenue.csv" contains the sales revenue per territory, per month:
#
#	Territory,Month,Amount
#	1,1,54228
#	1,2,61640
#	1,3,43491
#	1,4,52173
#	2,1,36061
#	2,2,44957
#	2,3,35058
#	2,4,33855
#	3,1,50876
#	3,2,57682
#	3,3,53689
#	3,4,49173
#
# We are going to merge the data from these two tables and generate a charts in a png file.

import matplotlib
import pandas as pd

# Import our csv data files.
calls = pd.read_csv("sales_calls.csv")
#print(calls)
revenue = pd.read_csv("sales_revenue.csv")
#print(revenue)

# Lets merge the two tables, by "Teritory" and "Month".
calls_revenue = pd.merge(calls, revenue, on=['Territory','Month'])
#print(calls_revenue)

# Add an 'Amount per call' column.
calls_revenue['Amount per call'] = calls_revenue.Amount / calls_revenue.Calls

# Focussing only on "Territory" 3.
territory3 = calls_revenue[calls_revenue.Territory==3]
#print(territory3)

# ...and where the sales revenue per call was over 500.
over_500 = territory3[territory3.Amount/territory3.Calls>500]
#print(over_500)

# And let's add that calculation as a column to the results.
print(over_500)

# Group the sales by "Territory" and create a chart.
sales_by_territory = calls_revenue[['Territory','Amount']].groupby(['Territory']).sum().plot.bar() ;# Other options: plot.line(), plot.pie()
sales_by_territory.set_title("Sales by Territory")
fig = sales_by_territory.get_figure()
fig.savefig("sales_by_territory.png")

# Display sum(), mean(), median(), max(), and min() values for the 'Amount' column.
#print(calls_revenue.Amount.sum())
#print(calls_revenue.Amount.mean())
#print(calls_revenue.Amount.median())
#print(calls_revenue.Amount.min())
#print(calls_revenue.Amount.max())
