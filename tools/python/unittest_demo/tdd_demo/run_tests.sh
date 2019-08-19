# Python unit testing - "unittest" vs "nosetest" vs "pytest"
#
# See https://code.tutsplus.com/tutorials/beginning-test-driven-development-in-python--net-30137
#
# "nosetest" and "pytest" are different Python testing frameworks. They include different 
# "test runners", meaning that they differ in how they display the running tests and how 
# they display the test failure output. IMO you can use straight "unittest", i.e. without
# needing to install a library such as "pytest", but "pytest" does give nice colourisation
# of errors etc. There may be also additional benefits as my tests start to get more complex.
# 
# JeremyC 19-08-2019

# Classic "unittest" module test runner.
# The "unittest" module is part of the Python standard library.
# Run all tests:
#python3 -m unittest
# Run a specific test module:
#python3 -m unittest test/test_calculator.py

# "nosetest" test runner.
# pip install nose
# For more info on the "nosetests":
# https://pythontesting.net/framework/nose/nose-introduction/
# Run all tests in our "test" package:
#nosetests test
# Run a specific test module:
#nosetests test/test_calculator.py

# "py.test" test runner.
# pip install pytest
# pytest has nice colouration, showing failures in red.
# pytest also has a hany "Captured stdout call" section at the bottom
# that contains all output written to stdout from the (failing) tests.
# Run all tests in our "test" package:
#py.test test/
# Run a specific test module:
py.test test/test_calculator.py

