""" Simple web server to serve files from a specific directory

	NOTE: 	This runs SimpleHTTPServer in a thread. By calling thread.setDeamon(True),
		the web server terminates when the main program thread exists. This is
		actually very handy, because it should enable us to start and stop the
		server during a unit or Behave test.

	This demo can be run with Python2:
		python2 web_server_in_thread.py 

"""

import os
import SimpleHTTPServer
import SocketServer
import threading
import time

class MyThread(threading.Thread):
	PORT = 9000

	def __init__(self, _dir):
		threading.Thread.__init__(self)
		self.dir = _dir

	def run(self):
		handler = SimpleHTTPServer.SimpleHTTPRequestHandler
		httpd = SocketServer.TCPServer(("", self.__class__.PORT), handler)
		print("serving at port", self.__class__.PORT)
		os.chdir(self.dir)
		httpd.serve_forever()


if __name__ == '__main__':
	thread = MyThread(".")
	thread.setDaemon(True)	# This is needed, otherwise the server prevents main thread from exiting.
	thread.start()
	print("Sleeping for 60 secs...")
	time.sleep(60)
	print("Main thread exiting.")
