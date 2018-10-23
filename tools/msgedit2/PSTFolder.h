#ifndef _PST_FOLDER_H
#define _PST_FOLDER_H

#include <mapix.h>

#include "Logger.h"

class PSTStoreSession;

class PSTFolder
{
private:
	Logger* 		m_pLogger;
	IMsgStore 		*m_pIMsgStore;
	
public:
	PSTFolder();
	~PSTFolder();

	IMsgStore* getMsgStore() { return m_pIMsgStore; }
	bool createRootFolder(PSTStoreSession *pPSTSession, const std::wstring& rootFolder, LPMAPIFOLDER *ppMapiFolder);
		
	static std::string convertHRESULTtoHex(HRESULT hRes);
};
#endif
