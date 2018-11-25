# Description:	List files above and below a specific file size.
#
# NOTE: There are various way to create specific sized files:
#		https://www.ostechnix.com/create-files-certain-size-linux/
#
#  The different size qualifiers :
#	-size n[cwbkMG]
#    `b'    for 512-byte blocks (this is the default if no suffix is used)
#    `c'    for bytes
#    `w'    for two-byte words
#    `k'    for Kilobytes       (units of 1024 bytes)
#    `M'    for Megabytes    (units of 1048576 bytes)
#    `G'    for Gigabytes (units of 1073741824 bytes)

mkdir -p dirA1/

truncate -s 3M dirA1/3mb_file.txt
truncate -s 2M dirA1/2mb_file.txt
truncate -s 1M dirA1/1mb_file.txt


cat > expected.output <<EOI
dirA1/2mb_file.txt
dirA1/3mb_file.txt
dirA1
dirA1/1mb_file.txt
dirA1/2mb_file.txt
EOI


find dirA1 -size +1M -print > actual.output
find dirA1 -size -3M -print >> actual.output

if cmp -s expected.output actual.output; then
	echo "TEST PASSED"
else
	echo "TEST FAILED"
	diff -c expected.output actual.output
fi


# Tidy
rm -fr dirA1 expected.output actual.output
