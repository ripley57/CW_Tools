import java.io.*;

/*
**
** Description:
**
**     This program converts a file from UTF-16LE to UTF-16. The output
**     file will still be UTF-16LE (i.e. little endian), but it will be
**     guaranteed to have a BOM (byte order mark) of FFFE added at to 
**     the start of the file, to indicate little endian.
**
**     It appears that, if you specify a DAT encoding of "UTF-16", 
**     CW assumes that it is UTF-16BE (i.e. big endian). To get
**     CW to work correctly with UTF-16LE we need to make sure
**     that the DAT file includes the BOM.
**
**
**     Example input:
**
**     $ od -x -c Loadfile_Export.DAT | head
**     0000000    00fe    0042    0045    0047    0044    004f    0043    00fe
**             376  \0   B  \0   E  \0   G  \0   D  \0   O  \0   C  \0 376  \0
**
**     Resultant output:
**
**     $ od -x -c Loadfile_Export.DAT.out | head
**     0000000    fffe    fe00    4200    4500    4700    4400    4f00    4300
**             376 377  \0 376  \0   B  \0   E  \0   G  \0   D  \0   O  \0   C
**
** Useful references:
**
** This code was taken from: 
** http://docs.oracle.com/javase/tutorial/i18n/text/stream.html
**
** List of different Java charset names:
** http://docs.oracle.com/javase/1.4.2/docs/api/java/nio/charset/Charset.html
**
** Java Unicode standard corresponds to UCS-2: 
** http://livedocs.adobe.com/coldfusion/8/htmldocs/help.html?content=i18n_07.html
**
** UCS-2 and Javascript: 
** http://mathiasbynens.be/notes/javascript-encoding
**
** BOMs:
** http://www.unicode.org/faq/utf_bom.html#bom4
**
** JeremyC 30/11/2012
*/

public class DBCS2SBCS {

    public static void main(String[] args) throws Exception {

        if (args.length != 1) {
            System.out.println("usage: java DBCS2SBCS inputfilename");
            return;
        }

        String infilename  = args[0];
        String outfilename = args[0] + ".out";

        System.out.println("Converting DBCS input file \"" + infilename + "\" to SBCS output file \"" + outfilename + "\" ...");
        String inputString = readInput(infilename);
        writeOutput(inputString, outfilename);
    }

    static void writeOutput(String str, String filename) throws Exception {
        FileOutputStream fos = new FileOutputStream(filename);
        //Writer out = new OutputStreamWriter(fos, "UTF8");
        //Writer out = new OutputStreamWriter(fos, "ISO-8859-1");
        //Writer out = new OutputStreamWriter(fos, "UTF-16LE");
        Writer out = new OutputStreamWriter(fos, "UTF-16");
        //out.write('\ufffe'); // UTF-16, little-endian BOM
        out.write(str);
        out.close();
    }

    static String readInput(String filename) throws Exception {
        StringBuffer buffer = new StringBuffer();
        FileInputStream fis = new FileInputStream(filename);
        //InputStreamReader isr = new InputStreamReader(fis, "UTF-16BE");
        //InputStreamReader isr = new InputStreamReader(fis, "UTF-16");
        InputStreamReader isr = new InputStreamReader(fis, "UTF-16LE");
        Reader in = new BufferedReader(isr);
        int ch;
        while ((ch = in.read()) > -1) {
            buffer.append((char)ch);
        }
        in.close();
        return buffer.toString();
    } 
}
