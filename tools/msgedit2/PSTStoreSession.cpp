#include <sstream>
#include <cassert>
#include "PSTStoreSession.h"

using namespace std;

PSTStoreSession::PSTStoreSession(string profileName, string pstFileName, Session* pSession)
	:m_profileName(profileName),m_PSTFileName(pstFileName),m_pSession(pSession)
{
	m_pLogger = Logger::getLogger("PSTSTORESESSION");
}

PSTStoreSession::~PSTStoreSession()
{
}

bool
PSTStoreSession::deleteProfile()
{
	return false;
}

bool
PSTStoreSession::close()
{
	return false;
}

bool
PSTStoreSession::createProfile()
{
	return false;
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
	string		sErr("unknown");
	
	assert(m_pSession != NULL);
	sErr = m_pSession->GetLastError(hRes);

	return sErr;
}
