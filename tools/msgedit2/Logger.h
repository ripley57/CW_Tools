#ifndef LOGGER_H
#define LOGGER_H

#include <map>
#include <string>
#include <vector>

using namespace std;

class Logger;

typedef std::map<std::string,Logger*>	 		tclassmap;
typedef std::map<std::string,Logger*>::iterator	tclassmap_iter; 

class Logger
{
private:
	string	m_classname;
	
	int m_info_on;		// Info-level logging.
	int m_debug_on;		// Debug-level logging.
	int m_error_on;		// Error-level logging.
	int m_detail_on;	// Detail-level logging.
		
	Logger* m_pLogger;
	
	// Class logger map.
	static void init_classmap();
	static tclassmap m_classmap;
	
	string getclassname() { return m_classname; }
	
public:
	Logger(string classname, int info_on, int debug_on, int error_on, int detail_on);
	~Logger();
	
	static Logger* getLogger(char* classname);
	static Logger* getLogger() { return getLogger(""); }
	
	void set_info_on() 	  { m_info_on  = 1;  }
	void set_debug_on()	  { m_debug_on = 1;  }
	void set_error_on()	  { m_error_on = 1;  }
	void set_detail_on()  { m_detail_on = 1; }
	
	void set_info_off()   { m_info_on   = 0; }
	void set_debug_off()  { m_debug_on  = 0; }
	void set_error_off()  { m_error_on  = 0; }
	void set_detail_off() { m_detail_on = 0; }
	
	bool is_info_on()	{ return m_info_on   == 1; }
	bool is_debug_on()	{ return m_debug_on  == 1; }
	bool is_error_on()	{ return m_error_on  == 1; }
	bool is_detail_on()	{ return m_detail_on == 1; }
	
	void info(string& s);
	void info(char* s);
	
	void debug(string& s);
	void debug(char* s);
	
	void error(string& s);
	void error(char* s);
	
	void detail(string& s);
	void detail(char* s);
};

#endif
