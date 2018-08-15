#include <mapix.h>
#include <mapitags.h>
#include <mapidefs.h>
#include <mapiutil.h>
#include <mapiguid.h>
#include <imessage.h>
#include <stdio.h>
#include <windows.h>
#include <strsafe.h>

#include "MSGEdit.h"

#define LOGON_FLAGS	MAPI_EXTENDED | MAPI_NEW_SESSION | MAPI_NO_MAIL | MAPI_USE_DEFAULT

SizedSPropTagArray(1, g_sptMsgProps) = {2, PR_SUBJECT};

HRESULT SaveSubject(LPMESSAGE pMsg, LPTSTR lpszSubject)
{
	LPSPropValue	pspvSaved = NULL;
	HRESULT		hRes;

	if (FAILED(hRes = MAPIAllocateBuffer(sizeof(SPropValue)*1, (LPVOID*)&pspvSaved)))
		return hRes;

	pspvSaved[0].ulPropTag = PR_SUBJECT;
	pspvSaved[0].Value.lpszA = lpszSubject;

	if (FAILED(hRes = pMsg->SetProps(1, pspvSaved, NULL)))
		goto Quit;

	pMsg->SaveChanges(KEEP_OPEN_READWRITE);

Quit:
	MAPIFreeBuffer((LPVOID)pspvSaved);
	return hRes;
}

#if 0
HRESULT OpenDefStore()
{
	LPMAPITABLE		pStoresTbl = NULL;
	static SRestriction	sres;
	SPropValue		spv;
	LPSRowSet		pRow = NULL;
	SBinary			sbEID = {0, NULL};
	HRESULT			hRes;

	static SizedSPropTagArray(2, sptCols) = {2, PR_ENTRYID, PR_DEFAULT_STORE};

	if (FAILED(hRes = m_pSess->GetMsgStoresTable(0, &pStoresTbl)))
	{
		ShowLastError(hRes);
		goto Quit;
	}

	sres.rt = RES_PROPERTY;
	sres.res.resProperty.relop = RELOP_EQ;
	sres.res.resProperty.ulPropTag = PR_DEFAULT_STORE;
	sres.res.resProperty.lpProp = &spv;

	spv.ulPropTag = PR_DEFAULT_STORE;
	spv.Value.b = TRUE;
	if (FAILED(hRes= HrQueryAllRows(pStoresTbl,
					(LPSPropTagArray)&sptCols,
					&sres,
					NULL,
					0,
					&pRow))) {
		ShowLastError(hRes);
		goto Quit;
	}
	
	if (	pRow 			&&
		pRow->cRows		&&
		pRow->aRow[0].cValues	&&
		PR_ENTRY_ID = pRow->aRow[0].lpProps[0].ulPropTag)
	{
		sbEID = pRow->aRow[0].lpProps[0].Value.bin;
	}
	else
	{
		hRes = MAPI_E_NOT_FOUND;
		goto Quit;
	}

	if (FAILED(hRes = m_pSess->OpenMsgStore(0, sbEID.cb, 
						(LPENTRYID)sbEID.lpb, NULL, 
						MDB_WRITE, &m_pMDB)))
	{
		ShowLastError(hRes);
		goto Quit;
	}

Quit:
	FreeProws(pRow);
	if (pStoresTbl)
		pStoresTbl->Release();
	return hRes;
}
#endif

#if 0
HRESULT InitSession()
{
	LPMAPISESSION	pSession = NULL;
	PCSession	pCSess = NULL;
	HRESULT		hRes;

	if (FAILED(hRes = MAPIInitialize(NULL))) {
		ShowLastError(hRes);
		return hRes;
	}

	if (FAILED(hRes = MAPILogonEx(0, NULL, NULL, LOGON_FLAGS, &pSession))) {
		ShowLastError(hRes);
		goto Quit;
	}

	pCSess= new CSession(pSession);
	if (!pCSess)
	{
		hRes = MAPI_E_NOT_ENOUGH_MEMORY;
		goto Quit;
	}

	if (FAILED(hRes = pCSess->Init()))
		goto Quit;

	// Open the default message store provider.
	if (FAILED(hRes = pCSess->OpenDefStore()))
		goto Quit;
	
}
#endif

