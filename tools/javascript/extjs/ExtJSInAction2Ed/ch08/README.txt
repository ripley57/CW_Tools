Demo from page 173 of ExtJSInAction 2nd Edition.

This demonstrates populating a grid panel using pages of json data retrieved from a MySQL database.

Note: Rather than install a PHP web server, a standalone PHP exe is built using "ExeOutput" (https://www.exeoutput.com/download). 
To save a couple of MBs space, I've included a zipped crud.exe in the local cgi-bin directory. 

To run the demo: 
o Unzip crud.zip in the cgi-bin directory and "chmod +x" it.
o Run "download_extjs4" to download ExtJS. Rename the extracted directory to ext-4.2.0.
o Launch "run_jetty" from this directory ("ch08").
o Go to http://localhost:8080/list/grid_demo.html in a web browser.

Note: This demo requires MySQL to be installed and the data.sql file needs to be imported. 
See "How to run ExtJS demo using standalone PHP exe.docx" for the full setup steps.

JeremyC 06-08-2018
