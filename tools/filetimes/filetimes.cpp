/*
** Program to display file times to millisecond level.
**
** JeremyC Nov 2013.
*/

#include <windows.h>
#include <stdio.h>
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

void usage(const char* progname)
{
	char *s = "\n\n" 
		  "Description:\n"
		  "This program displays the creation time, last accessed\n"
		  "time and last modified time of the specified file.\n";

	printf("%s\n", s);
	printf("Usage:\n%s <filename>\n", progname);
}

void main(int argc, char** argv) {
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
