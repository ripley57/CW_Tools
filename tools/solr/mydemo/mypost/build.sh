
cat >Manifest.txt <<EOI
Main-Class: SimplePostTool
Class-Path: .

EOI

javac SimplePostTool.java
jar cfm mypost.jar Manifest.txt *.class 
rm -f Manifest.txt
