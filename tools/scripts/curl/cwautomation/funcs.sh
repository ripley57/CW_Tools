# Library of functions to be "." (sourced) into the calling script curldemo.sh.

_CW_SERVER=localhost
_WEB_BROWSER_USER_AGENT="User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko"
_DISCUSSIONS_PER_PAGE=10

_DEBUG=on
function debugLog()
{
	[ "$_DEBUG" == "on" ] && echo DEBUG: $*
}


# Log into Clearwell as the specified user.
#
function cwLogin()
{
	local _username=$1
	local _password=$2
	
	curl -s --cookie-jar cjar -H '$_WEB_BROWSER_USER_AGENT' http://${_CW_SERVER}/esa/submitLocalLogin
	curl -s --cookie cjar --cookie-jar cjar -H '$_WEB_BROWSER_USER_AGENT' --data "cwu=$_username" --data "cwp=$_password" --location --output cwLogin.html http://${_CW_SERVER}/esa/submitLocalLogin
}


# Logout of Clearwell.
#
function cwLogout()
{
	curl -s --cookie cjar --cookie-jar cjar -H '$_WEB_BROWSER_USER_AGENT' --location --output cwLogout.html http://${_CW_SERVER}/esa/public/logout.jsp
}


# Return the Case Id.
#
function getCaseID()
{
	# Look for something like this in the cwLogin.html file:
	# "CaseId :  '0.6.7.361339923'" 
	local _case_id=$(grep -o -P "(?<=CaseId :  ').*(?=',)" cwLogin.html)
	echo $_case_id
}


# Get forgery-prevention value for this session.
#
function getCWfp() 
{
	# Look for something like this in the cwLogin.html file:
	# "caseOverview: 'navAction.do?sectionName=admin2&pa=monitorOverview&CWfp=-4050325143747857014'"
	local _cw_fp=$(grep -o -P "(?<=navAction\.do\?sectionName=admin2&pa=monitorOverview&CWfp=).*(?=')" cwLogin.html)
	echo $_cw_fp
}


# Perform an "All Corpus" search in the current Case.
#
function runAllCorpusSearch()
{
	curl -s --cookie cjar --cookie-jar cjar -H '$_WEB_BROWSER_USER_AGENT' \
--data "CWfp=$(getCWfp)" \
--data "searchCaseID=$(getCaseID)" \
--data 'searchID=' \
--data 'searchString=' \
--data 'folderPicker=All+Documents' \
--data 'selectedSearchFolderName=All+Documents' \
--data 'selectedSearchFolderId=ALL_DOCUMENTS' \
--data 'selectedSearchFolderReviewState=' \
--data 'actionPath=%2FsearchList.do' \
--data 'browserNavDetect=2' \
--data 'searchType=basic' \
--data 'searchAction=newSearch' \
--data 'focusID=' \
--data 'searchRoute=' \
--data 'previewFilter=' \
--data 'domainFlag=off' \
--data 'custodianFlag=off' \
--data 'recipientFlag=off' \
--data 'recipientAliasFlag=off' \
--data 'recipientDomainFlag=off' \
--data 'individualFlag=off' \
--data 'individualAliasFlag=off' \
--data 'departmentFlag=off' \
--data 'projectsFlag=off' \
--data 'queriesFlag=off' \
--data 'subqueriesFlag=off' \
--data 'predictionFlag=off' \
--data 'tagzFlag=off' \
--data 'tagTypeFlag=' \
--data 'docTypeFlag=off' \
--data 'fileTypeFlag=off' \
--data 'fileSizeFlag=off' \
--data 'languageFlag=off' \
--data 'emailWarningFlag=off' \
--data 'fileWarningFlag=off' \
--data 'exportErrorFlag=off' \
--data 'productionSlipsheetFlag=off' \
--data 'filtersAuto=auto' \
--data 'domainProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'custodianProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientAliasProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientDomainProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'individualProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'individualAliasProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'departmentProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'projectsProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'queriesProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'predictionProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'tagzProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'docTypeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileTypeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileSizeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'languageProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'emailWarningProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileWarningProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'exportErrorProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'productionSlipsheetProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'searchesProps=%7B%22searches_4%22%3A%7B%22start%22%3A0%2C%22open%22%3A%22t%22%7D%2C%22searches_1%22%3A%7B%22start%22%3A0%7D%2C%22searches_5%22%3A%7B%22start%22%3A0%7D%7D' \
--data 'searchesSelection=%7B%22searches_4%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%2C%22searches_1%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%2C%22searches_5%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%7D' \
--data 'scrollX=0' \
--data 'scrollY=0' \
--data 'filterSelectionString=' \
--data 'filterAppliedString=' \
--location --output runAllCorpusSearch.html http://${_CW_SERVER}/esa/searchList.do

	debugLog "Waiting 60 seconds for the search to complete..."
	sleep 60s
}


