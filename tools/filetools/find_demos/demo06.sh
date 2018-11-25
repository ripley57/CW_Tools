# Description:	Read matching files into a bash array, to later perform an action on them.

mkdir -p dirA1/dirA2/dirA3

echo "file one"   > "dirA1/dirA2/test file one.txt"
echo "file two"   > "dirA1/test file two.text"
echo "file three" > "dirA1/dirA2/test file three.txt"
echo "file four"  > "dirA1/dirA2/dirA3/test file four.txt"


# Load all matching filenames into a bash array
#
# NOTE: The purpose of the IFS is to insure that whitespaces are not interpreted by bash 
#		as a separator (e.g. ‘hello world.txt’ would become ‘hello’ and ‘wold.txt’).
#
IFS=$'\n' A=( $(find dirA1 -name \*.txt ) )

# Dump the contents of the array.
rm -f actual.output.tmp
for i in "${A[@]}" ; do 
	echo "$i" >> actual.output.tmp
done
sort actual.output.tmp > actual.output


cat > expected.output <<EOI
dirA1/dirA2/dirA3/test file four.txt
dirA1/dirA2/test file one.txt
dirA1/dirA2/test file three.txt
EOI


if cmp -s expected.output actual.output; then
	echo "TEST PASSED"
else
	echo "TEST FAILED"
	diff -c expected.output actual.output
fi


# Tidy
rm -fr dirA1 expected.output actual.output actual.output.tmp