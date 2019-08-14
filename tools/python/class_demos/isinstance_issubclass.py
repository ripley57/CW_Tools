""" isinstance() and issubclass() """

class A:
	pass

class B(A):
	pass

b = B()

print(type(b))
print(b.__class__)	;# Same output as above
if type(b) == b.__class__:
	print("Yep, the same")

# A class is just another Python object, and can be passed around.
b_class = b.__class__
if b_class == B:
	print("Yep, the same again")

# List base classes.
print(B.__bases__)


class C:
	pass

class D:
	pass

class E(D):
	pass

x = 12
c = C()
d = D()
e = E()

# isinstance
print(isinstance(x, E))	;# False
print(isinstance(c, E))	;# False
print(isinstance(e, E))	;# True
print(isinstance(e, D))	;# True
print(isinstance(d, E))	;# False

# issubclass
print(issubclass(C, D))			;# False
print(issubclass(E, D))			;# True
print(issubclass(D, D))			;# True
print(issubclass(e.__class__, D))	;# True
