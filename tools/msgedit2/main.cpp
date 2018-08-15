/*
** Description:
**	Program to read an input csv file of 'commands' 
**  of edits to be applied to an Outlook MSG file. 
**
**  JeremyC 17/7/2015.
*/

#include <fstream>
#include <errno.h>

#include "Logger.h"
#include "CSVReader.h"
#include "Session.h"
#include "MSGEdit.h"
#include "wingetopt.h"

void usage(char* progname)
{
	char* s = "\n"
	          "%s\n"
			  "\n"
			  "Description:\n"
			  "   Program to process input csv file of commands to apply to an MSG file.\n"
			  "   These commands can include, for example, updating the subject text.\n"
			  "   If the csv file is not specified as an input argument, in.csv is assumed.\n"
			  "\n"
			  "Usage:\n"
	          "   %s [-h] [-i <input-csv-file>]\n"
			  "\n"
			  "Example:\n"
			  "   %s in.csv\n"
			  "\n"
			  "Example input csv file to update subject of msg files:\n"
			  "   \"UPDATE\",\"SUBJECT\",\"test1.msg\",\"email 1 new subject text\"\n"
			  "   \"UPDATE\",\"SUBJECT\",\"test2.msg\",\"email 2 new subject text\"\n"
              "\n"
			  "Example input csv file to update subject and add attachments:\n"
			  "   \"UPDATE\",\"SUBJECT\",\"test1.msg\",\"this is the newest subject text\"\n"
              "   \"ADD\",\"ATTACH\",\"BODY_FILE\",\"test1.msg\",\"attachment1\",\"attach1.txt\"\n"
              "   \"ADD\",\"ATTACH\",\"BODY_INLINE\",\"test1.msg\",\"attachment2\",\"text content for attach 2\"\n"
			  "\n";

	fprintf(stderr, s, progname, progname, progname);
}

int main(int argc, char* argv[])
{	
	char*	pProgName = argv[0];
	char*	pInputFile = "in.csv";
	
	if (argc > 0)	// Check command-line arguments.
	{
		int option = 0;
		while ((option = getopt(argc, argv, "hi:")) != -1) {
			switch (option) {
            case 'h' : 	// Help option "-h".
				usage(pProgName);
				return 0;
            case 'i' : 
				pInputFile = optarg;
                break;
            default: 
                return 1;
			}
		}
    }
	
	Logger* pLogger = Logger::getLogger();
	
	pLogger->detail(string("Opening file: ") + pInputFile + "...");
	
	ifstream infile(pInputFile);
	if (!infile.is_open())
	{
		pLogger->error(string("Could not open input file: ") + pInputFile + ": " + strerror(errno));
		return 1;
	}
	
	ColReader colreader(infile);
	CSVReader csvreader(colreader);

	Session* pSession = new Session();
	if (!pSession->initialize())
	{
		pLogger->error("Failed to initialise MAPI. This program requires Outlook.");
		return 1;
	}
	pSession->logon();
	MSGEdit msgedit(csvreader, pSession);
	msgedit.processAllCommands();
	delete pSession;
	
	return 0;
}