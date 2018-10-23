#include <sstream>
#include <cassert>

#include <mapix.h>
#include <mapiutil.h>

#include "PSTProfile.h"
#include "SmartPointers.h"

using namespace std;

PSTProfile::PSTProfile(string profileName, string pstFileName)
	:m_profileName(profileName),m_pstFileName(pstFileName)
{
	m_pLogger = Logger::getLogger("PSTPROFILE");
	m_pLogger->debug("PSTProfile::PSTProfile() Entering...");
	m_pLogger->debug("PSTProfile::PSTProfile() Exiting...");
}

PSTProfile::~PSTProfile()
{
	m_pLogger->debug("PSTProfile::~PSTProfile() Entering...");
	m_pLogger->debug("PSTProfile::~PSTProfile() Exiting...");
}

bool
PSTProfile::createProfile()
{
	m_pLogger->debug("PSTProfile::PSTProfile() Entering...");
		
	IProfAdmin	*iProfAdmin = NULL;
	HRESULT hRes = MAPIAdminProfiles(0, &iProfAdmin);
	if (FAILED(hRes)) {
		m_pLogger->error("PSTProfile::createProfile: MAPIAdminProfiles failed with error: " + convert2hex(hRes));
		m_pLogger->debug("PSTProfile::createProfile() Exiting... " + __LINE__);
		return false;
	}
	MapiResource iProfAdminResource(iProfAdmin);
	
	m_pLogger->info("PSTProfile::createProfile: Calling iProfAdmin::CreateProfile() ...");
	hRes = iProfAdmin->CreateProfile(reinterpret_cast<LPTSTR>(const_cast<LPSTR>(m_profileName.c_str())), NULL, 0, 0);
	if (FAILED(hRes)) {
		m_pLogger->error("PSTProfile::createProfile: iProfAdmin::CreateProfile() failed with error: " + convert2hex(hRes));
		if (hRes == MAPI_E_NO_ACCESS) {
			m_pLogger->error("iProfAdmin::CreateProfile() failed with MAPI_E_NO_ACCESS. The profile already exists: " + m_profileName);
		}
		m_pLogger->debug("PSTProfile::createProfile() Exiting... " + __LINE__);
		return false;
	}
	
	m_pLogger->debug("PSTProfile::createProfile() Exiting...");
	return true;
}

bool 
PSTProfile::deleteProfile()
{
	m_pLogger->debug("PSTProfile::deleteProfile() Entering...");
	
	IProfAdmin	*iProfAdmin = NULL;
	
	m_pLogger->debug("PSTProfile::deleteProfile: Calling MAPIAdminProfiles() ...");
	HRESULT hRes = MAPIAdminProfiles(0, &iProfAdmin);
	if (FAILED(hRes)) {
		m_pLogger->error("PSTProfile::deleteProfile: MAPIAdminProfiles() failed with error: " + convert2hex(hRes));
		m_pLogger->debug("PSTProfile::deleteProfile() Exiting... " + __LINE__);
		false;
	}
	MapiResource iProfAdminResource(iProfAdmin);
	
	m_pLogger->debug("PSTProfile::deleteProfile: Calling IProfAdmin::DeleteProfile() ...");
	hRes = iProfAdmin->DeleteProfile(reinterpret_cast<LPTSTR>(const_cast<LPSTR>(m_profileName.c_str())), 0);
	if (FAILED(hRes)) {
		m_pLogger->error("PSTProfile::deleteProfile: IProfAdmin::DeleteProfile() failed with error: " + convert2hex(hRes));
		m_pLogger->debug("PSTProfile::deleteProfile() Exiting... " + __LINE__);
		return false;
	}
	
	m_pLogger->debug("PSTProfile::deleteProfile() Exiting...");
	return true;
}

string
PSTProfile::convert2hex(HRESULT hRes)
{
	stringstream ss;
	ss << std::hex << hRes;
	return ss.str();
}
