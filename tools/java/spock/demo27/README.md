# Spock additional features for enterprise projcects: Verify expected exception. @Issue, @Timeout, @Ignore, @IgnoreRest, @IgnoreIf, @Requires, @AutoCleanup.

Here we discuss techniques to solve problems that you *might* come across in a large project.


## ExceptionControlSpec.groovy - Testing that an expected exception has been thrown.
This is useful, for example, if you are developing a library, and you
want to verify what exceptions will be thrown to the calling code.


## IssueDocumentationSpec.groovy - The "@Issue" annotation.
We already know the reporting importance of "@Subject", "@Title" and "@Narrative" annotations.
The "@Issue" annotation enables you to reference a bug number, e.g.:
	@Issue(["JIRA-453","JIRA-678","JIRA-3485"])
	def "Negative quantity is the same as 0"() {
Again, this is purely informational. 
*NOTE*: I generated a surefire report (see updates in pom.xml, but it did include the
@Issue annotation values. I assume that, for now, the surefire reports does not make
use of this annotation.


## TimeoutLimitSpec.groovy - Using "@Timeout" to fail a test quickly.
For integration tests particularly, which can be slow due to possible environmental 
problems with external classes or databases, it's important to be able to fail quickly. 
With the "@Timeout" annotation, a test will fail unconditionally if its execution time 
passes the given threshold.
Example 1:
	@Timeout(5)
	def "credit card charge happy path"() {
Example 2:
	@Timeout(value = 5000, unit = TimeUnit.MILLISECONDS)
	def "credit card charge happy path - alt "() {


## SimpleIgnoreSpec.groovy - Skipping tests using "@Ignore".
NOte that you can include a reason:
	@Ignore("Until credit card server is migrated")
	def "credit card charge happy path"() {
You can place "@Ignore" on a single test method or on a whole class.


## KeepOneSpec.groovy - Skipping all other tests using "@IgnoreRest".
This annotation can be declared above one Spock test, and then all the other
tests will be skipped.


## SimpleConditionalSpec.groovy - Skipping tests conditionally, using "@IgnoreIf".
You can skip tests based on the Java version, the OS version, or any environment
variable, e.g.:
	@IgnoreIf({ jvm.java9 })
	@IgnoreIf({ os.windows })
Ignoring tests depending on environment variables enables you to split  your tests 
into separate categories/groups, which is a well-known technique. As an example, 
you could create “fast” and “slow” tests and set up your build server with two
jobs for different feedback lifecycles. To skip the test in this spec:
	SKIP_SPOCK_TESTS=wibble mvn verify
	...
	Running com.manning.spock.chapter8.extras.SimpleConditionalSpec
	Charging 1200
	Charging 1200
	Tests run: 3, Failures: 0, Errors: 0, Skipped: 1, Time elapsed: 0.362 sec


## SmartIgnoreSpec.groov - Using "@IgnoreIf" with a dynamic check.
The "@IgnoreIf" annotation accepts a Groovy closure, and the test will be skipped
if this returns false. For example:
	@IgnoreIf({ !new CreditCardProcessor().online() })
	def "credit card charge happy path - alt"() {
Note that you can even write your own Groovy class and use it here, e.g. to 
check if some service used by your test is available.


## RunIfSpec.groovy - "@Requires" is the inverse of "@IgnoreIf".
Example:
	@Requires({ new CreditCardProcessor().online() })
	def "credit card charge happy path"() {


## AutoCloseSpec.groovy - "@AutoCleanup" (similar to the "cleanup:" Spock block).
Note that this is declared above an object. The following example calls the
"shutdown()" method of the object after the test runs:
	@AutoCleanup("shutdown")
	private CreditCardProcessor creditCardSevice = new CreditCardProcessor()
If you don't specify a method like "shutdown", then the "close()" method of the
object will be called by default.


## "Spy" objects
You don't want to use these! Their use implies design problems with your code.


JeremyC 19-07-2019