# Extract the implicit saved search id corresponding to the "All Corpus" search.
function getSearchId()
{
	# Look for a string like this in runAllCorpusSearch.html
	# g_lastSearchID = '113';
    local _searchID=$(grep -o -P "(?<=g_lastSearchID = ').*(?=';)" runAllCorpusSearch.html)
	echo $_searchID
}


# Load the "Discussions" tab in "Analysis & Review".
#
function loadDiscussionsPage()
{
	curl -s --cookie cjar --cookie-jar cjar -H '$_WEB_BROWSER_USER_AGENT' \
--data "CWfp=$(getCWfp)" \
--data "searchCaseID=$(getCaseID)" \
--data "searchID=$(getSearchId)" \
--data 'previewFilter=' \
--data 'sc_obj=list_d%7C0~10~4~f' \
--data 'srr=2' \
--data 'isDiscussion=true' \
--data 'searchString=' \
--data 'folderPicker=All+Documents' \
--data 'selectedSearchFolderName=All+Documents' \
--data 'selectedSearchFolderId=ALL_DOCUMENTS' \
--data 'selectedSearchFolderReviewState=' \
--data 'actionPath=%2FselectDiscuss.do' \
--data 'browserNavDetect=2' \
--data 'searchType=basic' \
--data 'searchAction=' \
--data 'focusID=' \
--data 'searchRoute=2' \
--data 'previewFilter=' \
--data 'domainFlag=off' \
--data 'custodianFlag=off' \
--data 'recipientFlag=off' \
--data 'recipientAliasFlag=off' \
--data 'recipientDomainFlag=off' \
--data 'individualFlag=off' \
--data 'individualAliasFlag=off' \
--data 'departmentFlag=off' \
--data 'projectsFlag=off' \
--data 'queriesFlag=off' \
--data 'subqueriesFlag=off' \
--data 'predictionFlag=off' \
--data 'tagzFlag=off' \
--data 'tagTypeFlag=' \
--data 'docTypeFlag=off' \
--data 'fileTypeFlag=off' \
--data 'fileSizeFlag=off' \
--data 'languageFlag=off' \
--data 'emailWarningFlag=off' \
--data 'fileWarningFlag=off' \
--data 'exportErrorFlag=off' \
--data 'productionSlipsheetFlag=off' \
--data 'filtersAuto=auto' \
--data 'domainProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'custodianProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientAliasProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientDomainProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'individualProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'individualAliasProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'departmentProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'projectsProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'queriesProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'predictionProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'tagzProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'docTypeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileTypeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileSizeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'languageProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'emailWarningProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileWarningProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'exportErrorProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'productionSlipsheetProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'searchesProps=%7B%22searches_2%22%3A%7B%22start%22%3A0%2C%22open%22%3A%22t%22%7D%2C%22searches_1%22%3A%7B%22start%22%3A0%7D%2C%22searches_3%22%3A%7B%22start%22%3A0%7D%7D' \
--data 'searchesSelection=%7B%22searches_2%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%2C%22searches_1%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%2C%22searches_3%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%7D' \
--data 'scrollX=0' \
--data 'scrollY=0' \
--data 'filterSelectionString=' \
--data 'filterAppliedString=' \
--data 'pgLinksCurPage=0' \
--data 'exportCustodianSelection=' \
--data 'print_scope=print_sel' \
--data 'print_fmt=pdf' \
--data 'print_out=zip' \
--data 'inc_summary=inc_summary' \
--data 'inc_docids=inc_docids' \
--data 'inc_files=inc_files' \
--data 'startNum=1' \
--data 'parentFolderSource=new' \
--data 'newFolderName=' \
--data 'ext-comp-1034=Search+for+folders+by+name+%28e.g.+%22Batch*%22%29' \
--data 'batchFolderPrefix=' \
--data 'batchMethod=batchByBatchCount' \
--data 'batchBatchCount=' \
--data 'batchDocCount=' \
--data 'batchThreadsTogether=batchThreadsTogether' \
--data 'batchAllThreadDocs=batchAllThreadDocs' \
--data 'batchPriority=priorityThread' \
--data 'includeSearchResults=true' \
--data 'cacheMessages=true' \
--data 'cacheHtml=true' \
--data 'retryErrored=true' \
--data 'timeout=none' \
--data 'reviewAcceleratorDatePicker=' \
--data 'ocrLabel=' \
--data 'documentsToOCR=Selected+items+%280%29' \
--data 'ocrFileExtension-BMP=on' \
--data 'ocrFileExtension-DCX=on' \
--data 'ocrFileExtension-DJVU=on' \
--data 'ocrFileExtension-GIF=on' \
--data 'ocrFileExtension-JPEG=on' \
--data 'ocrFileExtension-PCX=on' \
--data 'ocrFileExtension-PDF=on' \
--data 'ocrFileExtension-PNG=on' \
--data 'ocrFileExtension-TIFF=on' \
--data 'ocrFileExtension-WDP=on' \
--data 'ocrFileExtension-XPS=on' \
--data 'ocrMinSize=10' \
--data 'ocrMaxSize=51200' \
--data 'ocrDictionary=English+only' \
--location --output loadDiscussionsPage.html http://${_CW_SERVER}/esa/selectDiscuss.do

	debugLog "Waiting 30 seconds for the Discussions page to load..."
	sleep 30s
}


