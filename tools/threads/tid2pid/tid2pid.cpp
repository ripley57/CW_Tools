/*
** Description:
** 	Given a thread id (tid), determine the corresponding process id (pid).
**  This tool is useful when two processes are deadlocked on a mutex.
**  Note: Unlike Critical Sections, Mutexes can be used to synchronize 
**        processes. Critical Sections can only synchronize threads in 
**        the same process.
**
** This prgram is from here:
** http://superuser.com/questions/975944/find-process-by-thread-id
**  
** JeremyC 30/11/2016
*/

//#include "stdafx.h"
#include <sstream>
#include <windows.h>
#include <stdio.h>
#include <iostream>
int main(int argc, char* argv[])
{
    if (argc < 2)
    {
        std::cout << "Usage: " << argv[0] << " <Thread ID>" << std::endl;
        std::cout << "Returns the process ID of a thread." << std::endl;
        std::cout << "Errorlevels:" << std::endl;
        std::cout << "   0 success" << std::endl;
        std::cout << "   1 too few arguments" << std::endl;
        std::cout << "   2 error parsing thread ID" << std::endl;
        std::cout << "   3 error opening thread" << std::endl;
        return 1;
    }

    std::istringstream iss(argv[1]);
    int threadId;

    if (iss >> threadId)
    {
        std::cout << threadId << std::endl;
        HANDLE threadHandle = OpenThread(THREAD_QUERY_INFORMATION, false, (DWORD)threadId);
        if (threadHandle)
        {
            DWORD pid = GetProcessIdOfThread(threadHandle);
            CloseHandle(threadHandle);
            std::cout << pid << std::endl;
            return 0;
        }
        std::cerr << "Error opening thread. Perhaps run as admin or thread does not exist?";
        return 3;
    }
    std::cerr << "Error parsing thread ID. Use decimal, not hex?";
    return 2;
}
