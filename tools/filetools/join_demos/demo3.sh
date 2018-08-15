# demo3.sh
#
#Description:
# Specify the column to compare in each file.
#
# Note: The two files must be sorted, by the column being compared.
# Note: By default join will condisder the first column in each file.
#
#cat demo3_file1.txt
#x 1. Asia:
#x 2. Africa:
#x 3. Europe:
#x 4. North America:
#
#cat demo3_file2.txt
#y z 1. India
#y z 3. The Netherlands
#y z 4. The US
#
#Command:
#   join -1 2 -2 3 demo3_file1.txt demo3_file2.txt
#
#Expected result:
#1. x Asia: y z India
#3. x Europe: y z The Netherlands
#4. x North America: y z The US
#
# Note: The column being compared is listed first in the output result.

join -1 2 -2 3 demo3_file1.txt demo3_file2.txt
