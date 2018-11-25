# Description:	Find file by inode number.

mkdir -p dirA1
echo "file one" > "dirA1/test file one.txt"


# Get the inum of the file.
inum=$(ls -i "dirA1/test file one.txt" | cut -d ' ' -f 1)



find dirA1 -inum $inum -print > actual.output


cat > expected.output <<EOI
dirA1/test file one.txt
EOI

if cmp -s expected.output actual.output; then
	echo "TEST PASSED"
else
	echo "TEST FAILED"
	diff -c expected.output actual.output
fi


# Tidy
rm -fr dirA1 expected.output actual.output
