#!/bin/bash

function printHeader()
{
	cat <<EOI
"DocID","DocType","DateSent","From","To","Subject","NativeFilePath_FileName","TextFilePath_FileName","CustField1","CustField2","CustField3","CustField4","CustField5","CustField6","CustField7"
EOI
}

function printRecords()
{
	local recNumStart=$1
	local recNumEnd=$2

	if [ "x$recNumEnd" = x ]; then
		recNumEnd=$recNumStart
		recNumStart=1
	fi

	local i
	local docid

	for (( i=$recNumStart; i <= $recNumEnd; i++ ))
	do
		docid=$(printf "%08d" $i)
 		printSingleRecord $docid
		copyTextFile $docid
		copyNativeFile $docid
	done
}

function copyTextFile()
{
	local _destDocId=$1
	mkdir -p text
	cp test_files/test_file_text.txt text/${_destDocId}.txt
}

function copyNativeFile()
{
	local _destDocId=$1
	mkdir -p native
	cp test_files/test_file_msg.msg native/${_destDocId}.msg
}

function printSingleRecord()
{
	local docid=$1
	cat <<EOI
"$docid","Message","2009-01-01T02:11:00.000+0000","Aiken, Sam <aiken@tamascorp.com>","Jack Fredericks <jfredericks@tamascorp.com>","Test file $docid","native\\$docid.msg","text\\$docid.txt","This is cust field 1 text" for $docid,"This is cust field 2 text for $docid","This is cust field 3 text for $docid","This is cust field 4 text for $docid","This is cust field 5 text for $docid","This is cust field 6 text for $docid","This is cust field 7 text for $docid"
EOI
}


loadfilename=demo.csv
rm -fr native text
printHeader | tee $loadfilename
printRecords 250001 500000 | tee -a $loadfilename

echo
echo "Finished!"
echo
echo "IMPORTANT: You may need to set the access permissions on the generated output files and directories."
echo
