/*
** Program to display file times to millisecond level.
**
** JeremyC Nov 2013.
*/

#include <windows.h>
#include <tchar.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strsafe.h>

BOOL TraverseDirectory(LPCTSTR PathName);
BOOL ProcessItem(LPCTSTR CurrPath, LPWIN32_FIND_DATA pFileData);
DWORD FileType(LPWIN32_FIND_DATA pFileData);
void displayUTCFileTime(LPCSTR desc, LPFILETIME ft);
void Error(LPTSTR lpszFunction);
int FileExists(LPCTSTR PathName);

#define TYPE_FILE 	1
#define TYPE_DOT	2
#define TYPE_DIR	3

#define DIRNAME_LEN MAX_PATH + 2
	
void _tmain(int argc, LPTSTR argv[]) {

	TCHAR CurrPath[MAX_PATH + 1];
	TCHAR PathName [MAX_PATH + 1];
	TCHAR pwdBuffer [DIRNAME_LEN];
	TCHAR AbsPath[MAX_PATH + 1];
	TCHAR AbsStartPath[MAX_PATH + 1];
	DWORD LenCurDir;
	LPTSTR pSlash;
	LPTSTR pFileName;
	TCHAR** lppFilePart={NULL};
	
	// Save the current directory
	GetCurrentDirectory(MAX_PATH, CurrPath);
	
	if (argc == 2 && (stricmp(_T("-h"), argv[1]) == 0 || stricmp(_T("/?"), argv[1]) == 0)) {
		_tprintf(_T("\n%s"
				    "\n   Program to list file last modified times."
				    "\n\nUsage:"
				    "\n   %s [directoryname]"
				    "\n\n   The current directory will be used if none is specified."
					"\n   Be careful running this against large directories, since"
					"\n   the program is recursive and could end up crashing."
				    "\n\n   The file times are displayed in the following format:"
				    "\n\n   DD/MM/YYYY HH:MM:SS.ZZZ UTC nnnnnnnnnnnnn filepath\n\n"), argv[0], argv[0]);
		return;
	}
	
	if (argc < 2) {
		// No path specified. Use the current dir.
		TraverseDirectory(_T("."));
	} else {
		pFileName = argv[1];
		_tcscpy(PathName, pFileName);
		
		// Remove trailing slash, if any.
		int len = _tcsclen(pFileName);
		if (PathName[len - 1] == '\\') {
			PathName[len - 1] = '\0';
		}
		
		// Convert path to absolute path, because it could have been a relative one.
		if (GetFullPathName(PathName, MAX_PATH, AbsPath, lppFilePart) == 0) {
			Error(_T("GetFullPathName"));
			return;
		}
		//_tprintf(_T("abspath=%s\n"), AbsPath);
				
		// Find rightmost slash, if any. 
		pSlash = _tcsrchr(AbsPath, '\\'); 
		if (pSlash != NULL) {
			*pSlash = '\0';
				
			//_tprintf(_T("Changing to directory %s ...\n"), AbsPath);
			if (SetCurrentDirectory(AbsPath) == 0) {
				Error(_T("SetCurrentDirectory: Could not change directory:"));
				return;
			}
			
			// Check that we changed directory successfully.
			// You see strange behaviour when the input path is something like "c:\tmp".
			// We end up trying to change to "c:". This fails, but there is no error,
			// so here we actually compare where we are to where we expected to be.
			LenCurDir = GetCurrentDirectory(DIRNAME_LEN, pwdBuffer);
			//_tprintf(_T("Intended=\"%s\", actual=\"%s\"\n"), AbsPath, pwdBuffer);
			if (_tcsncicmp(AbsPath, pwdBuffer, max(_tcslen(AbsPath), _tcslen(pwdBuffer))) != 0) {
				_tprintf(_T("Path is invalid. This program will not work against a top-level folder"));
				return;
			}
			
			*pSlash = '\\';
			pFileName = pSlash + 1;

		} else {
			pFileName = AbsPath;
		}
		
		// Before we start traversing, check that the starting file/dir exists.
		if (GetFullPathName(pFileName, MAX_PATH, AbsStartPath, lppFilePart) == 0) {
			Error(_T("GetFullPathName"));
			return;
		}
		if (!FileExists(AbsStartPath)) {
			Error(_T("FileExists"));
			return;
		}
		
		//printf("Traversing %s ...\n", pFileName);
		TraverseDirectory(pFileName);
		
		// Restore current dir.
		SetCurrentDirectory(CurrPath);
	}
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

/*
** Check if a file or directory exists.
*/
int FileExists(LPCTSTR PathName)
{
   WIN32_FIND_DATA FindFileData;
   HANDLE handle = FindFirstFile(PathName, &FindFileData) ;
   int found = handle != INVALID_HANDLE_VALUE;
   if (found)
       FindClose(handle);
   return found;
}

/*
** Traverse a directory. Perform ProcessItem for every match.
*/
BOOL TraverseDirectory(LPCTSTR PathName)
{	
	WIN32_FIND_DATA FindData;
	TCHAR 	CurrPath[MAX_PATH + 1];
	DWORD 	iPass;
	HANDLE	SearchHandle;
	DWORD	FType;
	
	GetCurrentDirectory(MAX_PATH, CurrPath);
	
	for (iPass = 1; iPass <= 2; iPass++) {
		// Pass 1: List files.
		// Pass 2: Traverse directories.
		SearchHandle = FindFirstFile(PathName, &FindData);
		do {
			// File or directory.
			FType = FileType(&FindData);
			if (iPass == 1) {
				ProcessItem(CurrPath, &FindData);
			}
			if (FType == TYPE_DIR && iPass == 2) {
				// Process a sub-directory.
				//_tprintf(_T("\n%s\\%s:"), CurrPath, FindData.cFileName);
				
				// Prepare to traverse directory.
				SetCurrentDirectory(FindData.cFileName);
				
				TraverseDirectory(_T("*"));
				
				// Recursive call.
				SetCurrentDirectory(_T(".."));
			}
		} while (FindNextFile(SearchHandle, &FindData));
		FindClose(SearchHandle);
	}
	return TRUE;
}

/*
** List file last modified time in UTC milliseconds.
*/
BOOL ProcessItem(LPCTSTR CurrPath, LPWIN32_FIND_DATA pFileData)
{
	DWORD 		FType = FileType(pFileData);
	SYSTEMTIME	LastWrite;
	
	if (FType != TYPE_FILE && FType != TYPE_DIR)
		return FALSE;
		
	if (FType == TYPE_FILE) {
		//FileTimeToSystemTime(&(pFileData->ftLastWriteTime), &LastWrite);
		displayUTCFileTime(pFileData->cFileName, &(pFileData->ftLastWriteTime));
#if 0
		_tprintf(_T("%02d/%02d/%04d %02d:%02d:%02d %s\\%s\n"),
		LastWrite.wMonth, 	LastWrite.wDay,
		LastWrite.wYear,	LastWrite.wHour,
		LastWrite.wMinute,	LastWrite.wSecond,
		CurrPath, pFileData->cFileName);
#endif
		_tprintf(_T(" %s\\%s\n"), CurrPath, pFileData->cFileName);
	}

	return TRUE;
}

/*
** File types supported...
** 	TYPE_FILE: 	file
**	TYPE_DIR:	directory
**	TYPE_DOR:	. or .. directory
*/
DWORD FileType(LPWIN32_FIND_DATA pFileData)
{
	BOOL IsDir;
	DWORD FType = TYPE_FILE;
	
	IsDir = ((pFileData->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) != 0);
	if (IsDir) {
		if (lstrcmp(pFileData->cFileName, _T("."))  == 0 ||
			lstrcmp(pFileData->cFileName, _T("..")) == 0) {
			FType = TYPE_DOT;
		} else {
			FType = TYPE_DIR;
		}
	}
	return FType;
}

/*
** Display FILETIME in UTC.
*/
void displayUTCFileTime(LPCSTR desc, LPFILETIME ft)
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
		printf("%02d/%02d/%04d %02d:%02d:%02d.%03d UTC %llu", 
			st_utc.wDay,  st_utc.wMonth,  st_utc.wYear, 
			st_utc.wHour, st_utc.wMinute, st_utc.wSecond, st_utc.wMilliseconds,
			qwResult);
	} else {
		printf("Could not display file time for: %s\n", desc);
	}
}


