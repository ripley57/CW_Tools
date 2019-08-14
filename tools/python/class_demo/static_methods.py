
# @staticmethod and @classmethod
#
# You can define a static method similar to Java:
#       @staticmethod
#       def total_area():
#               total = 0
#               for c in Circle.all_circles:
#                       total += c.area()
#               return total
# Note that no 'self' parameter is included.
#
# The following is also a static method
#       @classmethod
#       def total_area(cls):
#               total = 0
#               for c in cls.all_circles:
#                       total += c.area()
#               return total
# Note that the class is passed as a parameter. By not refering explicitly to
# the class name (e.g. 'Circle'), any class inheriting this class can call this
# static method and have it refer to their own members, not the base class's.
# Static methods are inside the class's namespace, and are therefore a good way
# to bundle utility functions related to the class.

