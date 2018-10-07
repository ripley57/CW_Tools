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

#define INITGUID
#include <objbase.h>

#define USES_IID_IMessage

#include <tchar.h>	
#include <assert.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <mapix.h>
#include <mspst.h>
#include <mapiutil.h>
#include <mapidefs.h>
#include <Imessage.h>
#include <strsafe.h>

#include "CommonDefines.h"
#include "SmartPointers.h"
#include "Utils.h"

using namespace std;

static HRESULT CreateProfile(tstring& profilename, tstring& pstfile, tstring& password);
static HRESULT DeleteProfile(tstring& profilename);
static HRESULT ListEmails(tstring& profilename);
static HRESULT FindDefaultMsgStore(LPMAPISESSION lpSession, ULONG* lpcbeid, LPENTRYID* lppeid);
static HRESULT ListFolderEmails(SRow row, LPMDB lpMdb, wstring folderpath);
static FILE* createOutputFile();
static void writeEmailW(wstring entryidStr, wstring creationtimeMS, wstring creationtimeStr, wstring subject, wstring folderpath);
static HRESULT SearchFolder(tstring& profilename, tstring& foldername, int createseachfolder, int deletesearchfolder);
static HRESULT exportEmail(LPMDB, SPropValue* eid);

// Output csv file.
// NOTE: We need to write to an output file, because the Windows
//       command prompt displays foreign characters as '?' chars.
FILE* fp = NULL;
tstring gOutputFileName = _T("output.csv");

// Logging.
#define Log(x)	{if (gDebug) {tstringstream ss; ss << x; tcout << ss.str() << endl;}}
int gDebug = 0;	// Set to 1 for verbose logging.

int gExport = 0; // Set to 1 export the messages as msg files.

FILE* createOutputFile()
{
	// Our writeEmailW() function writes UNICODE, so for 
	// clarity we should use _wfopen() instead of _tfopen().
	//fp = _tfopen(gOutputFileName.c_str(), _T("wb"));
	
	// The "ccs=UNICODE" argument ensures UNICODE bom is added (FEFF).
	// (See https://msdn.microsoft.com/en-us/library/yeby3zcb.aspx)
	// This ensures that Excel displays foreign characters correctly, including Japanese.
	// NOTE: The "b" from "wb" had to be removed for "ccs=UNICODE" to add the bom.
	fp = _wfopen(gOutputFileName.c_str(), L"w, ccs=UNICODE");
	if (fp)
		fwprintf(fp, L"PR_ENTRYID,PR_CREATION_TIME (ms),PR_CREATION_TIME (string),PR_SUBJECT, FOLDER\n");

	return fp;
}

void closeOutputFile()
{
	if (fp) fclose(fp);
}

void writeEmailW(wstring entryidStr, wstring creationtimeMS, wstring creationtimeStr, wstring subject, wstring folderpath)
{
	if (fp)
		fwprintf(fp, L"%ws,%ws,%ws,%ws,%ws\n", entryidStr.c_str(), creationtimeMS.c_str(), creationtimeStr.c_str(), subject.c_str(), folderpath.c_str());
}

void usage(tstring progname, tstring profilename)
{
	_ftprintf(stderr, _T("                                                        \n"));
	_ftprintf(stderr, _T("%s                                                      \n"), progname.c_str());
	_ftprintf(stderr, _T("                                                        \n"));
	_ftprintf(stderr, _T("Usage:                                                  \n"));
	_ftprintf(stderr, _T("    %s <pstfile> createsearchfolder                     \n"), progname.c_str());
	_ftprintf(stderr, _T("    %s <pstfile> deletesearchfolder                     \n"), progname.c_str());
	_ftprintf(stderr, _T("    %s <pstfile> [-p] [-e]                              \n"), progname.c_str());
	_ftprintf(stderr, _T("    %s -d                                               \n"), progname.c_str());
	_ftprintf(stderr, _T("                                                        \n"));
	_ftprintf(stderr, _T("Where:                                                  \n"));
	_ftprintf(stderr, _T("    -e                 Extract msg files to current dir.\n"));
	_ftprintf(stderr, _T("    -p                 Create profile \"%s\" only.      \n"), profilename.c_str());
	_ftprintf(stderr, _T("    -d                 Delete profile \"%s\" only.      \n"), profilename.c_str());
	_ftprintf(stderr, _T("    -v                 Verbose logging.                 \n"));
	_ftprintf(stderr, _T("    -h                 Display this help information.   \n"));
	_ftprintf(stderr, _T("                                                        \n"));
	_ftprintf(stderr, _T("Examples:                                               \n"));
	_ftprintf(stderr, _T("    %s D:\\generated.pst -e                             \n"), progname.c_str());
	_ftprintf(stderr, _T("    %s D:\\generated.pst -v                             \n"), progname.c_str());
	_ftprintf(stderr, _T("    %s -d                                               \n"), progname.c_str());
	_ftprintf(stderr, _T("    %s D:\\generated.pst -p                             \n"), progname.c_str());
}

