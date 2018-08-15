
#define tstricmp   _tcsicmp

#if defined(_UNICODE) || defined(UNICODE)

#define tstring std::wstring
#define tostream std::wostream 
#define tofstream std::wofstream 
#define tstringstream std::wstringstream
#define tostringstream std::wostringstream
#define tistream std::wistream 
#define tfilebuf std::wfilebuf
#define tistringstream std::wistringstream
#define tifstream std::wifstream
#define tcout std::wcout
#define tcin std::wcin
#define tcerr std::wcerr

#else //_UNICODE || UNICODE

#define tstring std::string
#define tofstream std::ofstream 
#define tstringstream std::tstringstream
#define tostringstream std::ostringstream
#define tistream std::istream
#define tfilebuf std::filebuf
#define tistringstream std::istringstream
#define tifstream std::ifstream
#define tostream std::ostream 
#define tcout std::cout
#define tcin std::cin
#define tcerr std::cerr

#endif 