// https://msdn.microsoft.com/en-us/library/windows/desktop/ms680582(v=vs.85).aspx
void DisplayError(LPTSTR lpszFunction) 
{ 
    // Retrieve the system error message for the last-error code

    LPVOID lpMsgBuf;
    LPVOID lpDisplayBuf;
    DWORD dw = GetLastError(); 

    FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | 
        FORMAT_MESSAGE_FROM_SYSTEM |
        FORMAT_MESSAGE_IGNORE_INSERTS,
        NULL,
        dw,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPTSTR) &lpMsgBuf,
        0, NULL );

    // Display the error message and exit the process

    lpDisplayBuf = (LPVOID)LocalAlloc(LMEM_ZEROINIT, 
        (lstrlen((LPCTSTR)lpMsgBuf) + lstrlen((LPCTSTR)lpszFunction) + 40) * sizeof(TCHAR)); 
    StringCchPrintf((LPTSTR)lpDisplayBuf, 
        LocalSize(lpDisplayBuf) / sizeof(TCHAR),
        TEXT("%s failed with error %d: %s"), 
        lpszFunction, dw, lpMsgBuf); 
    MessageBox(NULL, (LPCTSTR)lpDisplayBuf, TEXT("Error"), MB_OK); 

    LocalFree(lpMsgBuf);
    LocalFree(lpDisplayBuf);
}

SizedSPropTagArray(2, sptCols) = {2, PR_ENTRYID, PR_SUBJECT};

