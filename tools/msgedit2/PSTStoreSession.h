#include <mapix.h>

#include "Logger.h"

#ifndef _PST_STORE_SESSION_H
#define _PST_STORE_SESSION_H
class PSTStoreSession
{
private:
	LPMAPISESSION 	m_pSession;
	
	Logger* 		m_pLogger;
	
public:
	PSTStoreSession();
	~PSTStoreSession();

	static std::string convertHRESULTtoHex(HRESULT hRes);
	std::string GetLastError(HRESULT hRes);
};
#endif
