# BDD ("Behavioural Driven Development")

BDD 
the importance of conversation and collabora-
tion in the BDD process, and that you need to work together to define accep-
tance criteria in a clear and unambiguous format that can be automated using
tools such as Cucumber, JB ehave, or SpecFlow.

Using BDD for unit tests:
think in terms of writing low-level specifications rather than unit tests.




Vision:
Create a tool that helps users manage duplicated files. The tool should be able to 
generate a report, grouping any duplicated files, based on either their binary 
content checksum, or by their file name. 

In "Geoffrey A. Moore" template form:
FOR computer users
WHO want to identify and better manage duplicated files
THE Dups utility is an application
THAT enables the user to quickly identify duplicated files
UNLIKE other file diff tools,
OUR PRODUCT can identify duplicate files by either content checksum or file name, and
the final report of duplicated files groups the files together, for easy review.

Business Goals: 
These are high-level statements that focus on business value, they are statements that
executives would be able to relate to and discuss.
o Enable users to reduce disk usage, by helping them identify duplicate files.
o Prevent accidentally deletion of valuable files, by enabling users to compare two sets of directories.

Business Goals should be "SMART":
- Specific
- Measurable
- Achievable
- Relevant
- Time-bound

Capabilities:
As a software engineer, you design and build "capabilities" that realise the business goals.
A capability gives the user the ability to achieve some goal or fulfill some task:
- Users need the ability to be able to identify duplicate files, by content checksum or by file name.
- Users need the ability to be able to compare the files in two sets of directories, by content checksum or file name, 
in order to identify missing files, 

Features:
Feaures are the implemented components in an application that deliver a capability to the users.
A feature is not a user story, but it can be described by one or serveral user stories.
Features" that will deliver the capabilities (and what will actually be built):
o Given a single set of directories, list any duplicate files.
o Given two sets of directories, list the files in the first set that are also present in the second set.
o Given two sets of directories, list the files in the first set that are missing from the second set.
A feature is something that users can test and use in isolation. A feature can deliver business value in
itself; once a feature is completed, you could theoretically deploy it into production immediately, without 
having to wait for any other features to be finished first.

NOTE: JBehave ".story" files are called ".feature" files in Gherkin. They contain multiple scenarios (concrete
examples) of the feature.
The ".story" suffix used by JBehave has historical origins and is a little misleading. It’s
generally a bad idea to have a .story file for each user story. Remember, stories are
transitory planning artifacts that can be disregarded at the end of an iteration, but fea-
tures are valuable units of functionality that stakeholders can understand and relate to.
Many teams write the feature files during the “Three Amigos” sessions and store them in the 
source code repository at the end of the meetings.

User stories:
In Agile, features are broken down into into chunks small enough to build within a single iteration.
These chunks are called "user stories".

A user story is a planning tool that helps you flesh out the details of what you need to deliver for a 
particular feature.

It’s important to remember that user stories are essentially planning artifacts.
You can define features quite a bit ahead of time, but you only want to start creating
stories for a feature when you get closer to actually implementing the feature.
Once the feature has been implemented, the user stories can be discarded.

Agile practitioners are fond of emphasizing that a user story is not actually a requirement, but more a 
promise to have a conversation with the stakeholders about a requirement. Stories are a little like entries 
in a to-do list, giving you a general picture of what needs to be done, and reminding you to go ask about the 
details when you come to implement the story.

Although you may not deliver a user story into production by itself, you can and should show implemented 
stories to end users and other stakeholders, to make sure that you’re on the right track and to learn more
about the best way to implement the subsequent stories.

Wherever possible, identify the stories that involve the most uncertainty,
and tackle these ones first. Then review the remaining stories, keeping in mind what
you’ve learned and considering the feedback the stakeholders give you. This simple
approach can go a long way in helping you increase your knowledge and understand-
ing in areas that matter.


Goals re-written in a foramt that 
Page 36
Teams practicing BDD often like to describe the features in the following format, linking each feature to a business goal:

In order to identify duplicate files  
As a user
I want to know about any duplicates existing in a given set of directories

In order to identify duplicate files
As a user
I want to know about any files in one given set of directories that also exist in a second given set of directories

In order to identify missing files
As a user
I want to know about any files in one given set of directories that are missing from a second given set of directories


Breaking down features into stories:
A feature may be detailed enough to work with as is, but often you'll need to break it up into smaller pieces.
In Agile, larger features are broken into user stories, where each story is small enough to deliver in a single iteration.

=> In my case, my features are already detailed enough, so we can consider them stories as is. 
Below are my features, marked as "Story", and with some concrete examples (aka "scenarios"). These stories
will be converted into .story files for use with Thucydides/Serenity and JBehave:

Story: Identify duplicate files present in a single set of directories.
   In order to identify duplicate files  
   As a user
   I want to know about any duplicates existing in a given set of directories

   Scenario: Identify duplicate files in a single directory.
   Given directoryset setA consisting of directory dirA containing file file1 with checksum checksum1 and file file2 with checksum checksum1
   When I search for duplicates
   Then files file1 and file2 are listed

   Scenario: Identify duplicate files across multiple directories.
   Given directoryset setA consisting of directory dirA containing file file1 with checksum checksum1 and directory dirB containing file file2 with checksum checksum1
   When I search for duplicates
   Then files file1 and file2 are listed


Story: Identify duplicate files by comparing two sets of directories.
   In order to identify duplicate files
   As a user
   I want to know about any files in one given set of directories that also exist in a second given set of directories

   Scenario: Both directory sets consist of a single directory.
   Scenario: First directory set consists of multiple directories.
   Scenario: Second directory set consists of multiple directories.
   Scenraio: Both directory sets consist of multiple directories.


Story: Identify mssing files by comparing two sets of directories.
   In order to identify missing files
   As a user
   I want to know about any files in one given set of directories that are missing from a second given set of directories

   Scenario: Both directory sets consist of a single directory.
   Scenario: First directory set consists of multiple directories.
   Scenario: Second directory set consists of multiple directories.
   Scenraio: Both directory sets consist of multiple directories.


Examples:
Examples are at the heart of BDD . In conversations with users and stakeholders, BDD
practitioners use concrete examples to develop their understanding of features and user
stories of all sizes, but also to flush out and clarify areas of uncertainty.

Concrete examples and conversation with users, stakeholders, and domain experts drive the learning process.

You discuss concrete examples of how an application should behave.
...and reflect on these examples to build up a shared understanding of the requirements
Then you look for additional examples to confirm or extend your understanding.

One of the core concepts behind BDD is the idea that you can express significant
concrete examples in a form that’s both readable for stakeholders and executable as
part of your automated test suite.

When you automate your acceptance criteria using this sort of BDD tool, you
express your examples in a slightly more structured form, often referred to as scenar-
ios. Dan North defined a canonical form for these scenarios in the mid-2000s, built
around a simple “Given ... When ... Then” structure, and this format has been widely
adopted by BDD practitioners ever since.

examples => scenarios => automated acceptance tests


JeremyC 22-07-2019
