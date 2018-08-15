#include <fstream>
#include <iostream>
#include <sstream> 
#include <stdlib.h>	// atoi()

#include "Logger.h"

tclassmap Logger::m_classmap;

Logger::Logger(string classname, int info_on, int debug_on, int error_on, int detail_on)
	:m_info_on(info_on),
	 m_debug_on(debug_on),
	 m_error_on(error_on),
	 m_detail_on(detail_on),
	 m_pLogger(NULL)
{
	// Add ": " to the classname that is displayed in the log output.
	if (classname.compare("") != 0)
	{
		m_classname = classname + ": ";
	}
}

Logger::~Logger()
{

}

void
Logger::init_classmap()
{
	if (m_classmap.size() == 0)
	{
		ifstream config_file("logger.config");
		if (config_file.is_open())
		{
			// Insert default class logger (info=on, debug=off, error=on, detail=off).
			// NOTE: These defaults can be overriden using an entry in logger.config.
			m_classmap[string("")] = new Logger(string(""),1,0,1,0);
		
			// Read class logger configurations from config file.
			while(!config_file.eof()){
				string 		line;
				string 		classname = "";
						
				// Default logging class values.
				string info_on   = "1"; 
				string debug_on  = "0";
				string error_on  = "1";
				string detail_on = "0";
			
				std::getline(config_file, line);
				// Debugging
				//cout << line << endl;
			
				if (line[0] == '#')		// Skip comment line.
					continue;
				if (line.size() == 0)	// Skip empty line.
					continue;
			
				// Extract fields from line.
				std::stringstream ss;
				ss << line;
				ss >> classname;
				ss >> info_on;
				ss >> debug_on;
				ss >> error_on;
				ss >> detail_on;
			
				// Debugging
				//cout << "classname : " << classname  << endl;  
				//cout << "info_on   : " << info_on    << endl; 
				//cout << "debug_on  : " << debug_on   << endl; 
				//cout << "error_on  : " << error_on   << endl;
				//cout << "detail_on : " << detail_on  << endl;

				if (classname.compare("DEFAULT") == 0)
				{
					// The default logging is being overidden by an entry in the config file.
					// We don't want to print "DEFAULT" for default logging, so use an empty string.
					classname = "";
				}
				
				m_classmap[classname] = new  Logger(	classname,
														atoi(info_on.c_str()), 
														atoi(debug_on.c_str()), 
														atoi(error_on.c_str()),
														atoi(detail_on.c_str()) );
			}
		}
		else 
		{
			// Create default logger.

			// Default logging class values.
			string info_on   = "1"; 
			string debug_on  = "0";
			string error_on  = "1";
			string detail_on = "1";

			m_classmap[string("")] = new  Logger(string(""),
				atoi(info_on.c_str()), 
				atoi(debug_on.c_str()),
				atoi(error_on.c_str()),
				atoi(detail_on.c_str()) );
		}
	}
}

Logger* 
Logger::getLogger(char* classname)
{
	init_classmap();
	string s(classname);
	for(tclassmap_iter iter = m_classmap.begin(); iter != m_classmap.end(); ++iter)
    {
		string cn 		= iter->first;
		Logger* pLogger = iter->second;
		
		if (s.compare(cn) == 0) {
			return pLogger;	// Found logger for this class, so return it.
		}
    }
	
	// Haven't found logger for this class. Create one using default settings.
	Logger* pDefLogger = m_classmap[string("")];
	m_classmap[classname] = new  Logger(	classname,
											pDefLogger->is_info_on()   == true ? 1 : 0, 
											pDefLogger->is_debug_on()  == true ? 1 : 0, 
											pDefLogger->is_error_on()  == true ? 1 : 0,
											pDefLogger->is_detail_on() == true ? 1 : 0	);
	return m_classmap[classname];
}
	
void 
Logger::info(string& s)
{
	if (is_info_on())
	{
		cerr << getclassname() << "INFO: " << s << endl;
	}
}

void
Logger::info(char* s)
{
	string str(s);
	info(str);
}
	
void 
Logger::debug(string &s)
{
	if (is_debug_on())
	{
		cerr << getclassname() << "DEBUG: " << s << endl;
	}
}

void
Logger::debug(char* s)
{
	string str(s);
	debug(str);
}	

void 
Logger::error(string &s)
{
	if (is_error_on())
	{
		cerr << getclassname() << "ERROR: " << s << endl;
	}
}

void
Logger::error(char* s)
{
	string str(s);
	error(str);
}

void 
Logger::detail(string &s)
{
	if (is_detail_on())
	{
		cerr << getclassname() << "DETAIL: " << s << endl;
	}
}

void
Logger::detail(char* s)
{
	string str(s);
	detail(str);
}