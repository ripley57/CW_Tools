#include <sstream>
#include "Msg.h"

Msg::Msg(string& msgpath)
	: m_msgpath(msgpath),m_msgopen(false),m_pIStorage(0),m_pIMessage(0),m_pSession(NULL)
{
	m_pLogger = Logger::getLogger("MSG");
}

Msg::Msg(string& msgpath, Session* session)
	: m_msgpath(msgpath),m_msgopen(false),m_pIStorage(0),m_pIMessage(0),m_pSession(session)
{
	m_pLogger = Logger::getLogger("MSG");
}

Msg::~Msg()
{
	if (m_pIMessage)
	{
		m_pLogger->detail("~Msg: About to call IMessage->Release()...");
		m_pIMessage->Release();
	}
	
	if (m_pIStorage)
	{
		m_pLogger->detail("~Msg: About to call IStorage->Release()...");
		m_pIStorage->Release();
	}
}
		
string
Msg::convertHRESULTtoHex(HRESULT hRes)
{
	stringstream ss;
	ss << std::hex << hRes;
	return ss.str();
}
	
bool
Msg::deserializeIMsgFromFile()
{
	m_pLogger->detail("Msg::deserializeIMsgFromFile() Entering...");

	IMalloc* pMalloc = MAPIGetDefaultMalloc();
	if (pMalloc == NULL) {
		m_pLogger->error("OpenMsg: MAPIGetDefaultMalloc failed");
		return false;
	}
	
	std::wstring w_msgpath = std::wstring(m_msgpath.begin(), m_msgpath.end());
	m_pLogger->detail("Msg::deserializeIMsgFromFile() About to call StgOpenStorageEx() to open: " + m_msgpath);
	
	STGOPTIONS myOpts = {0};
	myOpts.usVersion = 1,//STGOPTIONS_VERSION;
	myOpts.reserved = 0;
	myOpts.ulSectorSize = 4096;
	#if STGOPTIONS_VERSION >= 2
	myOpts.pwcsTemplateFile = 0;
	#endif 

	// Open a IStorage Interface on top of the compound file.
	DWORD grfMode = STGM_DIRECT_SWMR | STGM_READ | STGM_SHARE_DENY_NONE;
	HRESULT hRes = StgOpenStorageEx ((LPOLESTR)w_msgpath.c_str(), 
							 grfMode,
							 STGFMT_DOCFILE,
                             0, //FILE_FLAG_NO_BUFFERING,
							&myOpts,
							0,
							__uuidof(IStorage),
							(LPVOID*)&m_pIStorage);
    if (FAILED(hRes)) {
		return false;
	}
	
	// Open an IMessage session.
    hRes = OpenIMsgSession(pMalloc, 0, &m_pMsgSession);
	if (FAILED(hRes)) {
		return false;
	}
	
	// Open an IMessage interface on the IStorage object.
	ULONG ulFlags=fMapiUnicode;
   	hRes = OpenIMsgOnIStg((LPMSGSESS)m_pMsgSession,
                            MAPIAllocateBuffer,
                            MAPIAllocateMore,
                            MAPIFreeBuffer,
                            (LPMALLOC)pMalloc,
                            NULL,
                            (LPSTORAGE)m_pIStorage,
                            NULL, 0, ulFlags, (LPMESSAGE*)&m_pIMsg);
	if (FAILED(hRes)) {
		return false;
	}
	
	m_pLogger->detail("Msg::deserializeIMsgFromFile() Exiting...");
	return true;
}
	
