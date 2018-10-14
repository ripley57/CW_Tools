#ifndef _PST_WRITER_H
#define _PST_WRITER_H

#include <mapix.h>
#include <iostream>

#include "Logger.h"
#include "Session.h"
#include "PSTStoreSession.h"

class PSTWriter
{
private:	
	Session			*m_pSession;
	PSTStoreSession	*m_pPSTStoreSession;
	
	std::string 	m_PSTFileName;
	std::string 	m_rootFolder;
	std::string 	m_profileName;
	
	Logger* 		m_pLogger;
	
public:
	PSTWriter(string pstFileName, Session *pSession);
	~PSTWriter();

	bool open();
	bool close();
	std::string createProfileName();
	std::string getPSTFileName() { return m_PSTFileName; }
	
	static std::string convertHRESULTtoHex(HRESULT hRes);
	std::string GetLastError(HRESULT hRes);
};
#endif
