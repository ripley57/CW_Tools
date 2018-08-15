To configure cgi exe shutdown1min:  
sudo sh config.sh

To call from Jetty:  
http://localhost:8080/ctx1/cgi-bin/shutdown1min

To call one of your own cgi-bin programs (e.g. "demo.bat"), simply create a "cgi-bin" directory 
from where you are running "run_jetty", and copy the program there. Then invoke the program using 
a URL such as "http://localhost:8080/ctx1/cgi-bin/demo.bat".  

NOTE: If you get a server error from Jetty, make sure your program has exectute permissions listed by Cygwin.  


To enable Jetty DEBUG logging in CGI.java, add the following to the existing jetty-logging.properties file:

org.eclipse.jetty.util.log.class=org.eclipse.jetty.util.log.StdErrLog
org.eclipse.jetty.LEVEL=INFO
org.eclipse.jetty.STACKS=true
org.eclipse.jetty.SOURCE=true
org.eclipse.jetty.servlets.CGI.LEVEL=DEBUG


When you invoke your cgi exe (e.g. "http://localhost:8080/ctx1/cgi-bin/demo.bat") you will now see output like this:  

2018-08-01 09:58:46.438:INFO:oejs.Server:jetty-8.1.13.v20130916
2018-08-01 09:58:46.613:INFO:oejs.AbstractConnector:Started SelectChannelConnector@0.0.0.0:8080
2018-08-01 09:58:50.673:DBUG:oejs.CGI:CGI: ContextPath : /ctx1
2018-08-01 09:58:50.673:DBUG:oejs.CGI:CGI: ServletPath : /cgi-bin
2018-08-01 09:58:50.674:DBUG:oejs.CGI:CGI: PathInfo    : /demo.bat
2018-08-01 09:58:50.674:DBUG:oejs.CGI:CGI: _docRoot    : C:\Users\Administrator.EDP.000\Cygwin\home\administrator\CW_Tools\tools\jetty\cgi-bin
2018-08-01 09:58:50.675:DBUG:oejs.CGI:CGI: _path       : null
2018-08-01 09:58:50.676:DBUG:oejs.CGI:CGI: _ignoreExitState: false
2018-08-01 09:58:50.677:DBUG:oejs.CGI:CGI: script is C:\Users\Administrator.EDP.000\Cygwin\home\administrator\CW_Tools\tools\jetty\cgi-bin\demo.bat
2018-08-01 09:58:50.678:DBUG:oejs.CGI:CGI: pathInfo is
2018-08-01 09:58:50.681:DBUG:oejs.CGI:Environment: export "REMOTE_HOST=0:0:0:0:0:0:0:1"; export "SERVER_PROTOCOL=HTTP/1.1"; 
export  "HTTP_CACHE_CONTROL=max-age=0"; export "REMOTE_ADDR=0:0:0:0:0:0:0:1"; export "SERVER_SOFTWARE=jetty/8.1.13.v20130916"; 
export "PATH_TRANSLATED=C:\Users\Administrator.EDP.000\Cygwin\home\administrator\CW_Tools\tools\jetty\demo.bat"; 
export "HTTPS=OFF"; export "CONTENT_TYPE="; export "REQUEST_METHOD=GET"; export "SCRIPT_NAME=/ctx1/cgi-bin/demo.bat"; 
export "SERVER_NAME=localhost"; export "HTTP_UPGRADE_INSECURE_REQUESTS=1"; export "AUTH_TYPE="; export "GATEWAY_INTERFACE=CGI/1.1";
export "SERVER_PORT=8080"; 
export "SCRIPT_FILENAME=C:\Users\Administrator.EDP.000\Cygwin\home\administrator\CW_Tools\tools\jetty\ctx1\cgi-bin\demo.bat"; 
export "HTTP_ACCEPT_LANGUAGE=en-US,en;q=0.9"; export "REMOTE_USER="; export "HTTP_HOST=localhost:8080"; 
export "SystemRoot=C:\WINDOWS"; export "CONTENT_LENGTH=0"; export "QUERY_STRING="; 
export "HTTP_ACCEPT=text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"; 
export "HTTP_USER_AGENT=Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36"; 
export "HTTP_ACCEPT_ENCODING=gzip, deflate, br"; export "HTTP_CONNECTION=keep-alive"; 
2018-08-01 09:58:50.685:DBUG:oejs.CGI:Command: 
C:\Users\Administrator.EDP.000\Cygwin\home\administrator\CW_Tools\tools\jetty\cgi-bin\demo.bat

MyCGI.java
==========
This is a version of CGI.java that you can compile and add extra logging to, etc. You can invoke this using a URI such as "http://localhost:8080/ctx1/cgi-bin2/demo.bat?arg1=hello&arg2=bob" (note the "cgi-bin2" - see MyServer.java). Simply edit MyCGI.java and then run "_build_jetty" to compile it. Then use "run_jetty" as usual. 