bool
Msg::OpenMsg()
{
	HRESULT		hRes;
	IMalloc* 	lpMalloc = NULL;
		
	if (is_open()) 	// Msg is already open.
	{
		m_pLogger->detail("OpenMsg: Msg is already open. Returning true...");
		return true;	
	}
		
	std::wstring w_msgpath = std::wstring(m_msgpath.begin(), m_msgpath.end());
	m_pLogger->detail("OpenMsg: About to call StgOpenStorage() to open: " + m_msgpath);
	hRes = StgOpenStorage(	w_msgpath.c_str(),	// const WCHAR *
							NULL,
							STGM_TRANSACTED | STGM_READWRITE, 
							NULL,
							0,
							&m_pIStorage);
	if (S_OK != hRes) {
		string e;
		switch (hRes) {
		case STG_E_FILENOTFOUND:
			e = "STG_E_FILENOTFOUND: Indicates that the specified file does not exist.";
			break;
		case STG_E_ACCESSDENIED:
			e = "STG_E_ACCESSDENIED: Access denied because the caller does not have enough permissions, or another caller has the file open and locked.";
			break;
		case STG_E_LOCKVIOLATION:
			e = "STG_E_LOCKVIOLATION: Access denied because another caller has the file open and locked.";
			break;
		case STG_E_SHAREVIOLATION:
			e = "STG_E_SHAREVIOLATION: Access denied because another caller has the file open and locked.";
			break;
		case STG_E_FILEALREADYEXISTS:
			e = "STG_E_FILEALREADYEXISTS: Indicates that the file exists but is not a storage object.";
			break;
		case STG_E_TOOMANYOPENFILES:
			e = "STG_E_TOOMANYOPENFILES: Indicates that the storage object was not opened because there are too many open files.";
			break;
		case STG_E_INSUFFICIENTMEMORY:
			e = "STG_E_INSUFFICIENTMEMORY: Indicates that the storage object was not opened due to inadequate memory.";
			break;
		case STG_E_INVALIDNAME:
			e = "STG_E_INVALIDNAME: Indicates a non-valid name in the pwcsName parameter.";
			break;
		case STG_E_INVALIDPOINTER:
			e = "STG_E_INVALIDPOINTER: Indicates a non-valid pointer in one of the parameters: snbExclude, pwcsName, pstgPriority, or ppStgOpen.";
			break;
		case STG_E_INVALIDFLAG:
			e = "STG_E_INVALIDFLAG: Indicates a non-valid flag combination in the grfMode parameter.";
			break;
		case STG_E_INVALIDFUNCTION:
			e = "STG_E_INVALIDFUNCTION: Indicates STGM_DELETEONRELEASE specified in the grfMode parameter.";
			break;
		case STG_E_OLDFORMAT:
			e = "STG_E_OLDFORMAT: Indicates that the storage object being opened was created by the Beta 1 storage provider. This format is no longer supported.";
			break;
		case STG_E_NOTSIMPLEFORMAT:
			e = "STG_E_NOTSIMPLEFORMAT: Indicates that the STGM_SIMPLE flag was specified in the grfMode parameter and the storage object being opened was not written in simple mode.";
			break;
		case STG_E_OLDDLL:
			e = "STG_E_OLDDLL: The DLL used to open this storage object is a version of the DLL that is older than the one used to create it.";
			break;
		case STG_E_PATHNOTFOUND:
			e = "STG_E_PATHNOTFOUND: Specified path does not exist.";
			break;
		default: 
			e = "Unknown error\n";
		}
		m_pLogger->error(string("OpenMsg: StgOpenStorage failed: ") + e);
		return false;
	}
	
	lpMalloc = MAPIGetDefaultMalloc();
	if (lpMalloc == NULL)
	{
		m_pLogger->error("OpenMsg: MAPIGetDefaultMalloc failed");
		return false;
	}
	
	m_pLogger->detail("OpenMsg: About to call OpenIMsgOnIStg()...");
	hRes = OpenIMsgOnIStg(	NULL,
				::MAPIAllocateBuffer,
				::MAPIAllocateMore,
				::MAPIFreeBuffer,
				lpMalloc,
				NULL,
				m_pIStorage,
				NULL, 
				0, 
				MAPI_UNICODE, 
				&m_pIMessage);
	if (S_OK != hRes) {
		m_pLogger->error("OpenMsg: OpenIMsgOnIStg() failed: " + convertHRESULTtoHex(hRes));
		return false;
	}

	m_msgopen = true;	// msg is now in the "open" state.
	return true;		// Success.
}

// trim trailing chars
void 
Msg::trim_trailing_chars(string& s, string& trimchars)
{
	size_t endpos = s.find_last_not_of(trimchars);
	if(string::npos != endpos )
	{
		s = s.substr( 0, endpos+1 );
	}
}

// trim leading chars
void
Msg::trim_leading_chars(string& s, string& trimchars)
{
	size_t startpos = s.find_first_not_of(trimchars);
	if( string::npos != startpos )
	{
		s = s.substr( startpos );
	}
}

// trim chars
void
Msg::trim_chars(string& s, string& trimchars)
{
	trim_trailing_chars(s, trimchars);
	trim_leading_chars(s, trimchars);
}

/*
** Description:
**		Add recipients to message.
**		The recipients are specified in a single string, 
**		as a list of PR_DISPLAY_NAME values separated by ";", e.g.:
**
**		"fred; bert; arthur <arthur@arthur.com>; sidney rotter"
*/
bool
Msg::setRecipients(string& text, bool unicode)
{
	m_pLogger->detail("setRecipients: Entering ...");
	
	int				iBatchSize = 100;	// Batch size for adding recipients.
	istringstream 	displayname_iss(text);
	string			displayname_token;
	vector<string>	vRecipientsToAdd;

	while (getline(displayname_iss, displayname_token, ';'))
	{
		trim_chars(displayname_token, string(" "));

		// Look for optional email address, e.g. "fred <fred@fred.com>".
		istringstream 	emailadr_iss(displayname_token);
		string 			emailaddr_token;
		
		size_t pos1 = displayname_token.find("<");
		size_t pos2 = displayname_token.find(">");

		if (string::npos != pos1 && string::npos != pos2)
		{
			// Extract display name and email address so they can be trimmed. 
			string display = displayname_token.substr(0,pos1);
			string email   = displayname_token.substr(pos1,pos2);
			trim_chars(display, string(" "));
			trim_chars(email, string(" <>"));

			// Add 'displayname;emailaddress' to list of recipients to add.
			vRecipientsToAdd.push_back(string(display)+";"+string(email));
		}
		else
		{
			// Use the following email address.
			string sDefaultEmail("test@test.com");

			// Add 'displayname;emailaddress' to list of recipients to add.
			vRecipientsToAdd.push_back(string(displayname_token)+";"+string(sDefaultEmail));
		}

		// Add batch of recipients.
		if (vRecipientsToAdd.size() == iBatchSize)
		{
			m_pLogger->detail("setRecipients: About to add batch of recipients...");
			if (AddMultipleRecipients(vRecipientsToAdd, false) == false) return false;
			vRecipientsToAdd.clear();
		}
	}
	
	// Add any remaining recipients.
	if (vRecipientsToAdd.size() > 0)
	{
		m_pLogger->detail("setRecipients: About to add final group of recipients...");
		if (AddMultipleRecipients(vRecipientsToAdd, false) == false) return false;
	}
	
	return true;	//  Success
}


