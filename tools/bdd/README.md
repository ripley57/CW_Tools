# BDD ("Behavioural Driven Development")

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


## JBehave
The JBehave "steps" can be written in Java or Groovy. See https://jbehave.org/reference/latest/using-groovy.html

[JBehave (Selenium) Tutorial](https://github.com/jbehave/jbehave-tutorial)


JeremyC 26-07-2019
