#ifndef UTILS_H
#define UTILS_H

#include <Windows.h>
#include <string>
#include <Mapidefs.h>

#include "CommonDefines.h"

using namespace std;

tstring convertFILETIMEtoUTC(FILETIME ft, int displayMSonly);
tstring convertENTRYIDtostring(SPropValue* veid);
tstring trimleft(tstring str);
tstring trimright(tstring str);
tstring trim(tstring str);
tstring removefileextension(const tstring& filename);
tstring convert2hex(HRESULT hRes);
tstring wstring2tstring(const wstring& src);
string wstring2string(const wstring& src);
wstring string2wstring(const string& src);
string tstring2string(const tstring& src);
tstring string2tstring(const string& src);
wstring tstring2wstring(const tstring& src);

#endif