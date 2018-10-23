#include <sstream>
#include <cassert>

#include "PSTWriter.h"
#include "PSTStoreSession.h"
#include "Utils.h"

using namespace std;

PSTWriter::PSTWriter(string pstFileName, Session* pSession)
	:m_PSTFileName(pstFileName),
	m_rootFolder("@PR_IPM_SUBTREE_ENTRYID"),
	m_pSession(pSession),
	m_pPSTStoreSession(NULL)
{
	m_pLogger = Logger::getLogger("PSTWRITER");
	m_pLogger->detail("PSTWriter::PSTWriter() Entering...");
	
	m_profileName = createProfileName();
	m_pPSTStoreSession = new PSTStoreSession(m_profileName, m_PSTFileName, m_pSession);
	
	m_pLogger->detail("PSTWriter::PSTWriter() Exiting...");
}

PSTWriter::~PSTWriter()
{
	m_pLogger->detail("PSTWriter::~PSTWriter() Entering...");
	
	close();
	
	m_pLogger->detail("PSTWriter::~PSTWriter() Exiting...");
}

bool
PSTWriter::open()
{
	m_pLogger->detail("PSTWriter::open() Entering...");
	
	assert(m_pPSTStoreSession != NULL);
	bool ret = m_pPSTStoreSession->open();
	
	m_pLogger->detail("PSTWriter::open() Exiting... ret=" + bool_as_text(ret));
	return ret;
}

bool
PSTWriter::close()
{
	m_pLogger->detail("PSTWriter::close() Entering...");
	
	bool ret = true;
	if (m_pPSTStoreSession != NULL) {
		ret = m_pPSTStoreSession->close();
		delete m_pPSTStoreSession;
		m_pPSTStoreSession = NULL;
	}
	
	m_pLogger->detail("PSTWriter::close() Exiting... ret=" + bool_as_text(ret));
	return ret;
}

#define PST_WRITER_PROFILE_NAME "PSTWriter_msgedit2"
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
	string sErr("unknown");
	assert(m_pSession != NULL);
	sErr = m_pSession->GetLastError(hRes);
	return sErr;
}