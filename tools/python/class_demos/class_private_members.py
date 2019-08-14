""" Introduction to private class members """

# A private variable or method is one that can't be seen outside the methods of the
# class in which it's defined. 
#
# They have two purposes:
# 1. Control external access.
# 2. Prevent issues with name clashes from inheritance (see same_name_variables.py)
#
# A class can define a private variable and inherit from a class that defines a
# private variable of the same name. This doesn't cause a problem, because a
# separate copy of them are kept.
#
# Declaring variables and methods as private also makes the code more readable;
# anything not declared private is part of the class's public interface.
#
# NOTE: A variable or method is declared as private using a prefix of '__'.

class Mine:
	def __init__(self):
		self.x = 2
		self.__y = 3
	def print_y(self):
		print(self.__y)

m = Mine()

# works
print(m.x)

# fails
print(m.__y)

# but non-private method CAN access the private variable
print(m.print_y)
