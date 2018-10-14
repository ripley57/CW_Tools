#include <sstream>
#include <cassert>
#include "PSTWriter.h"
#include "PSTStoreSession.h"

using namespace std;

PSTWriter::PSTWriter(string pstFileName, Session* pSession)
	:m_PSTFileName(pstFileName),
	m_rootFolder("@PR_IPM_SUBTREE_ENTRYID"),
	m_pSession(pSession)
{
	m_pLogger = Logger::getLogger("PSTWRITER");
	
	m_profileName = createProfileName();
	m_pPSTStoreSession = new PSTStoreSession(m_profileName, m_PSTFileName, m_pSession);
}

PSTWriter::~PSTWriter()
{
	if (m_pPSTStoreSession != NULL) {
		m_pPSTStoreSession->deleteProfile();
		m_pPSTStoreSession->close();
	}
}

bool
PSTWriter::open()
{
	bool ret = m_pPSTStoreSession->createProfile();
	return ret;
}

bool
PSTWriter::close()
{
	return false;
}

#define PST_WRITER_PROFILE_NAME "PSTWriter"
string
PSTWriter::createProfileName()
{
	string profileName = PST_WRITER_PROFILE_NAME;
	return profileName;
}

string
PSTWriter::convertHRESULTtoHex(HRESULT hRes)
{
	stringstream ss;
	ss << std::hex << hRes;
	return ss.str();
}

string
PSTWriter::GetLastError(HRESULT hRes)
{
	string		sErr("unknown");
	
	assert(m_pSession != NULL);
	sErr = m_pSession->GetLastError(hRes);
	
	return sErr;
}