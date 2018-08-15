#!/bin/sh

this_script=`which "$0" 2>/dev/null`

# We use "basename" here for this demo, so that we don't get problems
# with "which" returning a full Linux-style path to this script. This
# causes problems when we run this demo on Cygwin, because a Linux-style
# path is used as the classpath with a Windows installaton of Java.
# To avoid that problem, we use just this script filename, without any path.
cp=$(basename $this_script)

exec java -cp $cp Test "$@"
