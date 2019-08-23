""" Demonstrates how to create you own custom pytest option "--nice"

	Taken from eBook "Python testing with Pytest" page 98.
	NOTE: All the significant code is in file "conftest.py"

	To run this demo:
	pytest [-v] test_custom_option.py [--nice]

	NOTE:	This demo, when run using "test_api_exceptionfrom" from the eBook, 
		does not work...

	pytest -v func/test_api_exceptions.py -k TestAdd --nice
	...
	INTERNALERROR>     if pytest.config.getoption('nice'):
	INTERNALERROR> AttributeError: module 'pytest' has no attribute 'config'

	This error appears to be due to changed made to pytest.
	From https://github.com/pydata/xarray/issues/1353:
	"You cannot use pytest.config.getvalue() in code imported before pytest's 
	argument parsing takes place. For example, conftest.py files are imported
	before command line parsing and thus config.getvalue() will not execute 
	correctly."
	See also: https://github.com/pytest-dev/pytest/issues/5030

	NOTE:	Interestingly, this cut-down worked using the same code, but there
		was a warning:
	pytest -v test_custom_option.py --nice
	...
	.../conftest.py:21: PytestDeprecationWarning: the `pytest.config` global is deprecated.  
	Please use `request.config` or `pytest_configure` (if you're a pytest plugin) instead.
    		if report.failed and pytest.config.getoption('nice'):

	NOTE:	I fixed this by adding "config" to the declarations of the two pytest
		hooks, and then using "config.getoption()" instead of "pytest.config.getoption()".
		I tried this after seeing the "config" paramter in the definitions of 
		the hooks here: 
		https://docs.pytest.org/en/latest/_modules/_pytest/hookspec.html
"""


def test_nice_option_passed(nice):
    assert nice


def test_failure():
    assert 1 == 2