# Change the discussions-per-page size.
#
function changeDiscussionsPageSize()
{
	local _page_size=$1
	
	setDiscussionsPageSize $_page_size
	
	curl -s --cookie cjar --cookie-jar cjar -H '$_WEB_BROWSER_USER_AGENT' \
--data "rowsPerPage=${_page_size}" \
--data "CWfp=$(getCWfp)" \
--data "searchCaseID=$(getCaseID)" \
--data "searchID=$(getSearchId)" \
--data 'sc_obj=list_m%7C0~10~4~f' \
--data 'srr=1' \
--data 'pgCtrl=t' \
--data 'bufLoad=t' \
--data 'searchString=' \
--data 'folderPicker=All+Documents' \
--data 'selectedSearchFolderName=All+Documents' \
--data 'selectedSearchFolderId=ALL_DOCUMENTS' \
--data 'selectedSearchFolderReviewState=' \
--data 'actionPath=%2FsearchPage.do' \
--data 'browserNavDetect=2' \
--data 'searchType=basic' \
--data 'searchAction=' \
--data 'focusID=' \
--data 'searchRoute=1' \
--data 'previewFilter=' \
--data 'domainFlag=off' \
--data 'custodianFlag=off' \
--data 'recipientFlag=off' \
--data 'recipientAliasFlag=off' \
--data 'recipientDomainFlag=off' \
--data 'individualFlag=off' \
--data 'individualAliasFlag=off' \
--data 'departmentFlag=off' \
--data 'projectsFlag=off' \
--data 'queriesFlag=off' \
--data 'subqueriesFlag=off' \
--data 'predictionFlag=off' \
--data 'tagzFlag=off' \
--data 'tagTypeFlag=' \
--data 'docTypeFlag=off' \
--data 'fileTypeFlag=off' \
--data 'fileSizeFlag=off' \
--data 'languageFlag=off' \
--data 'emailWarningFlag=off' \
--data 'fileWarningFlag=off' \
--data 'exportErrorFlag=off' \
--data 'productionSlipsheetFlag=off' \
--data 'filtersAuto=auto' \
--data 'domainProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'custodianProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientAliasProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientDomainProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'individualProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'individualAliasProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'departmentProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'projectsProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'queriesProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'predictionProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'tagzProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'docTypeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileTypeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileSizeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'languageProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'emailWarningProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileWarningProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'exportErrorProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'productionSlipsheetProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'searchesProps=%7B%22searches_4%22%3A%7B%22start%22%3A0%2C%22open%22%3A%22t%22%7D%2C%22searches_1%22%3A%7B%22start%22%3A0%7D%2C%22searches_5%22%3A%7B%22start%22%3A0%7D%7D' \
--data 'searchesSelection=%7B%22searches_4%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%2C%22searches_1%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%2C%22searches_5%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%7D' \
--data 'scrollX=0' \
--data 'scrollY=0' \
--data 'filterSelectionString=' \
--data 'filterAppliedString=' \
--data 'exportCustodianSelection=' \
--data 'print_scope=print_sel' \
--data 'print_fmt=pdf' \
--data 'print_out=zip' \
--data 'inc_summary=inc_summary' \
--data 'inc_docids=inc_docids' \
--data 'inc_files=inc_files' \
--data 'startNum=1' \
--data 'parentFolderSource=new' \
--data 'newFolderName=' \
--data 'ext-comp-1040=Search+for+folders+by+name+%28e.g.+%22Batch*%22%29' \
--data 'batchFolderPrefix=' \
--data 'batchMethod=batchByBatchCount' \
--data 'batchBatchCount=' \
--data 'batchDocCount=' \
--data 'batchThreadsTogether=batchThreadsTogether' \
--data 'batchAllThreadDocs=batchAllThreadDocs' \
--data 'batchPriority=priorityThread' \
--data 'includeSearchResults=true' \
--data 'cacheMessages=true' \
--data 'cacheHtml=true' \
--data 'retryErrored=true' \
--data 'timeout=none' \
--data 'reviewAcceleratorDatePicker=' \
--data 'ocrLabel=' \
--data 'documentsToOCR=Selected+items+%280%29' \
--data 'ocrFileExtension-BMP=on' \
--data 'ocrFileExtension-DCX=on' \
--data 'ocrFileExtension-DJVU=on' \
--data 'ocrFileExtension-GIF=on' \
--data 'ocrFileExtension-JPEG=on' \
--data 'ocrFileExtension-PCX=on' \
--data 'ocrFileExtension-PDF=on' \
--data 'ocrFileExtension-PNG=on' \
--data 'ocrFileExtension-TIFF=on' \
--data 'ocrFileExtension-WDP=on' \
--data 'ocrFileExtension-XPS=on' \
--data 'ocrMinSize=10' \
--data 'ocrMaxSize=51200' \
--data 'ocrDictionary=English+only' \
--data 'pgLinksCurPage=0' \
--location --output changeDiscussionsPageSize.html http://${_CW_SERVER}/esa/searchList.do

	debugLog "Waiting 30 seconds for the Discussions page to reload..."
	sleep 30s
}


