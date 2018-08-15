# Description:
#	Read statusLog.txt files in current directory (and sub-directories).
#	Calculate the average processing times.
#	Generate a CSV file of the times, with newest jobs at the top.

# List file names in last modified order - oldest first.
fnames="$(find . -type f -iname statuslog.txt -printf '%T@ %p\n' | sort -k 1n | sed 's/^[^ ]* //')"
#echo fnames=$fnames

awk -f procperf.awk $fnames > output_unsorted.csv

# Sort by US date format (mm/dd/yyyy) and then crawler start time (hh:mm:ss). Also skip the header line.
tail -n +2 output_unsorted.csv | sort -k1.7,1.10nr -k1.1,1.2nr -k1.4,1.5nr -k2.1,2.2nr -k2.4,2.6nr -k2.6,2.8nr > output_noheader_sorted.csv

# Re-add the header.
tac output_noheader_sorted.csv > output_reversed.csv
head -1 output_unsorted.csv >> output_reversed.csv
tac output_reversed.csv > output.csv

rm -f output_unsorted.csv
rm -f output_noheader_sorted.csv
rm -f output_reversed.csv
