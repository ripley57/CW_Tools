/*
** Various utility functions, mainly for string manipulation.
**
** Note: The following is a good refresher of char, w_char, TCHAR etc:
** https://www.codeproject.com/Articles/2995/The-Complete-Guide-to-C-Strings-Part-I-Win32-Chara
**
** JeremyC 6/6/2017
*/

#include <tchar.h>
#include <sstream>

#include "Utils.h"

tstring trimright(tstring str)
{
	size_t endpos = str.find_last_not_of(_T(" \t"));
	if(tstring::npos != endpos) str = str.substr(0, endpos+1);
	return str;
}

tstring trimleft(tstring str)
{
	size_t startpos = str.find_first_not_of(_T(" \t\\"));
	if(tstring::npos != startpos) str = str.substr(startpos);
	return str;
}

tstring trim(tstring str)
{
	return trimleft(trimright(str));
}

tstring convert2hex(HRESULT hRes)
{
	tstringstream ss;
	ss << std::hex << hRes;
	return ss.str();
}

tstring removefileextension(const tstring& filename) {
    size_t lastdot = filename.find_last_of(_T("."));
    if (lastdot == tstring::npos) return filename;
    return filename.substr(0, lastdot); 
}

tstring convertENTRYIDtostring(SPropValue* veid)
{
	tostringstream oss;
	for (unsigned int i = 0; i < veid->Value.bin.cb; i++) {
		if (i > 100)
			break;
		int byte = veid->Value.bin.lpb[i];
		TCHAR buf[4];
		_stprintf(buf, _T("%02x"), byte);
		oss << buf;
	}	
	return oss.str();
}

tstring convertFILETIMEtoUTC(FILETIME ft, int displayMSonly)
{
	// Convert to ULONGLONG.
	ULONGLONG qwResult;
    qwResult = (((ULONGLONG) ft.dwHighDateTime) << 32) + ft.dwLowDateTime;
	
	// Subtract Offset between January 1, 1601 UTC and midnight January 1, 1970 UTC 
    // in 100 ns intervals.
    qwResult -= 116444736000000000;
	
    // Truncate to milliseconds
    qwResult = qwResult / 10000;

	TCHAR buf[128];
	SYSTEMTIME st_utc;
	if (FileTimeToSystemTime(&ft, &st_utc) != 0) {
		if (displayMSonly) {
			_stprintf(buf, _T("%llu"), qwResult);
		} else {
			_stprintf(buf, _T("%02d/%02d/%04d %02d:%02d:%02d UTC"), 
			st_utc.wDay,  st_utc.wMonth,  st_utc.wYear, 
			st_utc.wHour, st_utc.wMinute, st_utc.wSecond,
			qwResult);
		}
	} else {
		_stprintf(buf, _T(""));
	}
	return tstring(buf);
}

wstring cstr2wstring(char *text)
{
	int			len		= 0;
	wchar_t		*retVal	= NULL;

	if(text == NULL)
		return(NULL);
	len = strlen(text);
	retVal = (wchar_t *)calloc(len+1, sizeof(wchar_t));
	MultiByteToWideChar(CP_ACP, 0, text, -1, retVal, len);
	wstring ret = wstring(retVal);
	delete retVal;
	return ret;
}

tstring wstring2tstring(const wstring& src)
{
#ifdef _UNICODE
	return src;
#else
	return wstring2string(src);
#endif
}

string wstring2string(const wstring& src)
{
	return string(src.begin(), src.end());
}

wstring string2wstring(const string& src)
{
	return wstring(src.begin(), src.end());
}

string tstring2string(const tstring& src)
{
#ifdef _UNICODE
	return wstring2string(src);
#else
	return src;
#endif
}

wstring tstring2wstring(const tstring& src)
{
#ifdef _UNICODE
	return src;
#else
	return string2wstring(src);
#endif
}

tstring string2tstring(const string& src)
{
#ifdef _UNICODE
	return string2wstring(src);
#else
	return src;
#endif
}