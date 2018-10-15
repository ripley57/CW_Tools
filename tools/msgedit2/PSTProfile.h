#ifndef _PST_PROFILE_H
#define _PST_PROFILE_H

#include <mapix.h>
#include <iostream>

#include "Logger.h"

class PSTProfile
{
private:	
	Logger* 		m_pLogger;
	
	std::string		m_profileName;
	std::string 	m_pstFileName;
	
	std::string convert2hex(HRESULT hRes);
	
public:
	PSTProfile(string profileName, string pstFileName);
	~PSTProfile();
	
	bool createProfile();
	bool deleteProfile();
	std::string getProfileName() { return m_profileName; }
	std::string getPstFileName() { return m_pstFileName; }
};
#endif