# Determine the total number of Discussions. 
#
function getDiscussionsCount()
{
	# Look for something like this in the loadDiscussionsPage.html file:
	# class="sl_counter_complete">222</span> Discussions</a><img
	# Note the use of "tr -d '\r'" to remove the trailing '\r' added by sed.
	local _number_of_discussions=$(sed -n 's#^.*class="sl_counter_complete">\([0-9][0-9]*[^<]*\)</span> Discussions</a><img#\1#p' loadDiscussionsPage.html | tr -d '\r')
	echo $_number_of_discussions
}


# Return the number of Discussions displayed per page.
#
function getDiscussionsPageSize()
{
	echo $_DISCUSSIONS_PER_PAGE
}

# Update the variable indicating the number of Discussions displayed per page.
#
function setDiscussionsPageSize()
{
	_DISCUSSIONS_PER_PAGE=$1
}


# Calculate the number of pages of Discussions.
#
function getDiscussionsPageCount()
{
	local _number_of_discussions=$(getDiscussionsCount)
	local _discussion_page_size=$(getDiscussionsPageSize)
	local _number_of_discussion_pages=$(expr $_number_of_discussions / $_discussion_page_size)
	if [ $(expr $_number_of_discussions % $_discussion_page_size) -gt 0 ]; then
		let _number_of_discussion_pages=_number_of_discussion_pages+1
	fi
	echo $_number_of_discussion_pages
}


