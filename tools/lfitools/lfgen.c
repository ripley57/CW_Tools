#include <windows.h>
#include <tchar.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <strsafe.h>

/*
** For basename() on Linux/Cygwin
** Need to use _splitpath on Windows.
#include <libgen.h>
*/

int bDebug = 0;

void PrintUsage(char *progname)
{
	fprintf(stderr,
		"\n"
		"%s\n\n"
		"Description:\n"
		"  This program is used to generate records in a load file.\n"
		"  Consecutive records are given an increasing identifier.\n"
		"  If multiple format strings are specified, those after\n"
		"  the first format string are considered format strings for\n"
		"  child records. A child record format string is expected to\n"
		"  have at least two numeric inserts. The second insert will\n"
		"  be given the value of the parent identifier.\n"
		"\n"
		"Usage:\n"
		"  %s <min> <max> <fmt> [<fmt2> <fmt3> ... <fmtN>]\n"
		"\n"
		"  min  - starting unique identifier\n"
		"  max  - ending unique identifier\n"
		"  fmt  - format string of parent record\n"
		"  fmt2 - format string of first child record\n" 
		"  fmt3 - format string of second child record\n"
		"  fmtN - format string of N-1 child record\n"
		"\n"
		"Examples:\n"
		"  Create two parent records:\n"  
        "    %s 1 2 \"hello %%lu\"\n"
        "    hello 1\n"
		"    hello 2\n"
		"\n"
		"  Create two parent records, each with one child record:\n"
		"    %s 1 4 \\\"%%06lu\\\",\\\"\\\",\\\"capture%%03lu.jpg\\\" \\\"%%06lu\\\",\\\"%%06lu\\\",\\\"attach%%05lu.txt\\\"\n"
        "    \"000001\",\"\",\"capture001.jpg\"\n"
        "    \"000002\",\"000001\",\"attach0002.txt\"\n"
        "    \"000003\",\"\",\"capture003.jpg\"\n"
        "    \"000004\",\"000003\",\"attach0004.txt\"\n"
    	"\n",
		progname, progname, progname, progname);
}

// http://msdn.microsoft.com/en-gb/library/windows/desktop/ms680582(v=vs.85).aspx
void Error(LPTSTR lpszFunction)
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

        printf("ERROR: %s\n", lpDisplayBuf);
    // MessageBox(NULL, (LPCTSTR)lpDisplayBuf, TEXT("Error"), MB_OK);

    LocalFree(lpMsgBuf);
    LocalFree(lpDisplayBuf);
    //ExitProcess(dw);
}

void PrintIt(const char* fmt, ...)
{
    va_list argptr;
    va_start(argptr, fmt);
    vfprintf(stdout, fmt, argptr);
    va_end(argptr);
	fflush(stdout);
    printf("\n");
	fflush(stdout);
}

TCHAR* ProgName(LPCTSTR progname)
{
	static TCHAR  AbsPath[MAX_PATH + 1];
	LPTSTR lpFilePath;
	
	if (GetFullPathName(progname, MAX_PATH, AbsPath, &lpFilePath) == 0) {
        Error(_T("GetFullPathName"));
        return NULL;
    }

	return lpFilePath;
}

int CountInserts(char *fmt)
{
	int nCount = 0;
	char *p = fmt;
	int nLen = strlen(fmt);
	int i = 0;
	
	if (bDebug) printf("fmt=%s\n", fmt);
	while (i < nLen) {
		if (p[i] == '%') 
			nCount++;
		i++;
	}
	if (bDebug) printf("nCount=%d\n", nCount);
	return nCount;
}

int main(int argc, char* argv[])
{
	long  min;
	long  max;
	char **fmt;
	int   nfmt;
	unsigned long l;
	unsigned long ll;
	int num;
	
	if (argc < 4 || (argc == 2 && !stricmp(argv[1], "-h"))) {
		PrintUsage(ProgName(argv[0]));
		return(1);
	}
	
	min = atol(argv[1]);
	max = atol(argv[2]);
	fmt = &argv[3];
	nfmt = argc - 3;
	
	if (min > max) {
		fprintf(stderr, "bad min/max value!\n");
		return(1);
	}

	for (l=min; l<=max;) {
		unsigned long i;
		for (i=0L; i<nfmt; i++) {
			ll = l + i;
			if (bDebug) { printf("DEBUG: l=%lu, ll=%lu, fmt=%s\n", l, ll, fmt[i]); }
			num = CountInserts(fmt[i]);
			switch (num) {
			case 1:	PrintIt(fmt[i], ll);							break;
			case 2:	PrintIt(fmt[i], ll, l);							break;
			case 3:	PrintIt(fmt[i], ll, l, ll);						break;
			case 4:	PrintIt(fmt[i], ll, l, ll, ll);					break;
			case 5:	PrintIt(fmt[i], ll, l, ll, ll, ll);				break;
			case 6:	PrintIt(fmt[i], ll, l, ll, ll, ll, ll);			break;
			case 7:	PrintIt(fmt[i], ll, l, ll, ll, ll, ll, ll);		break;
			case 8:	PrintIt(fmt[i], ll, l, ll, ll, ll, ll, ll, ll);	break;
			case 9:	PrintIt(fmt[i], ll, l, ll, ll, ll, ll, ll, ll, ll);break;
			case 10:	PrintIt(fmt[i], ll, l, ll, ll, ll, ll, ll, ll, ll, ll);break;
			case 11:	PrintIt(fmt[i], ll, l, ll, ll, ll, ll, ll, ll, ll, ll, ll);break;
			case 12:	PrintIt(fmt[i], ll, l, ll, ll, ll, ll, ll, ll, ll, ll, ll, ll);break;
			case 13:	PrintIt(fmt[i], ll, l, ll, ll, ll, ll, ll, ll, ll, ll, ll, ll, ll);break;
			case 14:	PrintIt(fmt[i], ll, l, ll, ll, ll, ll, ll, ll, ll, ll, ll, ll, ll, ll);break;
			case 15:	PrintIt(fmt[i], ll, l, ll, ll, ll, ll, ll, ll, ll, ll, ll, ll, ll, ll, ll);break;
			}
		}
		l = ll + 1;
	}

	return(0);
}
