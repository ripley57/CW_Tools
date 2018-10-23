#include <sstream>
#include <cassert>

#define INITGUID
#include <objbase.h>

#define USES_IID_IMessage

#include <mapix.h>
#include <mapiutil.h>
#include <mspst.h>
#include <mapiguid.h>

#include "PSTStoreSession.h"
#include "SmartPointers.h"
#include "Utils.h"
#include "PSTFolder.h"
#include "Msg.h"
#include "EdkMdb.h"

using namespace std;

PSTStoreSession::PSTStoreSession(string profileName, string pstFileName, Session* pSession)
	:m_pPSTProfile(NULL), m_pSession(pSession), m_pWriteSession(NULL), m_pIMsgStore(NULL)
{
	m_pLogger = Logger::getLogger("PSTSTORESESSION");
	m_pLogger->detail("PSTStoreSession::PSTStoreSession() Entering...");
	
	m_pPSTProfile = new PSTProfile(profileName, pstFileName);
	
	m_pLogger->detail("PSTStoreSession::PSTStoreSession() Exiting...");
}

PSTStoreSession::~PSTStoreSession()
{
	m_pLogger->detail("PSTStoreSession::~PSTStoreSession() Entering...");
	
	close();
	
	m_pLogger->detail("PSTStoreSession::~PSTStoreSession() Exiting...");
}

