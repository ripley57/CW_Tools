# Recfactoring Spock tests: helper methods for improved readability.


## HelperMethodsSpec.groovy - Using helper methods to make tests more readable.
The added advantage of helper methods is that you can share them across test methods
 or even across specifications (by creating an inheritance among Spock tests, for
example). You should therefore design them so they can be reused by multiple tests.

Helper methods should be used in all Spock blocks when you feel that the size of the
code gets out of hand.


## HelperMethodsAssertSpec.groovy - Grouping assertions for readability.
This is another example of a test that can be improved for readability.
Splitting the assertions into multiple "then:" blocks makes it clear from the
grouping what are seconsary checks.
This test spec also includes a 3rd version of the test method, using helper
methods to improve readability by using descriptive helper method names.
*NOTE:* The recommended approach is not to return boolean from a helper method,
but instead to return void and do the assertions inside the helper method.
*NOTE:* Unless you are using the Spock "with()" syntax inside a helper method,
then you need to include "assert", e.g.:
	private void loanApprovedAsRequested(Customer customer)
	{
		assert customer.activeLoans == 1
	}
If you forget to add "assert" then the statement will pass the test regardless 
of the result (which is  very bad!!!).


## HelperMethodsInteractSpec.groovy - Grouping interactivity checks (i.e. on a mocked object).
This test spec shows how you can group interactivity checks being performed
against a mocked object, so as to clearly indicate the separate things being checked, 
e.g. primary checks, then secondary checks.
*NOTE:* "Interaction" blocks are required for helper methods that query mocks, e.g.:
	and: "loan was approved as is"
	interaction {
		loanWasApprovedWithNoChanges(loan)
	}	
where:
	private void loanWasApprovedWithNoChanges(Loan loan)
	{
		1 * loan.setApproved(true)
		0 * loan.setAmount(_)
	}


*NOTE:* You can go a step further than descriptive helper methods by creating
your own DSL (domain specific language) using Groovy. See chapter 19 of
"Groovy In Action 2nd Edition".


JeremyC 19-07-2019
