# JUnit  

### Bits & Pieces:  
* JUnit 4 removed the need to extend your Test classes from "TestCase".
* Command-line example (uses the "console façade runner"): java -cp "lib/junit4.jar;lib/hamcrest-core.jar;classes" org.junit.runner.JUnitCore ConfigTest
* The requirements to define a test class are that the class must be public and contain a zero-argument constructor.
* The requirements to create a test method are that it must be annotated with @Test, be public, take no arguments, and return void.
* JUnit creates a new instance of the test class before invoking each @Test method.
* Because each test method runs on a new test class instance, we can’t reuse instance variable values *across* test methods.
* Assert methods with two value parameters follow a pattern worth memorizing: the first parameter is the expected value, and the second parameter is the actual value.

### JUnit test "Suites".  
The default Suite scans your test class for any methods that you annotated with @Test. Internally, the default Suite creates an instance of your test class for each @Test method. JUnit then executes every @Test method independently from the others to avoid potential side effects."

### No graphical runner since JUnit 4 - You now need to use Eclipse.  
Before JUnit 4, JUnit included Swing and AWT test runners; these are no longer included. Those graphical test runners had a progress indicator running across the screen, known as the famous JUnit green bar. JUnit testers tend to refer to passing tests as green bar and failing tests as red bar. “Keep the bar green to keep the code clean” is the JUnit motto. Figure 2.1 shows the Eclipse JUnit view after a green-bar test run. These days, all major IDEs support integration with JUnit."

### "Test Fixtures":  
In your test classes, setting up the test by placing the environment into a known state (e.g. by creating objects, acquiring resources, etc) is referred to as the setting up the "test fixture".  

### JUnit Best Practices:  
* Define your test classes in the same package as the classes being tested, but keep them in a separate parallel directory structure, e.g. "src/main/java" and "src/tests/java". You need your tests in the same package to allow access to protected methods. And you want your tests in a separate directory to simplify file management - as your tests become more complex, e.g. with mock objects etc, this clarifies the separation between the two types of sources.  

### JUnit annotations @Before and @After and @BeforeClass and @AfterClass:  
The @Before and @After annotated methods are executed right before/after the execution of each one of your @Test methods and regardless of whether the test failed or not. This helps you to extract all of your common logic, like instantiating your domain objects and setting them up in some known state. You can have as many of these methods as you want, but beware that if you have more than one of the @Before/@After methods, the order of their execution is not defined. JUnit also provides the @BeforeClass and @AfterClass annotations to annotate your methods in that class. The methods that you annotate will get executed, only once, before/after all of your @Test methods. Again, as with the @Before and @After annotations, you can have as many of these methods as you want, and again the order of the execution is unspecified. You need to remember that both the @Before/@After and @BeforeClass/@AfterClass annotated methods must be public. The @BeforeClass/@AfterClass annotated methods must be public and static.  
