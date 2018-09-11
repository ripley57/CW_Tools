/*
** From https://docs.microsoft.com/en-us/windows/desktop/api/winsock2/ns-winsock2-hostent
**
** From what I can make out, Java's InetAddress.getCanonicalHostName(), when using the 
** default Windows appliance's local host resolution services (i.e. not using 
** java -Dsun.net.spi.nameservice.provider.1=dns,sun - see here: 
** https://bugs.openjdk.java.net/browse/JDK-4801219), uses the native windows function 
** gethostbyaddr() for a reverse IP lookup. See here for Java's use of this function:
** http://hg.openjdk.java.net/jdk8/jdk8/jdk/file/82b276590b85/src/windows/native/java/net/Inet4AddressImpl.c
** See InetAddress.java in the src.zip that comes with the Oracle Java jdk, for where
** the Java function ends up calling the Windows native function gethostbyaddr().
**
** The Windows function gethostbyaddr() works similarly (perhaps the same?) as a reverse 
** IP look-up using ping -a, which uses DNS "PTR" records to map an IP address to the 
** corresponding "canonical"  hostname, i.e. the hostname associated with the IP address's
** "A" record, and not a hostname associated with any alias, "CNAME" DNS record.  
**
** Example usage:
**    gethostbyaddr.exe 192.168.0.4
**    Calling gethostbyaddr with 192.168.0.4
**    Function returned:
**        Official name: e1317t
**        Address type: AF_INET
**        Address length: 4
**        IPv4 Address #1: 192.168.0.4
**
** How to create a DNS PTR record on Windows:
** https://www.youtube.com/watch?v=p8fyaXLS3PQ
**
** See the DNS and Blind O'reilly book about DNS PTR and CNAME records.
** An IP address can have only one canonical host name, so this is what
** the DNS PTR record needs to point to. Aliases for a hostname can be
** created using one or more CNAME records, but these need to point back
** to the canonical hostname.
** 
** Hostname aliases can cause errors trying to access a local UNC path:
** https://social.technet.microsoft.com/Forums/lync/en-US/ee6d2e78-6bab-42c2-a709-04df66e7979f/navigating-to-a-server-alias-from-itself-prompts-for-credentials-windows-server-2008-r2?forum=winserverNIS
**
** JeremyC 11-09-2018
*/

#define WIN32_LEAN_AND_MEAN

#include <winsock2.h>
#include <ws2tcpip.h>
#include <stdio.h>

// Need to link with Ws2_32.lib
#pragma comment(lib, "ws2_32.lib")

int main(int argc, char **argv)
{
    //-----------------------------------------
    // Declare and initialize variables
    WSADATA wsaData;
    int iResult;

    DWORD dwError;
    int i = 0;

    struct hostent *remoteHost;
    char *host_name;
    struct in_addr addr;

    char **pAlias;

    // Validate the parameters
    if (argc != 2) {
        printf("usage: %s ipv4address\n", argv[0]);
        printf(" or\n");
        printf("       %s hostname\n", argv[0]);
        printf("  to return the host\n");
        printf("       %s 127.0.0.1\n", argv[0]);
        printf("  to return the IP addresses for a host\n");
        printf("       %s www.contoso.com\n", argv[0]);
        return 1;
    }
    // Initialize Winsock
    iResult = WSAStartup(MAKEWORD(2, 2), &wsaData);
    if (iResult != 0) {
        printf("WSAStartup failed: %d\n", iResult);
        return 1;
    }

    host_name = argv[1];

// If the user input is an alpha name for the host, use gethostbyname()
// If not, get host by addr (assume IPv4)
    if (isalpha(host_name[0])) {        /* host address is a name */
        printf("Calling gethostbyname with %s\n", host_name);
        remoteHost = gethostbyname(host_name);
    } else {
        printf("Calling gethostbyaddr with %s\n", host_name);
        addr.s_addr = inet_addr(host_name);
        if (addr.s_addr == INADDR_NONE) {
            printf("The IPv4 address entered must be a legal address\n");
            return 1;
        } else
            remoteHost = gethostbyaddr((char *) &addr, 4, AF_INET);
    }

    if (remoteHost == NULL) {
        dwError = WSAGetLastError();
        if (dwError != 0) {
            if (dwError == WSAHOST_NOT_FOUND) {
                printf("Host not found\n");
                return 1;
            } else if (dwError == WSANO_DATA) {
                printf("No data record found\n");
                return 1;
            } else {
                printf("Function failed with error: %ld\n", dwError);
                return 1;
            }
        }
    } else {
        printf("Function returned:\n");
        printf("\tOfficial name: %s\n", remoteHost->h_name);
        for (pAlias = remoteHost->h_aliases; *pAlias != 0; pAlias++) {
            printf("\tAlternate name #%d: %s\n", ++i, *pAlias);
        }
        printf("\tAddress type: ");
        switch (remoteHost->h_addrtype) {
        case AF_INET:
            printf("AF_INET\n");
            break;
        case AF_INET6:
            printf("AF_INET6\n");
            break;
        case AF_NETBIOS:
            printf("AF_NETBIOS\n");
            break;
        default:
            printf(" %d\n", remoteHost->h_addrtype);
            break;
        }
        printf("\tAddress length: %d\n", remoteHost->h_length);

        if (remoteHost->h_addrtype == AF_INET) {
            while (remoteHost->h_addr_list[i] != 0) {
                addr.s_addr = *(u_long *) remoteHost->h_addr_list[i++];
                printf("\tIPv4 Address #%d: %s\n", i, inet_ntoa(addr));
            }
        } else if (remoteHost->h_addrtype == AF_INET6)
            printf("\tRemotehost is an IPv6 address\n");
    }

    return 0;
}
