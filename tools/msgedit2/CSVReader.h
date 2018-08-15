#ifndef CSVREADER_H
#define CSVREADER_H

#include <iostream>
#include <vector>

#include "Logger.h"

using namespace std;

class ColReader
{
private:
	istream&	m_cin;
	
	Logger* 	m_pLogger;
	
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

#endif