int main(int c, LPTSTR argv[])
{
	HRESULT 	hRes;
	
	char *filename 			= argv[1];
	char *new_subject_text 	= argv[2];
	
	if (filename == NULL) {
		printf("Filename argument missing!\n");
		return -1;
	}
	
	if (new_subject_text == NULL) {
		printf("New subject text argument missing!\n");
		return -1;
	}
		
	wchar_t wtext1[1024];
	mbstowcs(wtext1, filename, strlen(filename)+1);
	LPWSTR ptr_filename = wtext1;
	
	wchar_t wtext2[1024];
	mbstowcs(wtext2, new_subject_text, strlen(new_subject_text)+1);
	LPWSTR ptr_new_subject_text = wtext2;
	
	IStorage*  pIStorage = 0;
    IMessage*  pIMessage = 0;
	
	DWORD gfMode = STGM_TRANSACTED | STGM_READWRITE;
    
	STGOPTIONS sOptions = {0}; 
    sOptions.usVersion = 1;
    sOptions.ulSectorSize = 4096;
	
	IMalloc* lpMalloc = NULL;
	
	LPSPropProblemArray	pProblems = NULL;
	SPropValue	spvProps[1] = {0};
	spvProps[0].ulPropTag = PR_SUBJECT;
	spvProps[0].Value.lpszA = new_subject_text;
	
	ULONG 			ulCount;
	LPSPropValue	pProps;
	
	LPMAPISESSION 	pSession = NULL;
	
	if (FAILED(hRes = MAPIInitialize(NULL))) {
		printf("MAPIInitialize: Failed\n");
		goto Quit;
	}

#if 0
	// This isn't actually needed, but the call to MAPIInitialize *is* required.
    if (FAILED(hRes = MAPILogonEx(0,
                                  NULL,
                                  NULL,
                                  MAPI_EXTENDED | MAPI_NEW_SESSION | MAPI_NO_MAIL | MAPI_USE_DEFAULT,
                                  &pSession)))
	{
		printf("MAPILogonEx: Failed\n");
		goto Quit;
	}
#endif
							  
	hRes = StgOpenStorage(	ptr_filename, 
							NULL,
							gfMode, 
							NULL,
							0,
							&pIStorage);
	if (S_OK != hRes) {
		printf("StgOpenStorage: Failed\n");
		//DisplayError(TEXT("StgOpenStorage: Failed"));
		
		switch (hRes) {
		case STG_E_FILENOTFOUND:
			printf("STG_E_FILENOTFOUND: Indicates that the specified file does not exist.\n");
			break;
		case STG_E_ACCESSDENIED:
			printf("STG_E_ACCESSDENIED: Access denied because the caller does not have enough permissions, or another caller has the file open and locked.\n");
			break;
		case STG_E_LOCKVIOLATION:
			printf("STG_E_LOCKVIOLATION: Access denied because another caller has the file open and locked.\n");
			break;
		case STG_E_SHAREVIOLATION:
			printf("STG_E_SHAREVIOLATION: Access denied because another caller has the file open and locked.\n");
			break;
		case STG_E_FILEALREADYEXISTS:
			printf("STG_E_FILEALREADYEXISTS: Indicates that the file exists but is not a storage object.\n");
			break;
		case STG_E_TOOMANYOPENFILES:
			printf("STG_E_TOOMANYOPENFILES: Indicates that the storage object was not opened because there are too many open files.\n");
			break;
		case STG_E_INSUFFICIENTMEMORY:
			printf("STG_E_INSUFFICIENTMEMORY: Indicates that the storage object was not opened due to inadequate memory.\n");
			break;
		case STG_E_INVALIDNAME:
			printf("STG_E_INVALIDNAME: Indicates a non-valid name in the pwcsName parameter.\n");
			break;
		case STG_E_INVALIDPOINTER:
			printf("STG_E_INVALIDPOINTER: Indicates a non-valid pointer in one of the parameters: snbExclude, pwcsName, pstgPriority, or ppStgOpen.\n");
			break;
		case STG_E_INVALIDFLAG:
			printf("STG_E_INVALIDFLAG: Indicates a non-valid flag combination in the grfMode parameter.\n");
			break;
		case STG_E_INVALIDFUNCTION:
			printf("STG_E_INVALIDFUNCTION: Indicates STGM_DELETEONRELEASE specified in the grfMode parameter.\n");
			break;
		case STG_E_OLDFORMAT:
			printf("STG_E_OLDFORMAT: Indicates that the storage object being opened was created by the Beta 1 storage provider. This format is no longer supported.\n");
			break;
		case STG_E_NOTSIMPLEFORMAT:
			printf("STG_E_NOTSIMPLEFORMAT: Indicates that the STGM_SIMPLE flag was specified in the grfMode parameter and the storage object being opened was not written in simple mode.\n");
			break;
		case STG_E_OLDDLL:
			printf("STG_E_OLDDLL: The DLL used to open this storage object is a version of the DLL that is older than the one used to create it.\n");
			break;
		case STG_E_PATHNOTFOUND:
			printf("STG_E_PATHNOTFOUND: Specified path does not exist.\n");
			break;
		default: 
			printf("Unknown error\n");
		}
		
		goto Quit;
	}
	
	lpMalloc = MAPIGetDefaultMalloc();
	if (lpMalloc == NULL)
	{
		printf("MAPIGetDefaultMalloc: Failed\n");
		goto Quit;
	}
	
	hRes = OpenIMsgOnIStg(	NULL,
							::MAPIAllocateBuffer,
							::MAPIAllocateMore,
							::MAPIFreeBuffer,
							lpMalloc,
							NULL,
							pIStorage,
							NULL, 
							0, 
							MAPI_UNICODE, 
							&pIMessage);
	if (S_OK != hRes) {
		printf("OpenIMsgOnIStg: Failed (%x)", hRes);
		//DisplayError(TEXT("OpenIMsgOnIStg: Failed"));
		goto Quit;
	}
	
	hRes = pIMessage->GetProps((LPSPropTagArray)&sptCols, 0, &ulCount, &pProps);
	if (SUCCEEDED(hRes))
	{
		if (PR_ENTRYID == pProps[0].ulPropTag)
		{
		}
		if (PR_SUBJECT == pProps[1].ulPropTag)
		{
			printf("GetProps: PR_SUBJECT=%s\n", pProps[1].Value.lpszA);
		}
		MAPIFreeBuffer(pProps);
	}
	else
	{
		printf("GetProps: Failed");
	}

	hRes = pIMessage->SetProps(1, spvProps, &pProblems);
	if (FAILED(hRes)) {
		printf("SetProps: Failed");
		goto Quit;
	}
	
	pIMessage->SaveChanges(KEEP_OPEN_READWRITE);
    pIStorage->Commit(STGC_DEFAULT);

Quit:
	MAPIUninitialize();
    if (pIMessage != NULL)
			pIMessage->Release();
    if (pIStorage !=NULL)
			pIStorage->Release();
}
