"""
	Demo showing how to invoke classes from your own Python package.
	This demo works with Python 2.7 and Python 3.6.

        o Any folder containing a file named __init__.py is considered a package.
        o However, in Python 3.3 and above, any folder (even without a __init__.py file)
          is considered a package (each folder becomes an implicit namespace package).
          The distinction between a module and a package therefore seems very blurred.
	o File __init__.py can contain package initialization code (see this demo,
	  where code in the __init__.py files is required when using the first method
	  of invoking my own class).
	
	Note: 
	o Even after reading...
	  https://chrisyeh96.github.io/2017/08/08/definitive-guide-python-imports.html
	  ...I'm still not 100% sure how this all works. 
        o This demo shows two different	ways to use a class defined in your own written 
	  Python package. Which method is better, I'm not sure. The first method looks
	  like it might be better though, as the __init__.py files seem to control what 
	  is accessible to the user.
	o Info on Python docstring:
	  https://www.geeksforgeeks.org/python-docstrings
"""

import sys

print("\nPython version: \n%s\n" % sys.version)

# The Package and module search path can be changed by either changing
# the PYTHONPATH environment variable, or by updating sys.path.
#sys.path.append("Utils")

#
# AcestreamHelper class
#
import Utils
print(Utils.Acestream.AcestreamHelper.__doc__)
ahelper = Utils.Acestream.AcestreamHelper()
ahelper.is_url("http://wibble.com")

#
# AcestreamHelper2 class
#
from Utils.Acestream.AcestreamHelper2 import AcestreamHelper2
print(AcestreamHelper2.__doc__)
ahelper2 = AcestreamHelper2()
ahelper2.is_url2("http://wobble.com")