bool
Msg::setBody(string& sBodyFilePath)
{
	LPSTREAM	pStrmSrc = NULL;
	LPSTREAM	pStrmDest = NULL;
	STATSTG		StatInfo;
	HRESULT		hRes;
	bool		ret = true;	// Success.
	
	m_pLogger->detail("Entering setbody()...");
		
	if (!OpenMsg())
	{
		m_pLogger->error("setBody: Msg could not be opened");
		ret = false;
		goto Quit;
	}

	m_pLogger->detail("setBody(): About to call OpenStreamOnFile()...");
	if (FAILED(hRes = OpenStreamOnFile(	MAPIAllocateBuffer,
						MAPIFreeBuffer,
						STGM_READ,
						sBodyFilePath.c_str(),
						NULL,
						&pStrmSrc))) {
		ret = false;
		goto Quit;
	}
	
	m_pLogger->detail("setBody(): About to call OpenProperty()...");
	if (FAILED(hRes = m_pIMessage->OpenProperty(PR_BODY, 
						(LPIID)&IID_IStream, STGM_WRITE,
						MAPI_MODIFY | MAPI_CREATE, 
						(LPUNKNOWN *)&pStrmDest	))) {
		ret = false;
		goto Quit;
	}

	m_pLogger->detail("setBody(): About to call Stat()...");
	pStrmSrc->Stat(&StatInfo, STATFLAG_NONAME);
	
	m_pLogger->detail("setBodyl(): About to call CopyTo() ...");
	if (FAILED(hRes = pStrmSrc->CopyTo(pStrmDest, StatInfo.cbSize, NULL, NULL))) {
		ret = false;
		goto Quit;
	}
	
	// https://msdn.microsoft.com/en-us/library/office/cc839695.aspx
	pStrmDest->Commit(STGC_DEFAULT);
	
	m_pLogger->detail("setBody(): About to call IMessage->SaveChanges()...");
	m_pIMessage->SaveChanges(KEEP_OPEN_READWRITE);
	
	m_pLogger->detail("setBody(): About to call IStorage->Commit()...");
	m_pIStorage->Commit(STGC_DEFAULT);

Quit:	
	if (pStrmSrc)
		pStrmSrc->Release();	
	if (pStrmDest)
		pStrmDest->Release();

	m_pLogger->detail("Leaving setBody()...");
	return ret;
}

bool
Msg::setSubject(string& text, bool unicode)
{
	HRESULT			hRes;
	LPSPropProblemArray	pProblems = NULL;
	SPropValue		spvProps[1] = {0};	// https://msdn.microsoft.com/en-us/library/office/cc815896.aspx
	
	if (!OpenMsg())
	{
		m_pLogger->error("setSubject: Msg could not be opened");
		return false;	// Failed.
	}
		
	spvProps[0].ulPropTag = PR_SUBJECT;
	if (unicode)
	{
		std::wstring w_text = std::wstring(text.begin(), text.end());
		spvProps[0].Value.lpszW = const_cast<LPWSTR>(w_text.c_str());	// LPWSTR (PT_UNICODE)
	}
	else
	{
		spvProps[0].Value.lpszA = const_cast<LPSTR>(text.c_str());	// LPSTR (PT_STRING8)
	}
		
	m_pLogger->detail("setSubject: About tocall IMessage->SetProps()...");
	
	hRes = m_pIMessage->SetProps(1, spvProps, &pProblems);
	if (FAILED(hRes)) {
		m_pLogger->error(string("setSubject: SetProps failed: ") + convertHRESULTtoHex(hRes));
		return false;	// Failed.
	}
	
	m_pLogger->detail("setSubject: About to call IMessage->SaveChanges()...");
	m_pIMessage->SaveChanges(KEEP_OPEN_READWRITE);
	m_pLogger->detail("setSubject: About to call IStorage->Commit()...");
	m_pIStorage->Commit(STGC_DEFAULT);

	return true;	// Success
}

