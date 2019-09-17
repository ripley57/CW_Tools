""" Demo of python builtin logging """

import pytest

from results_printer import ResultsPrinter


def test_print_results_table():

	data = ['9', '8', '7', '6', '5', '4', '3', '2', '1', '9', '8', '7', '6', '5', '4', '3', '2']

	printer = ResultsPrinter(data)
	results_lines = printer.print_results(3,3)
	actual = '\n'.join(results_lines)

	expected = """\
9 8 7
6 5 4
3 2 1

9 8 7
6 5 4
3 2
"""

	assert(expected == actual)