#if 0
/*
** Old (non-directory recursing) code is here.
** This method below uses CreateFile() explicitly, which
** unfortunately updates the last accessed time. The only 
** way to avoid this, when you use CreateFile(), is to have 
** write access to the file and call SetFileTime() immediately 
** after opening it. It seems however, that using FindFirstFile()
** and FindNextFile() avoids this issue entirely :-). 
*/

void usage(const char* progname)
{
	char *s = "\n\n" 
		  "Description:\n"
		  "This program displays the creation time, last accessed\n"
		  "time and last modified time of the specified file.\n";

	printf("%s\n", s);
	printf("Usage:\n%s <filename>\n", progname);
}

/*
** Display FILETIME
**
** Windows File Times:
** http://msdn.microsoft.com/en-us/library/windows/desktop/ms724290(v=vs.85).aspx
**
** A file time is a 64-bit value that represents the number of 100-nanosecond 
** intervals that have elapsed since 12:00 A.M. January 1, 1601 Coordinated 
** Universal Time (UTC). The system records file times when applications create, 
** access, and write to files.
**
** The NTFS file system stores time values in UTC format, so they are not affected 
** by changes in time zone or daylight saving time.
**
** The FAT file system stores time values based on the local time of the computer.
** Because of this, a file that is saved at 3:00pm PST in Washington is seen as
** 3:00pm EST in New York on a FAT volume.
** GetFileTime retrieves cached UTC times from the FAT file system. When it becomes 
** daylight saving time, the time retrieved by GetFileTime is off an hour, because 
** the cache is not updated. When you restart the computer, the cached time that 
** GetFileTime retrieves is correct.
** FindFirstFile retrieves the local time from the FAT file system and converts it 
** to UTC by using the current settings for the time zone and daylight saving time. 
** Therefore, if it is daylight saving time, FindFirstFile takes daylight saving time 
** into account, even if the file time you are converting is in standard time.
*/
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
		printf("%-15s %02d:%02d:%04d %02d:%02d:%02d.%03d UTC %llu\n", 
			desc, 
			st_utc.wDay,  st_utc.wMonth,  st_utc.wYear, 
			st_utc.wHour, st_utc.wMinute, st_utc.wSecond, st_utc.wMilliseconds,
			qwResult);
	} else {
		printf("Could not display file time: %s\n", desc);
	}
}

