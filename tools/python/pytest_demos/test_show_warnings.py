""" From https://docs.pytest.org/en/latest/warnings.html

	NOTE: 	Added this test because the first mention of warnings and "recwarn" in
		my eBook "Python Testing with Pytest" (page 92) is very confusing.
		The examples in the book use "recwarn.pop()" to essentially prevent
		the warning from being displayed at the end of the session.

	To run:
		pytest test_show_warnings.py
"""

import warnings


def api_v1():
    # The following will cause a warning to be displayed at the end of the test output.
    warnings.warn(UserWarning("api v1, should use functions from v2"))
    return 1


def test_one():
    assert api_v1() == 1
