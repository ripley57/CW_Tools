
# C++: Multiple inheritance in C++ is possible, but people avoid using it because it is so complicated.
#
# Java: Multiple inheritance is NOT possible in Java, but a class can implement multiple interfaces.
#
# Python: Multiple inheritance IS possible in Python.
# 
# If there were no clashing instance variable or method names, multiple inheritance would simply 
# create a class combining all the involved classes. The new class could therefore be used as if
# it were instances of any of the other classes.
#
# Example:
# 	class A(B, C, D):
#		...
#
# Things get more complicated when classes have some identical method names. If your new class 
# doesn't define ae method, but several of the classes you inhertied from does, which should 
# Python call? This is depends on Python's search order. Example:
#
#   E   F          G
#    \ /           |
#     B	     C	   D
#      \     |	  /
#       \    |   /
#            A
#
# Suppose we create an instance of class A and then call method a.f(), where f() is 
# defined in all of F, C and G. Which f() get's called?
# =>
# 1. Python first looks in class A.
# 2. Python looks in the first base class of A, which is B.
# 3. Python looks in the in the first base class of B, which is E.
# 4. Python goes back to class B and looks in the next base class, which is F.
