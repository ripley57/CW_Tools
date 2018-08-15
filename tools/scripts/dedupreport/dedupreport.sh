# Description:
# 	Run this script from inside a metadata export directory containing
#	clearwe_export_*.xml files. This script will display the different
#	source locations for each document in CW.
#
# 	This script needs to be run from a system with Cygwin (such as a
#	CW appliance) or from a Linux/UNIX system.
#
# Usage:
#	sh dedupreport.sh
#
# Example:
#
#	$ sh dedupreport.sh
#	Parsing XML files. This may take several minutes...
#	
#	Number of items processeed by CW:
#	66064
#	
#	Number of unique items indexed by CW:
#	22397
#	
#	De-dup%:
#	66%
#	
#	See report1.log for all source locations of each Doc ID.
#	See report2.log for number of source locations of each Doc ID (most de-duped at top).
#
# JeremyC 15/10/2012

XML_FILES=$(ls -1 clearwe_export_*.xml | sort)

# Explanation of sed command:
#
# -e '/DocID=/ { s/.* DocID="\([^"]*\)".*/\1/;h }' 
#
# At the next "DocID=" line, extract the doc id number and move it from the 
# sed pattern space to the sed hold buffer ('h' option'), replacing the current 
# contents of the hold buffer.
#
#    
# -e '/Subject/ { s/.*TagValue="\(.*\)".*/\1/;H }' 
#
# At the next "Subject" line, which will be the subject for the current doc id,
# extract the subject text and append it to the sed hold buffer ('H' option). 
# This means that the hold buffer will now be: <doc id>\n<subject>
#
#
# -e '/LocationURI/ { s/.*<LocationURI>\(.*\)<\/LocationURI>/\1/;G;s/\n/ # /g;p }'
# 
# For each "LocationURI" line, one for each source location of the current 
# doc id, extract the location value (into the pattern space) and append the
# contents of the hold buffer to the pattern space ('G' option). This means 
# that the pattern space will now be: <location>\n<doc id>\n<subject>. 
# Then we replace each '\n' with a '#', to make it easier for us to later
# work with each field.
#
# The end result is that we will print out lines like this:
# <location1> # <doc id 1> # <subject 1>
# <location2> # <doc id 1> # <subject 1>
# <location1> # <doc id 2> # <subject 2>
# ...etc...
#
rm -f report1.log
echo "Parsing XML files. This may take several minutes..."
cat $XML_FILES | sed -n -e '/DocID=/ { s/.* DocID="\([^"]*\)".*/\1/;h }' -e '/Subject/ { s/.*TagValue="\(.*\)".*$/\1/;H }' -e '/LocationURI/ { s/.*<LocationURI>\(.*\)<\/LocationURI>/\1/;G;s/\n/ # /g;p }' > report1.log

rm -f report2.log
cat report1.log | cut -d# -f2 | uniq -c | sort -t# -k2 -r > report2.log

#cut -d# -f2 report1.log | uniq | wc -l 
INDEXED_COUNT=$(cat report2.log | wc -l)

#cat report1.log | cut -d# -f2 | uniq -c | perl -lane 'print @F[0]' | perl -ae '{ map {$sum += $_} <>; print "$sum\n" }'
PROCESSED_COUNT=$(cat report1.log | wc -l)

echo 
echo "Number of items processeed by CW:"
echo $PROCESSED_COUNT

echo
echo "Number of unique items indexed by CW:"
echo $INDEXED_COUNT

echo
echo "De-dup%:"
DEDUP_PERCENTAGE=$(expr \( $PROCESSED_COUNT - $INDEXED_COUNT \) \* 100 / $PROCESSED_COUNT)
echo ${DEDUP_PERCENTAGE}%

echo
echo "See report1.log for all source locations of each Doc ID."
echo "See report2.log for number of source locations of each Doc ID (most de-duped at top)."
