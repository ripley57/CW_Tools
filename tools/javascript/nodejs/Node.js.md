# Node.js  

**Note:** Use my "install_nodejs" CW_Tools command to download and install Node.js locally.  

## Introduction to Node.js:  
https://www.sitepoint.com/an-introduction-to-node-js/  

## Reading files from a filesystem using Node.js:  
http://stackabuse.com/read-files-with-node-js/

## Creating your own Node.js module of functions:  
https://stackoverflow.com/questions/5656436/how-to-create-my-own-module-of-functions-in-a-node-js-app

## Simple Node.js web server "http-server":  
https://github.com/indexzero/http-server  
See also my doc "Creating HTTP server using standalone Node js installation.docx".

## Node.js command-line app to convert CSV file to JSON format:  
https://github.com/Keyang/node-csvtojson  
Installation:  
```
npm i --save csvtojson
```
Example input CSV file example.csv:
```
id,name,address
3,fred,england
5,bert,wales
```
Converting to JSON:  
```
D:\tmp>csvtojson example.csv
[
{"id":"3","name":"fred","address":"england"},
{"id":"5","name":"bert","address":"wales"}
]
```
