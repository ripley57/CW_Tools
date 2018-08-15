To Test this Demo
=================
Note: Use run_jetty.bat to start jetty, not the run_jetty command in load_tool.sh.

o Language test: 
http://localhost:9090/ctx0/it/

o Servlet that spits the request including HTTP headers such as User-Agent:
http://localhost:9090/ctx2/spit/

o Directory listing:
http://localhost:9090/list/ 

o CGI demo:
Note: Use run_jetty.bat and not the run_jetty command in load_tool.sh.
If you examine run_jetty.bat, you will see that the "cgi-bin" directory
in this directory needs to be copied to "C:\" for this cgi demo to work.
Linux:
http://localhost:9090/ctx1/cgi-bin/demo.sh
Windows:
http://localhost:9090/ctx1/cgi-bin/demo.bat
 
Jetty Links
===========
Jetty home page:
http://www.eclipse.org/jetty/

Jetty downloads:
http://download.eclipse.org/jetty/
http://download.eclipse.org/jetty/8.1.13.v20130916/dist/

Embedding Jetty Tutorial:
https://wiki.eclipse.org/Jetty/Tutorial/Embedding_Jetty

Jetty source code:
http://repo1.maven.org/maven2/org/eclipse/jetty/aggregate/jetty-all/

Run Jetty on TonidoPlug2 (Ubuntu Debian Squeeze 6.0, see /etc/lsb-release)
========================
1. Install Java
apt-get update
apt-get install default-jre
apt-get install default-jdk
2. Create startup script



JeremyC 05/04/2014
