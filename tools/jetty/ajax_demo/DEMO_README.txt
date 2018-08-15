To run this Ajax demo:

1. Launch jetty using "run_jetty" while in the "ajax_demo" directory.
Note: We are using the run_jetty command in load_tools.sh and not run_jetty.bat.

2. Go to http://localhost:8080/list and view file ajax_demo_chap13.html

3. Click the button. 
This will retrieve file test.txt from the Jetty server, parse the XML 
structure and then display the value in the UI.

Note: For security, Ajax requests can only be sent to the same
host. This is why you first need to load ajax_demo_chap13.html
from http://localhost:8080/list/ajax_demo_chap13.html

4 Jan 2014.
