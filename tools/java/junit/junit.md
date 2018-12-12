# JUnit  

### Bits & Pieces:  
* JUnit 4 removed the need to extend your Test classes from "TestCase".

### "Test Fixtures":  
In your test classes, setting up the test by placing the environment into a known state (e.g. by creating objects, acquiring resources, etc) is referred to as the setting up the "test fixture".  

### JUnit annotations @Before and @After and @BeforeClass and @AfterClass:  
The @Before and @After annotated methods are executed right before/after the execution of each one of your @Test methods and regardless of whether the test failed or not. This helps you to extract all of your common logic, like instantiating your domain objects and setting them up in some known state. You can have as many of these methods as you want, but beware that if you have more than one of the @Before/@After methods, the order of their execution is not defined. JUnit also provides the @BeforeClass and @AfterClass annotations to annotate your methods in that class. The methods that you annotate will get executed, only once, before/after all of your @Test methods. Again, as with the @Before and @After annotations, you can have as many of these methods as you want, and again the order of the execution is unspecified. You need to remember that both the @Before/@After and @BeforeClass/@AfterClass annotated methods must be public. The @BeforeClass/@AfterClass annotated methods must be public and static.  
