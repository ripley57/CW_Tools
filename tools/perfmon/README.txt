Useful Perfmon and disk performance links:

http://ss64.com/nt/logman.html
http://technet.microsoft.com/en-us/library/bb490956.aspx
http://blogs.technet.com/b/askperf/archive/2010/11/05/performance-tuning-windows-server-2008-r2-pt-2.aspx
http://technet.microsoft.com/en-us/magazine/2008.08.pulse.aspx

====================================================================================================================

From http://technet.microsoft.com/en-us/magazine/2008.08.pulse.aspx:

Hard Disk Bottleneck
Since the disk system stores and handles programs and data on the server, a bottleneck affecting disk usage 
and speed will have a big impact on the server's overall performance.

Please note that if the disk objects have not been enabled on your server, you need to use the command-line 
tool Diskperf to enable them. Also, note that % Disk Time can exceed 100 percent and, therefore, I prefer to 
use % Idle Time, Avg. Disk sec/Read, and Avg. Disk sec/write to give me a more accurate picture of how busy 
the hard disk is. You can find more on % Disk Time in the Knowledge Base article available at 
support.microsoft.com/kb/310067.

Following are the counters the Microsoft Service Support engineers rely on for disk monitoring.

LogicalDisk\% Free Space 
This measures the percentage of free space on the selected logical disk drive. 
Take note if this falls below 15 percent, as you risk running out of free space for the OS to store critical 
files. One obvious solution here is to add more disk space.

PhysicalDisk\% Idle Time
This measures the percentage of time the disk was idle during the sample interval. If this counter falls below 
20 percent, the disk system is saturated. You may consider replacing the current disk system with a faster disk 
system.

PhysicalDisk\Avg. Disk Sec/Read 
This measures the average time, in seconds, to read data from the disk. If the 
number is larger than 25 milliseconds (ms), that means the disk system is experiencing latency when reading from 
the disk. For mission-critical servers hosting SQL Server and Exchange Server, the acceptable threshold is 
much lower, approximately 10 ms. The most logical solution here is to replace the current disk system with a 
faster disk system.

PhysicalDisk\Avg. Disk Sec/Write
This measures the average time, in seconds, it takes to write data to the disk. If the number is larger than 25 ms, 
the disk system experiences latency when writing to the disk. For mission-critical servers hosting SQL Server and 
Exchange Server, the acceptable threshold is much lower, approximately 10 ms. The likely solution here is to replace 
the disk system with a faster disk system.

PhysicalDisk\Avg. Disk Queue Length 
This indicates how many I/O operations are waiting for the hard drive to become available. If the value here is 
larger than the two times the number of spindles, that means the disk itself may be the bottleneck.

Memory\Cache Bytes 
This is the size, in bytes, of the portion of the system file cache which is currently resident and active in 
physical memory. 
There may be a disk bottleneck if this value is greater than 300MB.

====================================================================================================================

From 

http://blogs.technet.com/b/mspfe/archive/2012/12/19/the-case-of-the-disappearing-memory.aspx
http://support.microsoft.com/kb/976618
http://blogs.msdn.com/b/ntdebugging/archive/2007/11/27/too-much-cache.aspx

Memory\System Cache Resident Bytes
Memory\Available MBytes

====================================================================================================================

From http://blogs.technet.com/b/askperf/archive/2010/11/05/performance-tuning-windows-server-2008-r2-pt-2.aspx

Average Disk Second/Read, Average Disk Second/Write, Average Disk Second/Transfer: 
These are probably my favorite disk counters. They tell you how long, in seconds, a given read or write request is 
taking. (Transfer is considered a Read\Write round trip, so is pretty much what you get if you add the other two.) 
These counters tell you real numbers that deal directly with disk performance. For instance, if you see that your 
Average Disk Seconds/Write is hitting .200 sustained, that tells you that your write requests are taking a full 200 ms 
to complete. Since modern disks are typically rated at well under 10 ms random access time, any number much higher than
that is problematic. Short spikes are okay, but long rises on any of these numbers tell you that the disk or disk 
subsystem simply is not keeping up with load. The good thing is, these being real numbers, the number of disks or how 
they are configured is really not important. High numbers equate to bad performance regardless.
====================================================================================================================

JeremyC 16/5/2014
