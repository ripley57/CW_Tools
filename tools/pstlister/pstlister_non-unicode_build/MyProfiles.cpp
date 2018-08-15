/*
** Description:
**	List basic email details in a PST file.
**
** Example output:
**	pstlister.exe d:\generated.pst
**	PR_CREATION_TIME: 17827337337823036163,PR_SUBJECT: This is a test email.,FOLDER: \Top of Outlook data file\myfoldername
**
** JeremyC 03-06-2017
*/

#include <tchar.h>	
#include <assert.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <mapix.h>
#include <mspst.h>
#include <mapiutil.h>
#include <strsafe.h>

using namespace std;

HRESULT CreateProfile(char *profilename, char *pstfile, char *password);
HRESULT DeleteProfile(char *profilename);
HRESULT ListEmails(FILE* fp, char* profilename);
HRESULT FindDefaultMsgStore(LPMAPISESSION lpSession, ULONG* lpcbeid, LPENTRYID* lppeid);
HRESULT ListFolderEmails(FILE* fp, SRow row, LPMDB lpMdb, string folderpath);
string convertFILETIMEtoUTC(FILETIME ft, int displayMSonly);
FILE* createOutputFile();
void writeEmail(FILE* fp, string creationtimeMS, string creationtimeStr, string subject, string folderpath);
void writeEmailW(FILE* fp, wstring creationtimeMS, wstring creationtimeStr, wstring subject, wstring folderpath);
string trimleft(string str);
string trimright(string str);
string trim(string str);
string removefileextension(const std::string& filename);
string convert2hex(HRESULT hRes);

// Display email subject using Unicode property.
int gUnicode = 0;

// Logging.
int gDebug = 0;	// Set to 1 to see verbose logging.
#define Log(x)	{if (gDebug) {stringstream ss; ss << x; cout << ss.str() << endl;}}

// Output UNICODE file.
// NOTE: We need to write to an output file, because the Windows
//       command prompt displays foreign characters as '?' chars.
string gOutputFileName = "output.csv";

wstring string2wstring(const string& s)
{
    wstring temp(s.length(),L' ');
    std::copy(s.begin(), s.end(), temp.begin());
    return temp; 
}

FILE* createOutputFile(string outputFileName)
{
	FILE* fp = fopen(outputFileName.c_str(), "wb");
	if (gUnicode)
		fwprintf(fp, L"%ws\r\n", L"PR_CREATION_TIME (ms),PR_CREATION_TIME (string),PR_SUBJECT, FOLDER");
	else 
		fprintf(fp,   "%s\r\n",   "PR_CREATION_TIME (ms),PR_CREATION_TIME (string),PR_SUBJECT, FOLDER");
	return fp;
}
void closeOutputFile(FILE* fp)
{
	fclose(fp);
}

void writeEmail(FILE* fp, string creationtimeMS, string creationtimeStr, string subject, string folderpath)
{
	//fprintf(fp,"%s\n", subject.c_str());
	fprintf(fp,"%s,%s,%s,%s\r\n", creationtimeMS.c_str(), creationtimeStr.c_str(), subject.c_str(), folderpath.c_str());
}
void writeEmailW(FILE* fp, wstring creationtimeMS, wstring creationtimeStr, wstring subject, wstring folderpath)
{
	//fwprintf(fp,L"%ws\n", subject.c_str());
	fwprintf(fp,L"%ws,%ws,%ws,%ws\r\n", creationtimeMS.c_str(), creationtimeStr.c_str(), subject.c_str(), folderpath.c_str());
}

string trimright(string str)
{
	size_t endpos = str.find_last_not_of(" \t");
	if(string::npos != endpos) str = str.substr(0, endpos+1);
	return str;
}

string trimleft(string str)
{
	size_t startpos = str.find_first_not_of(" \t\\");
	if(string::npos != startpos) str = str.substr( startpos );
	return str;
}

string trim(string str)
{
	return trimleft(trimright(str));
}

string removefileextension(const std::string& filename) {
    size_t lastdot = filename.find_last_of(".");
    if (lastdot == std::string::npos) return filename;
    return filename.substr(0, lastdot); 
}

