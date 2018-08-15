#include <mapix.h>
#include <iostream>

#include "Logger.h"

#ifndef _SESSION_H
#define _SESSION_H
class Session
{
private:
	bool			m_initialized;
	LPMAPISESSION 	m_pSession;
	LPADRBOOK		m_pAddrBook;
		
	Logger* 		m_pLogger;
	
public:
	Session();
	~Session();

	bool is_initialized()	{	return m_initialized;	}
	bool initialize();	
	bool logon();
	
	static std::string convertHRESULTtoHex(HRESULT hRes);
	std::string GetLastError(HRESULT hRes);
	
	LPADRBOOK getAddressBook() { return m_pAddrBook; }
};
#endif
