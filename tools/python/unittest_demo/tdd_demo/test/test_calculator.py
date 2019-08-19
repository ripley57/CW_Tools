import unittest

from app.calculator import Calculator


class TddInPythonExample(unittest.TestCase):

	# setUp() and tearDown() called before each "test_" method. 
	# Part of standard unittest Python module, see:
	# https://docs.python.org/2/library/unittest.html
	def setUp(self):
		self.calc = Calculator()
	
	def test_calculator_add_method_returns_correct_result(self):
		result = self.calc.add(2,2)
		self.assertEqual(4, result)

	def test_calculator_returns_error_message_if_both_args_not_numbers(self):
		self.assertRaises(ValueError, self.calc.add, 'two', 'three')

	def test_calculator_returns_error_message_if_x_arg_not_number(self):
		self.assertRaises(ValueError, self.calc.add, 'two', 3)

	def test_calculator_returns_error_message_if_y_arg_not_number(self):
		self.assertRaises(ValueError, self.calc.add, 2, 'three')

# This is handy if you just want to run this test module on its own quickly.
if __name__ == '__main__':
	unittest.main()

