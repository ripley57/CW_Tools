Note: See the steps in book "Inside Windows Debugging" to see how to determine the thread id of the thread that has acquired a critical section object. This tool (tid2pid.exe) can then be passed this thread id, to return the process id of the process in which the thread is running. Note: A critical section object is always local to a process, i.e. it can only be acquired by a local thread, never a thread from a different process.

JeremyC 2/12/2016.
