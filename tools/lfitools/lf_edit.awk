# Description:
#   Awk script to populate any empty "filename" field values.
#   If there is a "subject" value then use that for "filename".
#   Otherwise, use a value of "missing" for the "filename" field.
#
#   Note how awk can handle hex field separater 0x14 and hex text
#   qualifier 0xc3 0xbe.
# 
# JeremyC 11th Nov 2014

# From https://www.gnu.org/software/gawk/manual/html_node/Join-Function.html
function join(array, start, end, sep,    result, i)
{
    if (sep == "")
       sep = " "
    else if (sep == SUBSEP) # magic value
       sep = ""
    result = array[start]
    for (i = start + 1; i <= end; i++)
        result = result sep array[i]
    return result
}

BEGIN {
}


/^.*/							{
							  # Split on field separator, which is hex 14.
							  split($0, a, "\x14");

 							  bates_beg=a[1];
							  bates_end=a[2];
               						  bates_beg_attach=a[3];
							  bates_end_attach=a[4];
							  file_type=a[5];
							  subject=a[10];
							  filename=a[13]; 
							
							  if (file_type != "\xc3\xbeMicrosoft Outlook Note\xc3\xbe" && filename == "\xc3\xbe\xc3\xbe") {
								# This is a non email document with no file name specified.

								#printf("No filename! (bates_beg=%s, file_type=%s, subject=%s)\n", bates_beg, file_type, subject);

								# Use subject, if present, otherwise use "missing".
								if (subject != "\xc3\xbe\xc3\xbe") 
									a[13]=subject;
								else
									a[13]="missing";
							  }

							  # Rejoin the fields and print.
							  printf("%s\n", join(a, 1, 17, "\x14"));
							}


END { 
}
