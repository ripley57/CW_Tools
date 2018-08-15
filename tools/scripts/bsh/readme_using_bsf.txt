See http://confluence-cw.teneo-test.local/display/Walle/BSF_Service.html

To start the bsf service:

b admin-client shell addRemovableService bsfservice

Note: It will turn itself off after 10 mins of inactivity.



To run a script (must name .bsh):

D:\CW\V66>b admin-client bsfservice evalScript c:\tmp\FileIDtoMimeType.bsh



Note the 'trick' to be able to print to stdout (command-line):

buf = new StringBuffer();
String mimet = StellentFileIdToMIMETypeMapper.getMimeType(new Integer("1548"));
buf.append("Mime Type for stellent id 1548 = " + mimet + "\n");
buf;


JeremyC 16/10/2012

