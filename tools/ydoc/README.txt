INTRODUCTION

Use the genoptions.sh script to create a Javadocs "options" file that
can be used to generate CW Javadocs that includes UML class diagrams.


INSTRUCTIONS

1. Run the "genoptions" command from inside Cygwin, to create the Javadocs 
"options" file. Specify the CW version, directory containing the uncompiled
Java source files, and destination directory. For example:

gendocs 66 /cygdrive/d/svn/V66_fixes/src /cygdrive/c/tmp/out

Note: The file "options.example" is an example of a generated "options" files.


2. Run the javadocs command from inside a Windows DOS shell:

javadocs @options


JeremyC 9/12/2012