# Request a report for the specified Discussion thread id.
#
# Setting "zip=n" prevents a report zip being created in the pickup window.
# Instead of zip, the report files end up under the "fileManager" directory, e.g.:
# D:\CW\V811R1\data\esadb\dataStore_case_a8e6sowft3_52381034\fileManager\0.14.7.21\jobRun_250\CSV_EXPORT_CONTENT
# QUESTION: Is this preferrable to having a zip file in the job pickup window?
#
function generateSingleDiscussionReport()
{
	local _thread_id=$1
	local _thread_name=$2

	curl -s --cookie cjar --cookie-jar cjar -H '$_WEB_BROWSER_USER_AGENT' \
--data "CWfp=$(getCWfp)" \
--data "searchCaseID=$(getCaseID)" \
--data "sc_obj=d~${_thread_id}!idx%2C0" \
--data "searchID=$(getSearchId)" \
--data 'jsCB=no' \
--data 'previewFilter=' \
--data 'srr=3' \
--data 's=all' \
--data 'incTags=n' \
--data 'incTagEventComments=n' \
--data 'incFolders=n' \
--data 'incDocumentNotes=n' \
--data 'fmt=csv' \
--data 'pageNum=n' \
--data 'zip=n' \
--data 'incSummary=y' \
--data 'incAttach=y' \
--data 'incDocIds=y' \
--data 'maxLoc=' \
--data 'pdfPerDocFamily=n' \
--data 'userSelectedDestinationId=' \
--data 'batchLabel=' \
--location --output generateSingleDiscussionReport_${_thread_id}.html http://${_CW_SERVER}/esa/printDiscussionMsgs.do

	# Wait for report to be requested.
	sleep 15s
}

# Load a single Discussion thread.
#
function loadSingleDiscussionThread()
{	
	local _thread_id=$1
	local _thread_name=$2
	
	curl -s --cookie cjar --cookie-jar cjar -H '$_WEB_BROWSER_USER_AGENT' \
--data "CWfp=$(getCWfp)" \
--data "searchCaseID=$(getCaseID)" \
--data "threadID=${_thread_id}" \
--data "searchID=$(getSearchId)" \
--data 'inclThreadLinks=true' \
--data 'isDiscussion=true' \
--data 'searchString=' \
--data 'folderPicker=All+Documents' \
--data 'selectedSearchFolderName=All+Documents' \
--data 'selectedSearchFolderId=ALL_DOCUMENTS' \
--data 'selectedSearchFolderReviewState=' \
--data 'actionPath=%2FselectDiscuss.do' \
--data 'browserNavDetect=2' \
--data 'searchType=basic' \
--data 'searchAction=' \
--data 'focusID=' \
--data 'searchRoute=3' \
--data 'previewFilter=' \
--data 'domainFlag=off' \
--data 'custodianFlag=off' \
--data 'recipientFlag=off' \
--data 'recipientAliasFlag=off' \
--data 'recipientDomainFlag=off' \
--data 'individualFlag=off' \
--data 'individualAliasFlag=off' \
--data 'departmentFlag=off' \
--data 'projectsFlag=off' \
--data 'queriesFlag=off' \
--data 'subqueriesFlag=off' \
--data 'predictionFlag=off' \
--data 'tagzFlag=off' \
--data 'tagTypeFlag=' \
--data 'docTypeFlag=off' \
--data 'fileTypeFlag=off' \
--data 'fileSizeFlag=off' \
--data 'languageFlag=off' \
--data 'emailWarningFlag=off' \
--data 'fileWarningFlag=off' \
--data 'exportErrorFlag=off' \
--data 'productionSlipsheetFlag=off' \
--data 'filtersAuto=auto' \
--data 'domainProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'custodianProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientAliasProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientDomainProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'individualProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'individualAliasProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'departmentProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'projectsProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'queriesProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'predictionProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'tagzProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'docTypeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileTypeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileSizeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'languageProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'emailWarningProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileWarningProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'exportErrorProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'productionSlipsheetProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'searchesProps=%7B%22searches_4%22%3A%7B%22start%22%3A0%2C%22open%22%3A%22t%22%7D%2C%22searches_1%22%3A%7B%22start%22%3A0%7D%2C%22searches_5%22%3A%7B%22start%22%3A0%7D%7D' \
--data 'searchesSelection=%7B%22searches_4%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%2C%22searches_1%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%2C%22searches_5%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%7D' \
--data 'scrollX=0' \
--data 'scrollY=0' \
--data 'filterSelectionString=' \
--data 'filterAppliedString=' \
--data 'pgLinksCurPage=0' \
--data 'exportCustodianSelection=' \
--data 'print_scope=print_sel' \
--data 'print_fmt=pdf' \
--data 'print_out=zip' \
--data 'inc_summary=inc_summary' \
--data 'inc_docids=inc_docids' \
--data 'inc_files=inc_files' \
--data 'startNum=1' \
--data 'parentFolderSource=new' \
--data 'newFolderName=' \
--data 'ext-comp-1033=Search+for+folders+by+name+%28e.g.+%22Batch*%22%29' \
--data 'batchFolderPrefix=' \
--data 'batchMethod=batchByBatchCount' \
--data 'batchBatchCount=' \
--data 'batchDocCount=' \
--data 'batchThreadsTogether=batchThreadsTogether' \
--data 'batchAllThreadDocs=batchAllThreadDocs' \
--data 'batchPriority=priorityThread' \
--data 'includeSearchResults=true' \
--data 'cacheMessages=true' \
--data 'cacheHtml=true' \
--data 'retryErrored=true' \
--data 'timeout=none' \
--data 'reviewAcceleratorDatePicker=' \
--data 'ocrLabel=' \
--data 'documentsToOCR=Selected+items+%280%29' \
--data 'ocrFileExtension-BMP=on' \
--data 'ocrFileExtension-DCX=on' \
--data 'ocrFileExtension-DJVU=on' \
--data 'ocrFileExtension-GIF=on' \
--data 'ocrFileExtension-JPEG=on' \
--data 'ocrFileExtension-PCX=on' \
--data 'ocrFileExtension-PDF=on' \
--data 'ocrFileExtension-PNG=on' \
--data 'ocrFileExtension-TIFF=on' \
--data 'ocrFileExtension-WDP=on' \
--data 'ocrFileExtension-XPS=on' \
--data 'ocrMinSize=10' \
--data 'ocrMaxSize=51200' \
--data 'ocrDictionary=English+only' \
--data 'sc_obj=list_d%7C0%7E10%7E4%7Ef' \
--data 'srr=3' \
--location --output loadSingleDiscussionThread_${_thread_id}.html http://${_CW_SERVER}/esa/discussThread.do

	# Wait for discussion thread to load.
	sleep 30s
}