bool
PSTStoreSession::createPSTFile()
{
	m_pLogger->detail("PSTStoreSession::createPSTFile() Entering...");
	bool ret = false;

	IProfAdmin	*iProfAdmin = NULL;
	HRESULT hRes = MAPIAdminProfiles(0, &iProfAdmin);
	if (FAILED(hRes))
		return false;
	MapiResource iProfAdminResource(iProfAdmin);
	
	IMsgServiceAdmin *pAdminServices = NULL;	
	hRes = iProfAdmin->AdminServices((LPTSTR)m_pPSTProfile->getProfileName().c_str(),NULL,NULL,0,&pAdminServices);
	if (FAILED(hRes)) {
		return false;
	}
	MapiResource pAdminServicesResource(pAdminServices);
	
	string servicename = "MSUPST MS";	
	hRes = pAdminServices->CreateMsgService((LPTSTR)servicename.c_str(),NULL,NULL,NULL);
	if (FAILED(hRes)) {
		return false;
	}
	
	LPMAPITABLE	pMTServices = NULL;
	hRes = pAdminServices->GetMsgServiceTable(NULL, &pMTServices);
	if (FAILED(hRes)) {
		return false;
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
	LPSRowSet lpRows = NULL;
	hRes = HrQueryAllRows(pMTServices, (LPSPropTagArray)&Columns, NULL, NULL, 0, &lpRows);
	if (FAILED(hRes)) {
		return false;
	}
	MapiTableRowsResource mtServiceRowsResource(lpRows);
	
	std::string path = m_pPSTProfile->getPstFileName();
	std::wstring storeDisplayName = cstr2wstring("mygeneratedpst");
	char *pszMsgService = "MSUPST MS";
	int cRows = lpRows->cRows;
	for(LPSRow pRow = lpRows->aRow; pRow < lpRows->aRow + cRows; ++pRow) {
		if (pRow->lpProps[ePR_SERVICE_UID].ulPropTag != PR_SERVICE_UID) {
			throw std::exception("Wrong property tag for service ID");
        }
        MAPIUID m_MsgStoreUID = *((LPMAPIUID)pRow->lpProps[ePR_SERVICE_UID].Value.bin.lpb);
        if (strcmp(pRow->lpProps[ePR_SERVICE_NAME].Value.lpszA, pszMsgService) == 0) {
            // Create the PST Message Store.
			ULONG count = 0;
            const ULONG nMAXProps = 2;
            SPropValue   rgval[nMAXProps];

            rgval[count].ulPropTag = PR_DISPLAY_NAME_W;
            rgval[count].Value.lpszW = const_cast<wchar_t*>(storeDisplayName.c_str());
            ++count;

            rgval[count].ulPropTag = PR_PST_PATH;
            rgval[count].Value.lpszA = const_cast<char*>(path.c_str());
            ++count;
				
			hRes = pAdminServices->ConfigureMsgService(&m_MsgStoreUID, 0, 0, count, rgval);
			if (FAILED(hRes)) {
				return false;
			}
		}
	}
	
	// We should have the PST created now. Let's now open the PST ready for writing.
	
	hRes = MAPILogonEx(0,(LPTSTR)m_pPSTProfile->getProfileName().c_str(),NULL,MAPI_NEW_SESSION|MAPI_EXTENDED|MAPI_NO_MAIL|MAPI_TIMEOUT_SHORT,&m_pWriteSession);
	if (FAILED(hRes)) {
		return false;
	}
	
	LPMAPITABLE		ptable;
    hRes = m_pWriteSession->GetMsgStoresTable(0, &ptable);
    if (FAILED(hRes)) {                
        throw std::runtime_error("GetMsgStoresTable failed");
    }
	
	SizedSPropTagArray(3, columns) = { 3, { PR_DEFAULT_STORE, PR_ENTRYID, PR_DISPLAY_NAME } };
	LPSRowSet prows = NULL;
    hRes = HrQueryAllRows(ptable, (LPSPropTagArray) &columns, NULL/*&restDefStore*/, NULL, 0, &prows);
	if (FAILED(hRes)) {
		return false;
	}
	MapiTableRowsResource mtServiceRowsResource2(prows);
		
    hRes = m_pWriteSession->OpenMsgStore(0, // window handle
            prows->aRow[0].lpProps[1].Value.bin.cb, // cbEid,    // # of bytes in entry ID
            (LPENTRYID)prows->aRow[0].lpProps[1].Value.bin.lpb, // lpEid,    // pointer to entry ID
            NULL,   // interface ID pointer
            /*0x80*/ MDB_WRITE | MAPI_DEFERRED_ERRORS | MAPI_BEST_ACCESS | MDB_NO_MAIL,  // flags
            &m_pIMsgStore); // output ptr to store
    if (FAILED(hRes)) {
		return false;
	}
		
	m_pLogger->detail("PSTStoreSession::createPSTFile() Exiting...");
	return ret;
}

bool 
PSTStoreSession::writeMsg(const std::string& msgFilePath, const std::string& folderPath)
{
	m_pLogger->detail("PSTStoreSession::writeMsg() Entering...");
	bool ret = false;
	
	LPMAPIFOLDER lpFolder = NULL;
	ret = m_pPSTFolder.createRootFolder(this, string2wstring(folderPath), &lpFolder);
	if (ret == true) {
		MapiResource lpFolderRes(lpFolder);
		std::string s(msgFilePath);
		Msg msg(s);
		ret = msg.deserializeIMsgFromFile();
		if (ret == true) {
			ret = WriteIMessageToPST(msg.getIMessage(), lpFolder);
		}
	}

	m_pLogger->detail("PSTStoreSession::writeMsg() Exiting...");
	return ret;
}

bool
PSTStoreSession::WriteIMessageToPST(LPMESSAGE lpIMessage, LPMAPIFOLDER lpFolder)
{
	m_pLogger->detail("PSTStoreSession::WriteIMessageToPST() Entering...");
	
	// Create (empty) message.
	LPMESSAGE lpMsg = NULL;
	HRESULT hRes = lpFolder->CreateMessage(NULL, MAPI_DEFERRED_ERRORS, &lpMsg);
	if (FAILED(hRes)) {
		return false;
	}
	MapiResource lpMsgRes (lpMsg);
	
	// use CopyTo to copy IMessage into and save.
	hRes = copyIMessage(lpIMessage, lpMsg);
	if (FAILED(hRes)) {
		return false;
	}

    // Save the message.
	hRes = lpMsg->SaveChanges(FORCE_SAVE);
	if (FAILED(hRes)) {
		return false;
	}
	
	m_pLogger->detail("PSTStoreSession::WriteIMessageToPSAT() Exiting...");
	return true;
}

bool
PSTStoreSession::copyIMessage(LPMESSAGE lpIMessageSrc, LPMESSAGE lpIMessageDst)
{
	assert(lpIMessageSrc != NULL);
	assert(lpIMessageDst != NULL);
	
	SizedSPropTagArray(17, excludePropTags) =
		{	17,
			{
				PR_ENTRYID,
				PR_ACCESS,
				PR_ACCESS_LEVEL,
                PR_HASATTACH,
				PR_MESSAGE_SIZE,
				PR_OBJECT_TYPE,
				PR_PARENT_ENTRYID,
				PR_RECORD_KEY,
				PR_STORE_SUPPORT_MASK,
				PR_STORE_ENTRYID,
				PR_STORE_RECORD_KEY,
                PR_NORMALIZED_SUBJECT,
				PR_REPLICA_SERVER, // https://github.com/JasonSchlauch/mfcmapi/blob/master/include/EdkMdb.h
				PR_REPLICA_VERSION,
				PR_MDB_PROVIDER,
				PR_HAS_NAMED_PROPERTIES,
				PR_ICS_CHANGE_KEY
			}
		};
		
	HRESULT hRes = lpIMessageSrc->CopyTo(0, NULL, (LPSPropTagArray)&excludePropTags, NULL, NULL, (LPIID)&IID_IMessage, lpIMessageDst, 0, NULL);
	if (FAILED(hRes)) {
		return false;
	}
	
	return true;
}

bool
PSTStoreSession::createProfile()
{
	m_pLogger->detail("PSTStoreSession::createProfile() Entering...");
	
	bool ret = false;
	assert(m_pPSTProfile != NULL);
	ret = m_pPSTProfile->createProfile();
	
	m_pLogger->detail("PSTStoreSession::createProfile() Exiting...");
	return ret;
}

bool
PSTStoreSession::deleteProfile()
{
	m_pLogger->detail("PSTStoreSession::deleteProfile() Entering...");
	
	bool ret = false;
	if (m_pPSTProfile != NULL) {
		ret = m_pPSTProfile->deleteProfile();
	}
	
	m_pLogger->detail("PSTStoreSession::deleteProfile() Exiting...");
	return ret;
}

bool
PSTStoreSession::open()
{
	m_pLogger->detail("PSTStoreSession::open() Entering...");
	
	createProfile();
	createPSTFile();
	
	m_pLogger->detail("PSTStoreSession::open() Exiting...");
	return true;
}

bool
PSTStoreSession::close()
{
	m_pLogger->detail("PSTStoreSession::close() Entering...");
	
	deleteProfile();
	if (m_pPSTProfile != NULL) {
		delete m_pPSTProfile;
		m_pPSTProfile = NULL;
	}
	m_pLogger->detail("PSTStoreSession::close() Exiting...");
	return true;
}

string
PSTStoreSession::convertHRESULTtoHex(HRESULT hRes)
{
	stringstream ss;
	ss << std::hex << hRes;
	return ss.str();
}

string
PSTStoreSession::GetLastError(HRESULT hRes)
{
	string sErr("unknown");
	assert(m_pSession != NULL);
	sErr = m_pSession->GetLastError(hRes);
	return sErr;
}
