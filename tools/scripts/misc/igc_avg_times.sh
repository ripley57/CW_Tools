# Description:
#    Parse the IGC log file rie_nie_logfile.xml and calculate the average IGC 
#    processing time for each file type.
#
# Example output:
#
#$ sh ./igc_avg_times.sh
#Type   Count   Average (secs)    Largest (secs)
#doc    92      5.43283           18.8446
#docx   8       17.3708           119.047
#gif    19      0.597074          1.09426
#htm    3       3.13844           5.42241
#jpg    36      0.510767          1.11951
#msg    830     20.4736           202.509
#pdf    60      1.86731           12.5343
#png    15      0.617121          1.13701
#ppt    43      9.75692           55.6071
#pptx   4       15.4642           26.1182
#xls    39      11.1947           127.577
#xlsm   2       4.5024            4.97282
#xlsx   5       45.5365           129.172
#
# JeremyC 22/7/2016.

file_types=$(grep -o -P '(?<=<ext>).*(?=<\/ext>)' rie_nie_logfile.xml  | sort | uniq)
printf "\nType   Count   Average (secs)    Largest (secs)\n\n"
for t in $file_types
do
    sed -n "/^[ \t]*<ext>$t<\/ext>/,/[^[ \t]*<\/logentry>/p" rie_nie_logfile.xml | \
	grep totaltime | \
	grep -o -P '(?<=<totaltime>).*(?=<\/totaltime>)' | \
	gawk -v  ext=$t 'BEGIN {largest=0;} {split($1,time_array,":"); time_secs=(time_array[1]*3600)+(time_array[2]*60)+(time_array[3]); if (time_secs>largest) {largest=time_secs;} ; sum+=time_secs} END {printf("%-06s %-07s %-17s %s\n", ext, NR, sum/NR, largest)}'
done

