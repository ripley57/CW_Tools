# Description:	Move multiple files to a new directory, NOT using the "$@" variable. 

mkdir dirA1

echo "file 1 old" > dirA1/file1.old
echo "file 2 old" > dirA1/file2.old
echo "file 3 new" > dirA1/file3.new

mkdir dirB1


cat >expected.output <<EOI
dirA1
dirA1/file3.new
dirB1
dirB1/file1.old
dirB1/file2.old
EOI


find dirA1 -name "*.old" -exec mv {} dirB1 \;


find dirA1 | sort > actual.output
find dirB1 | sort >> actual.output

if cmp -s expected.output actual.output; then
	echo "TEST PASSED"
else
	echo "TEST FAILED"
	diff -c expected.output actual.output
fi


# Tidy
rm -fr dirA1 dirB1 expected.output actual.output
