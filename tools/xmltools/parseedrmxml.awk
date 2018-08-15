
# Description:
#     Parse EDRM xml file and display the following:
#
#     docid, document type, location count, processing batch count, processing batch labels (i.e. names)
#
#     This script requires awk. You can download awk for Windows here:
#     http://gnuwin32.sourceforge.net/packages/gawk.htm
#
# Usage examples:
#     awk -f parseedrmxml.awk clearwe_export_0000001.xml clearwe_export_0000002.xml > output.csv
#     awk -f parseedrmxml.awk clearwe_export_0000*.xml > output.csv
#
# Example usage (with output sorted by column 4 (batch count)):
#
# $ awk -f parseedrmxml.awk clearwe_export_000000*.xml | sort -t',' -k4 -nr | head
# 0.7.61.7851,File,6,3,"Sun Apr 14 2013 11:35:41 PDT - Processing - SALES_MANAGERS_PROC#Sun Apr 14 2013 11:02:50 PDT - Processing - REGIONAL_VPS_PROC#Sun Apr 14 2013 10:41:05 PDT - Processing - CORPORATE_EXECS_PROC"
# 0.7.61.7842,File,6,3,"Sun Apr 14 2013 11:35:41 PDT - Processing - SALES_MANAGERS_PROC#Sun Apr 14 2013 11:02:50 PDT - Processing - REGIONAL_VPS_PROC#Sun Apr 14 2013 10:41:05 PDT - Processing - CORPORATE_EXECS_PROC"
# 0.7.61.7797,File,6,3,"Sun Apr 14 2013 11:35:41 PDT - Processing - SALES_MANAGERS_PROC#Sun Apr 14 2013 11:02:50 PDT - Processing - REGIONAL_VPS_PROC#Sun Apr 14 2013 10:41:05 PDT - Processing - CORPORATE_EXECS_PROC"


BEGIN          { 
                 total_documents_count=0; 
                 total_locs_count=0;
               }
	
/<Document /   { 
                 total_documents_count++;
                 location_count=0; 

                 doc_id=doc_type=mime_type=$0; 

                 sub(/^.*DocID="/,"", doc_id); 
                 sub(/".*$/,"", doc_id); 
                 
                 sub(/^.*DocType="/,"", doc_type); 
                 sub(/".*$/,"", doc_type); 
               }

/<Batches>/    {
                 batch_count=0;
                 batch_names="";
               }

/<BatchId>/    {
                 batch_count++;
                 batch=$0
                 sub(/^.*<BatchId>/,"", batch); 
                 sub(/<\/BatchId>.*$/,"", batch);
                 if (batch_names != "")
                    batch_names=sprintf("%s%s", batch_names, "#");
                 batch_names=sprintf("%s%s", batch_names, batch);
               } 


/<LocationURI>/ { 
                 total_locations_count++;
                 location_count++;
               }

/<\/Document>/ {
                 printf("%s,%s,%s,%s,\"%s\"\n", doc_id, doc_type, location_count, batch_count, batch_names); 
               }

END            {
                 # Uncomment the following lines to see de-dupe calculation. 
                 #printf("\nTotal documents count: %s\nTotal locations count: %s\nDe-dupe percentage: %s\n", 
                 #total_documents_count, total_locations_count, ((total_locations_count - total_documents_count)/total_locations_count)); 
               }

