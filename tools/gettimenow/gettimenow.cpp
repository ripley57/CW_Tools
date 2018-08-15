/*
** Description:
** This program is useful if you want to test de-dupe
** to second level vs millisecond level. The program
** gets the current system time, truncates it to a
** value in seconds and then prints the low and high
** dword values as used in mfcmapi to change the sent
** time in PR_CLIENT_SUBBMIT_TIME.
**
** Example output:
** D:\tmp>gettimenow.exe
** Time now:       dwLowDateTime=26265ae0, dwHighDateTime=01cecfd3
** Before truncation to seconds: qwResult=130269945025420000
** After  truncation to seconds: qwResult=130269945000000000
** Time truncated: dwLowDateTime=24a27a00, dwHighDateTime=01cecfd3
**
** JeremyC 23rd Oct 2013.
*/

#include <windows.h>
#include <stdio.h>
#include <strsafe.h>

FILETIME TruncateTimeToSeconds(FILETIME ft)
{
   ULONGLONG qwResult;

   // Copy the time into a quadword.
   qwResult = (((ULONGLONG) ft.dwHighDateTime) << 32) + ft.dwLowDateTime;

   printf("Before truncation to seconds: qwResult=%lld\n", qwResult);
   
   // Truncate to seconds
   qwResult = qwResult / 100000000;
   
   // Convert back to nanoseconds.
   qwResult = qwResult * 100000000;

   printf("After  truncation to seconds: qwResult=%lld\n", qwResult);
   
   // Copy the result back into the FILETIME structure.
   ft.dwLowDateTime  = (DWORD) (qwResult & 0xFFFFFFFF );
   ft.dwHighDateTime = (DWORD) (qwResult >> 32 );

   return ft;
}

SYSTEMTIME TruncateTimeToSeconds2(SYSTEMTIME st)
{
	st.wMilliseconds = 0;
	return st;
}

void main(int argc, char** argv) {
	FILETIME ft_seconds;

	SYSTEMTIME st;
	GetLocalTime(&st);

	FILETIME ft;
	SystemTimeToFileTime(&st, &ft);
    printf("Time now:       dwLowDateTime=%08x, dwHighDateTime=%08x\n", ft.dwLowDateTime, ft.dwHighDateTime);

	// Truncate time to seconds
	FILETIME ft_s;
	//ft_s = TruncateTimeToSeconds(ft);
	st = TruncateTimeToSeconds2(st);
	SystemTimeToFileTime(&st, &ft_s);
    printf("Time truncated: dwLowDateTime=%08x, dwHighDateTime=%08x\n", ft_s.dwLowDateTime, ft_s.dwHighDateTime);

	exit(0);
}
