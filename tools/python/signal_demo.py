""" Launch SimpleHTTPServer and control when it terminates!

    NOTE: This demo can only be run with python2
    Use the "2to3" tool (sudo apt install 2to3) to create aversion to run with python3.

    To run:
    python2 web_server_clean_terminate.py

    To stop:
    * kill -2 <pid>
    * Then request another url.

    NOTE: This demo has one small 'quirk'. The call to "httpd.handle_request()" sits waiting
	  for the next request. This means that to terminate the web server loop below, you
	  have to send a SIGINT to this process, kill -2 <pid>, but you also have to then
	  request some other page (any other page should do it, even a non-existent one). 
	  Admittedly this is slightly annoying, but it's got to be better than sending a
	  kill signal directly to the python process, which seems to tie-up the server port 
	  for a noticeable time (at least approx 30 secs).

    NOTE: On Linux, use "kill -l" to see the list of kill names and numbers.

    References:
	https://docs.python.org/2/library/basehttpserver.html#module-BaseHTTPServer
    	https://docs.python.org/2/library/simplehttpserver.html#module-SimpleHTTPServer
	https://docs.python.org/2/library/signal.html#module-signal
"""

import BaseHTTPServer, SimpleHTTPServer
import os
import signal
import time

g_terminate = False

def keep_running():
	print("Sleeping 1 sec...")
	time.sleep(1)
	return not g_terminate

def run_web_server(dir=".", server_class=BaseHTTPServer.HTTPServer, handler_class=SimpleHTTPServer.SimpleHTTPRequestHandler):
	server_address = ('', 9000)
	os.chdir(dir)	# Serve the files in this directory
	httpd = server_class(server_address, handler_class)
	while keep_running():
		try:
			httpd.handle_request()
		except e:		
			pass

def handler(signum, frame):
	print("handler() called!")
	global g_terminate
	g_terminate = True

signal.signal(signal.SIGINT, handler)
run_web_server('test/resources/html/')