bool
Msg::delete_PR_RTF_COMPRESSED()
{
	HRESULT		hRes;
	LPSPropProblemArray	pProblems = NULL;
	SPropValue	spvProps[1] = {0};
	
	const static SizedSPropTagArray(1, sptSenderPropTags) =
	{
		1,
		{
				PR_RTF_COMPRESSED
		}
	};
			
	if (!OpenMsg())
	{
		m_pLogger->error("delete_PR_RTF_COMPRESSED: Msg could not be opened");
		return false;	// Failed.
	}
	
	spvProps[0].ulPropTag = PR_RTF_COMPRESSED;
	
	m_pLogger->detail("delete_PR_RTF_COMPRESSED: About toc call IMessage->DeleteProps()...");
	
	//hRes = m_pIMessage->DeleteProps((LPSPropTagArray)&spvProps, &pProblems);
	hRes = m_pIMessage->DeleteProps((LPSPropTagArray)&sptSenderPropTags, &pProblems);
	if (S_OK == hRes) 	// No warnings returned.
	{
		if (pProblems)
		{
			m_pLogger->error("delete_PR_RTF_COMPRESSED: Could not delete property!");
			MAPIFreeBuffer(pProblems);
			return false;
		}
	}
	else
	{
		m_pLogger->error(string("delete_PR_RTF_COMPRESSED: Could not delete property: ") + convertHRESULTtoHex(hRes));
	}
	
	m_pLogger->detail("delete_PR_RTF_COMPRESSED: About to call IMessage->SaveChanges()...");
	m_pIMessage->SaveChanges(KEEP_OPEN_READWRITE);
	m_pLogger->detail("delete_PR_RTF_COMPRESSED: About to call IStorage->Commit()...");
	m_pIStorage->Commit(STGC_DEFAULT);
	
	return true;	// Success
}

/*
** Description:
**	Add a batch of recipients to the message.
*/
bool
Msg::AddMultipleRecipients(vector<string>& vRecipients, bool bNewList)
{
	HRESULT		hRes;
	LPADRLIST	lpAddrList = NULL;
	ULONG 		ulModFlags = MODRECIP_ADD;	// By default add new reicipient to existing list.
	ULONG		ulAddrListSize = 0;
	ULONG		ulRecipientCount = vRecipients.size();
	
	if (ulRecipientCount == 0)
	{
		m_pLogger->detail("AddMultipleRecipients: No recipients to add");
		return true;	// Success.
	}
	
	if (!OpenMsg())
	{
		m_pLogger->error("AddMultipleRecipients: Msg could not be opened");
		return false;	// Failure.
	}
	
	ulAddrListSize = CbNewADRLIST(ulRecipientCount);
	hRes = MAPIAllocateBuffer(ulAddrListSize, (LPVOID *)&lpAddrList);
	if (FAILED(hRes))
	{
		m_pLogger->error(string("AddMultipleRecipients: MAPIAllocateBuffer failed: ") + convertHRESULTtoHex(hRes));
		return false;	// Failure.
	}
	lpAddrList->cEntries = ulRecipientCount;
	
	vector<string>::iterator it;
	int i=0;
	for (it=vRecipients.begin() ; it<vRecipients.end(); it++,i++) 
	{
		istringstream 	iss(vRecipients[i]);

		string			sDisplayName;
		string			sEmailAddress;

		// We expect each string in the vector to have format: 'displayname;emailaddress'
		getline(iss, sDisplayName, ';');
		getline(iss, sEmailAddress);
		trim_chars(sDisplayName, string(" "));
		trim_chars(sEmailAddress, string(" "));
		m_pLogger->detail("AddMultipleRecipients: sDisplayName=" + sDisplayName + ", sEmailAddress=" + sEmailAddress);

		enum { DISPLAYNAME, RECIPIENTTYPE, ENTRYID, EMAILADDRESS, NUM_ATT_PROPS };
	
		// Allocate room for the properties for this recipient.
		lpAddrList->aEntries[i].cValues = NUM_ATT_PROPS;
		hRes = MAPIAllocateBuffer(NUM_ATT_PROPS * sizeof(SPropValue), (LPVOID*)&lpAddrList->aEntries[i].rgPropVals);
		if (FAILED(hRes))
		{
			m_pLogger->error(string("AddMultipleRecipients: MAPIAllocateBuffer failed: ") + convertHRESULTtoHex(hRes));
			if (lpAddrList) 
				FreePadrlist(lpAddrList);
			return false;	// Failure.
		}
		
		// Add PR_DISPLAY_NAME
		lpAddrList->aEntries[i].rgPropVals[DISPLAYNAME].ulPropTag = PR_DISPLAY_NAME;	 
		MAPIAllocateMore((sDisplayName.length() + 1) * sizeof(TCHAR), 
						lpAddrList->aEntries[0].rgPropVals, 
						(LPVOID*)&lpAddrList->aEntries[i].rgPropVals[DISPLAYNAME].Value.lpszA);
		lstrcpy(lpAddrList->aEntries[i].rgPropVals[DISPLAYNAME].Value.lpszA, sDisplayName.c_str());
	
		// Add PR_EMAIL_ADDRESS
		// We will always populate PR_EMAIL_ADDRESS in the recipient table.
		// I'm not sure if I should instead be using ResolveName after calling CreateOneOff. For now I'll just set the property.
		lpAddrList->aEntries[i].rgPropVals[EMAILADDRESS].ulPropTag = PR_EMAIL_ADDRESS;	 
		MAPIAllocateMore((sEmailAddress.length() + 1) * sizeof(TCHAR), 
						lpAddrList->aEntries[0].rgPropVals, 
						(LPVOID*)&lpAddrList->aEntries[i].rgPropVals[EMAILADDRESS].Value.lpszA);
		lstrcpy(lpAddrList->aEntries[i].rgPropVals[EMAILADDRESS].Value.lpszA, sEmailAddress.c_str());
	
		// Add PR_RECIPIENT_TYPE
		lpAddrList->aEntries[i].rgPropVals[RECIPIENTTYPE].ulPropTag = PR_RECIPIENT_TYPE;
		lpAddrList->aEntries[i].rgPropVals[RECIPIENTTYPE].Value.l   = MAPI_TO;
	
		// Add PR_ENTRYID
		// We use the CreateOneOff function to create a temporary entryid.
		lpAddrList->aEntries[i].rgPropVals[ENTRYID].ulPropTag = PR_ENTRYID;
		hRes = m_pSession->getAddressBook()->CreateOneOff(lpAddrList->aEntries[i].rgPropVals[DISPLAYNAME].Value.lpszA,
														"SMTP",
														"DUMMY@DUMMY.COM",	
														0, // MAPI_UNICODE parameters passed or Ansi.
														&lpAddrList->aEntries[i].rgPropVals[ENTRYID].Value.bin.cb,
														(LPENTRYID*)&lpAddrList->aEntries[i].rgPropVals[ENTRYID].Value.bin.lpb);
		if (FAILED(hRes)) 
		{
			m_pLogger->error(string("AddMultipleRecipients: CreateOneOff failed: ") + convertHRESULTtoHex(hRes));
			if (lpAddrList) 
				FreePadrlist(lpAddrList);
			return false;	// Failure.
		}
	}
	
	// Create new recipient list or add to existing list.
	ulModFlags = bNewList == true ? 0 : MODRECIP_ADD;
	
	// Update recipient list.
	hRes = m_pIMessage->ModifyRecipients(ulModFlags, lpAddrList);
	if (FAILED(hRes))
	{
		m_pLogger->error(string("AddMultipleRecipients: ModifyRecipients failed: ") + convertHRESULTtoHex(hRes));
		if (lpAddrList) 
			FreePadrlist(lpAddrList);
		return false;	// Failure.
	}
	
	// Save message.
	m_pIMessage->SaveChanges(KEEP_OPEN_READWRITE);
	m_pIStorage->Commit(STGC_DEFAULT);
	
	if (lpAddrList)
		FreePadrlist(lpAddrList);
	
	return true;	// Success.
}

