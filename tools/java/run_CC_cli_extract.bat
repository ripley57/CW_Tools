set BASE_PATH=D:\CW\V714\
set LIB_PATH=%BASE_PATH%\web\app\WEB-INF\lib

set CLASSPATH=%BASE_PATH%\web\app\WEB-INF\classes;^
%LIB_PATH%\annotations.jar;^
%LIB_PATH%\log4j.jar;^
%LIB_PATH%\apache-log4j-extras-1.1.jar;^
%LIB_PATH%\slf4j-log4j12-1.6.4.jar;^
%LIB_PATH%\guava-12.0.1-javadoc.jar;^
%LIB_PATH%\guava-12.0.1-sources.jar;^
%LIB_PATH%\guava-12.0.1.jar;^
%LIB_PATH%\hibernate3.jar;^
%LIB_PATH%\lucene-core-2.4-esa.jar;^
%LIB_PATH%\xstream.jar;^
%LIB_PATH%\commons-collections.jar;^
%LIB_PATH%\poi-3.5-beta5-20090219.jar;^
%LIB_PATH%\poi-scratchpad-3.5-beta5-20090219.jar;^
%LIB_PATH%\PDFBox-0.7.0.jar;^
%LIB_PATH%\mysql-connector-java-5.0.6-bin.jar;^
%LIB_PATH%\commons-io-1.1.jar;^
%LIB_PATH%\Tidy.jar;^
%LIB_PATH%\icu4j-4_0.jar;^
%LIB_PATH%\jakarta-regexp-1.5.jar;^
%LIB_PATH%\mail.jar;^
%LIB_PATH%\jcifs.jar;^
%LIB_PATH%\itext-1.3.1.jar;^
%LIB_PATH%\Notes.jar;^
%LIB_PATH%\geronimo-servlet_2.5_spec-1.2.jar;^
%LIB_PATH%\commons-fileupload-1.2.1.jar;^
%LIB_PATH%\json.jar;^
%LIB_PATH%\flexjson-1.7-cw.jar;^
%LIB_PATH%\jdom.jar;^
%LIB_PATH%\btrlp.jar;^
%LIB_PATH%\btutil.jar;^
%LIB_PATH%\struts.jar;^
%LIB_PATH%\ehcache.jar;^
%LIB_PATH%\jfreechart-0.9.21.jar;^
%LIB_PATH%\CleanContent.jar;^
%LIB_PATH%\jasperreports-3.0.0.jar;^
%LIB_PATH%\jcommon-0.9.6.jar;^
%LIB_PATH%\poi-contrib-3.5-beta5-20090219.jar;^
%BASE_PATH%\tomcat\server\lib\catalina.jar;^
%BASE_PATH%\tomcat\server\lib\catalina-optional.jar;

java com.teneo.esa.common.containerfile.analyzer.CCAnalyzer "EXTRACT_ALL,DETECT_HIDDEN_CONTENTS,EXTRACT_TEXTMD"  "D:\Test_Data\Non_RTF_Demo_7\Document.docx" "CASCADES_FIX1" "300" "0" "D:\outdir" "0x7fffff"

