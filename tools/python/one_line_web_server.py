""" One-line file server

	Usage:

	python3 one_line_web_server.py 
	Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
"""

import http.server

http.server.test(HandlerClass=http.server.SimpleHTTPRequestHandler)
