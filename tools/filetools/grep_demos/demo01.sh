# Description:	Grep for BOTH words that must exist in a file.
 
mkdir -p dirA1
echo "This file contains monkey"				> dirA1/fileone.txt
echo "This file contains monkey and darts"			> dirA1/filetwo.txt
echo "This file also contains monkey and darts to there." 	> dirA1/filethree.txt
echo "This file only contains dart boohoo." 			> dirA1/filefour.txt

# We will use two separate regular expressions, to make the example a little more interesting.
gawk 'BEGIN { IGNORECASE=1} /monk.y/ && /d.*rtS/ { print FILENAME }' dirA1/* > actual.output


cat >expected.output <<EOI
dirA1/filethree.txt
dirA1/filetwo.txt
EOI


if cmp -s expected.output actual.output; then
	echo "TEST PASSED"
else
	echo "TEST FAILED"
	diff -c expected.output actual.output
fi


# Tidy
rm -fr dirA1 expected.output actual.output