string convertFILETIMEtoUTC(FILETIME ft, int displayMSonly)
{
	// Convert to ULONGLONG.
	ULONGLONG qwResult;
    qwResult = (((ULONGLONG) ft.dwHighDateTime) << 32) + ft.dwLowDateTime;
	
	// Subtract Offset between January 1, 1601 UTC and midnight January 1, 1970 UTC 
    // in 100 ns intervals.
    qwResult -= 116444736000000000;
	
    // Truncate to milliseconds
    qwResult = qwResult / 10000;

	char buf[128];
	SYSTEMTIME st_utc;
	if (FileTimeToSystemTime(&ft, &st_utc) != 0) {
		if (displayMSonly) {
			sprintf(buf, "%llu", qwResult);
		} else {
			sprintf(buf, "%02d/%02d/%04d %02d:%02d:%02d UTC", 
			st_utc.wDay,  st_utc.wMonth,  st_utc.wYear, 
			st_utc.wHour, st_utc.wMinute, st_utc.wSecond,
			qwResult);
		}
	} else {
		sprintf(buf, "");
	}
	return string(buf);
}

string convert2hex(HRESULT hRes)
{
	stringstream ss;
	ss << std::hex << hRes;
	return ss.str();
}

#if 0
wstring cstr2wstring(char *text)
{
	int			len		= 0;
	wchar_t		*retVal	= NULL;

	if(text == NULL)
		return(NULL);
	len = strlen(text);
	retVal = (wchar_t *)calloc(len+1, sizeof(wchar_t));
	MultiByteToWideChar(CP_ACP, 0, text, -1, retVal, len);
	wstring ret = wstring(retVal);
	delete retVal;
	return ret;
}
#endif


////////// START: Smart wrapper classes to automatically free MAPI reasources.
class MapiResource
{
public:
	MapiResource(IUnknown *res) : m_res(res) {}
	~MapiResource(void) { UlRelease(m_res); }
private:
	IUnknown *m_res;
};

class MapiTableRowsResource
{
public:
	MapiTableRowsResource(SRowSet *prows) : m_prows(prows) {}
	~MapiTableRowsResource(void) { FreeProws(m_prows); }
private:
	SRowSet *m_prows;
};

class MapiSessionResource
{
public:
	MapiSessionResource(IMAPISession *isession) : m_isession(isession) {}
	~MapiSessionResource(void) {
		if (m_isession)
			m_isession->Logoff(0, 0, 0);
		UlRelease(m_isession);
	}
private:
	IMAPISession *m_isession;
};

class MapiBufferResource
{
public:
	MapiBufferResource(void *buffer) : m_buffer(buffer) {}
	~MapiBufferResource(void) { MAPIFreeBuffer(m_buffer); }
private:
	void *m_buffer;
};
////////// START: Smart wrapper classes to automatically free MAPI reasources.


void usage(string progname, string profilename)
{
	fprintf(stderr, "                                                        \n");
	fprintf(stderr, "%s                                                      \n", progname.c_str());
	fprintf(stderr, "                                                        \n");
	fprintf(stderr, "Usage:                                                  \n");
	fprintf(stderr, "    %s [<pstfile> [-p] [-v]] | [-d [-v]] | [-h]         \n", progname.c_str());
	fprintf(stderr, "                                                        \n");
	fprintf(stderr, "Where:                                                  \n");
	fprintf(stderr, "    -v                 Verbose logging.                 \n");
	fprintf(stderr, "    -p                 Create profile \"%s\" only.      \n", profilename.c_str());
	fprintf(stderr, "    -d                 Delete profile \"%s\" only.      \n", profilename.c_str());
	fprintf(stderr, "    -h                 Display this help information.   \n");
	fprintf(stderr, "    -u                 Display subject in Unicode.      \n");
	fprintf(stderr, "                                                        \n");
	fprintf(stderr, "Examples:                                               \n");
	fprintf(stderr, "    %s D:\\generated.pst                                \n", progname.c_str());
	fprintf(stderr, "    %s D:\\generated.pst -v                             \n", progname.c_str());
	fprintf(stderr, "    %s -d                                               \n", progname.c_str());
	fprintf(stderr, "    %s D:\\generated.pst -p                             \n", progname.c_str());
}

