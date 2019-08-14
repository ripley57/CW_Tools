"""	Demonstrates scoping rules and access to private and non-private variables and methods

	Note: Edit and play with this script to get a feel for everything.

	See page 224 of "The Quick Python Books 3rd Ed".
"""

# When you're in a method of a class, you have direct access to...
#
# ...the "local namespace":
# This includes the method's parameters (argumentss) and any variables 
# declared in the method.
#
# ...the "global namespace":
# This includes funtions and variables declared at the module level.
#
# ...the "built-in namespace":
# This includes built-in functions and exceptions.
#
# NOTE: These three namespaces are searched in the order declared above.
#
#
# Using the 'self' variable, you also have instance to...
#
# ...the "instance's namespace":
# Ths includes instance variables, private instance variables, superclass
# instance variables.
#
# ...the "class's namespace".
# This includes class methods, class variables, private class methods, 
# private class variables.
#
# ...the "superclass's namespace".
# This includes superclass methods and superclass class variables.
#
# NOTE: These three namespaces are searched in the order declared above.
#
# 
# NOTE: As per above, private superclass instance variables, 
# private superclass methods, and private superclass class variables
# cannot be accessed from the inheriting class. A class is therefore
# able to hide these from its children.


# Start of demo.

mv = "module variable: mv"

def mf():
	return "module function: mf()"


# our superclass in this demo
class SC:
	# Class-level variables (shared between all instances of the class).
	# These also exist independently of any instances of this class.
	scv = "superclass variable: self.scv (to assign you must use SC.scv)" 
	__pscv = "private superclass variable: no access"

	def __init__(self):
		self.sciv = "superclass instance variable: self.sciv (to assign you must use SC.sciv)"
		self.__psciv = "private superclass instance variable: no access"

	def scm(self):
		return "superclass method: self.scm()"

	def __pscm(self):
		return "private superclass method: no access"


# a class inherited from superclass
class C(SC):
	cv = "class variable: self.cv (to assign you must use C.cv)"
	__pcv = "private class variable: self.__pcv (to assign you must use C.__pcv)"
	
	def __init__(self):
		SC.__init__(self)
		self.__pciv = "private class instance variable: self.__pciv"

	def cm(self):
		return "class method: self.cm()"

	def __pcm(self):
		return "private class method: self.__pm()"

	def m(self, p="parameter: p"):
		lv = "local variable: lv"
		self.civ = "class instance variable: self.civ"
		print("We can access local, global and built-in namespaces...")
		#print("local namespace (locals):", list(locals().keys()))
		print(p)		;# Method parameter
		print(lv)		;# Local variable
		#print("global namespace (globals):", list(globals().keys()))
		print(mv)		;# Module variable
		print(mf())		;# Module function
		print("We can access instance, class, and superclass namespaces, through 'self'...")
		#print("instance namespace (dir(self)):", dir(self))
		print(self.civ)		;# Class instance variable
		print(self.__pciv)	;# Class private instance variable
		print(self.sciv)	;# Superclass instance variable
		#print("class namespace (dir(C)):", dir(C))
		print(self.cv)		;# Class variable
		print(self.cm())	;# Class method
		print(self.__pcv)	;# Private class variable
		print(self.__pcm())	;# Private class method
		#print("superclass namespace (dir(SC)):", dir(SC))
		print(self.scm())	;# Superclass method
		print(self.scv)		;# Superclass variable

c = C()
c.m()
