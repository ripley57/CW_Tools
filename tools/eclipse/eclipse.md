(Also see eBook "EclipseInAction.pdf").  

## Eclipse online documnentation:  
* juno: http://help.eclipse.org/juno
* luna: https://help.eclipse.org/luna

## Tips  
### Code completion (page 25)
You can invoke code completion manually at any time by pressing Ctrl+Space. The exact effect will depend on the context, and you may wish to experiment a bit with this feature to become familiar with it. It can be useful, for example, after typing the first few letters of a particularly long class name.  

### Debugging - Step with Filters  
The "Step With Filters" button works the same as "Step Into", but it’s selective about what methods it will step into. You normally want to step only into methods in your own classes and not into the standard Java packages or third-party packages. You can specify which methods Step Filter will execute and return from immediately by selecting "Window"→"Preferences"→"Java"→"Debug"→"Step Filtering" and
defining step filters by checking the packages and classes listed there. Taking a moment to set these filters is well worth the trouble, because Step With Filters saves you from getting lost deep in unknown code—something that can happen all too often when you use "Step Into".

## Q & A
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
