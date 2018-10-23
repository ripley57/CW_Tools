#include <windows.h>

string convertHRESULTtoHex(HRESULT hRes);
std::string bool_as_text(bool b);
std::string int_as_text(int i);
wstring cstr2wstring(char *text);
std::wstring string2wstring(const std::string &str);
std::vector<std::wstring> split(const std::wstring& str, const std::wstring& sep);
