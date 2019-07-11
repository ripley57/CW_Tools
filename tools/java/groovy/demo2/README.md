# Groovy basics - optional typing

## DefDemo.groovy & DefDemo2.groocy
There is no Spock-specific syntax in the "DefDemo.groovy" and "DefDemo2.groovy"
scripts, so we can execute them using the "groovy" command (which is a wrapper 
script on Linux). Use my CW_Tools wrapper command "groovy", which downloads and
installs the Groovy binary package from http://groovy-lang.org/install.html).

To run:
groovy DefDemo.groovy
groovy DefDemo2.groovy


## DefDemoSpec.groocy
This Groovy *does* require Spock. Instead of using maven this time, we'll use Ant.
We'll create a build.xml file based on the Spock Ant example:
https://github.com/spockframework/spock-example/build.xml. 
In fact, we'll just use a copy of this file, with our Groovy script to run copied
to the local directory "src/test/groovy/".

To run:
ant

*NOTE:* Using the "groovy" command-line tool is a quick way to determine if there 
        is any Spock-specificv syntax being used, i.e. script is not base Groovy.


JeremyC 11-07-2019
