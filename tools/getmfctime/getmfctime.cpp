/*
** Program to convert file last modified time in milliseconds to 
** high and log MFC time values. The idea is that this program can
** be used with mfcmapi.exe in order to set the sent time to a 
** specific value using PR_CLIENT_SUBMIT_TIME.
**
** JeremyC Dec 2013.
*/

#include <windows.h>
#include <tchar.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strsafe.h>

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

// Display FILETIME value.
void displayFileTime(LPCSTR desc, LPFILETIME ft)
{
	// Convert to ULONGLONG.
	ULONGLONG qwResult;
    qwResult = (((ULONGLONG) ft->dwHighDateTime) << 32) + ft->dwLowDateTime;
	
	// Subtract Offset between January 1, 1601 UTC and midnight January 1, 1970 UTC 
    // in 100 ns intervals.
    qwResult -= 116444736000000000;
	
    // Truncate to milliseconds
    qwResult = qwResult / 10000;

	SYSTEMTIME st_utc;
	if (FileTimeToSystemTime(ft, &st_utc) != 0) {
		printf("%s%02d/%02d/%04d %02d:%02d:%02d.%03d UTC %llu\n", 
			desc, 
			st_utc.wDay,  st_utc.wMonth,  st_utc.wYear, 
			st_utc.wHour, st_utc.wMinute, st_utc.wSecond, st_utc.wMilliseconds,
			qwResult);
	} else {
		printf("Could not display file time: %s\n", desc);
	}
}

// Convert string to ULONGLONG.
ULONGLONG toNum(char a[]) {
  int c, sign;
 
  ULONGLONG n = 0;
 
  for (c = 0; a[c] != '\0'; c++) {
    n = n * 10 + a[c] - '0';
  }
 
  return n;
}

// Convert CW sentdatetime string into a FILETIME structure.
BOOL convertStringToFILETIME(char* str, LPFILETIME ft)
{
	ULONGLONG qwResult;
	
	//_tprintf(_T("str=%s\n"), str);
	qwResult = toNum(str);
	//_tprintf(_T("%llu\n"), qwResult);

	 // Expand to milliseconds
    qwResult = qwResult * 10000;
	
	// Add Offset between January 1, 1601 UTC and midnight January 1, 1970 UTC 
    // in 100 ns intervals.
    qwResult += 116444736000000000;
	
	ft->dwLowDateTime  = (DWORD) (qwResult & 0xFFFFFFFF );
    ft->dwHighDateTime = (DWORD) (qwResult >> 32 );
	
	return TRUE;
}

void usage(const char* progname)
{
	_tprintf(	_T("\n")
				_T("%s\n\n")
				_T("Description:\n")
				_T("  Given file time in milliseconds, display low and high values\n")
				_T("  for setting PR_CLIENT_SUBMIT_TIME using mfcmapi.exe.\n\n")
				_T("Usage:\n")
				_T("  %s sentdatetime\n\n") 
				_T("Example:\n")
				_T("  %s 1374434628000\n\n"),
				progname, progname, progname	);
}

void main(int argc, char** argv) {
	HANDLE 		hFile;
	FILETIME 	ft;
	
	if (argc != 2 || 
		 !stricmp(argv[1], "/?") || 
		 !stricmp(argv[1], "-h") || 
		 !stricmp(argv[1], "-help")) {
		usage(argv[0]);
		exit(-1);
	}

	if (convertStringToFILETIME(argv[1], &ft) == FALSE) {
		_tprintf(_T("Could not convert string to FILETIME\n"));
		return;
	}
	
	//displayFileTime(_T(""), &ft);

	_tprintf(_T("\n")
		 _T("Input value : %s\n\n")
		 _T("Low value   : 0x%08x\n")
		 _T("High value  : 0x%08x\n"),
		 argv[1], 
		 ft.dwLowDateTime,
		 ft.dwHighDateTime);

#if 0
Code from setlmtime...
	hFile = CreateFile(argv[2], GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile == INVALID_HANDLE_VALUE) {
		ErrorExit(_T("Could not open file"));
	}
	if (SetFileTime(hFile, NULL, NULL, &ft) == FALSE) {
		CloseHandle(hFile);
		ErrorExit(_T("Could not set time"));
	}
	CloseHandle(hFile);
#endif

	exit(0);
}
