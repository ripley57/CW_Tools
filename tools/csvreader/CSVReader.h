#include <istream>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

class ColReader
{
private:
	istream&	m_cin;
	
public:
	ColReader(istream& input = std::cin);
	~ColReader();	
	
	char read(string& col);
	bool getNextChar(istream &in, char& c);
	int readQuotedCol(string& quotedCol); 
	bool at_eof();
};

class CSVReader
{
private:
	ColReader&		m_colReader;

public:
	CSVReader(ColReader& colReader);
	~CSVReader();

	std::vector<string> readRow();
	bool at_eof();
};
