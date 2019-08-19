
class Calculator:

	def add(self, x, y):
		number_types = (int, float)

		if isinstance(x, number_types) and isinstance(y, number_types):
			## Old-school 'printf' debugging.
			#print('X is: {}'.format(x))
			#print('Y is: {}'.format(y))

			# Attach Python debugger pdb.
			# See also https://code.tutsplus.com/tutorials/beginning-test-driven-development-in-python--net-30137
			#import pdb; pdb.set_trace()

			result = x - y
			#print('Result is: {}'.format(result))
			return result
		else:
			raise ValueError
