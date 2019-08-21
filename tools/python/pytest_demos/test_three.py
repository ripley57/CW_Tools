""" Test the Task data type (from pytest book)

	To run all tests:
		pytest test_three.py [-v]

	To run one specific test:
		pytest [-v] test_three.py::test_asdict

	Some handy pytest command-line options:
	--collect-only		preview which tests will be run
				NOTE: This option is useful to check if options
				      such as "-k" will do what you want.
	-k EXPRESSION		only run tests/classes which match the given
				substring expression.
				Example: -k 'test_method or test_other' matches
				all test functions and classes whose name
				contains 'test_method' or 'test_other'.
	-m MARKEXPR		only run tests matching given mark expression.
				example: -m 'mark1 and not mark2'.
	-x, --exitfirst 	exit instantly on first error or failed test.
	--maxfail=num 		exit after first num failures or errors.
	--capture=method 	per-test capturing method: one of fd|sys|no.
	-s 			shortcut for --capture=no.
	--lf, --last-failed	rerun only the tests that failed last time
				(or all if none failed)
	--ff, --failed-first 	run all tests but run the last failures first.
	-v, --verbose 		increase verbosity.
	-q, --quiet 		decrease verbosity.
	-l, --showlocals	show locals in tracebacks (disabled by default).
	--tb=style		traceback print mode (auto/long/short/line/native/no).
	--durations=N 		show N slowest setup/test durations (N=0 for all).
	--collect-only 		only collect tests, don't execute them.
	--version 		display pytest lib version and import information.
	-h, --help 		show help message and configuration info
"""

import pytest
from collections import namedtuple

Task = namedtuple('Task', ['summary', 'owner', 'done', 'id'])
Task.__new__.__defaults__ = (None, None, False, None)

def test_defaults():
	""" Using no parameters should invoke the defaults. """
	t1 = Task()
	t2 = Task(None, None, False, None)
	assert t1 == t2

#@pytest.mark.run_these_please
def test_member_access():
	""" Check .field funtionality of namedtuple """
	t = Task('buy milk', 'brian')
	assert t.summary == 'buy milk'
	assert t.owner == 'brian'
	assert (t.done, t.id) == (False, None)

def test_asdict():
	""" _asdict() should return a dictionary """
	print("Hello from test_asdict. You will see this output only if the test fails!")
	t_task = Task('do something', 'okken', True, 21)
	t_dict = t_task._asdict()
	expected = {	'summary': 'do something',
			'owner': 'okken',
			'done': True,
			'id': 221	}
	assert t_dict == expected

def test_replace():
	""" replace() should change passed-in fields. """
	t_before = Task('finish book', 'brian', False)
	t_after = t_before._replace(id=10, done=True)
	t_expected = Task('finish book', 'brian', True, 101)
	assert t_after == t_expected

