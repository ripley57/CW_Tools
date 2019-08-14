""" 	Python special method attributes, including __str__ 

	__str__ is similar to implementing Java's toString() method.

	There are other "special method attributes" in additon to __str__.
	They can be used to help you create classes that, for example, 
	behave as lists or dictionaries. To the user they would appear
	as a list, but your underlying implementation could be completely
	original, e.g. using a balanced tree to store the list contents.
"""

class Colour:
	def __init__(self, red, green, blue):
		self._red = red
		self._green = green
		self._blue = blue
	def __str__(self):
		return "Colour: R={0:d}, G={1:d}, B={2:d}".format(self._red, self._green, self._blue)


# Demo 1
# The __str__ special method attribute.
c = Colour(15, 35, 3)
print(c)	;# Colour: R=15, G=35, B=3


# Demo 2
# The __getitem__ special method attribute.
# Make an object behave like a list. 
#
# Any object that defines __getitem__ as an instance method can return elements as though
# it were a list: all accesses of the form 'object[i]' are translated into 'object.__getitem__(i)'
#
# The "LineReader" class defined below is only intended to be used inside a 'for' loop.
# We take advantage of the fact that a 'for' loop generates calls with an increasing index value
# passed: __getitem__(self,0), __getitem__(self,1), etc. Note that we ignore this index value,
# because we don't use it.
#
# Note that this is not a full list emulation, because we don't also implement versions of
# other special method attributes such as "__setitem" or "__add__" (for concatenation),
# "__mul__", "__len__", "__delitem__", "append()", "insert()", "extend()".
#
# The problem:
# 	We want to be able to read lines like this from a file:
#
#	John Smith::37::Springfield, Massachusetts
#	Ellen Nelle::25::Springfield, Connecticut
#	Dale McGladdery::29::Springfield, Hawaii
#
#	Wouldn't it be great if we could read and return each line as a list?
#	What we do below is create a class "LineReader" that behaves like a list.

def create_test_data(filename="testdata.txt"):
	data = [	'John Smith::37::Springfield, Massachusetts\n',
			'Ellen Nelle::25::Springfield, Connecticut\n',
			'Dale McGladdery::29::Springfield, Hawaii\n'	]
	file = open(filename, 'w')
	file.writelines(data)
	file.close

class LineReader:
	def __init__(self, filename):
		self.fileobject = open(filename, 'r')
	def __getitem__(self, index):
		line = self.fileobject.readline()
		if line == "":
			self.fileobject.close()
			raise IndexError	;# NOTE: The 'for' loop automatically catches this exception.
		else:
			return line.split("::")[:2]	;# Return just the first two fields.
		
create_test_data("testdata.txt")
for name, age in LineReader("testdata.txt"):
	print("name={0}, age={1}".format(name, age))


# Demo 3
# A slightly fuller implementation of a list.
#
# Note that this is still not a full list implementation, because it does include:
# "__add__", "__mul__", "__len__", "__delitem__", "append()", "insert()", "extend()".
#
# NOTE: An alternative to implementing all these methods, is to subclass 'list'. See
#       the demo below this one.
#
# Python allows you to have different data types in a list.
# Here we'll implement a list type that only allows a single data type.

class TypedList:
	def __init__(self, example_element, initial_list=[]):
		""" 	Passed parameter indicates the only allowed type in our list. 
			We also check any optionally passed initial list. 
		"""
		self.type = type(example_element)	;# We will only allow this data type in our list.
		if not isinstance(initial_list, list):
			raise TypeError("Second argument of TypedList must be a list")
		for element in initial_list:
			self.__check(element)
		self.elements = initial_list[:]

	def __setitem__(self, i, element):
		self.__check(element)
		self.elements[i] = element

	def __getitem__(self, i):
		return self.elements[i]

	def __check(self, element):
		if type(element) != self.type:
			raise TypeError("Attempted to add an element of incorrect type")

x = TypedList('Hello', ["List", "of", "strings"])
x[2] = "Wibble"
print(x[1])
y = TypedList('bob', 10 * [""])	;# Initialise a list with 10 elements.
y[8] = 'ooooh'


# Demo 4
#
# Here we'll save ourself some work, by subclassing the 'list' built-in type, 
# rather than implement each of the "special method attributes" for a list.
# We will only override the methods that we need to.
# Remember that every type in Python is a class, including 'list'.

class TypedListList(list):
	def __init__(self, example_element, initial_list=[]):
		self.type = type(example_element)
		if not isinstance(initial_list, list):
			raise TypeError("Second argument must be a list")
		for element in initial_list:
			self.__check(element)
		super().__init__(initial_list)

	def __check(self, element):
		if type(element) != self.type:
			raise TypeError("Attempted to add an element of incorrect type")

	def __setitem__(self, i, element):
		self.__check(element)
		super().__setitem__(i, element)

# Now our class supports every list method.
z = TypedListList("", 5 * [""])
z[2] = 'Hello'
z[3] = 'There'
print(z[2] + ' ' + z[3])
a, b, c, d, e = z
print(a, b, c, d)
print(z[:])
print(len(z))
z.sort()
print(z[:])


# Demo 5
#
# As an alternative to subclassing the 'list' class...
#
# Before subclassing the built-in 'list' class was possible, you had to subclass the
# "UserList" class from the "collections" module.
#
# Note that the underlying list is available as the "data" attribute. Having access
# to list can be useful. Similar classes exist: "UserDict" and "UserString".

from collections import UserList
class TypedUserList(UserList):
	def __init__(self, example_element, initial_list=[]):
		self.type = type(example_element)
		if not isinstance(initial_list, list):
			raise TypeError("Second argument must be a list")
		for element in initial_list:
			self.__check(element)
		super().__init__(initial_list)

	def __check(self, element):
		if type(element) != self.type:
			raise TypeError("Attempted to add a element of incorrect type")

	def __setitem__(self, i, element):
		self.__check(element)
		self.data[i] = element

	def __getitem__(self, i):
		return self.data[i]

a = TypedUserList("", 5 * [""])
a[2] = "Goodbye"
print(a[2])

