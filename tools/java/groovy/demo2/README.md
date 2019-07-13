# Groovy basics - optional typing

## DefDemo.groovy & DefDemo2.groocy
There is no Spock-specific syntax in the "DefDemo.groovy" and "DefDemo2.groovy"
scripts, so we can execute them using the "groovy" command (which is a wrapper 
script on Linux). Use my CW_Tools wrapper command "groovy", which downloads and
installs the Groovy binary package from http://groovy-lang.org/install.html).

To run:
groovy DefDemo.groovy
groovy DefDemo2.groovy

*NOTE:* Using the "groovy" command-line tool is a quick way to determine if there 
        is any Spock-specificv syntax being used, i.e. script is not base Groovy.
	(Although, you'll always going to see "Spec" if it's a Spock groovy script).


## DefDemoSpec.groocy
This Groovy *does* require Spock. For a change, instead of using Maven we'll use Ant.
We'll create a build.xml file using the official Spock Ant example:
	https://github.com/spockframework/spock-example/build.xml. 
In fact, we'll just use a copy of this file, with our Groovy script to run copied
into the local directory "src/test/groovy/" where Ant will find it.
To run:
ant


JeremyC 11-07-2019
