#include <sstream>
#include <cassert>

#include <mapix.h>
#include <mapiutil.h>

#include "PSTStoreSession.h"
#include "PSTFolder.h"
#include "SmartPointers.h"
#include "Utils.h"

PSTFolder::PSTFolder()
	:m_pIMsgStore(NULL)
{
	m_pLogger = Logger::getLogger("PSTFOLDER");
	m_pLogger->detail("PSTFolder::PSTFolder() Entering...");
	
	m_pLogger->detail("PSTFolder::PSTFolder() Exiting...");
}

PSTFolder::~PSTFolder()
{
	m_pLogger->detail("PSTFolder::~PSTFolder() Entering...");
	
	m_pLogger->detail("PSTFolder::~PSTFolder() Exiting...");
}

bool
PSTFolder::createRootFolder(PSTStoreSession *pPSTSession, const std::wstring& rootFolder, LPMAPIFOLDER *ppMapiFolder)
{
	m_pLogger->detail("PSTFolder::createRootFolder() Entering...");

	std::vector<std::wstring> dirs = split(rootFolder, L"\\");
	
	LPSPropValue	lpEid = NULL;
	HRESULT hRes = ::HrGetOneProp(pPSTSession->getMsgStore(),PR_IPM_SUBTREE_ENTRYID,&lpEid);
	if (FAILED(hRes)) {
		return false;
	}
	MapiBufferResource lpEidBufferRes(lpEid);
	
	// Open the IPM subtree folder.
	ULONG ulObjType = 0;
	LPMAPIFOLDER    currentFolder = NULL;
	hRes = pPSTSession->getMsgStore()->OpenEntry(lpEid->Value.bin.cb,(LPENTRYID)lpEid->Value.bin.lpb,NULL,0x10,&ulObjType,reinterpret_cast<IUnknown**>(&currentFolder));
	if (FAILED(hRes)) {
		return false;
	}
	MapiResource lpFolderResource(currentFolder);	
		
	for (size_t i = 0; i < dirs.size(); ++i) {
        if (dirs[i].size() == 0)
            continue;
		LPMAPIFOLDER newFolder = NULL;
        hRes = currentFolder->CreateFolder(FOLDER_GENERIC,(LPTSTR)dirs[i].c_str(),NULL,NULL,1|OPEN_IF_EXISTS | MAPI_UNICODE,&newFolder);
		if (FAILED(hRes)) {
			return false;
		}
		currentFolder->SaveChanges(KEEP_OPEN_READWRITE);
		currentFolder = newFolder;
		*ppMapiFolder = newFolder;
	}
	
	m_pLogger->detail("PSTFolder::createRootFolder() Exiting...");
	return true;
}

string
PSTFolder::convertHRESULTtoHex(HRESULT hRes)
{
	stringstream ss;
	ss << std::hex << hRes;
	return ss.str();
}