# Load a specified page of Discussions.
#
function loadPageOfDiscussions()
{
	local _page_number=$1	;# First page number is zero.
	
	local _rows_per_page=$(getDiscussionsPageSize)
	
	curl -s --cookie cjar --cookie-jar cjar -H '$_WEB_BROWSER_USER_AGENT' \
--data "CWfp=$(getCWfp)" \
--data "searchCaseID=$(getCaseID)" \
--data "page=$_page_number" \
--data "rowsPerPage=$_rows_per_page" \
--data "searchID=$(getSearchId)" \
--data 'previewFilter=' \
--data 'sc_obj=list_d%7C0~10~4~f' \
--data 'srr=4' \
--data 'pgCtrl=t' \
--data 'bufLoad=t' \
--data 'searchString=' \
--data 'folderPicker=All+Documents' \
--data 'selectedSearchFolderName=All+Documents' \
--data 'selectedSearchFolderId=ALL_DOCUMENTS' \
--data 'selectedSearchFolderReviewState=' \
--data 'actionPath=%2FselectDiscuss.do' \
--data 'browserNavDetect=2' \
--data 'searchType=basic' \
--data 'searchAction=' \
--data 'focusID=' \
--data 'searchRoute=4' \
--data 'previewFilter=' \
--data 'domainFlag=off' \
--data 'custodianFlag=off' \
--data 'recipientFlag=off' \
--data 'recipientAliasFlag=off' \
--data 'recipientDomainFlag=off' \
--data 'individualFlag=off' \
--data 'individualAliasFlag=off' \
--data 'departmentFlag=off' \
--data 'projectsFlag=off' \
--data 'queriesFlag=off' \
--data 'subqueriesFlag=off' \
--data 'predictionFlag=off' \
--data 'tagzFlag=off' \
--data 'tagTypeFlag=' \
--data 'docTypeFlag=off' \
--data 'fileTypeFlag=off' \
--data 'fileSizeFlag=off' \
--data 'languageFlag=off' \
--data 'emailWarningFlag=off' \
--data 'fileWarningFlag=off' \
--data 'exportErrorFlag=off' \
--data 'productionSlipsheetFlag=off' \
--data 'filtersAuto=auto' \
--data 'domainProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'custodianProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientAliasProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'recipientDomainProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'individualProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'individualAliasProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'departmentProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'projectsProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'queriesProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'predictionProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'tagzProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'docTypeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileTypeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileSizeProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'languageProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'emailWarningProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'fileWarningProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'exportErrorProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'productionSlipsheetProps=start%3A0%3Bpolarity%3Aneg%3BpolarityApplied%3Aneg' \
--data 'searchesProps=%7B%22searches_4%22%3A%7B%22start%22%3A0%2C%22open%22%3A%22t%22%7D%2C%22searches_1%22%3A%7B%22start%22%3A0%7D%2C%22searches_5%22%3A%7B%22start%22%3A0%7D%7D' \
--data 'searchesSelection=%7B%22searches_4%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%2C%22searches_1%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%2C%22searches_5%22%3A%7B%22polarity%22%3A%22pos%22%2C%22selected%22%3A%5B%5D%7D%7D' \
--data 'scrollX=0' \
--data 'scrollY=0' \
--data 'filterSelectionString=' \
--data 'filterAppliedString=' \
--data 'pgLinksCurPage=0' \
--data 'exportCustodianSelection=' \
--data 'print_scope=print_sel' \
--data 'print_fmt=pdf' \
--data 'print_out=zip' \
--data 'inc_summary=inc_summary' \
--data 'inc_docids=inc_docids' \
--data 'inc_files=inc_files' \
--data 'startNum=1' \
--data 'parentFolderSource=new' \
--data 'newFolderName=' \
--data 'ext-comp-1033=Search+for+folders+by+name+%28e.g.+%22Batch*%22%29' \
--data 'batchFolderPrefix=' \
--data 'batchMethod=batchByBatchCount' \
--data 'batchBatchCount=' \
--data 'batchDocCount=' \
--data 'batchThreadsTogether=batchThreadsTogether' \
--data 'batchAllThreadDocs=batchAllThreadDocs' \
--data 'batchPriority=priorityThread' \
--data 'includeSearchResults=true' \
--data 'cacheMessages=true' \
--data 'cacheHtml=true' \
--data 'retryErrored=true' \
--data 'timeout=none' \
--data 'reviewAcceleratorDatePicker=' \
--data 'ocrLabel=' \
--data 'documentsToOCR=Selected+items+%280%29' \
--data 'ocrFileExtension-BMP=on' \
--data 'ocrFileExtension-DCX=on' \
--data 'ocrFileExtension-DJVU=on' \
--data 'ocrFileExtension-GIF=on' \
--data 'ocrFileExtension-JPEG=on' \
--data 'ocrFileExtension-PCX=on' \
--data 'ocrFileExtension-PDF=on' \
--data 'ocrFileExtension-PNG=on' \
--data 'ocrFileExtension-TIFF=on' \
--data 'ocrFileExtension-WDP=on' \
--data 'ocrFileExtension-XPS=on' \
--data 'ocrMinSize=10' \
--data 'ocrMaxSize=51200' \
--data 'ocrDictionary=English+only' \
--location --output loadPageOfDiscussions_page${_page_number}.html http://${_CW_SERVER}/esa/discuss.do

	# Wait for page load to complete.
	sleep 30s
}


