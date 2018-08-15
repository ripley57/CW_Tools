# demo5.sh
#
#Description:
# Specify the field delimiter to use. Also make the check case-insensitive.
# For matching lines, only print the 2nd column of the first file, and the
# the 3rd and 4th columns of the second file.
#
# Note: The two files must be sorted, by the column being compared.
# Note: By default join will condisder the first column in each file.
#
#cat demo5_file1.txt
#x,a,Asia:
#x,b,Africa:
#x,c,Europe:
#x,d,North America:
#
#cat demo5_file2.txt
#y,z,A,India
#y,z,C,The Netherlands
#y,z,D,The US
#
#Command:
#   join -1 2 -2 3 -i -t , -o 1.2,2.3,2.4 demo5_file1.txt demo5_file2.txt
#
#Expected result:
#a,A,India
#c,C,The Netherlands
#d,D,The US

join -1 2 -2 3 -i -i -t , -o 1.2,2.3,2.4 demo5_file1.txt demo5_file2.txt
