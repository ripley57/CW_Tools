@ECHO OFF
REM To debug the jsonvalidator.jar file, see my doc "How to debug any external jar in Eclipse.docx".
java -Xdebug -Xrunjdwp:transport=dt_socket,address=8000,suspend=y,server=y -jar jsonvalidator.jar data.json schema.json