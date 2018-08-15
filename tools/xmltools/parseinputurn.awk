
# Description:
#     Parse input_urn.xml.
#
#     This script requires awk. You can download awk for Windows here:
#     http://gnuwin32.sourceforge.net/packages/gawk.htm
#
# Usage:
#     awk -f parseinputurn.awk input_urn.xml > output.csv

BEGIN          { 
                 total_documents_count=0; 
               }

 
/<Message>/    { 
                 total_documents_count++;
               }

/DOCID=/       { 
                 doc_id=$0; 
                 sub(/^.*DOCID="/, "", doc_id); 
                 sub(/".*$/, "", doc_id); 
               }

/Subject=/     { 
                 subject_or_filename=$0; 
                 sub(/^.*Subject="[ ]*/,"", subject_or_filename); 
                 sub(/".*$/,"", subject_or_filename); 
               }

/<\/Message>/  { 
                 printf("\"%s\",\"%s\",\"%s\"\n", doc_id, location_count, subject_or_filename); 
               }

END            {
               }

