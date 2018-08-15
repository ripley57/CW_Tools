#include "stdafx.h"
#include <Windows.h>
//#include <synchapi.h>

int
__cdecl
wmain(
    VOID
    )
{
    WCHAR* cacheMutexName = L"HelloWorldMutex";
    HANDLE handle = ::CreateMutex(NULL, FALSE, cacheMutexName);

    DWORD result = WaitForSingleObject(handle, INFINITE);

    switch (result)
    {
    case WAIT_OBJECT_0:
        printf("The thread got ownership of the mutex.\r\n");
        break;
    case WAIT_ABANDONED:
        printf("The thread got ownership of an abandoned mutex.\r\n");
        break;
    }

    // Countdown.
    for (int i = 10; i > 0; i--)
    {
        wprintf(L"%d\r\n", i);
        Sleep(1000);
    }
    wprintf(L"0\r\n");

    ReleaseMutex(handle);
    printf("Mutex released.\r\n");

    return 0;
}
