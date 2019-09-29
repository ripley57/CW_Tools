# BDD ("Behavioural Driven Development")

From Thucydides/Serenity home page (http://thucydides.info/docs/serenity-staging/):

"Behaviour Driven Development or BDD, is a development approach where team members 
explore, and build a shared understanding of application requirements through 
conversations around examples. In Agile teams practicing BDD, this is often done 
before or early on in a sprint, in a special meeting sometimes called 
"the three amigos" or "the three-way handshake", where (at least) a BA (Business 
Analyst, Product Owner/Manager), a developer and a tester get together to work 
through examples from the acceptance criteria. The examples being discussed are 
concrete illustrations of how the system should work, or how a user might use a 
feature. These examples help provoke discussion, uncovering assumptions and 
omissions that would have otherwise lead the development team into error further 
down the track."

"Serenity BDD is also commonly used for automated Regression Tests. Whereas BDD 
Acceptance Tests are defined very early on in the piece, before development starts, 
Regression Tests involve an existing system. Other than that, the steps involved 
in defining and automating the tests are very similar."


[Dan North introduction to BDD](https://dannorth.net/introducing-bdd/)

Building the "right thing" the "right way"
==========================================
BDD is all about building "the right thing" (i.e features that tie-up with the
business goals), and building "the thing right" (i.e. code that is maintainable 
and extendable).

Executable acceptance tests
===========================
BDD uses executable acceptance tests; to provide living documentation that all 
stakeholders can understand, and visible product development progress. The
executable acceptance tests drive the design and implementation, and ensure 
that "the right thing" is being built.

Conversation and collaboration
==============================
BDD emphasises the importance of conversation and collaboration in the BDD process 
(e.g. using "3 Amigos"; a developer, a tester, a business analysts), and that you
need to work together to define acceptance criteria in a clear and unambiguous 
format that can be automated using tools such as Cucumber (Java/JS), 
JBehave (Groovy/Java), or SpecFlow (C#).

Scenarios/Examples
==================
Concrete examples are at the heart of BDD. In conversations with users and stakeholders, 
BDD practitioners use concrete examples to develop their understanding of features and 
user stories of all sizes, but also to flush out and clarify areas of uncertainty.

Unit tests
==========
BDD practices can also be applied to unit tests, by focussing on low-level
specifications, rather than simply excercising the methods of each class.

The idea is that everything relates back to the business goals:
Business Goals -> Capabilities -> Features -> User Stories -> Concrete Examples

See eBook "BDD In Action", and also "Java Testing with Spock".


## JBehave (for Java)   [Behave for Python]
"JBehave is a framework for Behaviour-Driven Development (BDD). BDD is an evolution of 
test-driven development (TDD) and acceptance-test driven design, and is intended to make 
these practices more accessible and intuitive to newcomers and experts alike. BDD shifts 
the vocabulary from being test-based to behaviour-based, and positions itself as a design 
philosophy." 

[Nice summary of JBehave (or Cucumber) usage](https://jbehave.org/reference/latest/index.html):
1. Write story
2. Map steps to story
3. Configure stories (JUnit test runner)
4. Run stories (and examine the reports)

features -> stories -> scenarios -> steps:
"Our example contains 2 features with a few stories. Each story can contain one 
or more scenarios, each scenario consists of one or more steps and some examples."

- The JBehave "steps" can be written in Java or Groovy. See https://jbehave.org/reference/latest/using-groovy.html
- [JBehave (Selenium) Tutorial](https://github.com/jbehave/jbehave-tutorial)
- A testsuite is needed to invoke the JBehave steps, e.g.:
	src/test/java/com/jeremyc/jbehave/AcceptanceTestSuite.java
  What's interesting is that this contains very little code, i.e. the "binding" between the 
  ".story" files and the JBehave steps Java (or Groovy) files, is done 'magically'.


JeremyC 26-07-2019
