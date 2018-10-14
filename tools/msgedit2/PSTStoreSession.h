#ifndef _PST_STORE_SESSION_H
#define _PST_STORE_SESSION_H

#include <mapix.h>
#include "Logger.h"

class PSTStoreSession
{
private:
	LPMAPISESSION 	m_pSession;
	
	std::string		m_profileName;
	std::string		m_PSTFileName;
	
	Logger* 		m_pLogger;
	
public:
	PSTStoreSession(string profileName, string pstFileName);
	~PSTStoreSession();

	bool deleteProfile();
	bool close();
	bool createProfile();

	static std::string convertHRESULTtoHex(HRESULT hRes);
	std::string GetLastError(HRESULT hRes);
};
#endif
