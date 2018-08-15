#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main()
{
   setuid(0);
   printf("Content-type: text/plain\n\n");
   printf("Shutting down in 1 minute ...\n");
   system("/sbin/shutdown -h +1");
   return 0;
}
