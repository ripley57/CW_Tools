#ifndef _PST_PROFILE_H
#define _PST_PROFILE_H

#include <mapix.h>
#include <iostream>

#include "Logger.h"

class PSTProfile
{
private:	
	Logger* 		m_pLogger;
	
public:
	PSTProfile();
	~PSTProfile();
	
	bool createProfile();
	bool deleteProfile();
};
#endif
