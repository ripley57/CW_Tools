Demo to show how Java object creation can be driven by a Java Properties file
=============================================================================

NOTE: This directory is importable into Eclipse as a project, hence the files ".settings", ".classpath" and ".project".
 

A. Running the demo inside Eclipse
==================================

o Import this directory "props2objs" into Eclipse:
"File > Import > General > Existing Projects into Workspace".


o Changing the Java version used by Eclipse.
If you have imported the project into a different appliance, you may need to re-point the project to an existing Java installation.

First go here:
"Project > Properties > Libraries"

Then, if the "JRE System Library [jdk...]" says "(unbound)", you need to point to a new Java installation. Double-click the entry and either point to an existing  "c:\jdk-..." directory, or select the option "Workspace default JRE (jdk-...).


o The Project's "Run > Run Configurations..." and "Run > Debug Configurations..." configurations.
You don't need to do anything here! The "Java Application > action1" and "Java Application > action2" run and debug launchers should already be present. These supply the input argument "action1" or "action2" respectively.

These launch configurations were imported automatically because they have been configured as shared files, as follows:
1. Right-click on the Project name and select "New > Folder". This is where our launch configurations will be saved by Eclipse.
2. Go to "Run > Run Configurations..." and select each of "FW (disable)" and "FW (enable)". 
3. Select the "Common" tab and select "Shared file". 
4. Click "Browse..." and navigate to the new folder we added earlier.
5. Click "Apply". You should now see two ".launch" files in the directory.
(see also https://www-01.ibm.com/support/docview.wss?uid=swg21264629)


o Run the "action1" or "action2" launcher. 
Output should be seen in the Eclipse console window.



B. Running the demo outside of Eclipse
======================================

o Configuring Ant (ANT_HOME).
Running the CW_Tools "ant" command will download and extract ant to tools/ant/. To use this ant from a cmd.exe window, the "ant" command also displays the path to a generated Windows batch script named "setenv.cmd" to setup the ant environment. NOTE: To run the CW_Tools "ant" command (i.e. in Cygwin) you will first need to be pointing to a Java installation, e.g. export JAVA_HOME=/cygdrive/c/jdk-8u74-windows-x64

If running the demo in Cygwin, there are various methods, including these:
ant run-action1
ant run-action2
ant -Dbuild.args="action1|somearg2|somearg3"

If running the demo in Windows:
o Run the "setenv.cmd" script to setup the Ant environment. You may also need to setup your Java environment, e.g. set JAVA_HOME=C:\jdk-8u74-windows-x64):
o Launch cmd.exe and change to this directory ("props2objs").
o Run "action1.bat" to build and run the demo passing the "action1" input argument.
o Run "action2.bat" to build and run the demo passing the "action2" input argument.
o Alternatively, you can use the same methods used when running the demo in Cygwin:
ant run-action1
ant run-action2
ant -Dbuild.args="action1|somearg2|somearg3"


o You should see Ant output similar to this:
C:\Users\jcdc\Cygwin\home\jcdc\Github\CW_Tools\tools\java\props2objs>ant -Dbuild.args="action2"
Buildfile: C:\Users\jcdc\Cygwin\home\jcdc\Github\CW_Tools\tools\java\props2objs\build.xml

compile:

run:
     [echo] Running...
 [autoprop] set build.arg0=action2
     [java] Running...
     [java] Performing Action2:  ...
     [java] EntityTypeA: action2: name=obj2 [attr1=val1_obj2, attr2=val2_obj2]
     [java] EntityTypeA: action2: name=obj1 [attr1=val1_obj1, attr2=val2_obj1]
     [java] EntityTypeB: action2: name=obj3 [attr1=val1_obj3, attr2=val2_obj3, attr3=val3_obj3, attr4=val4_obj3]

BUILD SUCCESSFUL
Total time: 3 seconds

	 
22-11-2018
