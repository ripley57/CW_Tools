# Python packages

# Having a single large module file is not a good idea. 
# A package enables related module files to be grouped together.
#
# module	-	A module is a file containing code, usually related functions, classes, variables, etc.
#			The name of the module is the name of the file.
#
# package	-	A package is a directory containing related module files, or further subdirectories.
#			The name of the package is the name of the main package directory.
#			QUESTION: What is the "main package directory" ????


# "__init__.py" files
#
#	o An "__init__.py" file is required for a directory to be recognised as a package.
#	  This is to prevent possibly misc Python code from being accidentally imported. 
#	o The "__init__.py" file is automatically executed the first time a package
# 	  (or sub-package) is loaded. This enables you to perform package initialisation.
#
# NOTE: For most packages, you won't need to put anything in the "__init__.py" file.


# "__all__" optional attribute in "__init__.py" files
#
# This is to support "mathproj import *"
# You would hope that this import all non-private names from mathproj. 
# If present, this should be a list of strings defining the names that are to be 
# imported when a "from ... import *" is executed on that particular package.
#
# NOTE: If "__all__" isn't present, "from ... import *" does nothing.
# NOTE: If you use "__all__" to try and hide certain names (by not listing them),
#       a better approach is to make those names private using the "__" prefix.


# Demo package structure:
#
# mathproj/__init__.py
# mathproj/comp/__init__.py
# mathproj/comp/c1.py
# mathproj/comp/numeric/__init__.py
# mathproj/comp/numeric/n1.py
# mathproj/comp/numeric/n2.py
#
# NOTE: While it's possible to create a complex package directory structure, a
#       two-level hierarchy should be sufficient as a maximum - "Flat is better than nested".

import mathproj.comp.numeric.n1
mathproj.comp.numeric.n1.g()