/*
** Description:
**	Add a single recipient to the messages's recipient table.
**
**	References:
**		https://msdn.microsoft.com/en-us/library/office/cc842196.aspx
**
**		CreateOneOff:
**		https://msdn.microsoft.com/en-us/library/office/cc842377.aspx
**
**		ModifyRecipients:
**		https://msdn.microsoft.com/en-us/library/office/cc815334.aspx
*/
bool
Msg::AddRecipient(string& sDisplayName, string& sEmailAddress, bool bNewList)
{
	HRESULT		hRes;
	LPADRLIST	lpAddrList = NULL;
	ULONG 		ulModFlags = MODRECIP_ADD;	// By default add new reicipient to existing list.
	
	if (!OpenMsg())
	{
		m_pLogger->error("AddRecipient: Msg could not be opened");
		return false;	// Failed.
	}
	
	// We will always populate PR_EMAIL_ADDRESS in recipient table.
	// NB: I'm not sure if I should instead be using ResolveName after
	//     calling CreateOneOff. For now I'll just set the property.
	string sEmail = sEmailAddress;
	if (sEmail.length() == 0)
		sEmail = string("dummy@dummy.com");
	
	enum { DISPLAYNAME, RECIPIENTTYPE, ENTRYID, EMAILADDRESS, NUM_ATT_PROPS };
	
	int cb = CbNewADRLIST(1);
	hRes = MAPIAllocateBuffer(cb, (LPVOID *)&lpAddrList);
	if (FAILED(hRes))
	{
		m_pLogger->error(string("AddRecipient: MAPIAllocateBuffer failed: ") + convertHRESULTtoHex(hRes));
		return false;
	}
	
	// Number of recipients.
	lpAddrList->cEntries = 1;
	
	// Properties required to add a recipient.
	lpAddrList->aEntries[0].cValues = NUM_ATT_PROPS;
	hRes = MAPIAllocateBuffer(NUM_ATT_PROPS * sizeof(SPropValue), (LPVOID*)&lpAddrList->aEntries[0].rgPropVals);
	if (FAILED(hRes))
	{
		m_pLogger->error(string("AddRecipient: MAPIAllocateBuffer failed: ") + convertHRESULTtoHex(hRes));
		if (lpAddrList)
			MAPIFreeBuffer(lpAddrList);
		return false;
	}
		
	// PR_DISPLAY_NAME
	lpAddrList->aEntries[0].rgPropVals[DISPLAYNAME].ulPropTag = PR_DISPLAY_NAME;	 
	MAPIAllocateMore(	(sDisplayName.length() + 1) * sizeof(TCHAR), 
						lpAddrList->aEntries[0].rgPropVals, 
						(LPVOID*)&lpAddrList->aEntries[0].rgPropVals[DISPLAYNAME].Value.lpszA	);
	lstrcpy(lpAddrList->aEntries[0].rgPropVals[DISPLAYNAME].Value.lpszA, sDisplayName.c_str());
	
	// PR_EMAIL_ADDRESS
	lpAddrList->aEntries[0].rgPropVals[EMAILADDRESS].ulPropTag = PR_EMAIL_ADDRESS;	 
	MAPIAllocateMore(	(sEmail.length() + 1) * sizeof(TCHAR), 
						lpAddrList->aEntries[0].rgPropVals, 
						(LPVOID*)&lpAddrList->aEntries[0].rgPropVals[EMAILADDRESS].Value.lpszA	);
	lstrcpy(lpAddrList->aEntries[0].rgPropVals[EMAILADDRESS].Value.lpszA, sEmail.c_str());
	
	// PR_RECIPIENT_TYPE
	lpAddrList->aEntries[0].rgPropVals[RECIPIENTTYPE].ulPropTag = PR_RECIPIENT_TYPE;
	lpAddrList->aEntries[0].rgPropVals[RECIPIENTTYPE].Value.l   = MAPI_TO;
	
	// PR_ENTRYID
	lpAddrList->aEntries[0].rgPropVals[ENTRYID].ulPropTag = PR_ENTRYID;
	hRes = m_pSession->getAddressBook()->CreateOneOff(	lpAddrList->aEntries[0].rgPropVals[DISPLAYNAME].Value.lpszA,
														"SMTP",
														"DUMMY@DUMMY.COM",	
														0, // MAPI_UNICODE parameters passed or Ansi.
														&lpAddrList->aEntries[0].rgPropVals[ENTRYID].Value.bin.cb,
														(LPENTRYID*)&lpAddrList->aEntries[0].rgPropVals[ENTRYID].Value.bin.lpb	);
	if (FAILED(hRes)) 
	{
		m_pLogger->error(string("AddRecipient: CreateOneOff failed: ") + convertHRESULTtoHex(hRes));
		if (lpAddrList)
			FreePadrlist(lpAddrList);
		return false;
	}
	
	ulModFlags = bNewList == true ? 0 : MODRECIP_ADD;
	hRes = m_pIMessage->ModifyRecipients(ulModFlags, lpAddrList);
	if (FAILED(hRes))
	{
		m_pLogger->error(string("AddRecipient: ModifyRecipients failed: ") + convertHRESULTtoHex(hRes));
		if (lpAddrList)
			FreePadrlist(lpAddrList);
		return false;
	}
	
	// Save changes.
	m_pIMessage->SaveChanges(KEEP_OPEN_READWRITE);
	m_pIStorage->Commit(STGC_DEFAULT);
	
	if (lpAddrList)
		FreePadrlist(lpAddrList);
	
	return true;	// Success.
}

