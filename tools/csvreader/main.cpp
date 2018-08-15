#include <fstream>

#include "CSVReader.h"

int main()
{	
	ifstream infile("in.csv");
	if (!infile.is_open())
	{
		cerr << "Could not open input file!" << endl;
		return 1;
	}
	
	ColReader colreader(infile);
	CSVReader csvreader(colreader);
		
	int rowid = 0;
	while (!csvreader.at_eof())
	{
		std::vector<string> cols = csvreader.readRow();
		
		cout << "Number of fields in row " << ++rowid << ": " << cols.size() << endl;
		
		std::vector<string>::iterator iter;
		int i;
		for (iter = cols.begin(), i = 1; iter != cols.end(); iter++, i++)
		{
			cout << "field " << i << ": " << *iter << endl;
		}
	}
	
	infile.close();
	return 0;
}