#ifndef _PST_STORE_SESSION_H
#define _PST_STORE_SESSION_H

#include <mapix.h>

#include "Logger.h"
#include "Session.h"
#include "PSTProfile.h"
#include "PSTFolder.h"

class PSTStoreSession
{
private:
	Session*	 	m_pSession;
	Logger* 		m_pLogger;
	PSTProfile*		m_pPSTProfile;
	
	LPMAPISESSION 	m_pWriteSession;
	IMsgStore 		*m_pIMsgStore;
	
	PSTFolder		m_pPSTFolder;
	
public:
	PSTStoreSession(std::string profileName, std::string pstFileName, Session* pSession);
	~PSTStoreSession();

	bool open();
	bool close();
	bool createProfile();
	bool deleteProfile();
	bool createPSTFile();
	bool writeMsg(const std::string& msgFilePath, const std::string& folderPath);
	IMsgStore* getMsgStore() { return m_pIMsgStore; }
	bool WriteIMessageToPST(LPMESSAGE lpIMessage, LPMAPIFOLDER lpFolder);
	bool copyIMessage(LPMESSAGE lpIMessageSrc, LPMESSAGE lpIMessageDst);
	
	static std::string convertHRESULTtoHex(HRESULT hRes);
	std::string GetLastError(HRESULT hRes);
};
#endif
