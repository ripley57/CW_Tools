# Description:	Search multiple directories.
 
mkdir -p dirA1/dirA2/dirA3
echo "hello" > dirA1/dirA2/dirA3/fileA.txt

mkdir -p dirB1/dirB2
echo "goodbye" > dirB1/dirB2/fileB.wobble

mkdir -p dirC1/dirC2/dirC3
echo "wowee" > dirC1/dirC2/dirC3/fileC.txt


cat >expected.output <<EOI
dirA1/dirA2/dirA3/fileA.txt
dirC1/dirC2/dirC3/fileC.txt
EOI


find dirA1 dirC1 -name "*.txt" > actual.output

if cmp -s expected.output actual.output; then
	echo "TEST PASSED"
else
	echo "TEST FAILED"
	diff -c expected.output actual.output
fi


# Tidy
rm -fr dirA1 dirB1 dirC1 expected.output actual.output
