# Description:	Using mindepth and maxdepth directory options.

mkdir -p dirA1/dirA2/dirA3

echo "file one"   > "dirA1/dirA2/test file one.txt"
echo "file two"   > "dirA1/test file two.txt"
echo "file three" > "dirA1/dirA2/test file three.txt"
echo "file four"  > "dirA1/dirA2/dirA3/test file four.txt"


# Up to a maximum directory depth.

cat > expected.output <<EOI
dirA1/dirA2/test file one.txt
dirA1/dirA2/test file three.txt
dirA1/test file two.txt
EOI


find dirA1 -maxdepth 2 -name "*.txt" -print | sort > actual.output

if cmp -s expected.output actual.output; then
	echo "TEST PASSED"
else
	echo "TEST FAILED"
	diff -c expected.output actual.output
fi



# Above a minimum directory depth.

cat > expected.output <<EOI
dirA1/dirA2/dirA3/test file four.txt
dirA1/dirA2/test file one.txt
dirA1/dirA2/test file three.txt
EOI


find dirA1 -mindepth 2 -name "*.txt" -print | sort > actual.output

if cmp -s expected.output actual.output; then
	echo "TEST PASSED"
else
	echo "TEST FAILED"
	diff -c expected.output actual.output
fi


# Tidy
rm -fr dirA1 expected.output actual.output
