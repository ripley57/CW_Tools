#include <windows.h>
#include <stdio.h>
#include <strsafe.h>

/*
HANDLE WINAPI CreateFile(
  _In_      LPCTSTR lpFileName,
  _In_      DWORD dwDesiredAccess,
  _In_      DWORD dwShareMode,
  _In_opt_  LPSECURITY_ATTRIBUTES lpSecurityAttributes,
  _In_      DWORD dwCreationDisposition,
  _In_      DWORD dwFlagsAndAttributes,
  _In_opt_  HANDLE hTemplateFile
);

BOOL WINAPI GetFileTime(
  _In_       HANDLE hFile,
  _Out_opt_  LPFILETIME lpCreationTime,
  _Out_opt_  LPFILETIME lpLastAccessTime,
  _Out_opt_  LPFILETIME lpLastWriteTime
);

BOOL WINAPI SetFileTime(
  _In_      HANDLE hFile,
  _In_opt_  const FILETIME *lpCreationTime,
  _In_opt_  const FILETIME *lpLastAccessTime,
  _In_opt_  const FILETIME *lpLastWriteTime
);
*/

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

// http://msdn.microsoft.com/en-gb/library/windows/desktop/ms724205(v=vs.85).aspx
// http://msdn.microsoft.com/en-gb/library/windows/desktop/ms724926(v=vs.85).aspx
BOOL SetFileToCurrentTime(HANDLE hFile)
{
    FILETIME ft;
    SYSTEMTIME st;
    BOOL f;

    GetSystemTime(&st);              // Gets the current system time
    SystemTimeToFileTime(&st, &ft);  // Converts the current system time to file time format
    f = SetFileTime(hFile,           // Sets last-write time of the file 
        (LPFILETIME) NULL,           // to the converted current system time 
        (LPFILETIME) NULL, 
        &ft);    

    return f;
}

void main(int argc, char** argv) {
	FILETIME ftCreationTime = {0};
	FILETIME ftLastAccessTime = {0};
	FILETIME ftLastWriteTime = {0};
	
	HANDLE hFile;

	hFile = CreateFile(argv[1], GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile == INVALID_HANDLE_VALUE) {
		//printf("Could not open %s file, error %ul\n", argv[1], GetLastError());
		ErrorExit(TEXT("CreateFile"));
		exit(1);
	}
	/*
	if (GetFileTime(hFile, &ftCreationTime, &ftLastAccessTime, &ftLastWriteTime) == 0) {
		printf("Could not get times of file %s\n", argv[1]);
		ErrorExit(TEXT("GetFileTime"));
		exit(2);
	}
	if (SetFileTime(hFile, &ftCreationTime, &ftLastAccessTime, &ftLastWriteTime) == 0) {
		printf("Could not set times of file %s\n", argv[1]);
		ErrorExit(TEXT("SetFileTime"));
		exit(2);
	}
	*/
	if (SetFileToCurrentTime(hFile) != TRUE) {
	    printf("Could not get set current time of file %s\n", argv[1]);
		ErrorExit(TEXT("SetFileToCurrentTime"));
		CloseHandle(hFile);
		exit(3);
	}
	
	CloseHandle(hFile);
	exit(0);
}





