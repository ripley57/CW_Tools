INSTALL DERBY (into the local "./lib" directory):
ant install-derby


USE THE DERBY COMMAND PROMPT TO CREATE AN EMBEDDED DATABASE:
Windows approach:
o setenv.bat
o %DERBY_INSTALL%\bin\ij.bat
o run 'createdb.sql';
o exit;
Note: This will create database "mydb" under c:\temp (see createdb.sql).



MORE DERBY COMMAND PROMPT EXAMPLES:
Windows approach:
o setenv.bat
o %DERBY_INSTALL%\bin\ij.bat
o connect 'jdbc:derby:c:/temp/mydb;create=false';
o show tables;
o select * from custs; 
o select * from orders;
o select * from custs where id='1';
o select * from orders where custid='1';
o delete from custs;
o delete from orders;
o exit;



RUN OUR JAVA EMBEDDED DERBY DATABASE FILLER DEMO:
First we empty the tables in our database (our Java program expects the tables to exist):
Windows approach:
o setenv.bat
o %DERBY_INSTALL%\bin\ij.bat
o connect 'jdbc:derby:c:/temp/mydb;create=false';
o delete from custs;
o delete from orders;

Now run our Java filler program (this will insert many table records):
o ant run-embedded-demo

Verify the new record counts:
o setenv.bat
o %DERBY_INSTALL%\bin\ij.bat
o connect 'jdbc:derby:c:/temp/mydb;create=false';
o select count(*) from custs;
o select count(*) from orders;



RUN OUR DATABASE AS A TRADITIONAL NETWORKED CLIENT/SERVER DATABASE (INSTEAD OF EMBEDDED):
(See http://db.apache.org/derby/papers/DerbyTut/ns_intro.html)
First we start a standalone Derby database server:
Windows approach:
o setenv.bat
o cd %DERBY_INSTALL%\bin
o setNetworkServerCP.bat
o startNetworkServer.bat
(Note: By default the Derby server will listen on port 1527).

Now we can connect our client. We'll use the ij client:
Windows approach:
o setenv.bat
o %DERBY_INSTALL%\bin\setNetworkClientCP.bat
o %DERBY_INSTALL%\bin\ij.bat
o connect 'jdbc:derby://localhost:1527//c:/temp/mydb;create=false';

Note: Here is a common "access denied" error you will likely see:

ij> connect 'jdbc:derby://localhost:1527/c:/temp/mydb;create=false';
ERROR XJ001: DERBY SQL error: ERRORCODE: 0, SQLSTATE: XJ001, SQLERRMC: java.security.AccessControlException¶access denied ("java.i
o.FilePermission" "C:\temp\mydb" "read")¶XJ001.U

An here is the error in the derby.log file:

Sun Jun 23 10:51:05 BST 2019 Thread[DRDAConnThread_2,5,main] Cleanup action starting
java.security.AccessControlException: access denied ("java.io.FilePermission" "C:\temp\mydb" "read")
	at java.security.AccessControlContext.checkPermission(Unknown Source)
	at java.security.AccessController.checkPermission(Unknown Source)
	at java.lang.SecurityManager.checkPermission(Unknown Source)
	...

Notice the mention of the Java "SecurityManager". Also notice the following when the server is started:
C:\Users\jcdc\Cygwin\home\jcdc\Github\CW_Tools\tools\sql\derby\lib\db-derby-10.14.2.0-bin\bin>startNetworkServer.bat
Sun Jun 23 11:14:20 BST 2019 : Security manager installed using the Basic server security policy.

=> We need to define a new extra 'java.policy' file and get our server to use this.
Instead of using -Djava.security.policy, we want a method where we don't have to edit our Derby batch scripts.
First, I launched "policytool" to create a policy file with relaxed file access permissions:

grant {
  permission java.io.FilePermission "c:/temp/-", "read,write,delete";
};

Note: I couldn't get this to work with "c:/temp/mydb/-", so this is the best I could get.
(see https://docs.oracle.com/javase/tutorial/security/tour1/index.html)

I copied this "java.policy" file to c:\temp and then updated my Java's "lib\security\java.security" file like this:

policy.url.1=file:${java.home}/lib/security/java.policy
policy.url.2=file:${user.home}/.java.policy
policy.url.3=file:///c:/temp/java.policy

I restarted my Derby database server and could then connect with the ij client:

ij> connect 'jdbc:derby://localhost:1527/c:/temp/mydb;create=false';
ij> select count(*) from custs;
1
-----------
1000


Note: A handy trick is to add an invalid character (e.g. a line beginning "#") to your policy file. When starting Derby
you will see an error, which at least indicates that your policy file is being read:

C:\Users\jcdc\Cygwin\home\jcdc\Github\CW_Tools\tools\sql\derby\lib\db-derby-10.14.2.0-bin\bin>startNetworkServer.bat
Sun Jun 23 11:47:57 BST 2019 : Security manager installed using the Basic server security policy.
java.security.policy: error parsing file:/c:/temp/java.policy:
        line 2: expected [;], found [#]
Sun Jun 23 11:48:03 BST 2019 : Apache Derby Network Server - 10.14.2.0 - (1828579) started and ready to accept connections on port
 1527



RUNNING OUR JAVA DATABASE FILLER PROGRAM ON A NETWORKED CLIENT/SERVER DATABASE (INSTEAD OF EMBEDDED):
Instead of running...
ant run-embedded-demo
...simply run:
ant run-networked-demo
Note: But remember to first clear the "custs" and "orders" tables!


JeremyC 23-06-2019
