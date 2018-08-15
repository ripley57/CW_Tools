'''
	o import statements search through the list of paths in sys.path
	o sys.path always includes the path of the script invoked on the command 
	  line and is agnostic to the actual working directory on the command line.
	o Any folder containing a file named __init__.py is considered a package.
        o In Python 3.3 and above, any folder (even without a __init__.py file) 
	  is considered a package.
'''

import sys

print("Python package search path: \n%s" % "\n".join(sys.path))

# To change the package search path you can add additional
# paths to the PYTHONPATH environment variable, or you can
# maniuplate sys.path, e.g.:

print("\nWith added package directory \"Utils\" :\n")
sys.path.append("Utils")
print("New Python package search path: \n%s" % "\n".join(sys.path))

# More info on sys.path and PYTHONPATH:
# https://leemendelowitz.github.io/blog/how-does-python-find-packages.html


