#include <sstream>
#include <cassert>
#include "Session.h"
#include "Utils.h"

using namespace std;

Session::Session()
	:m_initialized(false),m_pSession(NULL),m_pAddrBook(NULL)
{
	m_pLogger = Logger::getLogger("SESSION");
}

Session::~Session()
{
	if(m_pSession)
		m_pSession -> Release();
		
	if (m_pAddrBook)
        m_pAddrBook -> Release();
				
	MAPIUninitialize();
}

string
Session::convertHRESULTtoHex(HRESULT hRes)
{
	stringstream ss;
	ss << std::hex << hRes;
	return ss.str();
}

bool
Session::initialize()
{
	HRESULT		hRes;
	
	m_pLogger->detail("About to call MAPIInitialize()...");
	
	if (FAILED(hRes = MAPIInitialize(NULL))) {
		m_pLogger->error(string("MAPIInitialize failed: ") + convertHRESULTtoHex(hRes));
		return false;	// Failed.
	}
	
	m_initialized = true;
	return true;	// Success.
}

// NOTE: Not needed for reading of writing to an MSG file.
bool
Session::logon()
{
	HRESULT		hRes;
	
	LPADRLIST	pAdrList = NULL;
	ADRPARM		AdrParm;
	HWND      	hDlg;
	
	m_pLogger->detail("logon: About to call MAPILogonEx()...");
	hRes = MAPILogonEx(0,
                       NULL,
                       NULL,
                       MAPI_ALLOW_OTHERS | MAPI_NEW_SESSION | MAPI_EXPLICIT_PROFILE | MAPI_UNICODE | MAPI_USE_DEFAULT /*| MAPI_LOGON_UI*/,
                       &m_pSession);
	if (FAILED(hRes))
	{
		m_pLogger->error(string("logon: MAPILogonEx failed: ") + convertHRESULTtoHex(hRes));
		return false;	// Failed.
	}
	
	// Open top-level address book.
	m_pLogger->detail("logon: About to call OpenAddressBook()...");
	hRes = m_pSession->OpenAddressBook((ULONG)0, NULL, 0, &m_pAddrBook);
	if (FAILED(hRes))
	{
		m_pLogger->error(string("logon: OpenAddressBook failed: ") + convertHRESULTtoHex(hRes));
	}

	return true;	// Success.
}

string
Session::GetLastError(HRESULT hRes)
{
	string		sErr("unknown");
	LPMAPIERROR pErr = NULL;
	
	assert(m_pSession != NULL);
	
	if (S_OK == m_pSession->GetLastError(hRes, 0, &pErr))
	{
		sErr = string(pErr->lpszError);
		MAPIFreeBuffer((LPVOID)pErr);
	}
	
	return sErr;
}
