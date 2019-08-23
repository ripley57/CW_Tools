"""Define some fixtures to use in the project."""

import pytest


# Indicates if the "--nice" option was specified.
@pytest.fixture()
def nice(pytestconfig):
    return pytestconfig.option.nice


# Adds our own "--nice" option to pytest.
def pytest_addoption(parser):
    """Turn nice features on with --nice option."""
    group = parser.getgroup('nice')
    group.addoption("--nice", action="store_true",help="nice: turn failures into opportunities")


def pytest_report_header(config):
    """Thank tester for running tests."""
    if config.getoption('nice'):
        return "Thanks for running the tests."


# Called after tests have run.
def pytest_report_teststatus(report, config):
    """Turn failures into opportunities."""
    if report.when == 'call':
        if report.failed and config.getoption('nice'):
            return (report.outcome, 'O', 'OPPORTUNITY for improvement')
