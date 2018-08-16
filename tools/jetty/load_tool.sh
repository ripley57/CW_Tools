TOOLS_DIR=$*

_jetty_server=jetty-server-8.1.13.v20130916.jar
_jetty_util=jetty-util-8.1.13.v20130916.jar
_jetty_servlet=jetty-servlet-8.1.13.v20130916.jar
_jetty_servlets=jetty-servlets-8.1.13.v20130916.jar
_jetty_servlet_api=servlet-api-3.0.jar
_jetty_http=jetty-http-8.1.13.v20130916.jar
_jetty_io=jetty-io-8.1.13.v20130916.jar
_jetty_security=jetty-security-8.1.13.v20130916.jar
_jetty_continuation=jetty-continuation-8.1.13.v20130916.jar 
_jetty_xml=jetty.xml
_log4j=log4j-1.2.17.jar
_apache_commons_codec=commons-codec-1.10.jar

function _setjettycp() {
if [ "$(uname)" = "Linux" ]; then
   _cwd=$TOOLS_DIR/jetty
   _classpath="$_cwd:\
$_cwd/lib/$_apache_commons_codec:\
$_cwd/lib/$_jetty_server:\
$_cwd/lib/$_jetty_util:\
$_cwd/lib/$_jetty_servlet:\
$_cwd/lib/$_jetty_servlets:\
$_cwd/lib/$_jetty_servlet_api:\
$_cwd/lib/$_jetty_http:\
$_cwd/lib/$_jetty_io:\
$_cwd/lib/$_jetty_security:\
$_cwd/lib/$_jetty_continuation:\
$_cwd/jetty-logging.properties"
else
   _cwd=$(cygpath -w $TOOLS_DIR\\jetty)
   _classpath="$_cwd;\
$_cwd\\lib\\$_apache_commons_codec;\
$_cwd\\lib\\$_jetty_server;\
$_cwd\\lib\\$_jetty_util;\
$_cwd\\lib\\$_jetty_servlet;\
$_cwd\\lib\\$_jetty_servlets;\
$_cwd\\lib\\$_jetty_servlet_api;\
$_cwd\\lib\\$_jetty_http;\
$_cwd\\lib\\$_jetty_io;\
$_cwd\\lib\\$_jetty_security;\
$_cwd\\lib\\$_jetty_continuation;\
$_cwd\\jetty-logging.properties"
fi
}
_setjettycp

# Description:
#   Run a Jetty web server. 
#   For sharing files in the current directory.
#
# Usage:
#   run_jetty
#
function run_jetty() {
    if [ "$1" = '-h' ]; then
        usage run_jetty
        return
    fi

    java -cp $_classpath MyServer
}


# Description:
#   Build a Jetty web server. 
#
# Usage:
#   _build_jetty
#
function _build_jetty() {
    if [ "$1" = '-h' ]; then
        usage _build_jetty
        return
    fi
	(cd "$_cwd" && javac -cp "$_classpath" MyCGI.java && \
		mkdir -p       org/eclipse/jetty/servlets/ && \
		cp MyCGI.class org/eclipse/jetty/servlets/ \
	)
	(cd "$_cwd" && javac -cp "$_classpath" HelloServlet.java)
    (cd "$_cwd" && javac -cp "$_classpath" MyServer.java)
}
