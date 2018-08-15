SOLR DEMO (using Solr 4.7.1)
============================

JeremyC 31/5/2014.

1. Download Solr from http://www.apache.org/dyn/closer.cgi/lucene/solr/4.7.1


2. Extract solr-4.7.1.zip to a directory, e.g c:\solr-4.7.1


3. Confirm that you can run the Solr demo:

cd c:\solr-4.7.1\example
java -jar start.jar

If Solr starts successfully, you should see the following, to indicate that it is listening on port 8983:

24125 [main] INFO  org.eclipse.jetty.server.AbstractConnector  û Started SocketConnector@0.0.0.0:8983

You should also see the Solr admin page when you go to http://localhost:8983/solr

(NOTE: To run Solr using a different port: java -Djetty.port=8080 -jar start.jar).


4. Add some simple test data using the post.jar appliation supplied with Solr:

cd C:\solr-4.7.1\example\exampledocs
java -jar post.jar *.xml

The post.jar file sends XML documents to Solr using HTTP POST. After all the documents are sent to 
Solr, the post.jar application issues a commit, which makes the example documents findable in Solr.

To verify that the example documents were added successfully, go to the Query page in the Solr 
administration console (http://localhost:8983/solr) and execute the find all documents query (*:*).
NOTE: You need to select collection1 in the dropdown box on the left to access the Query page.

NOTE: These example xml files define the fields (and content) to be imported into Solr 
(see section "Indexing documents using XML or JSON" in "Solr In Action". Later, we will use Tika 
to automatically extract suitable fields to quickly import a directory of documents into Solr.


5. Remove the Lucene index ready for our next test.

To do this, stop Solr and then delete the sub-directories in 
"C:\solr-4.7.1\example\solr\collection1\data\". Then restart Solr. 


6. Use Tikka to import more complex file types, including PDF, MS Office and Outlook MSG files.

Solr offers a number of powerful utilities for adding documents from other systems. 
Three popular tools available for populating your Solr index are:
o Data Import Handler (DIH)
o ExtractingRequestHandler, aka Solr Cell
o Nutch

ExtractingRequestHandler, commonly called Solr Cell, allows you to index text content extracted 
from binary files like PDF, MS Office, and OpenOffice documents. Behind the scenes, Solr Cell 
uses the Apache Tika project to do the extraction. Specifically, Tika provides components that 
know how to detect the type of document and parse the binary documents to extract text and 
metadata. For example, you can send a PDF document to the ExtractingRequestHandler, and it will 
automatically populate fields like title, subject, keywords, and body_text in your Solr index. 
This capability is available through the /extraction request handler that is enabled in the 
example configuration files that ship with Solr. 

If you read http://wiki.apache.org/solr/ExtractingRequestHandler#Introduction, you can ignore 
the steps about configuring ExtractingRequestHandler; this is already configured in Solr-4.7.1.

The simple tool post.jar, which ships with Solr in the example/exampledocs folder, can be used to 
post a file to the Solr Cell ExtractingRequestHandler. The following sends the contents of the 
current directory to Solr:

java -Dauto -Drecursive -jar post.jar .

Apparently, the post.jar utility is "not meant for production use", but as a convenience tool for 
experimenting with Solr. It is made as a single java source file 
(see http://svn.apache.org/viewvc/lucene/dev/trunk/solr/core/src/java/org/apache/solr/util/SimplePostTool.java).

NOTE: I tried this post.jar tool with a couple of Outlook MSG files, but they were ignored. 
However, when I used the standalone Tika GUI tool (see "Tika In Action" and 
"java -jar tika-app-1.5.jar") I could see that Tika *was* able to recognise and extract text 
from these files. To get this to work with post.jar, I downloaded SimplePostTool.java and rebuilt 
post.jar with a few minor changes. NOTE: Due to Java 'generics' (I think) being used in the code, 
I had to use a JDK 1.7 to compile SimplePostTool.java, but it then ran fine using Java 1.6.

My rebuilt version of post.jar is called mypost.jar.
I built mypost.jar using the following script (build.sh):

cat >Manifest.txt <<EOI
Main-Class: SimplePostTool
Class-Path: .

EOI

javac SimplePostTool.java
jar cfm mypost.jar Manifest.txt *.class 
rm -f Manifest.txt

Now we can use mypost.jar to import a directory of test files named "Test_Data", that includes 
some Outlook MSG files:

java -Dauto -Drecursive -jar mypost.jar Test_Data

When you run this command, you should see output like the following:

C:\tmp\solr_demo_data>java -Dauto -Drecursive -jar mypost.jar Test_Data
SimplePostTool version 1.5
Posting files to base url http://localhost:8983/solr/update..
Entering auto mode. File endings considered are msg,xml,json,csv,pdf,doc,docx,ppt,pptx,xls,xls
odp,ods,ott,otp,ots,rtf,htm,html,txt,log
Entering recursive mode, max depth=999, delay=0s
Indexing directory Test_Data (2 files, depth=0)
POSTing file Test_email_1.msg (application/vnd.ms-outlook)
POSTing file Test_email_2.msg (application/vnd.ms-outlook)
2 files indexed.
COMMITting Solr index changes to http://localhost:8983/solr/update..
Time spent: 0:00:03.844

(NOTE: You can see usage of post.jar/mypost.jar by running the following: java -jar post.jar --help)


***


Other notes of mine from reading "Solr In Action":

o Solr is basically a web app (solr.war) running in Jetty.
o Solr home directory - one per Jetty server - system property:
  -Dsolr.solr.home=$SOLR_INSTALL/example/solr
o Solr can host multiple 'cores' (i.e. indexes) per Jetty server.  
  Each core has a separate directory (e.g. collection1) under 
  $SOLR_INSTALL/example/solr
o A Solr core is composed of a set of configuration files, Lucene index files,
  and Solr's transaction log. One Solr server running in Jetty can host multiple cores.
o As of Solr 4.4 cores can be autodiscovered and do not need to be defined in solr.xml. 
o The main Solr configuration file for a core is named solrconfig.xml. Also, schema.xml 
  is the main configuration file that governs index structure and text analysis for 
  documents and queries.
o The "all documents" search is *:*
o Search examples for the demo can be found in:
  $SOLR_INSTALL/docs/tutorial.html
o You are responsible for creating the UI, however Solr provides a customizable example 
  search UI called Solritas, to help you prototype your own search application:
  http://localhost:8983/solr/collection1/browse
o Boost the search term "power" so that it is twice as important as the term
  "iPod":
  iPod power^2
o Search for documents with term "new" and "house":
  +new +house
  or
  new AND house
o Search for "new" or "house":
  new house
  or 
  new OR house
o Exclude documents containing the term "rental":
  new house -rental
  or
  new house NOT rental
o Phrases:
  "new home" OR "new house"
  "3 bedroom" AND "walk in closet"
o Grouped expressions:
  new AND (house OR (home NOT improvemnt NOT depot NOT grown))
  (+(buying purchasing -renting) +(home house residence -(+property -bedroom)))
o How do phrae queries work, when Lucene contains an inverted term index?
  First, an AND search of the terms in returned, and then the positions are used.
o Fuzzy matches - wildcard searching:
  offi*
  or
  off*r
  or
  off?r

END
