# demo2.sh
#
#Description:
# Return the lines where the specified column does not only exist
# in the first file.
#
# Note: By default join will condisder the first column in each file.
# Note: The two files must be sorted, by the column being compared.
#
#cat demo2_file1.txt
#1. Asia:
#2. Africa:
#3. Europe:
#4. North America:
#
#cat demo2_file2.txt
#1. India
#3. The Netherlands
#4. The US
#
#Command:
#   join -v 1 demo2_file1.txt demo2_file2.txt
#
#Expected result:
#2. Africa:
#
# Note: Similarly, use "-v 2" to see lines that only exist in the 
#       second file.

join -v 1 demo2_file1.txt demo2_file2.txt
