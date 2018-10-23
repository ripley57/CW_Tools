#include <mapiutil.h>
#include <imessage.h>

#include "Logger.h"
#include "Session.h"

using namespace std;

class Msg
{
private:
	string		m_msgpath;
	bool		m_msgopen;				// Indicates if the msg file has been opened, i.e. read from disk.

	IStorage* 	m_pIStorage;
    IMessage* 	m_pIMessage;
	LPMSGSESS	m_pMsgSession;			// Message session used for serialization/deserialization
	LPMESSAGE 	m_pIMsg;				// The underlying IMesssage object
	
	Session*	m_pSession;
	
	bool is_open()	{	return m_msgopen;	}
	bool OpenMsg();
	
	Logger* m_pLogger;
	
	LPSTR ConcatRecipients(LPADRLIST pAdrList);
	bool AddRecipient(string& display, bool bNewList=false) { return AddRecipient(display, string("")); }
	bool AddRecipient(string& display, string& email, bool bNewList=false);
	bool AddMultipleRecipients(vector<string>& vRecipients, bool bNewList=false);
	void trim_chars(string& s, string& trimchars);
	void trim_leading_chars(string& s, string& trimchars);
	void trim_trailing_chars(string& s, string& trimchars);
	
public:
	Msg(string& msgpath);
	Msg(string& msgpath, Session* pSession);
	~Msg();

	bool setSubject(string& text, bool unicode = false);
	bool getSubject(string& text);	
	
	bool setRecipients(string& text, bool unicode = false);
	bool getRecipients(string& text);
	
	bool addAttachFile(string& sAttachName, string& sAttachPath);
	bool addAttachInline(string& sAttachName, string& sInlineBodyText);
	static std::string convertHRESULTtoHex(HRESULT hRes);
	
	bool delete_PR_RTF_COMPRESSED();
	
	bool setBody(string& sBodyFilePath);
	
	bool deserializeIMsgFromFile();
	LPMESSAGE getIMessage(void) { return m_pIMsg; };
};
