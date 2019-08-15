""" Simple demo of creating an Excel file in Python.

	You must install the OpenPyXL third-party library (see the comments in "excel_demo.py").
"""

import csv
from openpyxl import Workbook

data = [fields for fields in csv.reader(open("temp_data_clean.txt"), delimiter="|")]

wb = Workbook()
ws = wb.active
ws.title = "temperature data"
for row in data:
	ws.append(row)
wb.save("output_xlsx.xlsx")
