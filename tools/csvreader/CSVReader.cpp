#include "CSVReader.h"

//
// ColReader
//

ColReader::ColReader(istream& in)
	: m_cin(in)
{
}

ColReader::~ColReader()
{
}

bool 
ColReader::getNextChar(istream &in, char& c)
{
	c = in.get();
	if (in.eof())
	{
		c = 0;
		return false;
	}
	return true;
}

char
ColReader::read(string& col)
{
	char c = 0;
	while (true)
	{
		if (getNextChar(m_cin , c) == false)
			break;

		if (c == '\r')
			continue; // ignore

		if (c == ',' || c == '\n')
			break;

		if (c == '"') {
			if ((c = readQuotedCol(col)) == 0) {
				break;
			}
			continue;
		}
		col += c;
	}
	return c;
}

int 
ColReader::readQuotedCol(string& quotedCol) 
{
	char c = 0;
	
	while (getNextChar(m_cin, c) == true) 
	{
		if (c == '\r')
			continue; // ignore
			
		if (c == '"')
			break;
			
		quotedCol += c;
	}
	return c;
}

bool
ColReader::at_eof()
{
	return m_cin.eof();
}


//
// CSVReader
//

CSVReader::CSVReader(ColReader& colReader)
	: m_colReader(colReader)
{
}

CSVReader::~CSVReader()
{
}

std::vector<string> 
CSVReader::readRow()
{
	vector<string> colValues;
	
	while (true) 
	{
		char c;
		string colVal;
		
		c = m_colReader.read(colVal);
		if (c == ',' || colVal.length() > 0)
		{
			colValues.push_back(colVal);
		}
		
		if (c == ',')
			continue;
		break;
	}
	return colValues;
}

bool
CSVReader::at_eof()
{
	return m_colReader.at_eof();
}