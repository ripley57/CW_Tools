#ifndef _PST_STORE_SESSION_H
#define _PST_STORE_SESSION_H

#include <mapix.h>

#include "Logger.h"
#include "Session.h"
#include "PSTProfile.h"

class PSTStoreSession
{
private:
	Session*	 	m_pSession;
	
	Logger* 		m_pLogger;
	
	PSTProfile*		m_pPSTProfile;
	
public:
	PSTStoreSession(std::string profileName, std::string pstFileName, Session* pSession);
	~PSTStoreSession();

	bool deleteProfile();
	bool close();
	bool createProfile();
	bool createPSTFile();

	static std::string convertHRESULTtoHex(HRESULT hRes);
	std::string GetLastError(HRESULT hRes);
};
#endif
