"""Effect of variables with the same name in a class hierarchy

Note: This behaviour can be altered by declaring variables as
      private, e.g. '__z' instead of 'z'.
"""

# If Python can't find an instance variable, it tries to find it in a class variable
# of the same name. Only then, if it can't find it, will Python report an error.
# Because of this behaviour, class variables can be used to implement default values
# for instance variables. This saves the time and memory overhead of initializing
# the instance variable each time a class instance is created. HOWEVER, this approach
# makes it easy to inadvertently refer to an instance variable rather than a class
# variable, and this can cause a problem because these can have different values
# (remember that assignment to an instance variable will create an instance of the
# variable if it doesn't exist.)
# RECOMMENDATION: If you want to access or change a class variable, access it through
#                 the class name, not through an instance variable.

class P:
	z = 'Hello from P'

class C(P):
	pass

c = C()

# These search up the hierarchy for a variable of that name.
print(c.z)	;# 'Hello from P'
print(C.z)	;# 'Hello from P'
print(P.z)	;# 'Hello from P'

# Assigning to the class creates a separate class variable.
C.z = 'Hello from C'
print(c.z)	;# 'Hello from C'
print(C.z)	;# 'Hello from C'
print(P.z)	;# 'Hello from P'

# Assigning to the instance creates a separate instance variable.
c.z = 'Hello from instance c'
print(c.z)	;# 'Hello from instance c'
print(C.z)	;# 'Hello from C'
print(P.z)	;# 'Hello from P'
