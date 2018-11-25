# Description:	List files older or newer than a specific date.
#
# Linux "touch" command:
# https://www.binarytides.com/linux-touch-command/

mkdir -p dirA1/dirA2/dirA3

echo "file one"   > "dirA1/dirA2/test file one.txt"
echo "file two"   > "dirA1/test file two.txt"
echo "file three" > "dirA1/dirA2/test file three.txt"
echo "file four"  > "dirA1/dirA2/dirA3/test file four.txt"


# Set the last modified time to: 11:59am 13seconds 1st Feb 2015.
#
# Output from stat:
# Modify: 2015-02-01 11:59:13.000000000 +0000
#
touch -t 201502011159.13 "dirA1/dirA2/test file one.txt"


# Set the last modified time to: 22:45 3rd April 1989.
#
# Output from stat:
# Modify: 1989-04-03 22:45:00.000000000 +0100
#
touch -t 198904032245 "dirA1/test file two.txt"


# Set the last modified time to: 10:15am 5th March 2016.
#
# Output from stat:
# Modify: 2016-03-05 10:15:00.000000000 +0000
#
touch -t 201603051015 "dirA1/dirA2/test file three.txt"


# Set the last modified time to 3 days ago.
#
# Today in seconds since epoch:
let today_epoch_secs=$(date +%s)
# 3 days in seconds:
let three_days_secs=$(expr 3*24*60*60)
# 3 days aho in seconds since epoch:
let three_days_ago_secs=$(expr $today_epoch_secs-$three_days_secs)
touch -d @$three_days_ago_secs "dirA1/dirA2/dirA3/test file four.txt"


rm -f actual.output


# Files modified within the last 4 days.
#
# This should list:
# dirA1/dirA2/dirA3/test file four.txt
#
echo "==== TEST 1 ===========" >> actual.output
find dirA1 -type f -mtime -4 -print | sort >> actual.output


# Files newer than 1st Jan 2016.
#
# This should list:
# dirA1/dirA2/dirA3/test file four.txt
# dirA1/dirA2/test file three.txt 
#
echo "==== TEST 2 ===========" >> actual.output
find dirA1 -type f -newermt "jan 01, 2016 00:00" -print | sort >> actual.output


# Find files newer than file "dirA1/dirA2/test file three.txt".
#
# This should list:
# dirA1/dirA2/dirA3/test file four.txt
#
echo "==== TEST 3 ===========" >> actual.output
find dirA1 -type f -newer "dirA1/dirA2/test file three.txt" -print | sort >> actual.output


# Find files older than file "dirA1/dirA2/dirA3/test file four.txt".
#
# This should list:
# dirA1/dirA2/test file one.txt
# dirA1/dirA2/test file three.txt
# dirA1/test file two.txt
# 
echo "==== TEST 4 ===========" >> actual.output
find dirA1 -type f ! -newer "dirA1/dirA2/test file three.txt" -print | sort >> actual.output


cat > expected.output <<EOI
==== TEST 1 ===========
dirA1/dirA2/dirA3/test file four.txt
==== TEST 2 ===========
dirA1/dirA2/dirA3/test file four.txt
dirA1/dirA2/test file three.txt
==== TEST 3 ===========
dirA1/dirA2/dirA3/test file four.txt
==== TEST 4 ===========
dirA1/dirA2/test file one.txt
dirA1/dirA2/test file three.txt
dirA1/test file two.txt
EOI


if cmp -s expected.output actual.output; then
	echo "TEST PASSED"
else
	echo "TEST FAILED"
	diff -c expected.output actual.output
fi


# Tidy
rm -fr dirA1 expected.output actual.output