/*
** Description:
**		Extract PR_DISPLAY_NAME values from an ADRLIST, with ';' between each.
*/  
LPSTR  
Msg::ConcatRecipients(LPADRLIST pAdrList)
{
	HRESULT	hRes;
	LPSTR	*szNameArray;
	int		cRecips 	= 0;
	int		cBytes		= 0;	
	LPSTR	szRecips	= NULL;	// Final string to return.
	
	if (pAdrList->cEntries == 0)
		return NULL;
		
	szNameArray = new LPSTR[pAdrList->cEntries];
	if (!szNameArray) 
	{
		m_pLogger->error("ConcatRecipients: Memory allocation failed.");
		return NULL;
	}
	
	for (int i=0 ; i<(int)pAdrList->cEntries; i++)
	{
		LPSPropValue pProp = PpropFindProp(	pAdrList->aEntries[i].rgPropVals,
											pAdrList->aEntries[i].cValues,
											PR_DISPLAY_NAME	);
		if (pProp)
		{
			szNameArray[cRecips] = pProp->Value.lpszA;
			cBytes += lstrlen(szNameArray[cRecips]);
			cRecips++;
		}
		else
		{
			m_pLogger->detail("ConcatRecipients: Could not find PR_DISPLAY_NAME:");
		}
	}
	
	// Add extra room for the ';' delimiters.
	cBytes += cRecips;
	
	// Allocate memory for the final string to return.
	hRes = MAPIAllocateBuffer(sizeof(TCHAR) * (cBytes + 1), (LPVOID*)&szRecips);
	if (FAILED(hRes))
	{
		m_pLogger->error(string("getRecipients: MAPIAllocateBuffer failed: ") + convertHRESULTtoHex(hRes));
		delete[] szNameArray;
		return false;	// Failed.
	}

	// Build concatenated string.
	szRecips[0] = '\0';
	for (int i=0; i<cRecips; i++)
	{
		lstrcat(szRecips, szNameArray[i]);
		lstrcat(szRecips, ";");
	}
	szRecips[cBytes - 1] = '\0';
	delete[] szNameArray;
	return szRecips;
}

