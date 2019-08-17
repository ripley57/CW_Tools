import unittest

from product import Product

# For more info on the "unittest" standard Python module:
# https://docs.python.org/3.5/library/unittest.html
# See also "Practices of the Python Pro"

class ProductTestCase(unittest.TestCase):
	def test_transform_name_for_sku(self):
		# given
		small_black_shoes = Product('shoes', 'S', 'black')

		# when
		actual_value = small_black_shoes.transform_name_for_sku()

		# then
		expected_value = 'SHOES'
		self.assertEqual(expected_value, actual_value)

#if __name__ == '__main__':
#	unittest.main()