int _tmain(int argc, _TCHAR* argv[])
{
	tstring profilename		= _T("PSTLister");	// This is the name you will see listed in mlcfg32.
	tstring	pstfile			= _T("undefined");
	tstring foldername 		= _T("mysearchfolder");
	int 	createProfile 	= 1;
	int		listEmails		= 1;
	int 	deleteProfile 	= 1;
	int     requirepstfile 	= 1;
	int		createsearchfolder = 0;
	int		deletesearchfolder = 0;
	
	tstring progname = tstring(argv[0]);
	
	for (int i=1; i<argc; i++) {
		tstring s = argv[i];
		
		if (s == _T("-h") || s == _T("/?")) {
			usage(progname, profilename);
			exit(0);
		}
		
		if (s == _T("-v"))		// Enable verbose logging. 
			gDebug = 1;
		else 
		if (s == _T("-e"))		// Extract msg files. 
			gExport = 1;
		else
		if (s == _T("-p")) {	// Create profile only.
			createProfile	= 1;
			listEmails 		= 0;
			deleteProfile 	= 0;
		}
		else 
		if (s == _T("-d")) {	// Delete existing profile only.
			createProfile 	= 0;
			listEmails 		= 0;
			deleteProfile 	= 1;
			requirepstfile 	= 0;
		}
		else
		if (s == _T("createsearchfolder")) {
			createsearchfolder 	= 1;
			createProfile		= 1;
			listEmails			= 0;
			deleteProfile		= 1;
			requirepstfile 		= 1;
		}
		else
		if (s == _T("deletesearchfolder")) {
			deletesearchfolder  = 1;
			createProfile		= 1;
			listEmails			= 0;
			deleteProfile		= 1;
			requirepstfile 		= 1;
		}
		else {
			pstfile = s;
			ifstream infile(pstfile);
			if (!infile.good()) {
				tcerr << _T("ERROR: Could not open file: ") << pstfile << endl;
				exit(1);
			}
		}
	}
	
	if (requirepstfile && pstfile == _T("undefined")) {
		tcerr << _T("ERROR: Bad arguments.") << endl;
		usage(progname, profilename);
		exit(1);
	}

	// Start of main program logic here.
	
	HRESULT hRes = MAPIInitialize(0);
	if (FAILED(hRes)) {
		tcerr << _T("MAPIInitialize: Failed with error: ") << convert2hex(hRes) << endl;
		exit(1);
	}
	
	if (createProfile) {
		tstring password = _T("");
		hRes = CreateProfile(profilename, pstfile, password);
		if (FAILED(hRes)) {
			tcerr << _T("ERROR: Could not create profile \"") << profilename << _T("\". ");
			if (hRes == MAPI_E_NO_ACCESS /* 80070005 */)
				tcerr << _T("Profile already exists.") << endl;
			else 
				tcerr << _T("Error: ") << convert2hex(hRes) << endl;
			MAPIUninitialize();
			exit(1);
		}
		tcout << _T("Successfully created profile \"") << profilename << _T("\".") << endl;
	}

	if (createsearchfolder || deletesearchfolder) {
		hRes = SearchFolder(profilename, foldername, createsearchfolder, deletesearchfolder);
		if (FAILED(hRes)) {
			tcerr << _T("ERROR: Could not create search folder. Error: ") << convert2hex(hRes) << endl;
			DeleteProfile(profilename);
			MAPIUninitialize();
			exit(1);
		}
	}
	else
	if (listEmails) {
		if (!createOutputFile()) {
			tcerr << _T("ERROR: Could not open file: ") << gOutputFileName.c_str() << _T(". Check that the file is not already open.") << endl;
			DeleteProfile(profilename);
			MAPIUninitialize();
			exit(1);
		}
				
		hRes = ListEmails(profilename);
		if (FAILED(hRes)) {
			tcerr << _T("ERROR: Could not list emails. Error: ") << convert2hex(hRes) << endl;
			MAPIUninitialize();
			closeOutputFile();
			exit(1);
		}
		closeOutputFile();
		tcout << "See output file: " << gOutputFileName.c_str() << endl;
	}
	
	if (deleteProfile) {
		hRes = DeleteProfile(profilename);
		if (FAILED(hRes)) {
			tcerr << _T("ERROR: Could not delete profile \"") << profilename << _T("\". ");
			if (hRes == MAPI_E_NOT_FOUND /* 8004010f */) 
				tcerr << _T("Profile not found.") << endl;
			else
				tcerr << _T("Error: ") << convert2hex(hRes) << endl;
			MAPIUninitialize();
			exit(1);
		}
		tcout << _T("Successfully deleted profile \"") << profilename << _T("\".") << endl;
	}
	
	MAPIUninitialize();
	return hRes;
}

