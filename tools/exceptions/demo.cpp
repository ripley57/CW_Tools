/*
** Description:
**	 Simple exception demo.
**
** To compile (add /Zi to create pdb file):
**   cl /EHsc /Zi demo.cpp
**
** Running procdump to capture a dump for the first chance exception:
**   procdump -w -o -e 1 demo.exe d:\demo.dmp
**
** The dump file should show a call stack like this:
** 0:000> k
** ChildEBP RetAddr  
** WARNING: Stack unwind information not available. Following frames may be wrong.
** 001ef974 00f0538a KERNELBASE!RaiseException+0x58
** 001ef9ac 00f1c5c9 demo!_CxxThrowException+0x48 [f:\dd\vctools\crt_bld\self_x86\crt\prebuild\eh\throw.cpp @ 157]
** 001ef9c0 00f1c5d8 demo!func3+0x19 [d:\tmp_debugbreak\demo.cpp @ 37]
** 001ef9c8 00f1c5e8 demo!func2+0x8 [d:\tmp_debugbreak\demo.cpp @ 42]
** 001ef9d0 00f1c625 demo!func1+0x8 [d:\tmp_debugbreak\demo.cpp @ 47]
** 001ef9f8 00f05da6 demo!main+0x35 [d:\tmp_debugbreak\demo.cpp @ 53]
** *** ERROR: Symbol file could not be found.  Defaulted to export symbols for kernel32.dll - 
** 001efa40 761b33aa demo!__tmainCRTStartup+0x10b [f:\dd\vctools\crt_bld\self_x86\crt\src\crt0.c @ 278]
** 001efa4c 773c9f72 kernel32!BaseThreadInitThunk+0x12
** 001efa8c 773c9f45 ntdll!RtlInitializeExceptionChain+0x63
** 001efaa4 00000000 ntdll!RtlInitializeExceptionChain+0x36
**
** JeremyC 30/11/2016
*/

#include <windows.h>
#include <iostream>
using namespace std;

void func3()
{
    throw 10;
}

void func2()
{
	func3();
}

void func1()
{
	func2();
}

int main () {
  try
  {
    func1();
  }
  catch (int)
  {
	cout << "An int exception occurred." << endl;
  }
  catch (...)
  {
    cout << "An unknown exception occurred." << endl;
  }
  return 0;
}