#include <sstream>
#include <cassert>

#include "PSTStoreSession.h"

using namespace std;

PSTStoreSession::PSTStoreSession(string profileName, string pstFileName, Session* pSession)
	:m_pPSTProfile(NULL), m_pSession(pSession)
{
	m_pLogger = Logger::getLogger("PSTSTORESESSION");
	
	m_pPSTProfile = new PSTProfile(profileName, pstFileName);
}

PSTStoreSession::~PSTStoreSession()
{
	if (m_pPSTProfile != NULL) {
		delete m_pPSTProfile;
	}
}

bool
PSTStoreSession::createPSTFile()
{
	return false;
}

bool
PSTStoreSession::deleteProfile()
{
	return m_pPSTProfile->deleteProfile();
}

bool
PSTStoreSession::createProfile()
{
	return m_pPSTProfile->createProfile();
}

bool
PSTStoreSession::close()
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
