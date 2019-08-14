# Third-party Python libraries, and virtual environments

NOTE: First check that the Python standard library doesn't already do what you need.


## The "Python Packge Index" (aka "The Cheese Shop")
A reliable place to find third-party packages is the "Python Package Index" (or "PyPI"),
formerly known as the "The Cheese Shop" (soon to be replaced by "The Warehouse"):

https://pypi.python.org

NOTE: This is where the "pip" command tries to find packages for you, plus any dependencies,
      and then performs the installation.


## pip
Example: Install the "requests" library:
	python3 -m pip install requests

From "man python3":
       -m module-name
              Searches sys.path for the named module and runs the corresponding .py file as a script.

To update a package:
	python3 -m pip install --upgrade requests

If you need to specify a particular version of a package:
	python3 -m pip install requests==2.11.1
	python3 -m pip install requests>=2.9


## The pip "--user" flag.
This is used when you don't want to install a package in the main system instance of Python.
Or, because you don't have installation permissions to the system Python installation.

The "--user" flag installs the library in the user's home directory, where it's not accessible
to other users, e.g.:

python3 -m pip install --user requests


## Virtual environments
This option is even better than using "--user".
A virtual environment is a self-contained directory structure that contains both an installation
of Python and any additional packages that you install. 

To create a (Python 3) virtual environment:
python3 -m venv test-env
This creates an environment with Python, and with "pip" installed, in the directory named "test-env".

To use the environment, you need to "activate" it...
Windows example
test-env\Scripts\activate.bat
Linux example:
source test-env/bin/activate

Once activated, you will be using the "pip" included in the virtual environment, and you can run
it as a standalone command, like this:
pip install requests

NOTE: The version of Python used to create the environment is the default Python for that environment.
      Which means you can create separate Python 2 and Python 3 environments using "python2" and "python3".


JeremyC 14-08-2019
