How to run these JavaCC Demos
=============================

Both of the demos (adder.jj and four-letter-words.jj) are taken from the tutorial in "tutorial1/javacc-tutorial.pdf" (which came from https://www.engr.mun.ca/~theo/JavaCC-Tutorial/javacc-tutorial.pdf).

Note: Both of the following methods to run the demos require you first to set up your Java environmet (JAVA_HOME).

A. Running the demos in a Cygwin shell.
1. Run "ant" to download Ant and setup the Ant environment.
2. ant adder
3. ant flw

B. Running the demos in a Windows cmd.exe.
1. Run "ant" in a Cygwin shell to download Ant and generate script "tools/ant/setenv.cmd" to set up the Ant environment.
2. Run setenv.cmd
3. ant adder
4. ant flw

TODO:
o Perhaps try using the "javacc" Ant task. It looks like it might be a built-in Ant task (see https://ant.apache.org/manual/Tasks/javacc.html).
