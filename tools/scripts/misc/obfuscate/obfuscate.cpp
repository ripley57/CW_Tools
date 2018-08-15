/*
** Program to crudely obfuscate text files by shifting ascii character values.
**
** JeremyC July 2014.
*/

#include <windows.h>
#include <stdio.h>
#include <strsafe.h>
#include <iostream>

using namespace std;

typedef unsigned char BYTE;

void usage(const char* progname)
{
	char *s = "\n\n" 
		  "Description:\n"
		  "Obfuscate the ascii content of the specified intput \n"
		  "text file and write the obfuscated content to stdout.\n";
    printf("%s\n", s);
	printf("Usage:\n%s <filename>\n", progname);
}

// Get the size of a file
long getFileSize(FILE *file)
{
    long lCurPos, lEndPos;
    lCurPos = ftell(file);
    fseek(file, 0, 2);
    lEndPos = ftell(file);
    fseek(file, lCurPos, 0);
    return lEndPos;
}

void main(int argc, char** argv) {
	if (argc != 2 || 
		 !stricmp(argv[1], "/?") || 
		 !stricmp(argv[1], "-h") || 
		 !stricmp(argv[1], "-help")) {
		usage(argv[0]);
		exit(-1);
	}

	BYTE *fileBuf; 
	FILE *file = NULL;
	
	if ((file = fopen(argv[1], "rb")) == NULL) {
		cout << "Could not open file!" << endl;
		exit(1);
	}

	// Get the size of the file in bytes
	long fileSize = getFileSize(file);

	// Allocate space in the buffer for the whole file
    fileBuf = new BYTE[fileSize];

	// Read the file in to the buffer
    fread(fileBuf, fileSize, 1, file);
	
	for (long l=0; l<fileSize; l++) {
		BYTE b = fileBuf[l];
	
		if (b>=65 /*'A'*/ && b<=90 /*'Z'*/) {
			if (b==90 )
				b=65;
			else 
				b++;
		} else 
		if (b>=97 /*'a'*/ && b<=122 /*'z'*/) {
			if (b==122)
				b=97;
			else 
				b++;
		}				
		printf("%c", b);
	}

    delete[] fileBuf;
	fclose(file);   
	exit(0);
}
