# demo1.sh
#
#Description:
# Return the lines where the specified column exists in both files.
# The matching lines are returned with both lines joined.
#
# Note: By default join will condisder the first column in each file.
# Note: The two files must be sorted, by the column being compared.
#
#cat demo1_file1.txt
#1. Asia:
#2. Africa:
#3. Europe:
#4. North America:
#
#cat demo1_file2.txt
#1. India
#3. The Netherlands
#4. The US
#
#Command:
#   join demo1_file1.txt demo1_file2.txt
#
#Expected result:
#1. Asia: India
#3. Europe: The Netherlands
#4. North America: The US

join demo1_file1.txt demo1_file2.txt
