To run this demo, the html page must be served by a web server, so that the JavaScript is able to succesfully load the encrypted image file.

One way to run a web server is to use the CW_Tools "run_jetty" command, as follows:

1) Copy the following demo files into a directory somewhere:
aes.js
crypto-js.js
demo.html
kafka160120.jpg.encrypted

2) Launch the CW_Tools cygwin environment, cd to this directory and type "run_jetty"

3) Load the way page using the url http://localhost:8080/list/demo.html
If you are prompted for a username and password, use BL and BLBL respectively.

4) Click the "Decrypt" button to decrypt and display the image file.


JeremyC 22-07-2018