int _tmain(int argc, _TCHAR* argv[])
{
	string 	profilename		= "PSTLister";	// This is the name you will see listed in mlcfg32.
	string	pstfile			= "undefined";
	int 	createProfile 	= 1;
	int		listEmails		= 1;
	int 	deleteProfile 	= 1;
	int     requirepstfile 	= 1;
	
	string progname = string(argv[0]);
	
	for (int i=1; i<argc; i++) {
		string s = argv[i];
		
		if (s == "-h" || s == "/?") {
			usage(progname, profilename);
			exit(0);
		}
		
		if (s == "-v") 
			gDebug = 1;
		else 
		if (s == "-u")
			gUnicode = 1;
		else
		if (s == "-p") {
			// Create profile only.
			createProfile	= 1;
			listEmails 		= 0;
			deleteProfile 	= 0;
		}
		else 
		if (s == "-d") {
			// Delete existing profile only.
			createProfile 	= 0;
			listEmails 		= 0;
			deleteProfile 	= 1;
			requirepstfile 	= 0;
		}
		else {
			pstfile = s;
			ifstream infile(pstfile);
			if (!infile.good()) {
				cerr << "ERROR: Could not open file: " << pstfile << endl;
				exit(1);
			}
		}
	}
	
	if (requirepstfile && pstfile == "undefined") {
		cerr << "ERROR: Bad arguments." << endl;
		usage(progname, profilename);
		exit(1);
	}

	// Start of main program logic here.
	
	HRESULT hRes = MAPIInitialize(0);
	if (FAILED(hRes)) {
		cerr << "MAPIInitialize: Failed with error: " << convert2hex(hRes) << endl;
		exit(1);
	}
	
	if (createProfile) {
		hRes = CreateProfile((char*)profilename.c_str(), (char*)pstfile.c_str(), (char*)NULL);
		if (FAILED(hRes)) {
			cerr << "ERROR: Could not create profile \"" << profilename << "\". ";
			if (hRes == MAPI_E_NO_ACCESS /* 80070005 */)
				cerr << "Profile already exists." << endl;
			else 
				cerr << "Error: " << convert2hex(hRes) << endl;
			MAPIUninitialize();
			exit(1);
		}
		if (!listEmails) 
			cerr << "Successfully created profile \"" << profilename << "\"." << endl;
	}
	
	if (listEmails) {
		FILE* fp = createOutputFile(gOutputFileName);
		hRes = ListEmails(fp, (char*)profilename.c_str());
		if (FAILED(hRes)) {
			cerr << "ERROR: Could not list emails. Error: " << convert2hex(hRes) << endl;
			MAPIUninitialize();
			closeOutputFile(fp);
			exit(1);
		}
		closeOutputFile(fp);
	}
	
	if (deleteProfile) {
		hRes = DeleteProfile((char *)profilename.c_str());
		if (FAILED(hRes)) {
			cerr << "ERROR: Could not delete profile \"" << profilename << "\". ";
			if (hRes == MAPI_E_NOT_FOUND /* 8004010f */) 
				cerr << "Profile not found." << endl;
			else
				cerr << "Error: " << convert2hex(hRes) << endl;
			MAPIUninitialize();
			exit(1);
		}
		if (!listEmails) 
			cerr << "Successfully deleted profile \"" << profilename << "\"." << endl;
	}
	
	MAPIUninitialize();
	return hRes;
}

