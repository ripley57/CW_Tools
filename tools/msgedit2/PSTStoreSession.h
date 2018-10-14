#ifndef _PST_STORE_SESSION_H
#define _PST_STORE_SESSION_H

#include <mapix.h>
#include "Logger.h"
#include "Session.h"

class PSTStoreSession
{
private:
	Session*	 	m_pSession;
	
	std::string		m_profileName;
	std::string		m_PSTFileName;
	
	Logger* 		m_pLogger;
	
public:
	PSTStoreSession(string profileName, string pstFileName, Session* pSession);
	~PSTStoreSession();

	bool deleteProfile();
	bool close();
	bool createProfile();

	static std::string convertHRESULTtoHex(HRESULT hRes);
	std::string GetLastError(HRESULT hRes);
};
#endif
