JAVA_HOME=/usr/local/jdk
PATH=$JAVA_HOME/bin:/usr/local/ant/bin:$PATH
export JAVA_HOME PATH

CLASSPATH=.:${PWD}/jmx_1.1_ri_bin/lib/jmxtools.jar:${PWD}/jmx_1.1_ri_bin/lib/jmxri.jar
export CLASSPATH

java jmxbook.ch2.HelloAgent
