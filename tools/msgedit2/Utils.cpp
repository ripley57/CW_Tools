#include <string>
#include <sstream>
#include <vector>
#include <windows.h>
#include <strsafe.h>

void DisplayError(LPTSTR lpszFunction) 
{ 
    // Retrieve the system error message for the last-error code

    LPVOID lpMsgBuf;
    LPVOID lpDisplayBuf;
    DWORD dw = GetLastError(); 

    FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | 
        FORMAT_MESSAGE_FROM_SYSTEM |
        FORMAT_MESSAGE_IGNORE_INSERTS,
        NULL,
        dw,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPTSTR) &lpMsgBuf,
        0, NULL );

    // Display the error message and exit the process

    lpDisplayBuf = (LPVOID)LocalAlloc(LMEM_ZEROINIT, 
        (lstrlen((LPCTSTR)lpMsgBuf) + lstrlen((LPCTSTR)lpszFunction) + 40) * sizeof(TCHAR)); 
    StringCchPrintf((LPTSTR)lpDisplayBuf, 
        LocalSize(lpDisplayBuf) / sizeof(TCHAR),
        TEXT("%s failed with error %d: %s"), 
        lpszFunction, dw, lpMsgBuf); 
    MessageBox(NULL, (LPCTSTR)lpDisplayBuf, TEXT("Error"), MB_OK); 

    LocalFree(lpMsgBuf);
    LocalFree(lpDisplayBuf);
}

std::string bool_as_text(bool b)
{
    std::stringstream converter;
    converter << std::boolalpha << b;   // flag boolalpha calls converter.setf(std::ios_base::boolalpha)
    return converter.str();
}

std::string int_as_text(int i)
{
    std::stringstream ss;
	ss << i;
	return ss.str();
}

std::wstring cstr2wstring(char *text)
{
	int			len		= 0;
	wchar_t		*retVal	= NULL;

	if(text == NULL)
		return(NULL);
	len = strlen(text);
	retVal = (wchar_t *)calloc(len+1, sizeof(wchar_t));
	MultiByteToWideChar(CP_ACP, 0, text, -1, retVal, len);
	std::wstring ret = std::wstring(retVal);
	delete retVal;
	return ret;
}

std::wstring string2wstring(const std::string &str)
{
    if(str.empty())
        return L"";
    std::vector<wchar_t> res(str.size()*2); // should be enough

    int size = MultiByteToWideChar(CP_ACP, 0, str.c_str(), (int)str.size(), &res.at(0), (int)res.size());
	if(size) {
        return std::wstring(&res.at(0), size);
    }
    return L"";
}

std::vector<std::wstring> split(const std::wstring& str, const std::wstring& sep)
{
    std::vector<std::wstring> ret;
    for (size_t pos = 0; pos <= str.size();) {
        size_t new_pos = str.find( sep, pos);
        if(std::string::npos == new_pos)
            new_pos = str.size();
        ret.push_back( str.substr( pos, new_pos - pos));
        pos = new_pos + sep.size();
    }
    return ret;
}
