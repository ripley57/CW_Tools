
# Description:
#    Use this script to extract values from a Lotus Notes table listing.
# 
# A Lotus Notes document listing looks like this:
#
# head -3 xzz48905.txt
#                Who             Date    Time    Size    Subject
#                Deborah Jackson         16/10/2008      08:33   782,397 BOND 15.07.08 (version 6).xls
#                Liz Clare               16/10/2008      14:25   757,020 Bond Report pm
#
# Comments:
#    I have seen a one hour discrepency on occasion, so be aware of the time zone when comparing with input_urn.xml.
#    If you take one away for the header line, you can quickly get a count of the emails in the nsf file.
#
# Example usage:
#    sh parsensflisting.sh nve34049_2010.txt

sed -n 's/^.*[ \t]*\([0-9][0-9]\/[0-9][0-9]\/[0-9][0-9][0-9][0-9]\)[ \t]*\([0-9][0-9]:[0-9][0-9]\)[ \t]*\([^ \t]*\)[ \t]*\(.*\)$/\4/p' "$1"
