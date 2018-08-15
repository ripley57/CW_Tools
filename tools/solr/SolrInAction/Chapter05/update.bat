@echo off

REM Description: 
REM		Update a document in Solr using XML.
REM		Note: We use the unique document "id" value.

java -jar post.jar update.xml

REM Note: To target a specific index (aka "core"), e.g. the "ufo" core:
REM java -Durl=http://localhost:8983/solr/ufo/update -jar post.jar update.xml
