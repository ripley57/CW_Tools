#include <windows.h>
#include <tchar.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <strsafe.h>

int bDebug = 0;
int bVerbose = 1;

void PrintUsage(char *progname)
{
	fprintf(stderr,
		"\n"
		"%s\n\n"
		"Description:\n"
		"  This program is used to quickly generate duplicate\n"
		"  copies of files referenced in a load file.\n"
		"\n"
		"Usage:\n"
		"  %s <inpath> <min> <max> <outpathfmt>\n"
		"\n"
		"  inpath     - input file to be copied\n"
		"  min        - starting unique identifier\n"
		"  max        - ending unique identifier\n"
		"  outpathfmt - ouput file name format\n"
		"\n"
		"Examples:\n"
        	"  %s native\\capture.jpg 1 5 native\\capture%%06lu.jpg\n"
		"\n"
		"  %s native\\capture.jpg 1 5 native\\dir%%06lu\\capture%%06lu.jpg\n"
		"\n",
		progname, progname, progname, progname);
}

// http://msdn.microsoft.com/en-gb/library/windows/desktop/ms680582(v=vs.85).aspx
void ErrorExit(LPTSTR lpszFunction)
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
    ExitProcess(dw);
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

int CopyIt(LPWSTR inFilePath, LPWSTR outFilePath)
{
	if (bVerbose) { wprintf(L"CopyFile: in=%s, out=%s\n", inFilePath, outFilePath); }
	
	// CopyFile
	// http://msdn.microsoft.com/en-us/library/windows/desktop/aa363851(v=vs.85).aspx
	if (CopyFileW(inFilePath, outFilePath, FALSE) == 0) {
		wprintf(L"Could copy %s to %s, error %u\n", inFilePath, outFilePath, GetLastError());
        ErrorExit(TEXT("CopyFileW"));
	}
	return 1;
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
	
	while (i < nLen) {
		if (p[i] == '%') 
			nCount++;
		i++;
	}

	return nCount;
}


BOOL DirectoryExists(LPWSTR dirPath)
{
	HANDLE			fFile;		
	WIN32_FIND_DATA	fileinfo;	
	BOOL			bExists = FALSE;
	
	fFile = FindFirstFileW(dirPath, &fileinfo);
	if (fileinfo.dwFileAttributes == FILE_ATTRIBUTE_DIRECTORY)
	{
		//  Directory Exists
		bExists = TRUE;
	}
	
	FindClose(fFile);
	return bExists;
}
	

void CreateDirectoryTree(LPWSTR outFilePath)
{
	wchar_t *p;
		
    p = (wchar_t*)outFilePath;
	
	while (*p) 
	{
		if (*p == (wchar_t)'\\' || *p == (wchar_t)'/')
		{
			// Found directory separator.
			*p = (wchar_t)'\0';
			
			if (bDebug) { wprintf(L"CreateDirectoryTree: outFilePath=%s\n", outFilePath); }
			
			// Create the sub-directory.
			CreateDirectoryW(outFilePath, NULL);
			
			// Put back the directory separator. 
			*p = (wchar_t)'\\';
		}
		p++;
	}
}


void PrintIt(LPWSTR str, int len, LPWSTR fmt, ...)
{
    va_list argptr;
    va_start(argptr, fmt);
    vswprintf(str, len, fmt, argptr);
    va_end(argptr);
}


int main(int argc, char* argv[])
{
	char *inFile  = NULL;
	char* outFile = NULL;
	char *fmt;

	long  min;
	long  max;
	
	int num;
	
	wchar_t wInFile[_MAX_PATH];
	LPWSTR lpInFile = NULL;
	
	wchar_t wOutFileFmt[_MAX_PATH];
	wchar_t wOutFile[_MAX_PATH];
	LPWSTR lpOutFile = wOutFile;
		
	unsigned long l;
	
	int bufLen = sizeof(wOutFile);

	if (argc != 5 || (argc == 2 && !stricmp(argv[1], "-h"))) {
		PrintUsage(ProgName(argv[0]));
		return(1);
	}
	
	inFile = argv[1];
	min = atol(argv[2]);
	max = atol(argv[3]);
	fmt = argv[4];
	
	num = CountInserts(fmt);
	
	if (min > max) {
		fprintf(stderr, "bad min/max value!\n");
		return(1);
	}

	mbstowcs(wInFile, inFile, strlen(inFile)+1);
	lpInFile = wInFile;
	
	mbstowcs(wOutFileFmt, fmt, strlen(fmt)+1);

	for (l=min; l<=max; l++) {
		// _swprintf
		// http://msdn.microsoft.com/en-us/library/ybk95axf.aspx
		//swprintf(wOutFile, sizeof(wOutFile), wOutFileFmt, l);
		
		switch (num) {
		case 1:	PrintIt(wOutFile, bufLen, wOutFileFmt, l);							break;
		case 2:	PrintIt(wOutFile, bufLen, wOutFileFmt, l, l);						break;
		case 3:	PrintIt(wOutFile, bufLen, wOutFileFmt, l, l, l);					break;
		case 4:	PrintIt(wOutFile, bufLen, wOutFileFmt, l, l, l, l);					break;
		case 5:	PrintIt(wOutFile, bufLen, wOutFileFmt, l, l, l, l, l);				break;
		case 6:	PrintIt(wOutFile, bufLen, wOutFileFmt, l, l, l, l, l, l);			break;
		case 7:	PrintIt(wOutFile, bufLen, wOutFileFmt, l, l, l, l, l, l, l);		break;
		case 8:	PrintIt(wOutFile, bufLen, wOutFileFmt, l, l, l, l, l, l, l, l);		break;
		case 9:	PrintIt(wOutFile, bufLen, wOutFileFmt, l, l, l, l, l, l, l, l, l);	break;
		}
		
		//if (bDebug) { wprintf(L"wOutFile=%s\n", wOutFile); }
			
		CreateDirectoryTree(wOutFile);
		CopyIt(lpInFile, lpOutFile);
	}

	return(0);
}