bool
Msg::getRecipients(string& text)
{
	HRESULT			hRes;
	LPMAPITABLE		pTbl 	 = NULL;
	LPSRowSet		pRows 	 = NULL;
	LPSTR			szToLine = NULL;
	
	if (!OpenMsg())
	{
		m_pLogger->error("getSubject: Msg could not be opened");
		return false;	// Failed.
	}
	
	m_pLogger->detail("getRecipients: About to get recipient table ...");
	
	hRes = m_pIMessage->GetRecipientTable(0, &pTbl);
	if (FAILED(hRes)) 
	{
		m_pLogger->error(string("getRecipients: GetRecipientTable failed: ") + convertHRESULTtoHex(hRes));
		return false;	// Failed.
	}
	
	// These are the fields we want to fetch from each recipient row.
	SizedSPropTagArray(5, sptCols) = {5, 	PR_DISPLAY_NAME,
											PR_ENTRYID,
											PR_ADDRTYPE,
											PR_RECIPIENT_TYPE,
											PR_EMAIL_ADDRESS	};
	
	hRes = HrQueryAllRows(	pTbl,
							(LPSPropTagArray)&sptCols,
							NULL,
							NULL,
							0,
							&pRows	);
	if (FAILED(hRes)) 
	{
		m_pLogger->error(string("getRecipients: HrQueryAllRows: ") + convertHRESULTtoHex(hRes));
		if (pTbl)
			pTbl->Release();
		return false;	// Failed.
	}
	
	if (pRows->cRows == 0)
	{
		m_pLogger->detail("getRecipients: No recipients found");
	}
	else 
	{
		// From http://stackoverflow.com/questions/33936233/modify-recipients-for-a-mapi-message:
		// "SRowSet can be cast to AdrList - they have the same memory layout.".
		szToLine = ConcatRecipients((LPADRLIST)pRows);
		
		m_pLogger->detail(string("getRecipients: szToLine=") + szToLine);
	}

	if (pTbl)
		pTbl->Release();
	if (pRows)
		FreeProws(pRows);
	if (szToLine)
		 MAPIFreeBuffer((LPVOID)szToLine);
		
	return true;	// Success.
}

bool
Msg::getSubject(string& text)
{
	HRESULT		hRes;
	ULONG 		ulCount;
	LPSPropValue	pProps;
		
	if (!OpenMsg())
	{
		m_pLogger->error("getSubject: Msg could not be opened");
		return false;	// Failed.
	}
	
	SizedSPropTagArray(2, sptCols) = {2, PR_ENTRYID, PR_SUBJECT};
	
	m_pLogger->detail("getSubject: About to get subject text ...");
	hRes = m_pIMessage->GetProps((LPSPropTagArray)&sptCols, 0, &ulCount, &pProps);
	if (SUCCEEDED(hRes))
	{
		if (PR_ENTRYID == pProps[0].ulPropTag)
		{
		}
		if (PR_SUBJECT == pProps[1].ulPropTag)
		{
			text = string(pProps[1].Value.lpszA);
		}
		MAPIFreeBuffer(pProps);
		return true;	// Success;
	}

	return false;	// Failure.
}

bool 
Msg::addAttachInline(string& sAttachName, string& sInlineBodyText)
{
#define MAX_BUF	2048

	DWORD 	dwRetVal 	= 0;
	DWORD	dwWritten	= 0;
	UINT 	uRetVal   	= 0;
	BOOL 	fSuccess  	= FALSE;
	HANDLE 	hTempFile	= INVALID_HANDLE_VALUE;
	TCHAR 	szTempFileName[MAX_PATH];
	TCHAR 	lpTempPathBuffer[MAX_PATH];
	TCHAR	lpTempBuffer[MAX_BUF];
	bool	ret 		= false;

	m_pLogger->detail("Entering addAttachInline()...");
	m_pLogger->detail(string("addAttachInline(): sAttachName=") + sAttachName);
	m_pLogger->detail(string("addAttachInline(): sInlineBodyText=") + sInlineBodyText);
	
	// Gets the temp path env string (no guarantee it's a valid path).
	// From https://msdn.microsoft.com/en-us/library/windows/desktop/aa363875(v=vs.85).aspx
	m_pLogger->detail("addAttachInline: About to call GetTempPath()...");
    	dwRetVal = GetTempPath(MAX_PATH, lpTempPathBuffer); 
    	if (dwRetVal > MAX_PATH || (dwRetVal == 0))
    	{
        	m_pLogger->detail("addAttachInline: GetTempPath() failed.");
		goto Quit;
    	}
	
	// Generate a temporary file name. 
	m_pLogger->detail("addAttachInline: About to call GetTempFileName()...");
    	uRetVal = GetTempFileName(	lpTempPathBuffer, 	// directory for tmp files
					TEXT("addAttachInline"),// temp file name prefix 
                              		0,                	// create unique name 
                              		szTempFileName);  	// buffer for name 
    	if (uRetVal == 0) 
	{
        	m_pLogger->detail("addAttachInline: GetTempFileName() failed.");
		goto Quit;
	}
 
    	// Create a temporary file using our temporary file name.
	m_pLogger->detail("addAttachInline: About to call CreateFile()...");
    	hTempFile = CreateFile(	(LPTSTR) szTempFileName, // file name 
                           	GENERIC_WRITE,        	// open for write 
                           	0,                    	// do not share 
                           	NULL,                 	// default security 
                           	CREATE_ALWAYS,        	// overwrite existing
                           	FILE_ATTRIBUTE_NORMAL,	// normal file 
                           	NULL);                	// no template 
    	if (hTempFile == INVALID_HANDLE_VALUE) 
    	{	 
        	m_pLogger->detail("addAttachInline: CreateFile() failed.");
		goto Quit;
	}
  
	// Write text to our temporary file.
	lstrcpy(lpTempBuffer, sInlineBodyText.c_str());
	m_pLogger->detail(string("addAttachInline: About to call WriteFile(): ") + sInlineBodyText + "...");
	fSuccess = WriteFile(	hTempFile, 
				lpTempBuffer, 
				lstrlen(lpTempBuffer),
				&dwWritten, 
				NULL	); 
    	if (!fSuccess) 
    	{
		m_pLogger->detail("addAttachInline: WriteFile() failed.");
		goto Quit;
	}
	
	if (hTempFile != INVALID_HANDLE_VALUE)
	{
		CloseHandle(hTempFile);
		hTempFile = INVALID_HANDLE_VALUE;
	}

	// Add the attachment to the MSG.
	m_pLogger->detail("addAttachInline: About to call addAttachFile()...");
	ret = addAttachFile(sAttachName, string(szTempFileName));
  
	// Delete the temporary file.
	m_pLogger->detail("addAttachInline: About to DeleteFile()...");
	DeleteFile(szTempFileName);
	
Quit:
	if (hTempFile != INVALID_HANDLE_VALUE)
		CloseHandle(hTempFile);
	
	m_pLogger->detail("Leaving addAttachInline()...");
	return ret;
}

