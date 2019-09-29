# Creating a plugin for Pytest

The following installs a pytest plugin of the same conftest.py changes:

`pip install dist/pytest-nice-0.1.0.tar.gz`

(See "Python Testing with Pytest" page 109.)


**NOTE:** You can keep these plugin ".tar.gz" files (from your own custom plugins or
other downloaded plugins), in any shared directory somewhere. You can then install
them from there using this:

`pip install --no-index --find-links myplugins pytest-nice`

The "--no-index" tells pip to not go out to PyPI to look for what you want to install.
The "--find-links myplugins" tells PyPI to look in "myplugins" for packages to install. 
And of course, "pytest-nice" is what we want to install in this example.

To upgrade your plugin:

`pip install --upgrade --no-index --find-links myplugins pytest-nice`

