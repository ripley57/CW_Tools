# demo4.sh
#
#Description:
# Specify the field delimiter to use. Also make the check case-insensitive.
#
# Note: The two files must be sorted, by the column being compared.
# Note: By default join will condisder the first column in each file.
#
#cat demo4_file1.txt
#x,a,Asia:
#x,b,Africa:
#x,c,Europe:
#x,d,North America:
#
#cat demo4_file2.txt
#y,z,A,India
#y,z,C,The Netherlands
#y,z,D,The US
#
#Command:
#   join -1 2 -2 3 -i -t , demo4_file1.txt demo4_file2.txt
#
#Expected result:
#a,x,Asia:,y,z,India
#c,x,Europe:,y,z,The Netherlands
#d,x,North America:,y,z,The US
#
# Note: The column being compared is listed first in the output result.

join -1 2 -2 3 -i -t , demo4_file1.txt demo4_file2.txt