# Extract the thread ids and names from the current loaded page of Discussions. 
#
function extractDiscussionsFromPage() 
{
	local _page_number=$1
	# Extract the discussion thread names and thread id.
	# Extraction this information from lines in dicussions.html that look like this:
	# <td style="word-wrap:break-word"><script>writeDiscussionLink('2533304855166982', 'Project Veneer', false, true)</script></td> 
	# Lets generate a file of format: <thread-id>|<discussion-name>
	sed -n "s/^.*writeDiscussionLink('\([0-9][0-9][^']*\)', '\([^']*\)'.*$/\1|\2/p" loadPageOfDiscussions_page${_page_number}.html > discussions_page${_page_number}.txt
}


# Generate a report for each Discussion on the specified page.
#
function generateDiscussionReportsForPage()
{
	local _page_number=$1
	
	loadPageOfDiscussions "$_page_number"
	extractDiscussionsFromPage $_page_number
	
	local _thread_id
	local _thread_name
	IFS='|'
	while read -r _thread_id _thread_name
	do
		echo "Generating Discussion report for $_thread_id ($_thread_name) ..."
		loadSingleDiscussionThread "$_thread_id" "$_thread_name"
		generateSingleDiscussionReport "$_thread_id" "$_thread_name"
		
	done < discussions_page${_page_number}.txt
}
