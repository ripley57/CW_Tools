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
}

PSTProfile::~PSTProfile()
{
}

bool
PSTProfile::createProfile()
{
	IProfAdmin	*iProfAdmin = NULL;
	HRESULT hRes = MAPIAdminProfiles(0, &iProfAdmin);
	if (FAILED(hRes)) {
		m_pLogger->error("PSTProfile::createProfile: MAPIAdminProfiles failed with error: " + convert2hex(hRes));
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
		return false;
	}
	
	return true;
}

bool 
PSTProfile::deleteProfile()
{
	IProfAdmin	*iProfAdmin = NULL;
	
	m_pLogger->debug("PSTProfile::deleteProfile: Calling MAPIAdminProfiles() ...");
	HRESULT hRes = MAPIAdminProfiles(0, &iProfAdmin);
	if (FAILED(hRes)) {
		m_pLogger->error("PSTProfile::deleteProfile: MAPIAdminProfiles() failed with error: " + convert2hex(hRes));
		false;
	}
	MapiResource iProfAdminResource(iProfAdmin);
	
	m_pLogger->debug("PSTProfile::deleteProfile: Calling IProfAdmin::DeleteProfile() ...");
	hRes = iProfAdmin->DeleteProfile(reinterpret_cast<LPTSTR>(const_cast<LPSTR>(m_profileName.c_str())), 0);
	if (FAILED(hRes)) {
		m_pLogger->error("PSTProfile::deleteProfile: IProfAdmin::DeleteProfile() failed with error: " + convert2hex(hRes));
		return false;
	}
	
	return true;
}

string
PSTProfile::convert2hex(HRESULT hRes)
{
	stringstream ss;
	ss << std::hex << hRes;
	return ss.str();
}
