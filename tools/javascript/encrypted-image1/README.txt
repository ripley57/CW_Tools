Demo showing how images can be encrypted and decrypted using JavaScript.

From https://alicebobandmallory.com/articles/2010/10/14/encrypt-images-in-javascript

NOTE: To run this demo, the html file and the jpg image file must be served by a web server. This is due to web browser security. If you don't do this, then you'll see an error like this when you click the "Encrypt" button:

Uncaught DOMException: Failed to execute 'getImageData' on 'CanvasRenderingContext2D': The canvas has been tainted by cross-origin data.

One option is to use a simple web server such as the JavaScript-based http-server (https://github.com/indexzero/http-server), but even this takes about 60MB disk space (see my document "Creating HTTP server using standalone Node js installation.docx").

Alternatively, using CW_Tools, run "run_jetty" from this directory. Then open the html file from "http://localhost:8080/list/". Note: The UI username and password are BL and BLBL. 

JeremyC 18-07-2018

