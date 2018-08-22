#!/bin/bash
#
# Description:
#	Script to demonstrate how it is possible to automate the generation of a Case's Discussion thread reports.
#   Tested on Clearwell v811.
#
#   This script automates the following manual process required to create a single discussion thread report:
#	1. Log into Clearwell.
#   2. Run an "All Corpus" search.
#   3. Select the "Discussions" tab.
#   4. Change the Discussions page size.
#   5. Select each page of Discussions.
#   6. Execute "Actions > Print" for each Discussion.
# 
# Prerequisites:
#	o Create a Clearwell user named "automateduser" with password of "jcdc123" (see below to change this).
#	o Create the above user with Role "Case User" and assign the user a single Case only (i.e. the Case 
#     you are interested in). Doing this will take the user login immediately to that one Case.
#
# Limitations:
#   
#
# JeremyC 20-08-2018.

# Include library of functions. This is where all the hard work is done.
. ./funcs.sh

cwLogin "automateduser" "jcdc123"

echo "Running All Corpus search..."
runAllCorpusSearch

echo "Loading the Discussions page..."
loadDiscussionsPage
echo "Total number of Discussions: $(getDiscussionsCount)"
echo "Changing the Discussions page size to 100..."
changeDiscussionsPageSize "100"
number_of_discussion_pages=$(getDiscussionsPageCount)
echo "Number of Discussion pages: $number_of_discussion_pages"

# Generate Discussion reports for each page of Discussions.
for ((i=0; i<$number_of_discussion_pages; i++))
do
	echo "Generating Discussion reports for page $i ..."
	generateDiscussionReportsForPage $i
	
	# Debugging: Just do first page of discussions.
	#break
done

cwLogout
echo Finished! 
