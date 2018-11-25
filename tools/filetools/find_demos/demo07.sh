# Description:	Searching using the OR expression "-o".

mkdir -p dirA1/dirA2/dirA3

echo "file 123"     > "dirA1/dirA2/test file one.123"
echo "file 1234"    > "dirA1/test file two.1234"
echo "file 12345"   > "dirA1/dirA2/test file three.12345"
echo "file 123456"  > "dirA1/dirA2/dirA3/test file four.123456"


cat > expected.output <<EOI
1 ./dirA1/dirA2/dirA3/test file four.123456
1 ./dirA1/dirA2/test file one.123
EOI


find . \( -name "*.123" -o -name "*.123456" \) -exec wc -l {} \; | sort > actual.output

if cmp -s expected.output actual.output; then
	echo "TEST PASSED"
else
	echo "TEST FAILED"
	diff -c expected.output actual.output
fi


# Tidy
rm -fr dirA1 expected.output actual.output

