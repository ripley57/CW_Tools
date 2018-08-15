# Description:
#   Demo showing how self-executing jar files like jgit.sh (http://eclipse.org/jgit/download/) work.
#   See also my download.sh and cwtools.bat files in CW_Tools.
#
# JeremyC 29-06-2018

# First, let's build our jar file.
sh build_jar.sh

# Now we run our demos, which should all print "Hello world" ...

# 1)
# The following will work, as one would expect:
java -jar demo.jar

# 2)
# Interestingly, this will also work:
cp demo.jar wibble1
java -cp wibble1 Test

# 3)
# And, even more interestingly, this will also work:
cat >file.tmp <<EOI
some
random
text
EOI
cat file.tmp wibble1 > wibble2
java -cp wibble2 Test
# NOTE: 
# This 3rd example shows why self-executing jar files, like jgit.sh (http://eclipse.org/jgit/download/) work.
# What's happening is that java is looking for class "Test" in the loaded binary (wibble.wobble), and is
# ignoring anything before it, which means that it fortunately skips the leading ascii lines from file.tmp.

# 4) 
# Now, let's use this to create a self-executing jar inside a shell script.
# This is based on jgit.sh (see http://eclipse.org/jgit/download).
cat script1.sh wibble1 > script2.sh
chmod +x script2.sh
./script2.sh

# Tidy
rm -f script2.sh
rm -f wibble1
rm -f wibble2
rm -f demo.jar
rm -f file.tmp