/*
** Other possibly useful reference material regarding creating a profile:
** https://support.microsoft.com/en-us/help/306962/how-to-create-mapi-profiles-without-installing-outlook
*/
HRESULT CreateProfile(char *profilename, char *pstfile, char *password)
{
	Log("Entering CreateProfile() ...");
	HRESULT hRes;

	IProfAdmin	*iProfAdmin = NULL;
	hRes = MAPIAdminProfiles(0, &iProfAdmin);
	if (FAILED(hRes))
		return hRes;
	MapiResource iProfAdminResource(iProfAdmin);

	Log("CreateProfile: Calling iProfAdmin::CreateProfile() ...");
	hRes = iProfAdmin->CreateProfile((LPTSTR)profilename, (LPTSTR)password,	0, 0);
	if (FAILED(hRes)) {
		Log("iProfAdmin::CreateProfile() failed with error: " << convert2hex(hRes));
		if (hRes == MAPI_E_NO_ACCESS)
			Log("iProfAdmin::CreateProfile() failed with MAPI_E_NO_ACCESS (" << convert2hex(hRes) << "). The profile already exists (" << profilename << ").");	
		return hRes;
	}
	
	IMsgServiceAdmin *pAdminServices = NULL;	
	Log("CreateProfile: Calling iProfAdmin::AdminServices() ...");
	hRes = iProfAdmin->AdminServices((LPTSTR)profilename, NULL,	NULL, 0, &pAdminServices);
	if (FAILED(hRes)) {
		Log("iProfAdmin::AdminServices() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	MapiResource pAdminServicesResource(pAdminServices);

	string servicename = "MSUPST MS" ;	
	Log("CreateProfile: Calling IMsgServiceAdmin::CreateMsgService() ...");
	hRes = pAdminServices->CreateMsgService((LPTSTR)servicename.c_str(), (LPSTR)NULL, NULL, NULL);
	if (FAILED(hRes)) {
		Log("IMsgServiceAdmin::CreateMsgService() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	
	LPMAPITABLE	pMTServices = NULL;
	Log("CreateProfile: Calling IMsgServiceAdmin::GetMsgServiceTable() ...");
	hRes = pAdminServices->GetMsgServiceTable(NULL, &pMTServices);
	if (FAILED(hRes)) {
		Log("IMsgServiceAdmin::GetMsgServiceTable() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	MapiResource pMTServicesResource(pMTServices);
		
	enum {
		ePR_DISPLAY_NAME,
		ePR_SERVICE_NAME,
		ePR_INSTANCE_KEY,
		ePR_SERVICE_UID,
		NUMCOLS
	};
	SizedSPropTagArray(NUMCOLS, Columns) =
	{ NUMCOLS,
		{	PR_DISPLAY_NAME,
			PR_SERVICE_NAME, 
			PR_INSTANCE_KEY,
			PR_SERVICE_UID
		}
	};
	Log("CreateProfile: Calling LPMAPITABLE:SetColumns() ...");
	hRes = pMTServices->SetColumns((LPSPropTagArray)&Columns, 0);
	if (FAILED(hRes)) {
		Log("LPMAPITABLE:SetColumns() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	
	// Define a restriction.
	SPropValue	 	SvcProps;
	SRestriction	sres;
	sres.rt = RES_CONTENT;
	sres.res.resContent.ulFuzzyLevel = FL_FULLSTRING;
	sres.res.resContent.ulPropTag = PR_SERVICE_NAME;
	sres.res.resContent.lpProp = &SvcProps;
	SvcProps.ulPropTag = PR_SERVICE_NAME;
	SvcProps.Value.lpszA = (LPTSTR)servicename.c_str();
	
	ULONG ulRowCount = 0;
	Log("CreateProfile: Calling LPMAPITABLE::GetRowCount() ...");
	hRes = pMTServices->GetRowCount(NULL, &ulRowCount);
	if (FAILED(hRes)) {
		Log("LPMAPITABLE::GetRowCount() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	
	// Get all rows.
	LPSRowSet lpRows = NULL;
	Log("CreateProfile: Calling LPMAPITABLE::QueryRows() ...");
	hRes = pMTServices->QueryRows(ulRowCount, 0, &lpRows);
	if (FAILED(hRes)) {
		Log("LPMAPITABLE::QueryRows() failed with erorr: " << convert2hex(hRes));
		return hRes;
	}
	MapiTableRowsResource mtServiceRowsResource(lpRows);
	
	// Define array of profile properties to configure.
	SPropValue rgval[3];
	int numProps = 0;
	rgval[numProps].ulPropTag = PR_PST_PATH;
	rgval[numProps++].Value.lpszA = (char *)pstfile;
	rgval[numProps].ulPropTag = PR_DISPLAY_NAME;
	rgval[numProps++].Value.lpszA = "PST Lister";	
	rgval[numProps].ulPropTag =	PR_PST_REMEMBER_PW;
	rgval[numProps++].Value.b =	TRUE;
	
	// Configure the message service with the properties.
	// NOTE: I've found that this will create the specified PST file if it does not already exist!
	Log("CreateProfile: Calling IMsgServiceAdmin::ConfigureMsgService() ...");
	hRes = pAdminServices->ConfigureMsgService((LPMAPIUID)lpRows->aRow->lpProps[ePR_SERVICE_UID].Value.bin.lpb, NULL, 0, numProps, rgval);
	if (FAILED(hRes)) {
		Log("IMsgServiceAdmin::ConfigureMsgService() failed with error: " << convert2hex(hRes));
		return hRes;
	}

	Log("Leaving CreateProfile() ...");
	return S_OK;
}

HRESULT DeleteProfile(char *profilename)
{
	Log("Entering DeleteProfile() ...");
	HRESULT hRes;
	
	IProfAdmin	*iProfAdmin = NULL;
	Log("DeleteProfile: Calling MAPIAdminProfiles() ...");
	hRes = MAPIAdminProfiles(0, &iProfAdmin);
	if (FAILED(hRes)) {
		Log("MAPIAdminProfiles() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	MapiResource iProfAdminResource(iProfAdmin);
	
	Log("DeleteProfile: Calling IProfAdmin::DeleteProfile() ...");
	hRes = iProfAdmin->DeleteProfile((LPTSTR)profilename, 0);
	if (FAILED(hRes)) {
		Log("IProfAdmin::DeleteProfile() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	
	Log("Leaving DeleteProfile() ...");
	return hRes;
}

HRESULT ListEmails(FILE* fp, char* profilename)
{
	Log("Entering ListEmails() ...");
	HRESULT hRes = S_OK;
	LPSRowSet   lpRows = NULL;
	ULONG       cRows = 0;
	LPENTRYID   lpeid = NULL;
    ULONG       cbeid = 0;
		
	IMAPISession *lpSession = NULL;
	Log("ListEmails: Calling MAPILogonEx() for profile " << profilename << " ...");
	hRes = MAPILogonEx(0, (LPSTR)profilename, NULL,	MAPI_NEW_SESSION | MAPI_EXTENDED | MAPI_NO_MAIL | MAPI_EXPLICIT_PROFILE, &lpSession);
	if (FAILED(hRes)) {
		Log("MAPILogonEx() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	MapiSessionResource sessResource(lpSession);
	
    ULONG		cbEid = 0;  
    LPENTRYID	lpEid = NULL;
	Log("ListEmails: Calling FindDefaultMsgStore() ...");
    hRes = FindDefaultMsgStore(lpSession, &cbEid, &lpEid); 
    if (FAILED(hRes)) {
		Log("FindDefaultMsgStore() failed with error: " << convert2hex(hRes));
        return hRes;
	}
	MapiBufferResource lpEidBufferRes(lpEid);
	
	LPMDB lpMdb = NULL;
	Log("ListEmails: Calling IMAPISession::OpenMsgStore() ...");
	hRes = lpSession->OpenMsgStore(0, cbEid, lpEid, NULL, MDB_WRITE | MAPI_DEFERRED_ERRORS | MDB_NO_DIALOG, &lpMdb);
	if (FAILED(hRes)) {
		Log("IMAPISession::OpenMsgStore() failed with error: " << convert2hex(hRes));
	    return (hRes);
	}
	MapiResource lpMdbResource((IUnknown*)lpMdb);
	
	// Open the root folder in the msg store (i.e. in the pst file).
    ULONG			ulObjType = 0;
	LPMAPIFOLDER    lpRootFolder = NULL;
	Log("ListEmails: Calling LPMDB::OpenEntry() ...");
	hRes = lpMdb->OpenEntry(0, NULL, NULL, MAPI_MODIFY|MAPI_DEFERRED_ERRORS, &ulObjType, (LPUNKNOWN *)&lpRootFolder);
	if (FAILED(hRes)) {
		Log("LPMDB::OpenEntry() failed with error: " << convert2hex(hRes));
		return (hRes);
	}
	MapiResource lpRootFolderResource(lpRootFolder);
	if (ulObjType != MAPI_FOLDER) {
		Log("ListEmails: Could not open root folder.");
		hRes = MAPI_E_INVALID_OBJECT;
		return (hRes);
	}
	
	LPMAPITABLE lpHierarchyTable = NULL;
	Log("ListEmails: Calling LPMAPIFOLDER::GetHierarchyTable() ...");
	hRes = lpRootFolder->GetHierarchyTable(MAPI_DEFERRED_ERRORS, &lpHierarchyTable);
	if (FAILED(hRes)) {
		Log("LPMAPITABLE::GetHierarchyTable() failed with error: " << convert2hex(hRes));
		Log("MAPI_E_BAD_CHARWIDTH=" << convert2hex(MAPI_E_BAD_CHARWIDTH));
		Log("MAPI_E_NO_SUPPORT=" << convert2hex(MAPI_E_NO_SUPPORT));
		return (hRes);
	}
	MapiResource lpHierarchyTableResource(lpHierarchyTable);
	
	enum { 
		ePR_ENTRYID,
		ePR_DISPLAY_NAME
	};
	SizedSPropTagArray(2, tableProps) = {
		2,
		{
			PR_ENTRYID,
			PR_DISPLAY_NAME
		}
	};
	Log("ListEmails: Calling LPMAPIFOLDER::SetColumns() ...");
	hRes = lpHierarchyTable->SetColumns((LPSPropTagArray)&tableProps, 0);
	if (FAILED(hRes)) {
		Log("LPMAPITABLE::SetColumns() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	
	// Go to  beginning of table.
	Log("ListEmails: Calling LPMAPITABLE::SeekRow() ...");
    hRes = lpHierarchyTable->SeekRow(BOOKMARK_BEGINNING, 0, NULL);
    if(FAILED(hRes)) {
		Log("LPMAPITABLE::SeekRow() failed with error: " << convert2hex(hRes));
        return hRes;
	}

	// Get row count.
	Log("ListEmails: Calling LPMAPITABLE::GetRowCount() ...");
	hRes = lpHierarchyTable->GetRowCount(0, &cRows);
    if(FAILED(hRes)) {
		Log("LPMAPITABLE::GetRowCount() failed with error: " << convert2hex(hRes));
        return hRes;
	}
	
	// Read all the rows.
	Log("ListEmails: Calling LPMAPITABLE::QueryRows() ...");
    hRes = lpHierarchyTable->QueryRows(cRows, 0, &lpRows);
    if(FAILED(hRes)) {
		Log("LPMAPITABLE::QueryRows() failed with error: " << convert2hex(hRes));
		return hRes;
    }
	MapiTableRowsResource tableRowsResource(lpRows);
	Log("LPMAPITABLE::QueryRows() lpRows->cRows=" << lpRows->cRows);
	
	// Recursively display the contents of the top-level folders.
	string folderpath = "";
	ULONG i = 0;
	for (i = 0; i < cRows; i++)
		ListFolderEmails(fp, lpRows->aRow[i], lpMdb, folderpath);

	Log("Leaving ListEmails() ...");
	return hRes;
}

HRESULT ListFolderEmails(FILE* fp, SRow row, LPMDB lpMdb, string folderpath)
{
	Log("Entering ListFolderEmails() ...");
	HRESULT		hRes = S_OK;
	LPSRowSet	lpRows = NULL;
		
	assert(row.lpProps[0].ulPropTag == PR_ENTRYID);
	assert(row.lpProps[1].ulPropTag == PR_DISPLAY_NAME);
	
	// Construct full folder path.
	folderpath = folderpath + string("\\") + string(row.lpProps[1].Value.lpszA);	// PR_DISPLAY_NAME

	// Get the entryid for the passed folder.	
	ULONG		cbeid = 0;  
    LPENTRYID	lpeid = NULL;
    cbeid = row.lpProps[0].Value.bin.cb;
    MAPIAllocateBuffer(cbeid, (void **)&lpeid);
    CopyMemory(lpeid, row.lpProps[0].Value.bin.lpb, cbeid);
	MapiBufferResource lpEidResource(lpeid);

	// Open the folder.
    ULONG			ulObjType = 0;
	LPMAPIFOLDER    lpFolder = NULL;
	hRes = lpMdb->OpenEntry(cbeid, lpeid, NULL, MAPI_MODIFY|MAPI_DEFERRED_ERRORS, &ulObjType, (LPUNKNOWN *)&lpFolder);
	if (FAILED(hRes)) {
		Log("LPMDB::OpenEntry() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	MapiResource lpFolderResource(lpFolder);

	// Process any messages in the folder.
	LPMAPITABLE	lpMessagesTable = NULL;
	hRes = lpFolder->GetContentsTable(MAPI_DEFERRED_ERRORS, &lpMessagesTable);
	if (FAILED(hRes)) {
		Log("LPMAPIFOLDER::GetContentsTable() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	MapiResource lpTableResource(lpMessagesTable);
	
	enum { 
		ePR_ENTRYID,
		ePR_SUBJECT,
		ePR_SUBJECT_W,
		ePR_MESSAGE_CLASS,
		ePR_CREATION_TIME,
		NUMCOLS
	};
	SizedSPropTagArray(NUMCOLS, messageTableProps) = {
		NUMCOLS,
		{
			PR_ENTRYID,
			PR_SUBJECT,
			PR_SUBJECT_W,
			PR_MESSAGE_CLASS,
			PR_CREATION_TIME
		}
	};
	hRes = lpMessagesTable->SetColumns((LPSPropTagArray)&messageTableProps, 0);
	if (FAILED(hRes)) {
		Log("LPMAPITABLE::SetColumns() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	
	// Go to the first row.
	hRes = lpMessagesTable->SeekRow(BOOKMARK_BEGINNING,	0, NULL);
	if (FAILED(hRes)) {
		Log("LPMAPITABLE::SeekRow() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	
	// Display any emails present in this folder.
	for (;;) {
		lpRows = NULL;
		hRes = lpMessagesTable->QueryRows(1, NULL, &lpRows);
		if (FAILED(hRes)) {
			Log("LPMAPIFOLDER::QueryRows() failed with error: " << convert2hex(hRes));
			break;
		} 
		if (!lpRows || !lpRows->cRows) 
			break;
		MapiTableRowsResource lpRowsResource(lpRows);

		// Now we can process the row. This should be a single message.
		assert(lpRows->aRow[0].lpProps[ePR_ENTRYID].ulPropTag == PR_ENTRYID);
		assert(lpRows->aRow[0].lpProps[ePR_SUBJECT].ulPropTag == PR_SUBJECT);
		assert(lpRows->aRow[0].lpProps[ePR_SUBJECT_W].ulPropTag == PR_SUBJECT_W);
		assert(lpRows->aRow[0].lpProps[ePR_MESSAGE_CLASS].ulPropTag == PR_MESSAGE_CLASS);
		assert(lpRows->aRow[0].lpProps[ePR_CREATION_TIME].ulPropTag == PR_CREATION_TIME);
		
		// PR_CREATION_TIME
		FILETIME ft = lpRows->aRow[0].lpProps[ePR_CREATION_TIME].Value.ft;
		string creationtimeMS  = convertFILETIMEtoUTC(ft, 1);	// Miiliseconds format.	
		string creationtimeStr = convertFILETIMEtoUTC(ft, 0);	// Friendly string format.
		
		// PR_SUBJECT
		string  subject  = lpRows->aRow[0].lpProps[ePR_SUBJECT].Value.lpszA; 
		wstring subjectW = lpRows->aRow[0].lpProps[ePR_SUBJECT_W].Value.lpszW; 
		
		if (gUnicode) 
			writeEmailW(fp, string2wstring(creationtimeMS), string2wstring(creationtimeStr), subjectW, string2wstring(folderpath));
		else 
			writeEmail(fp, creationtimeMS, creationtimeStr, subject, folderpath);
	}
	
	// Process any sub-folders (i.e. containers) in this folder.
	LPMAPITABLE lpHierarchyTable = NULL;
	hRes = lpFolder->GetHierarchyTable(MAPI_DEFERRED_ERRORS, &lpHierarchyTable);
	if (FAILED(hRes)) {
		if (hRes == MAPI_E_NO_SUPPORT) { 
			// The container has no child containers and cannot provide a hierarchy table.
			Log("LPMAPIFOLDER::GetHierarchyTable() returned MAPI_E_NO_SUPPORT. Leaving ListFolderEmails() ...");
			return S_OK;
		}
		Log("LPMAPIFOLDER::GetHierarchyTable() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	MapiResource lpHierarchyTableResource(lpHierarchyTable);
		
	SizedSPropTagArray(2, tableProps2) = {
		2,
		{
			PR_ENTRYID,
			PR_DISPLAY_NAME
		}
	};
	hRes = lpHierarchyTable->SetColumns((LPSPropTagArray)&tableProps2, 0);
	if (FAILED(hRes)) {
		Log("LPMAPITABLE::SetColumns() failed with error: " << convert2hex(hRes));
		return hRes;
	}
	
	// Get row count.
	ULONG cRows = 0;
	hRes = lpHierarchyTable->GetRowCount(0, &cRows);
    if(FAILED(hRes)) {
		Log("LPMAPITABLE::GetRowCount() failed with error: " << convert2hex(hRes));
        return hRes;
	}
	if (cRows == 0) {
		Log("Empty Hierarchy table. Leaving ListFolderEmails() ...");
		return S_OK;
	}
	
	// Read all the rows.
    hRes = lpHierarchyTable->QueryRows(cRows, 0, &lpRows);
    if(FAILED(hRes)) {
		Log("LPMAPITABLE::QueryRows() failed with error: " << convert2hex(hRes));
		return hRes;
    }
	MapiTableRowsResource lpRowsResource(lpRows);
	
	// Recursion.
	ULONG i = 0;
	for (i = 0; i < cRows; i++)
		ListFolderEmails(fp, lpRows->aRow[i], lpMdb, folderpath);
		
	Log("Leaving ListFolderEmails() ...");
	return hRes;
}

HRESULT FindDefaultMsgStore(LPMAPISESSION lpSession, ULONG* lpcbeid, LPENTRYID* lppeid)
{
	Log("Entering FindDefaultMsgStore() ...");
	
	HRESULT		hr = NOERROR;
	SCODE       sc = 0;
    LPMAPITABLE lpTable = NULL;
	LPSRowSet   lpRows = NULL;
	LPENTRYID   lpeid = NULL;
    ULONG       cbeid = 0;
	ULONG       cRows = 0;
	ULONG       i = 0;
	
	SizedSPropTagArray(2, rgPropTagArray) =
    {
        2,
        {
            PR_DEFAULT_STORE,
            PR_ENTRYID
        }
    };
	
	// Get table of available MAPI message stores.
	Log("FindDefaultMsgStore: Calling LPMAPISESSION::GetMsgStoresTable() ...");
    hr = lpSession->GetMsgStoresTable(0, &lpTable);
    if(FAILED(hr)) {
		Log("LPMAPISESSION::GetMsgStoresTable() failed with error: " << convert2hex(hr));
		return (hr);
	}
	MapiResource tableResource(lpTable);
	
	Log("FindDefaultMsgStore: Calling LPMAPITABLE::GetRowCount() ...");
	hr = lpTable->GetRowCount(0, &cRows);
    if(FAILED(hr)) {
		Log("LPMAPITABLE::GetRowCount() failed with error: " << convert2hex(hr));
        return (hr);
	}

	// Set columns to return.
	Log("FindDefaultMsgStore: Calling LPMAPITABLE::SetColumns() ...");
    hr = lpTable->SetColumns((LPSPropTagArray)&rgPropTagArray, 0);
    if(FAILED(hr)) {
		Log("LPMAPITABLE::SetColumns() failed with error: " << convert2hex(hr));
        return (hr);
	}

	// Go to  beginning of table.
	Log("FindDefaultMsgStore: Calling LPMAPITABLE::SeekRow() ...");
    hr = lpTable->SeekRow(BOOKMARK_BEGINNING, 0, NULL);
    if(FAILED(hr)) {
		Log("LPMAPITABLE::SeekRow() failed with error: " << convert2hex(hr));
        return (hr);
	}

	// Read all the rows.
	Log("FindDefaultMsgStore: Calling LPMAPITABLE::QueryRows() ...");
    hr = lpTable->QueryRows(cRows, 0, &lpRows);
    if(SUCCEEDED(hr) && (lpRows != NULL) && (lpRows->cRows == 0)) {
		Log("LPMAPITABLE::QueryRows() returned 0 rows.");
        FreeProws(lpRows);
		lpRows = NULL;
		return (hr);
    }
	MapiTableRowsResource tableRowsResource(lpRows);
	Log("LPMAPITABLE::QueryRows() lpRows->cRows=" << lpRows->cRows);
	
	for (i = 0; i < cRows; i++) {
        if(lpRows->aRow[i].lpProps[0].Value.b == TRUE) {
            cbeid = lpRows->aRow[i].lpProps[1].Value.bin.cb;
            sc = MAPIAllocateBuffer(cbeid, (void **)&lpeid);
            if(FAILED(sc)) {
				Log("MAPIAllocateBuffer() failed with error: " << convert2hex(sc));
                cbeid = 0;
                lpeid = NULL;
			    hr = E_OUTOFMEMORY;
                return (hr);
            }
            // Copy entry ID of message store.
            CopyMemory(lpeid, lpRows->aRow[i].lpProps[1].Value.bin.lpb, cbeid);
            break;
        }
    }

    *lpcbeid = cbeid;
    *lppeid = lpeid;

	Log("Leaving FindDefaultMsgStore() ...");
    return (hr);
}