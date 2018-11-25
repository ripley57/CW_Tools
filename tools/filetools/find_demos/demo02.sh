# Description:	Exclude some directories.
 
mkdir -p dirA1/dirA2/dirA3
echo "hello" > dirA1/dirA2/dirA3/fileA.txt

mkdir -p dirA1/dirB1/dirB2
echo "goodbye" > dirA1/dirB1/dirB2/fileB.txt

mkdir -p dirA1/dirC1/dirC2/dirC3
echo "wowee" > dirA1/dirC1/dirC2/dirC3/fileC.txt


cat >expected.output <<EOI
dirA1/dirB1/dirB2/fileB.txt
EOI

# Note below: sub-dirs to be 'pruned' must be described with their full relative path.
find dirA1 -path dirA1/dirC1 -prune -o -path dirA1/dirA2 -prune -o -name "*.txt" -print > actual.output

if cmp -s expected.output actual.output; then
	echo "TEST PASSED"
else
	echo "TEST FAILED"
	diff -c expected.output actual.output
fi


# Tidy
rm -fr dirA1 expected.output actual.output