/*
** Other possibly useful reference material regarding creating a profile:
** https://support.microsoft.com/en-us/help/306962/how-to-create-mapi-profiles-without-installing-outlook
*/
HRESULT CreateProfile(tstring& profilename, tstring& pstfile, tstring& password)
{
	Log(_T("Entering CreateProfile() ..."));
	HRESULT hRes;

	IProfAdmin	*iProfAdmin = NULL;
	hRes = MAPIAdminProfiles(0, &iProfAdmin);
	if (FAILED(hRes))
		return hRes;
	MapiResource iProfAdminResource(iProfAdmin);
	
	Log(_T("CreateProfile: Calling iProfAdmin::CreateProfile() ..."));
	hRes = iProfAdmin->CreateProfile(reinterpret_cast<LPTSTR>(const_cast<LPSTR>((tstring2string(profilename)).c_str())), NULL, 0, 0);
	if (FAILED(hRes)) {
		Log(_T("iProfAdmin::CreateProfile() failed with error: ") << convert2hex(hRes));
		if (hRes == MAPI_E_NO_ACCESS)
			Log(_T("iProfAdmin::CreateProfile() failed with MAPI_E_NO_ACCESS (") << convert2hex(hRes) << _T("). The profile already exists (") << profilename << _T(")."));	
		return hRes;
	}
	
	IMsgServiceAdmin *pAdminServices = NULL;	
	Log(_T("CreateProfile: Calling iProfAdmin::AdminServices() ..."));
	hRes = iProfAdmin->AdminServices(reinterpret_cast<LPTSTR>(const_cast<LPSTR>((tstring2string(profilename)).c_str())), 
										NULL,NULL, 0, &pAdminServices);
	if (FAILED(hRes)) {
		Log(_T("iProfAdmin::AdminServices() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	MapiResource pAdminServicesResource(pAdminServices);

	tstring servicename = _T("MSUPST MS");	
	Log(_T("CreateProfile: Calling IMsgServiceAdmin::CreateMsgService() ..."));
	hRes = pAdminServices->CreateMsgService(reinterpret_cast<LPTSTR>(const_cast<LPSTR>((tstring2string(servicename)).c_str())), 
												NULL, NULL, NULL);
	if (FAILED(hRes)) {
		Log(_T("IMsgServiceAdmin::CreateMsgService() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	
	LPMAPITABLE	pMTServices = NULL;
	Log(_T("CreateProfile: Calling IMsgServiceAdmin::GetMsgServiceTable() ..."));
	hRes = pAdminServices->GetMsgServiceTable(NULL, &pMTServices);
	if (FAILED(hRes)) {
		Log(_T("IMsgServiceAdmin::GetMsgServiceTable() failed with error: ") << convert2hex(hRes));
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
	Log(_T("CreateProfile: Calling LPMAPITABLE:SetColumns() ..."));
	hRes = pMTServices->SetColumns((LPSPropTagArray)&Columns, 0);
	if (FAILED(hRes)) {
		Log(_T("LPMAPITABLE:SetColumns() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	
	ULONG ulRowCount = 0;
	Log(_T("CreateProfile: Calling LPMAPITABLE::GetRowCount() ..."));
	hRes = pMTServices->GetRowCount(NULL, &ulRowCount);
	if (FAILED(hRes)) {
		Log(_T("LPMAPITABLE::GetRowCount() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	//Log(_T("JCDC: rowCount=") << ulRowCount);
	
	// Get all rows.
	LPSRowSet lpRows = NULL;
	Log(_T("CreateProfile: Calling LPMAPITABLE::QueryRows() ..."));
	hRes = pMTServices->QueryRows(ulRowCount, 0, &lpRows);
	if (FAILED(hRes)) {
		Log(_T("LPMAPITABLE::QueryRows() failed with erorr: ") << convert2hex(hRes));
		return hRes;
	}
	//Log(_T("JCDC: PR_SERVICE_NAME=") << lpRows->aRow[0].lpProps[ePR_SERVICE_NAME].Value.lpszW);
	MapiTableRowsResource mtServiceRowsResource(lpRows);
	
	// Define array of profile properties to configure.
	SPropValue rgval[4];
	int numProps = 0;
	string p = tstring2string(pstfile);
	rgval[numProps].ulPropTag = PR_PST_PATH;
	rgval[numProps++].Value.lpszA = const_cast<LPSTR>(p.c_str());
	rgval[numProps].ulPropTag = PR_DISPLAY_NAME_A;
	rgval[numProps++].Value.lpszA = "PST Lister";	
	rgval[numProps].ulPropTag = PR_DISPLAY_NAME_W;
	rgval[numProps++].Value.lpszW = L"PST Lister";	
	rgval[numProps].ulPropTag =	PR_PST_REMEMBER_PW;
	rgval[numProps++].Value.b =	TRUE;
	//Log(_T("JCDC: pstfile=") << const_cast<LPWSTR>(tstring2wstring(pstfile).c_str()));
	
	// Configure the message service with the properties.
	// NOTE: I've found that this will create the specified PST file if it does not already exist!
	Log(_T("CreateProfile: Calling IMsgServiceAdmin::ConfigureMsgService() ..."));
	hRes = pAdminServices->ConfigureMsgService((LPMAPIUID)lpRows->aRow[0].lpProps[ePR_SERVICE_UID].Value.bin.lpb, 
												NULL, 
												0, 
												numProps, 
												rgval);
	if (FAILED(hRes)) {
		Log(_T("IMsgServiceAdmin::ConfigureMsgService() failed with error: ") << convert2hex(hRes));
		Log(_T("MAPI_E_EXTENDED_ERROR=") 	<< convert2hex(MAPI_E_EXTENDED_ERROR));
		Log(_T("MAPI_E_NOT_FOUND=") 		<< convert2hex(MAPI_E_NOT_FOUND));
		Log(_T("MAPI_E_NOT_INITIALIZED=") 	<< convert2hex(MAPI_E_NOT_INITIALIZED));
		Log(_T("MAPI_E_USER_CANCEL=") 		<< convert2hex(MAPI_E_USER_CANCEL));
		Log(_T("MAPI_E_DISK_ERROR=")   		<< convert2hex(MAPI_E_DISK_ERROR));
		return hRes;
	}

	Log(_T("Leaving CreateProfile() ..."));
	return S_OK;
}

HRESULT DeleteProfile(tstring& profilename)
{
	Log(_T("Entering DeleteProfile() ..."));
	HRESULT hRes;
	
	IProfAdmin	*iProfAdmin = NULL;
	Log(_T("DeleteProfile: Calling MAPIAdminProfiles() ..."));
	hRes = MAPIAdminProfiles(0, &iProfAdmin);
	if (FAILED(hRes)) {
		Log(_T("MAPIAdminProfiles() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	MapiResource iProfAdminResource(iProfAdmin);
	
	Log(_T("DeleteProfile: Calling IProfAdmin::DeleteProfile() ..."));
	hRes = iProfAdmin->DeleteProfile(reinterpret_cast<LPTSTR>(const_cast<LPSTR>((tstring2string(profilename)).c_str())), 0);
	if (FAILED(hRes)) {
		Log(_T("IProfAdmin::DeleteProfile() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	
	Log(_T("Leaving DeleteProfile() ..."));
	return hRes;
}

HRESULT ListEmails(tstring& profilename)
{
	Log("Entering ListEmails() ...");
	HRESULT hRes = S_OK;
	LPSRowSet   lpRows = NULL;
	ULONG       cRows = 0;
	LPENTRYID   lpeid = NULL;
    ULONG       cbeid = 0;
		
	IMAPISession *lpSession = NULL;
	Log(_T("ListEmails: Calling MAPILogonEx() for profile ") << profilename << " ...");
	hRes = MAPILogonEx(	0, 
						reinterpret_cast<LPTSTR>(const_cast<LPSTR>((tstring2string(profilename)).c_str())), 
						NULL,	
						MAPI_NEW_SESSION | MAPI_EXTENDED | MAPI_NO_MAIL | MAPI_EXPLICIT_PROFILE, 
						&lpSession);
	if (FAILED(hRes)) {
		Log(_T("MAPILogonEx() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	MapiSessionResource sessResource(lpSession);
	
    ULONG		cbEid = 0;  
    LPENTRYID	lpEid = NULL;
	Log(_T("ListEmails: Calling FindDefaultMsgStore() ..."));
    hRes = FindDefaultMsgStore(lpSession, &cbEid, &lpEid); 
    if (FAILED(hRes)) {
		Log(_T("FindDefaultMsgStore() failed with error: ") << convert2hex(hRes));
        return hRes;
	}
	MapiBufferResource lpEidBufferRes(lpEid);
	
	LPMDB lpMdb = NULL;
	Log(_T("ListEmails: Calling IMAPISession::OpenMsgStore() ..."));
	hRes = lpSession->OpenMsgStore(0, cbEid, lpEid, NULL, MDB_WRITE | MAPI_DEFERRED_ERRORS | MDB_NO_DIALOG, &lpMdb);
	if (FAILED(hRes)) {
		Log(_T("IMAPISession::OpenMsgStore() failed with error: ") << convert2hex(hRes));
	    return (hRes);
	}
	MapiResource lpMdbResource((IUnknown*)lpMdb);
	
	// Open the root folder in the msg store (i.e. in the pst file).
    ULONG			ulObjType = 0;
	LPMAPIFOLDER    lpRootFolder = NULL;
	Log(_T("ListEmails: Calling LPMDB::OpenEntry() ..."));
	hRes = lpMdb->OpenEntry(0, NULL, NULL, MAPI_MODIFY|MAPI_DEFERRED_ERRORS, &ulObjType, (LPUNKNOWN *)&lpRootFolder);
	if (FAILED(hRes)) {
		Log(_T("LPMDB::OpenEntry() failed with error: ") << convert2hex(hRes));
		return (hRes);
	}
	MapiResource lpRootFolderResource(lpRootFolder);
	if (ulObjType != MAPI_FOLDER) {
		Log(_T("ListEmails: Could not open root folder."));
		hRes = MAPI_E_INVALID_OBJECT;
		return (hRes);
	}
	
	LPMAPITABLE lpHierarchyTable = NULL;
	Log(_T("ListEmails: Calling LPMAPIFOLDER::GetHierarchyTable() ..."));
	hRes = lpRootFolder->GetHierarchyTable(MAPI_DEFERRED_ERRORS, &lpHierarchyTable);
	if (FAILED(hRes)) {
		Log(_T("LPMAPITABLE::GetHierarchyTable() failed with error: ") << convert2hex(hRes));
		Log(_T("MAPI_E_BAD_CHARWIDTH=") << convert2hex(MAPI_E_BAD_CHARWIDTH));
		Log(_T("MAPI_E_NO_SUPPORT=") << convert2hex(MAPI_E_NO_SUPPORT));
		return (hRes);
	}
	MapiResource lpHierarchyTableResource(lpHierarchyTable);
	
	enum { 
		ePR_ENTRYID,
		ePR_STORE_SUPPORT_MASK,
		ePR_DISPLAY_NAME_W,
		ePR_DISPLAY_NAME_A,
		NUMCOLS
	};
	SizedSPropTagArray(NUMCOLS, tableProps) = {
		NUMCOLS,
		{
			PR_ENTRYID,
			PR_STORE_SUPPORT_MASK,
			PR_DISPLAY_NAME_W,
			PR_DISPLAY_NAME_A
		}
	};
	Log(_T("ListEmails: Calling LPMAPIFOLDER::SetColumns() ..."));
	hRes = lpHierarchyTable->SetColumns((LPSPropTagArray)&tableProps, 0);
	if (FAILED(hRes)) {
		Log(_T("LPMAPITABLE::SetColumns() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	
	// Go to  beginning of table.
	Log(_T("ListEmails: Calling LPMAPITABLE::SeekRow() ..."));
    hRes = lpHierarchyTable->SeekRow(BOOKMARK_BEGINNING, 0, NULL);
    if(FAILED(hRes)) {
		Log(_T("LPMAPITABLE::SeekRow() failed with error: ") << convert2hex(hRes));
        return hRes;
	}

	// Get row count.
	Log(_T("ListEmails: Calling LPMAPITABLE::GetRowCount() ..."));
	hRes = lpHierarchyTable->GetRowCount(0, &cRows);
    if(FAILED(hRes)) {
		Log(_T("LPMAPITABLE::GetRowCount() failed with error: ") << convert2hex(hRes));
        return hRes;
	}
	
	// Read all the rows.
	Log("ListEmails: Calling LPMAPITABLE::QueryRows() ...");
    hRes = lpHierarchyTable->QueryRows(cRows, 0, &lpRows);
    if(FAILED(hRes)) {
		Log(_T("LPMAPITABLE::QueryRows() failed with error: ") << convert2hex(hRes));
		return hRes;
    }
	MapiTableRowsResource tableRowsResource(lpRows);
	Log(_T("LPMAPITABLE::QueryRows() lpRows->cRows=") << lpRows->cRows);
	
	// Display the contents of the top-level folders.
	wstring folderpath = _T("");
	ULONG i = 0;
	for (i = 0; i < cRows; i++)
		ListFolderEmails(lpRows->aRow[i], lpMdb, folderpath);

	Log(_T("Leaving ListEmails() ..."));
	return hRes;
}

HRESULT ListFolderEmails(SRow row, LPMDB lpMdb, wstring folderpath)
{
	Log(_T("Entering ListFolderEmails() ..."));
	HRESULT		hRes = S_OK;
	LPSRowSet	lpRows = NULL;
		
	assert(row.lpProps[0].ulPropTag == PR_ENTRYID);
	assert(row.lpProps[1].ulPropTag == PR_STORE_SUPPORT_MASK);
	assert(row.lpProps[2].ulPropTag == PR_DISPLAY_NAME_W);
	assert(row.lpProps[3].ulPropTag == PR_DISPLAY_NAME_A);
	
#define STORE_UNICODE_OK	0x0004000
	// PR_STORE_SUPPORT_MASK
	// This doesn't work, because the flag STORE_UNICODE_OK never seems to be set.
	// According to the documentation I've read, every object should have this set.
	//bool bUseUnicode = false;
	//if (row.lpProps[1].Value.l & STORE_UNICODE_OK)
	//	bUseUnicode = true;
	
	// Construct full folder path.
	wstring folderpath_w = row.lpProps[2].Value.lpszW;	// PR_DISPLAY_NAME_W
	string  folderpath_a = row.lpProps[3].Value.lpszA;	// PR_DISPLAY_NAME_A
	if (row.lpProps[2].Value.err == MAPI_E_BAD_CHARWIDTH)	// Fallback to use ANSI
		folderpath = folderpath + tstring(_T("\\")) + string2wstring(folderpath_a);
	else
		folderpath = folderpath + tstring(_T("\\")) + folderpath_w;
	Log(_T("JCDC: folderpath=") << folderpath);
	
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
		Log(_T("LPMDB::OpenEntry() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	MapiResource lpFolderResource(lpFolder);

	// Process any messages in the folder.
	LPMAPITABLE	lpMessagesTable = NULL;
	hRes = lpFolder->GetContentsTable(MAPI_DEFERRED_ERRORS, &lpMessagesTable);
	if (FAILED(hRes)) {
		Log(_T("LPMAPIFOLDER::GetContentsTable() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	MapiResource lpTableResource(lpMessagesTable);
	
	enum { 
		ePR_ENTRYID,
		ePR_SUBJECT_A,
		ePR_SUBJECT_W,
		ePR_MESSAGE_CLASS_A,
		ePR_MESSAGE_CLASS_W,
		ePR_CREATION_TIME,
		ePR_STORE_SUPPORT_MASK,
		NUMCOLS
	};
	SizedSPropTagArray(NUMCOLS, messageTableProps) = {
		NUMCOLS,
		{
			PR_ENTRYID,
			PR_SUBJECT_A,
			PR_SUBJECT_W,
			PR_MESSAGE_CLASS_A,
			PR_MESSAGE_CLASS_W,
			PR_CREATION_TIME,
			PR_STORE_SUPPORT_MASK
		}
	};
	hRes = lpMessagesTable->SetColumns((LPSPropTagArray)&messageTableProps, 0);
	if (FAILED(hRes)) {
		Log(_T("LPMAPITABLE::SetColumns() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	
	// Go to the first row.
	hRes = lpMessagesTable->SeekRow(BOOKMARK_BEGINNING,	0, NULL);
	if (FAILED(hRes)) {
		Log(_T("LPMAPITABLE::SeekRow() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	
	// Display any emails present in this folder.
	for (;;) {
		lpRows = NULL;
		hRes = lpMessagesTable->QueryRows(1, NULL, &lpRows);
		if (FAILED(hRes)) {
			Log(_T("LPMAPIFOLDER::QueryRows() failed with error: ") << convert2hex(hRes));
			break;
		} 
		if (!lpRows || !lpRows->cRows) 
			break;
		MapiTableRowsResource lpRowsResource(lpRows);

		// PR_MESSAGE_CLASS
		if (lpRows->aRow[0].lpProps[ePR_MESSAGE_CLASS_A].ulPropTag == PR_MESSAGE_CLASS_A) {
			Log(_T("PR_MESSAGE_CLASS_A=") << lpRows->aRow[0].lpProps[ePR_MESSAGE_CLASS_A].Value.lpszA);
		} 
		else
		if (lpRows->aRow[0].lpProps[ePR_MESSAGE_CLASS_W].ulPropTag == PR_MESSAGE_CLASS_W) {
			Log(_T("PR_MESSAGE_CLASS_W=") << lpRows->aRow[0].lpProps[ePR_MESSAGE_CLASS_W].Value.lpszW);
		}
		
		// PR_ENTRYID
		assert(lpRows->aRow[0].lpProps[ePR_ENTRYID].ulPropTag == PR_ENTRYID);
		tstring entryidStr = convertENTRYIDtostring(&(lpRows->aRow[0].lpProps[ePR_ENTRYID]));
		wstring entryidStr_w = tstring2wstring(entryidStr);
		Log(_T("PR_ENTRYID=") << entryidStr_w);
		
		// PR_CREATION_TIME
		assert(lpRows->aRow[0].lpProps[ePR_CREATION_TIME].ulPropTag == PR_CREATION_TIME);
		FILETIME ft = lpRows->aRow[0].lpProps[ePR_CREATION_TIME].Value.ft;
		tstring creationtimeMS  = convertFILETIMEtoUTC(ft, 1);	// Miiliseconds format.	
		tstring creationtimeStr = convertFILETIMEtoUTC(ft, 0);	// Friendly string format.
		Log(_T("PR_CREATION_TIME=") << creationtimeStr);
		wstring creationtimeMS_w = tstring2wstring(creationtimeMS);
		wstring creationtimeStr_w = tstring2wstring(creationtimeStr);
		
		wstring subject_w = _T("");
		
		// PR_SUBJECT_A
		string subjectA = "<SUBJECT NOT AVAILABLE>";
		if (lpRows->aRow[0].lpProps[ePR_SUBJECT_A].ulPropTag == PR_SUBJECT_A) {
			subjectA = lpRows->aRow[0].lpProps[ePR_SUBJECT_A].Value.lpszA; 
			subject_w = string2wstring(subjectA);
		} else {
			// The PR_SUBJECT_A property is not available, so we must not reference the string pointer value.
			Log(_T("PR_SUBJECT_A not available, Value.err=") << lpRows->aRow[0].lpProps[ePR_SUBJECT_A].Value.err);
		}
		
		// PR_SUBJECT_W
		wstring subjectW = _T("<SUBJECT NOT AVAILABLE>");
		if (lpRows->aRow[0].lpProps[ePR_SUBJECT_W].ulPropTag == PR_SUBJECT_W) {
			subjectW = lpRows->aRow[0].lpProps[ePR_SUBJECT_W].Value.lpszW;
			subject_w = subjectW;
		} else {	
			// The PR_SUBJECT_W property is not available, so we must not reference the string pointer value.
			Log(_T("PR_SUBJECT_W not available, Value.err=") << lpRows->aRow[0].lpProps[ePR_SUBJECT_W].Value.err);
			// Use PR_SUBJECT_A.
			subject_w = string2wstring(subjectA);
		}

		Log(_T("Calling writeEmailW() ..."));
		writeEmailW(entryidStr_w, creationtimeMS_w, creationtimeStr_w, subject_w, folderpath);

		if (gExport) {
			Log(_T("Calling exportEmail() ..."));
			exportEmail(lpMdb, &(lpRows->aRow[0].lpProps[ePR_ENTRYID]));
		}
	}
	
	// Process any sub-folders (i.e. containers) in this folder.
	LPMAPITABLE lpHierarchyTable = NULL;
	hRes = lpFolder->GetHierarchyTable(MAPI_DEFERRED_ERRORS, &lpHierarchyTable);
	if (FAILED(hRes)) {
		if (hRes == MAPI_E_NO_SUPPORT) { 
			// The container has no child containers and cannot provide a hierarchy table.
			Log(_T("LPMAPIFOLDER::GetHierarchyTable() returned MAPI_E_NO_SUPPORT. Leaving ListFolderEmails() ..."));
			return S_OK;
		}
		Log(_T("LPMAPIFOLDER::GetHierarchyTable() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	MapiResource lpHierarchyTableResource(lpHierarchyTable);
		
	SizedSPropTagArray(4, tableProps2) = {
		4,
		{
			PR_ENTRYID,
			PR_STORE_SUPPORT_MASK,
			PR_DISPLAY_NAME_W,
			PR_DISPLAY_NAME_A
		}
	};
	hRes = lpHierarchyTable->SetColumns((LPSPropTagArray)&tableProps2, 0);
	if (FAILED(hRes)) {
		Log(_T("LPMAPITABLE::SetColumns() failed with error: ") << convert2hex(hRes));
		return hRes;
	}
	
	// Get row count.
	ULONG cRows = 0;
	hRes = lpHierarchyTable->GetRowCount(0, &cRows);
    if(FAILED(hRes)) {
		Log(_T("LPMAPITABLE::GetRowCount() failed with error: ") << convert2hex(hRes));
        return hRes;
	}
	if (cRows == 0) {
		Log(_T("Empty Hierarchy table. Leaving ListFolderEmails() ..."));
		return S_OK;
	}
	
	// Read all the rows.
    hRes = lpHierarchyTable->QueryRows(cRows, 0, &lpRows);
    if(FAILED(hRes)) {
		Log(_T("LPMAPITABLE::QueryRows() failed with error: ") << convert2hex(hRes));
		return hRes;
    }
	MapiTableRowsResource lpRowsResource(lpRows);
	
	// Recursion.
	ULONG i = 0;
	for (i = 0; i < cRows; i++)
		ListFolderEmails(lpRows->aRow[i], lpMdb, folderpath);
		
	Log(_T("Leaving ListFolderEmails() ..."));
	return hRes;
}

// If a MAPI provider's functions return MAPI_E_EXTENDED_ERROR, then they should also
// provide more error information by running GetLastError() on the MAPI object where 
// the call failed. 
// See https://docs.microsoft.com/en-us/office/client-developer/outlook/mapi/mapi-extended-errors 
void DisplayGetLastError(LPMAPIERROR pErr, const char* functionname, unsigned int lineno)
{
	printf("##################\n");	
	printf("GetLastError: %s, line number: %u\n", 			functionname, lineno);
	if (pErr->lpszError)		
	printf("lpszError=%s\n", pErr->lpszError);
	if (pErr->lpszComponent) 	
	printf("lpszComponent=%s\n", pErr->lpszComponent);	
	printf("ulLowLevelError=%lu (ULONG)\n", pErr->ulLowLevelError);
	printf("ulContext=%lu (ULONG)\n", pErr->ulContext);
	printf("##################\n");
}

// See https://docs.microsoft.com/en-us/office/client-developer/outlook/mapi/searching-a-message-store
HRESULT SearchFolder(tstring& profilename, tstring& foldername, int createsearchfolder, int deletesearchfolder)
{
	Log("Entering SearchFolder() ...");
	HRESULT hRes = S_OK;
	LPSRowSet   lpRows = NULL;
	ULONG       cRows = 0;
	LPENTRYID   lpeid = NULL;
    ULONG       cbeid = 0;
		
	IMAPISession *lpSession = NULL;
	Log(_T("SearchFolder: Calling MAPILogonEx() for profile ") << profilename << " ...");
	hRes = MAPILogonEx(	0, 
						reinterpret_cast<LPTSTR>(const_cast<LPSTR>((tstring2string(profilename)).c_str())), 
						NULL,	
						MAPI_NEW_SESSION | MAPI_EXTENDED | MAPI_NO_MAIL | MAPI_EXPLICIT_PROFILE, 
						&lpSession);
	if (FAILED(hRes)) {
		Log(_T("SearchFolder: MAPILogonEx() failed with error: ") << convert2hex(hRes));
		return (hRes);
	}
	MapiSessionResource sessResource(lpSession);
	
    ULONG		cbEid = 0;  
    LPENTRYID	lpEid = NULL;
    hRes = FindDefaultMsgStore(lpSession, &cbEid, &lpEid); 
    if (FAILED(hRes)) {
		Log(_T("SearchFolder: FindDefaultMsgStore() failed with error: ") << convert2hex(hRes));
        return hRes;
	}
	MapiBufferResource lpEidBufferRes(lpEid);
	
	LPMDB lpMdb = NULL;
	hRes = lpSession->OpenMsgStore(0, cbEid, lpEid, NULL, MDB_WRITE | MAPI_DEFERRED_ERRORS | MDB_NO_DIALOG, &lpMdb);
	if (FAILED(hRes)) {
		Log(_T("SearchFolder: MAPISESSION::OpenMsgStore() failed with error: ") << convert2hex(hRes));
		LPMAPIERROR pErr;
		if (S_OK == lpSession->GetLastError(hRes, 0/*MAPI_UNICODE*/, &pErr)) {
			DisplayGetLastError(pErr, "SearchFolder: MAPISESSION::OpenMsgStore()", __LINE__);
			MAPIFreeBuffer(pErr);
		}
	    return (hRes);
	}
	MapiResource lpMdbResource((IUnknown*)lpMdb);
	
	// Create a search results folder.
	
	// 1)
	// Use IMAPIProps::GetProps to retrieve the PR_STORE_SUPPORT_MASK. We will also
	// retrieve the PR_FINDER_ENTRYID property at the same time. Then we'll check if
	// the STORE_SEARCH_OK flag is set, to indicate that searching is supported.
	ULONG 			ulCount;
	LPSPropValue	pProps;
	SizedSPropTagArray(2, sptCols) = {2, PR_STORE_SUPPORT_MASK, PR_FINDER_ENTRYID};
	hRes = lpMdb->GetProps((LPSPropTagArray)&sptCols, 0, &ulCount, &pProps);
	if (FAILED(hRes)) {
		Log(_T("SearchFolder: MDB::GetProps() for PR_FINDER_ENTRYID failed with error: ") << convert2hex(hRes));
		LPMAPIERROR pErr;
		if (S_OK == lpMdb->GetLastError(hRes, 0/*MAPI_UNICODE*/, &pErr)) {
			tstring functionname = _T("SearchFolder: MDB::GetProps()");
			DisplayGetLastError(pErr, "SearchFolder: MDB::GetProps() for PR_FINDER_ENTRYID", __LINE__);
			MAPIFreeBuffer(pErr);
		}
	    return (hRes);
	}
	MapiBufferResource lpMdbPropsResource(pProps);
	
	if (PR_STORE_SUPPORT_MASK == pProps[0].ulPropTag) {
		if (pProps[0].Value.l & STORE_SEARCH_OK) 
			tcout << _T("PR_STORE_SUPPORT_MASK contains STORE_SEARCH_OK (GOOD)") << endl;
		else 
			tcout << _T("PR_STORE_SUPPORT_MASK does NOT contain STORE_SEARCH_OK (BAD)") << endl;
	}
	else
		tcout << _T("WARNING: Failed to retrieve property PR_STORE_SUPPORT_MASK")  << endl;
	
	ULONG		cbeid2 = 0;  
    LPENTRYID	lpeid2 = NULL;
	if (PR_FINDER_ENTRYID == pProps[1].ulPropTag) {
	    cbeid2 = pProps[1].Value.bin.cb;
		MAPIAllocateBuffer(cbeid2, (void **)&lpeid2);
		CopyMemory(lpeid2, pProps[1].Value.bin.lpb, cbeid2);
	}
	else {
		tcout << _T("ERROR: Failed to retrieve property PR_FINDER_ENTRYID") << endl;
	    return (hRes);
	}
	MapiBufferResource lpEidResource(lpeid2);
	
	// 2) 	Call IMsgStore::OpenEntry to open the folder represented by PR_FINDER_ENTRYID.
    ULONG			ulObjType = 0;
	LPMAPIFOLDER    lpFolder = NULL;
	hRes = lpMdb->OpenEntry(cbeid2, lpeid2, NULL, MAPI_MODIFY|MAPI_DEFERRED_ERRORS, &ulObjType, (LPUNKNOWN *)&lpFolder);
	if (FAILED(hRes)) {
		Log(_T("SearchFolder: MDB::OpenEntry() for PR_FINDER_ENTRYID failed with error: ") << convert2hex(hRes));
		LPMAPIERROR pErr;
		if (S_OK == lpMdb->GetLastError(hRes, 0/*MAPI_UNICODE*/, &pErr)) {
			tstring functionname = _T("SearchFolder: MDB::OpenEntry()");
			DisplayGetLastError(pErr, "SearchFolder: MDB::OpenEntry() for PR_FINDER_ENTRYID", __LINE__);
			MAPIFreeBuffer(pErr);
		}
		return (hRes);
	}
	MapiResource lpFolderResource(lpFolder);	

	// 3)	Call the folder's IMAPIFolder::CreateFolder method to create a search-results
	//		folder with the FOLDER_SEARCH flag set.	
	if (createsearchfolder) {
		LPMAPIFOLDER    lpSearchFolder = NULL;
		hRes = lpFolder->CreateFolder(FOLDER_SEARCH, reinterpret_cast<LPTSTR>(const_cast<LPSTR>((tstring2string(foldername)).c_str())), NULL, NULL, 0/*MAPI_UNICODE*/, &lpSearchFolder);
		if (hRes == S_OK) {
			tcout << _T("Search folder created successfully (S_OK)") << endl;
		}
		else 
		if (hRes == MAPI_E_COLLISION) {
			tcout << _T("ERROR: Failed to create search folder. Folder already exists (MAPI_E_COLLISION) (") << convert2hex(hRes) << _T(")") << endl;
			LPMAPIERROR pErr;
			if (S_OK == lpFolder->GetLastError(hRes, 0/*MAPI_UNICODE*/, &pErr)) {
				tstring functionname = _T("SearchFolder: MAPIFOLDER::CreateFolder()");
				DisplayGetLastError(pErr, "SearchFolder: MAPIFOLDER::CreateFolder()", __LINE__);
				MAPIFreeBuffer(pErr);
			}
		}
		else
		if (hRes == MAPI_E_BAD_CHARWIDTH) {
			tcout << _T("ERROR: Failed to create search folder (MAPI_E_BAD_CHARWIDTH) (") << convert2hex(hRes) << _T(")") << endl;
			LPMAPIERROR pErr;
			if (S_OK == lpFolder->GetLastError(hRes, 0/*MAPI_UNICODE*/, &pErr)) {
				tstring functionname = _T("SearchFolder: MAPIFOLDER::CreateFolder()");
				DisplayGetLastError(pErr, "SearchFolder: MAPIFOLDER::CreateFolder()", __LINE__);
				MAPIFreeBuffer(pErr);
			}
		}
		else {
			tcout << _T("ERROR: Failed to create search folder, with error: ") << convert2hex(hRes) << endl;
			LPMAPIERROR pErr;
			if (S_OK == lpFolder->GetLastError(hRes, 0/*MAPI_UNICODE*/, &pErr)) {
				tstring functionname = _T("SearchFolder: MAPIFOLDER::CreateFolder()");
				DisplayGetLastError(pErr, "SearchFolder: MAPIFOLDER::CreateFolder()", __LINE__);
				MAPIFreeBuffer(pErr);
			}
		}
	}
	
	if (deletesearchfolder) {
		LPMAPITABLE lpHierarchyTable = NULL;
		hRes = lpFolder->GetHierarchyTable(MAPI_DEFERRED_ERRORS, &lpHierarchyTable);
		if (FAILED(hRes)) {
			Log(_T("MAPIFOLDER::GetHierarchyTable() failed with error: ") << convert2hex(hRes));
			return (hRes);
		}
		MapiResource lpHierarchyTableResource(lpHierarchyTable);
		
		enum { 
			ePR_ENTRYID,
			ePR_DISPLAY_NAME_W,
			ePR_DISPLAY_NAME_A,
			NUMCOLS
		};
		SizedSPropTagArray(NUMCOLS, tableProps) = {
			NUMCOLS,
			{
				PR_ENTRYID,
				PR_DISPLAY_NAME_W,
				PR_DISPLAY_NAME_A
			}
		};
		hRes = lpHierarchyTable->SetColumns((LPSPropTagArray)&tableProps, 0);
		if (FAILED(hRes)) {
			Log(_T("MAPITABLE::SetColumns() failed with error: ") << convert2hex(hRes));
			return hRes;
		}
		
		// Go to  beginning of table.
	    hRes = lpHierarchyTable->SeekRow(BOOKMARK_BEGINNING, 0, NULL);
		if(FAILED(hRes)) {
			Log(_T("MAPITABLE::SeekRow() failed with error: ") << convert2hex(hRes));
			return hRes;
		}
		
		// Get row count.
		hRes = lpHierarchyTable->GetRowCount(0, &cRows);
		if(FAILED(hRes)) {
			Log(_T("MAPITABLE::GetRowCount() failed with error: ") << convert2hex(hRes));
			return hRes;
		}
		if (cRows == 0) {
			tcout << _T("*** No search folders found") << endl;
			return hRes;
		}
		
		// Read all the rows.
		hRes = lpHierarchyTable->QueryRows(cRows, 0, &lpRows);
		if(FAILED(hRes)) {
			Log(_T("MAPITABLE::QueryRows() failed with error: ") << convert2hex(hRes));
			return hRes;
		}
		MapiTableRowsResource tableRowsResource(lpRows);
		Log(_T("MAPITABLE::QueryRows() lpRows->cRows=") << lpRows->cRows);

		// List all top-level folders as we delete the requested one (if it exists).
		wstring folderpath = _T("");
		ULONG i = 0;
		for (i = 0; i < cRows; i++) {
			SRow row = lpRows->aRow[i];
			wstring folderpath = _T("");
			
			// Construct full folder path.
			wstring folderpath_w = row.lpProps[1].Value.lpszW;		// PR_DISPLAY_NAME_W
			string  folderpath_a = row.lpProps[2].Value.lpszA;		// PR_DISPLAY_NAME_A
			if (row.lpProps[1].Value.err == MAPI_E_BAD_CHARWIDTH)	// Fallback to use ANSI
				folderpath = string2wstring(folderpath_a);
			else
				folderpath = folderpath_w;
			tcout << _T("*** Found search folder: ") << folderpath << endl;
		
			// Is this the requested search folder to be deleted?
			if (folderpath == foldername) {
				tcout << _T("*** Deleting search folder: ") << folderpath << _T(" ...") << endl;

				// Get the entryid for the folder.	
				ULONG		cbeid = 0;  
				LPENTRYID	lpeid = NULL;
				cbeid = row.lpProps[0].Value.bin.cb;
				MAPIAllocateBuffer(cbeid, (void **)&lpeid);
				CopyMemory(lpeid, row.lpProps[0].Value.bin.lpb, cbeid);
				MapiBufferResource lpEidResource(lpeid);
		
				// Delete the folder.
				hRes = lpFolder->DeleteFolder(cbeid, lpeid, 0, NULL, DEL_FOLDERS | DEL_MESSAGES);
				if (FAILED(hRes)) {
					Log(_T("SearchFolder: MAPIFOLDER::DeleteFolder() for search folder failed with error: ") << convert2hex(hRes));
					LPMAPIERROR pErr;
					if (S_OK == lpMdb->GetLastError(hRes, 0/*MAPI_UNICODE*/, &pErr)) {
						tstring functionname = _T("SearchFolder: MAPIFOLDER::DeleteFolder()");
						DisplayGetLastError(pErr, "SearchFolder: MAPIFOLDER::DeleteFolder()", __LINE__);
						MAPIFreeBuffer(pErr);
					}
				}
				else {
					tcout << _T("*** Successfully deleted search folder: ") << folderpath << endl;
				}
				return hRes;
			}
		}	
		tcout << _T("*** Search folder not found: ") << foldername << endl;
 	}
	
	// 4)	Build a restriction to hold your search criteria.
	// 5)	Create an array of entry identifiers that represent the folders to be searched.
	//		(this step is unnecessary if the search-results folder has been used before and
	//		you want to search the same folders).
	// 6)	Call the search-results folder's IMAPIContainer::SetSearchCriteria method, pointing
	//		lpContainerList to the entry id array and lpRestriction to the restriction (search filter).
	// 7)	If you have registered for search-complete notifications with the message store,
	//		wait for the notification to arrive.
	// 8)	View the results or the search by calling the search-result folder's IMAPIContainer::GetContentsTable
	//		method to access its contents table.
	// 9)	Call the contents table's IMAPITable::QueryRows method to retrieve the messages that
	//		satisfy the search criteria.
	
	Log(_T("Leaving SearchFolder() ..."));
	return hRes;	
}

HRESULT FindDefaultMsgStore(LPMAPISESSION lpSession, ULONG* lpcbeid, LPENTRYID* lppeid)
{
	Log(_T("Entering FindDefaultMsgStore() ..."));
	
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
	Log(_T("FindDefaultMsgStore: Calling LPMAPISESSION::GetMsgStoresTable() ..."));
    hr = lpSession->GetMsgStoresTable(0, &lpTable);
    if(FAILED(hr)) {
		Log(_T("LPMAPISESSION::GetMsgStoresTable() failed with error: ") << convert2hex(hr));
		return (hr);
	}
	MapiResource tableResource(lpTable);
	
	Log(_T("FindDefaultMsgStore: Calling LPMAPITABLE::GetRowCount() ..."));
	hr = lpTable->GetRowCount(0, &cRows);
    if(FAILED(hr)) {
		Log(_T("LPMAPITABLE::GetRowCount() failed with error: ") << convert2hex(hr));
        return (hr);
	}

	// Set columns to return.
	Log(_T("FindDefaultMsgStore: Calling LPMAPITABLE::SetColumns() ..."));
    hr = lpTable->SetColumns((LPSPropTagArray)&rgPropTagArray, 0);
    if(FAILED(hr)) {
		Log(_T("LPMAPITABLE::SetColumns() failed with error: ") << convert2hex(hr));
        return (hr);
	}

	// Go to  beginning of table.
	Log(_T("FindDefaultMsgStore: Calling LPMAPITABLE::SeekRow() ..."));
    hr = lpTable->SeekRow(BOOKMARK_BEGINNING, 0, NULL);
    if(FAILED(hr)) {
		Log(_T("LPMAPITABLE::SeekRow() failed with error: ") << convert2hex(hr));
        return (hr);
	}

	// Read all the rows.
	Log(_T("FindDefaultMsgStore: Calling LPMAPITABLE::QueryRows() ..."));
    hr = lpTable->QueryRows(cRows, 0, &lpRows);
    if(SUCCEEDED(hr) && (lpRows != NULL) && (lpRows->cRows == 0)) {
		Log(_T("LPMAPITABLE::QueryRows() returned 0 rows."));
        FreeProws(lpRows);
		lpRows = NULL;
		return (hr);
    }
	MapiTableRowsResource tableRowsResource(lpRows);
	Log(_T("LPMAPITABLE::QueryRows() lpRows->cRows=") << lpRows->cRows);
	
	for (i = 0; i < cRows; i++) {
        if(lpRows->aRow[i].lpProps[0].Value.b == TRUE) {
            cbeid = lpRows->aRow[i].lpProps[1].Value.bin.cb;
            sc = MAPIAllocateBuffer(cbeid, (void **)&lpeid);
            if(FAILED(sc)) {
				Log(_T("MAPIAllocateBuffer() failed with error: ") << convert2hex(sc));
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

	Log(_T("Leaving FindDefaultMsgStore() ..."));
    return (hr);
}

// https://support.microsoft.com/en-us/help/171907/info-save-message-to-msg-compound-file
// https://support.microsoft.com/en-gb/help/239795/how-to-list-messages-in-the-inbox-with-mapi
// {00020D0B-0000-0000-C000-000000000046}
DEFINE_GUID(CLSID_MailMessage,
0x00020D0B,
0x0000, 0x0000, 0xC0, 0x00, 0x0, 0x00, 0x0, 0x00, 0x00, 0x46);
HRESULT exportEmail(LPMDB lpMDB, SPropValue* eid)
{
	Log(_T("Entering exportEmail() ..."));
	HRESULT		hRes = NOERROR;
	LPMESSAGE	lpMessage = NULL;
	ULONG 		ulObjType = NULL;
			
	hRes = lpMDB->OpenEntry(eid->Value.bin.cb,
			(LPENTRYID)eid->Value.bin.lpb, 
            NULL,//default interface
            MAPI_BEST_ACCESS,
            &ulObjType,
            (LPUNKNOWN *)&lpMessage);	
		
	// Location of parent directory for extracted msg file.
	TCHAR szPath[_MAX_PATH];
	GetCurrentDirectory(_MAX_PATH, szPath);
	//GetTempPath(_MAX_PATH, szPath);
	_tcscat(szPath, _T("\\msgs"));
	_tmkdir(szPath);
	
	// Location of extracted msg file named after the entryid.
	tstring entryidStr = convertENTRYIDtostring(eid);
	//Log(_T("exportEmail() entryidStr=") << entryidStr.c_str());
	TCHAR strMsgFile[_MAX_PATH];
    _tcscpy(strMsgFile, szPath);
	_tcscat(strMsgFile, _T("\\"));
    _tcscat(strMsgFile, (wchar_t*)(tstring2wstring(entryidStr).c_str()));
    _tcscat(strMsgFile, _T(".msg"));
	Log(_T("exportEmail() strMsgFile=") << strMsgFile);
	
	// get memory allocation function
    LPMALLOC pMalloc = MAPIGetDefaultMalloc();

#if 0
	// Convert new file name to WideChar
	ULONG cbStrSize = 0L;
	LPWSTR lpWideCharStr = NULL;
    cbStrSize = MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, strMsgFile, -1, lpWideCharStr, 0);
	MAPIAllocateBuffer(cbStrSize * sizeof(WCHAR), (LPVOID *)&lpWideCharStr);
	MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, strMsgFile, -1, lpWideCharStr, cbStrSize);
#endif

	// create compound file
	LPSTORAGE pStorage = NULL;
    hRes = ::StgCreateDocfile(strMsgFile,
                              STGM_READWRITE |
                              STGM_TRANSACTED |
                              STGM_CREATE, 0, &pStorage);

	// Open an IMessage session.
	LPMSGSESS pMsgSession =  NULL;
    hRes = ::OpenIMsgSession(pMalloc, 0, &pMsgSession);

	// Open an IMessage interface on an IStorage object.
	LPMESSAGE pIMsg = NULL;
    hRes = ::OpenIMsgOnIStg(pMsgSession,
                            MAPIAllocateBuffer,
                            MAPIAllocateMore,
                            MAPIFreeBuffer,
                            pMalloc,
                            NULL,
                            pStorage,
                            NULL, 0, 0, &pIMsg);
							
	// write the CLSID to the IStorage instance - pStorage. This will
    // only work with clients that support this compound document type
    // as the storage medium. If the client does not support
    // CLSID_MailMessage as the compound document, you will have to use
    // the CLSID that it does support.
    hRes = WriteClassStg(pStorage, CLSID_MailMessage);							

	// Specify properties to exclude in the copy operation. These are
    // the properties that Exchange excludes to save bits and time.
    // Should not be necessary to exclude these, but speeds the process
    // when a lot of messages are being copied.
	SizedSPropTagArray ( 7, excludeTags );
    excludeTags.cValues = 7;
    excludeTags.aulPropTag[0] = PR_ACCESS;
    excludeTags.aulPropTag[1] = PR_BODY;
    excludeTags.aulPropTag[2] = PR_RTF_SYNC_BODY_COUNT;
    excludeTags.aulPropTag[3] = PR_RTF_SYNC_BODY_CRC;
    excludeTags.aulPropTag[4] = PR_RTF_SYNC_BODY_TAG;
    excludeTags.aulPropTag[5] = PR_RTF_SYNC_PREFIX_COUNT;
    excludeTags.aulPropTag[6] = PR_RTF_SYNC_TRAILING_COUNT;
							
	// copy message properties to IMessage object opened on top of IStorage.
    hRes = lpMessage->CopyTo(0, NULL,
                            (LPSPropTagArray)&excludeTags,
                            NULL, NULL,
                            (LPIID)&IID_IMessage,
                            pIMsg, 0, NULL);						
			
	// save changes to IMessage object.
    pIMsg->SaveChanges(KEEP_OPEN_READWRITE);
		
	 // save changes in storage of new doc file.
    hRes = pStorage->Commit(STGC_DEFAULT);

	// free objects and clean up memory.
    //MAPIFreeBuffer(lpWideCharStr);
    pStorage->Release();
    pIMsg->Release();
    CloseIMsgSession(pMsgSession);
	
	pStorage = NULL;
    pIMsg = NULL;
    pMsgSession = NULL;
    //lpWideCharStr = NULL;
		
	UlRelease(lpMessage);
	Log(_T("Leaving exportEmail() ..."));
    return (hRes);
}
