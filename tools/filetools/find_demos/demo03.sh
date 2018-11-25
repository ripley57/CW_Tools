# Description:	Complex exec example, with file referenced multiple times.

mkdir -p dirA1

cat >dirA1/testfile1.txt <<EOI
line one of the file 1
line two of the file 1
line three of the file 1
EOI

cat >dirA1/testfile2.wibble <<EOI
line one of the file 2
line two of the file 2
line three of the file 2
EOI


cat >expected.output <<EOI
3 dirA1/testfile1.txt
EOI


find dirA1 -type f -name "*.txt" -exec sh -c 'file "$1" | grep -q text && wc -l "$1"' _ {} \; > actual.output

if cmp -s expected.output actual.output; then
	echo "TEST PASSED"
else
	echo "TEST FAILED"
	diff -c expected.output actual.output
fi


# Tidy
rm -fr dirA1 expected.output actual.output