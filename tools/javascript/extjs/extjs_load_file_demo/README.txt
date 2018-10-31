Demo of ExtJS form including use of field Ext.form.FileUploadField to send a file from the filesystem.

To run the demo: 
o In Cygwin, run "download_extjs4" to download ExtJS. Rename the extracted directory to ext-4.2.0.
o In Cywgin, launch "run_jetty" from this directory (extjs_load_file_demo).
o In web browser, go to http://localhost:8080/list/file_upload_demo.html.
O If you are prompted for a username/password, it is BL/BLBL.
o Browse to a file on the filesystem - either a .slf or .zip file, then click "Submit".
o You should see a "Success" alert displayed.

NOTE #1: If, after selecting a file, the web page indicates the selected file path as "c:\fakepath\<filename>", then this is a known security feature with various web browsers. This can be safely ignored, because the original selected file path *will* be used. 

NOTE #2: When you click "Submit", the file contents is sent (HTTP POST) to the Jetty web server. This is what the submit() function of the ExtJS widget does. You will see the file contents (and other details) logged to stdout by the Jetty servlet DummyResponseServlet.java. 

JeremyC 31-10-2018
