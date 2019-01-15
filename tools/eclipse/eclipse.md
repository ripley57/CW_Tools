# Eclipse   

## Eclipse documnentation:  
* juno: http://help.eclipse.org/juno
* luna: https://help.eclipse.org/luna
* Also see my eBook **EclipseInAction.pdf**

## Tips  
### Code completion (page 25)
You can invoke code completion manually at any time by pressing Ctrl+Space. The exact effect will depend on the context, and you may wish to experiment a bit with this feature to become familiar with it. It can be useful, for example, after typing the first few letters of a particularly long class name.  

### Debugging - "Step Into" and Step Filters  
You normally want to only "Step Into" methods in your own classes and not into the standard Java packages or third-party packages. You can specify which methods that "Step Into" ignores (filters) by selecting "Window"→"Preferences"→"Java"→"Debug"→"Step Filtering" and
defining the packages and classes listed there. 

## Q & A
Q: How do I import an existing Eclipse project?  
A: See README.txt in tools/java/props2objs  
  
Q: How do I use my own custom Ant build.xml file with Eclipse?  
A: See https://www.ibm.com/developerworks/opensource/tutorials/os-ecl-easyant/index.html  
  
Q: Why can't my Ant build find javac ("Unable to find a javac compiler")?  
A: https://wiki.eclipse.org/FAQ_Why_can%27t_my_Ant_build_find_javac%3F  
**Note:** The easiest solution looks to be making Eclipse use a JDK instead of JRE (see https://www.gamefromscratch.com/post/2011/11/15/Telling-Eclipse-to-use-the-JDK-instead-of-JRE.aspx)  
  
Q: There is an exclamation icon next to the project name. What does it mean?  
A: To see the issues or errors: "Window → Show View → Problems" or "Window → Show View → Error Log".  
See: https://stackoverflow.com/questions/3812987/eclipse-shows-errors-but-i-cant-find-them  

Q: How do I import or export my Eclipse preferences?  
A: "File > Import" and "File > Export".  
See https://help.eclipse.org/neon/index.jsp?topic=%2Forg.eclipse.platform.doc.user%2Ftasks%2Ftimpandexp.htm  

Q: What is the .classpath file in my project directory (in my workspace folder)?  
A: This contains the source and jar classpath entries. It can be edited manually.  
Example contents:  
    <?xml version="1.0" encoding="UTF-8"?>
    <classpath>
        <classpathentry kind="src" path="src"/>
        <classpathentry kind="src" path="test/java"/>
        <classpathentry kind="src" path="unittests/java"/>
        <classpathentry kind="src" path="unittests/testdata"/>
        <classpathentry kind="lib" path="3rdparty/apps/ant/lib/ant-junit.jar"/>
        <classpathentry kind="lib" path="3rdparty/apps/ant/lib/ant.jar"/>

Q: How do I create a "scrapbook" page to tryout some Java snippet?  
A: "File > New > Other...." Then select "Java > Java Run/Debug > Scrapbook Page".  
See https://help.eclipse.org/neon/index.jsp?topic=%2Forg.eclipse.jdt.doc.user%2Ftasks%2Ftask-create_scrapbook_page.htm  

Q: What is an example command-line so that Eclipse can attach to the Java process?  
A: java -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000 Demo reports\MessagesReport.jasper output\output.pdf  

Q: How do I launch Ecipse with an older Java version?  
A: eclipse -vm c:\jrockit-jdk1.6.0_29-R28.2.0-4.1.0-x32\bin\javaw  

Q: How do I rename a source file in Eclipse?  
A: Right-click file -> refactor -> rename  

Q: I added JUnit test source files to my project, which I've placed in the directory "src/test/java". My main source files are kept in the directory "src/main/java". Eclipse is complaining that "The declared package "" does not match the expected package "main.java"". How do I tell Eclipse that the source directories are "src/test/java" and "src/main/java", instead of just "src"?  
A: Go to "Properties > Java Build Path", delete the existing "src" entry, and add two new src entries for "src/test/java" and "src/main/java". **NOTE**: This requires a restart of Eclipse afterwards. And you will also need to manually create the sub-directories to match the package declarations in the source files.

Q: How to I add a log4j.proeperties file to my project?
A: Add a folder named "resources" to your project, then using "Properties > Java Build Path" to add the folder to the "Sources" tab. The contents of the "resources" folder will now be copied to the runtime output directory "bin" that Eclipse uses. This will ensure that the log4j.properties file is on the classpath (see https://stackoverflow.com/questions/25162773/how-do-i-add-a-directory-to-the-eclipse-classpath).  

Q: How do I automatically create an Ant build.xml file from my Eclipse project?  
A: "File > Export", select "General > Ant Buildfiles". This will create a build.xml file in the project's top-level directory.  

Q: How do I list the targets in my build.xml file?
A: "ant -p"  
