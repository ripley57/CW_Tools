""" Demo showing python builtin logging """

import logging
import sys

class ResultsPrinter():
	def __init__(self, data):
		self.data = data
		self.result_rows = []

		#logging.basicConfig(filename='app.log', level=logging.ERROR) 
		root = logging.getLogger()
		root.setLevel(logging.ERROR)
		handler = logging.StreamHandler(sys.stdout)
		root.addHandler(handler)

	def print_results(self, rows_per_page=3, columns_per_page=3):
		self.rows_per_page = rows_per_page
		self.columns_per_page = columns_per_page
		self.results_per_page = rows_per_page * columns_per_page

		first_index = 0
		last_index = len(self.data) - 1

		logging.debug("DEBUG: data={}".format(self.data))
		logging.debug("DEBUG: first_index={}".format(first_index))
		logging.debug("DEBUG: last_index={}".format(last_index))
		logging.debug("DEBUG: rows_per_page={}".format(self.rows_per_page))
		logging.debug("DEBUG: columns_per_page={}".format(self.columns_per_page))

		# Print each page of results
		page_start_index = first_index
		while page_start_index <= last_index:
			page_end_index = min(page_start_index + self.results_per_page - 1, last_index)
			self._print_page(page_start_index, page_end_index)
			self.result_rows.append("")
			page_start_index = page_end_index + 1

		return self.result_rows

	def _print_page(self, first_index, last_index):
		logging.debug("DEBUG: _print_page({},{})".format(first_index, last_index))
		row_start_index = first_index
		while row_start_index <= last_index:
			row_end_index = min(row_start_index + self.columns_per_page - 1, last_index)
			self._print_row(row_start_index, row_end_index)
			row_start_index = row_end_index + 1

	def _print_row(self, first_index, last_index):
		logging.debug("DEBUG: _print_row({},{})".format(first_index, last_index))
		row_list = self.data[first_index:last_index+1]
		self.result_rows.append(' '.join(row_list))


if __name__ == '__main__':
	input_values = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B']
	results_printer = ResultsPrinter(input_values)
	lines = results_printer.print_results(3,3)
	for l in lines:
		print(l)