bool
Msg::addAttachFile(string& sAttachName, string& sAttachPath)
{
	HRESULT		hRes;
	LPSTREAM	pStrmSrc = NULL;
	LPSTREAM	pStrmDest = NULL;
	ULONG		ulAttNum;
	LPATTACH	pAtt = NULL;
	STATSTG		StatInfo;
	TCHAR		szFileName[MAX_PATH];
	
	enum 		{ FILENAME, METHOD, RENDERING, NUM_ATT_PROPS };
	SPropValue	spvAttachProps[NUM_ATT_PROPS];
		
	m_pLogger->detail("Entering addAttachFile()...");
	m_pLogger->detail("addAttachFile(): sAttachNme=" + sAttachName);
	m_pLogger->detail("addAttachFile(): sAttachPath=" + sAttachPath);
		
	if (!OpenMsg())
	{
		m_pLogger->error("addAttachFile(): Msg could not be opened");
		goto Quit;
	}

	m_pLogger->detail("addAttachFile(): About to call OpenStreamOnFile()...");
	if (FAILED(hRes = OpenStreamOnFile(	MAPIAllocateBuffer,
						MAPIFreeBuffer,
						STGM_READ,
						sAttachPath.c_str(),
						NULL,
						&pStrmSrc))) {
		goto Quit;
	}
	
	m_pLogger->detail("addAttachFile(): About to call CreateAttach()...");
	if (FAILED(hRes = m_pIMessage->CreateAttach( NULL, 0, &ulAttNum, &pAtt ))) {
		goto Quit;
	}
	
	m_pLogger->detail("addAttachFile(): About to call OpenProperty()...");
	if (FAILED(hRes = pAtt->OpenProperty(	PR_ATTACH_DATA_BIN, 
						(LPIID)&IID_IStream, 0,
						MAPI_MODIFY | MAPI_CREATE, 
						(LPUNKNOWN *)&pStrmDest	))) {
		goto Quit;
	}
	
	m_pLogger->detail("addAttachFile(): About to call Stat()...");
	pStrmSrc->Stat(&StatInfo, STATFLAG_NONAME);
	
	m_pLogger->detail("addAttachFile(): About to call CopyTo()...");
	if (FAILED(hRes = pStrmSrc->CopyTo(pStrmDest, StatInfo.cbSize, NULL, NULL))) {
		goto Quit;
	}
	
	spvAttachProps[FILENAME].ulPropTag 	= PR_ATTACH_FILENAME;
	lstrcpy(szFileName, sAttachName.c_str());
	spvAttachProps[FILENAME].Value.lpszA 	= szFileName;
	
	spvAttachProps[METHOD].ulPropTag 	= PR_ATTACH_METHOD;
	spvAttachProps[METHOD].Value.l		= ATTACH_BY_VALUE;
	
	spvAttachProps[RENDERING].ulPropTag 	= PR_RENDERING_POSITION;
	spvAttachProps[RENDERING].Value.l 	= -1;
	
	m_pLogger->detail("addAttachFile(): About to call SetProps()...");
	if (FAILED(hRes = pAtt->SetProps(NUM_ATT_PROPS, (LPSPropValue)&spvAttachProps, NULL))) {
		goto Quit;
	}
	
	m_pLogger->detail("addAttachFile(): About to call IAttach->SaveChanges()...");
	pAtt->SaveChanges(0);
	
	m_pLogger->detail("addAttachFile(): About to call IMessage->SaveChanges()...");
	m_pIMessage->SaveChanges(KEEP_OPEN_READWRITE);
	
	m_pLogger->detail("addAttachFile(): About to call IStorage->Commit()...");
	m_pIStorage->Commit(STGC_DEFAULT);
	
Quit:
	if (pStrmDest)
		pStrmDest->Release();
	if (pStrmSrc)
		pStrmSrc->Release();
	if (pAtt)
		pAtt->Release();

	m_pLogger->detail("Leaving addAttachFile()...");
	return FAILED(hRes) == FALSE;
}