void _tmain(int argc, LPTSTR argv[]) {
	if (argc != 2 || 
		 !stricmp(argv[1], "/?") || 
		 !stricmp(argv[1], "-h") || 
		 !stricmp(argv[1], "-help")) {
		usage(argv[0]);
		exit(-1);
	}
	
	FILETIME ftCreationTime   = {0};
	FILETIME ftLastAccessTime = {0};
	FILETIME ftLastWriteTime  = {0};
	HANDLE hFile;
	
	char *filename = argv[1];

	wchar_t wtext[1024];
	mbstowcs(wtext, filename, strlen(filename)+1); //Plus null
	LPWSTR ptr = wtext;
	
	/*
	** CreateFile
	** http://msdn.microsoft.com/en-us/library/windows/desktop/aa363858(v=vs.85).aspx
	*/
	hFile = CreateFileW(
			/*
			** LPCTSTR lpFileName
			*/
			ptr, 

			/*
			** DWORD dwDesiredAccess
			**
			** NOTE: In order to not update the last accessed time, we use
			**       SetFileTime() as shown below. However, in order to use
			**       this function and not get an access denied erorr, we
			**       need to have write access to the file!!! So this is a
			**       serious limitation, since the files cannot be read-only.
			**
			**		 Interestingly, our JNI code does not use GENERIC_WRITE, 
			**		 so we must be updating the last accessed time??? 
			**	     However, our use of FILE_ATTRIBUTE_NORMAL (see below) vs
			**       FILE_ATTRIBUTE_READONLY seems to prevent the last
			*        accessed time from being updated.
			*/
			GENERIC_READ | GENERIC_WRITE,

			/*
			** DWORD dwShareMode
			*/
			FILE_SHARE_READ,

			/*
			** LPSECURITY_ATTRIBUTES lpSecurityAttributes
			*/
			NULL,

			/*
			** DWORD dwCreationDisposition
			*/
			OPEN_EXISTING,

			/*
			** DWORD dwFlagsAndAttributes
			*/
			/*FILE_ATTRIBUTE_NORMAL | FILE_FLAG_BACKUP_SEMANTICS*/ FILE_ATTRIBUTE_READONLY,

			/*
			** HANDLE hTemplateFile
			*/
			NULL);

	if (hFile == INVALID_HANDLE_VALUE) {
		printf("Could not open %s file, error %u\n", argv[1], GetLastError());
		//ErrorExit(TEXT("open file"));
		exit(1);
	}
	
	/*
	** SetFileTime
	**
	** Do not update access time. This needs to be called immediately after opening file.
	** http://msdn.microsoft.com/en-us/library/windows/desktop/ms724933(v=vs.85).aspx
	*/
	static const FILETIME ftLeaveUnchanged = { 0xFFFFFFFF, 0xFFFFFFFF };
	if (SetFileTime(hFile, NULL, &ftLeaveUnchanged, NULL) == 0) {
		printf("Could not open %s file, error %u\n", argv[1], GetLastError());
		CloseHandle(hFile);
		//ErrorExit(TEXT("open file"));
		exit(2);
    }
	
	/*
	** GetFileTime
	**
	** http://msdn.microsoft.com/en-us/library/windows/desktop/ms724320(v=vs.85).aspx
	**
	** Remarks
	** Not all file systems can record creation and last access times and not all file 
	** systems record them in the same manner. For example, on FAT, create time has a 
	** resolution of 10 milliseconds, write time has a resolution of 2 seconds, and 
	** access time has a resolution of 1 day (really, the access date). Therefore, the 
	** GetFileTime function may not return the same file time information set using the 
	** SetFileTime function.
	**
	** NTFS delays updates to the last access time for a file by up to one hour after 
	** the last access. NTFS also permits last access time updates to be disabled. Last
	** access time is not updated on NTFS volumes by default.
	**
	** Windows Server 2003 and Windows XP:  Last access time is updated on NTFS volumes 
	** by default.
	*/
	if (GetFileTime(
			/*
			** HANDLE hFile
			*/
			hFile,

			/*
			** LPFILETIME lpCreationTime
			*/
			&ftCreationTime, 

			/*
			** LPFILETIME lpLastAccessTime
			*/
			&ftLastAccessTime, 

			/*
			** LPFILETIME lpLastWriteTime
			*/			
			&ftLastWriteTime) == 0) {

		printf("Could not get times of file %s\n", argv[1]);
		CloseHandle(hFile);
		//ErrorExit(TEXT("GetFileTime"));
		exit(3);
	}

	displayFileTime(TEXT("CreationTime"),   &ftCreationTime);
	displayFileTime(TEXT("LastAccessTime"), &ftLastAccessTime);
	displayFileTime(TEXT("LastWriteTime"),  &ftLastWriteTime);
	CloseHandle(hFile);
	exit(0);
}
#endif