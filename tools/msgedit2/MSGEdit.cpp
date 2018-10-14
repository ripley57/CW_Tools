#include <cassert>

#include "Msg.h"
#include "MSGEdit.h"

MSGEdit::MSGEdit(CSVReader& csvReader, Session* session)
	: m_csvReader(csvReader), m_pSession(session), m_pPSTWriter(NULL)
{
	m_pLogger = Logger::getLogger("MSGEDIT");
}

MSGEdit::~MSGEdit()
{
}

bool
MSGEdit::getNextCommand(msgcommand& cmd)
{
	std::vector<string> cmd_args = m_csvReader.readRow();
	
	if (cmd_args.size() > 0)
		cmd = cmd_args;
	
	return (cmd_args.size() > 0);
}

bool 
MSGEdit::processCommand(msgcommand cmd)
{
	string c = cmd[0];		// Actual command, e.g. "UPDATE". The remaining command args vary depending on this.

	if (c.compare("OPEN") == 0)
	{
		return processOpenCommand(cmd);
	}
	else
	if (c.compare("CLOSE") == 0)
	{
		return processCloseCommand(cmd);
	}		
	else
	if (c.compare("UPDATE") == 0)
	{
		return processUpdateCommand(cmd);
	}
	else
	if (c.compare("ADD") == 0)
	{
		return processAddCommand(cmd);
	}
	else
	if (c.compare("DELETE_PR_RTF_COMPRESSED") == 0)
	{
		return processDelete_PR_RTF_COMPRESSED(cmd);
	}
	
	return false;	// Failure.
}

/*
** processOpenCommand()
**
** Description:
**	Create named PST file or open existing PST file.
**
** Example CSV entry:
**	"OPEN","test.pst"
*/
bool
MSGEdit::processOpenCommand(msgcommand& cmd)
{
	string c	= cmd[0];		// "OPEN"
	
	string cmd_pstname = cmd[1];
	
	if (m_pPSTWriter != NULL)
	{
		if (cmd_pstname.compare(m_pPSTWriter->getPSTFileName()) == 0)
			return true;
	}
	else
	{
		m_pPSTWriter->close();	
		delete m_pPSTWriter;
		m_pPSTWriter = NULL;
	}
	
	m_pPSTWriter = new PSTWriter(cmd_pstname);
	bool ret = m_pPSTWriter->open();
	
	return ret;
}

/*
** processCloseCommand()
**
** Description:
**	Close the specified PST file.
**
** Example CSV entry:
**	"CLOSE","test.pst"
*/
bool
MSGEdit::processCloseCommand(msgcommand& cmd)
{
	string c	= cmd[0];		// "CLOSE"
	
	string cmd_pstname = cmd[1];
	
	bool ret = false;
	if (m_pPSTWriter != NULL) 
	{
		if (cmd_pstname.compare(m_pPSTWriter->getPSTFileName()) == 0)
		{
			ret = m_pPSTWriter->close();
			delete m_pPSTWriter;
			m_pPSTWriter = NULL;
		}
	}
	
	return ret;
}

bool 
MSGEdit::processUpdateCommand(msgcommand cmd)
{
	string c 	= cmd[0];		// "UPDATE"
	string c1 	= cmd[1];		// "SUBJECT", "RECIPIENTS", "BODY"

	if (c1.compare("SUBJECT") == 0)
	{
		return processUpdateSubjectCommand(cmd);
	}
	else
	if (c1.compare("RECIPIENTS") == 0)
	{
		return processUpdateRecipientsCommand(cmd);
	}
	if (c1.compare("BODY") == 0)
	{
		return processUpdateBodyCommand(cmd);
	}
	else
	{
		m_pLogger->error("MSGEdit::processUpdateCommand: Bad command: " + c1);
	}

	return false;	// Failure.
}

bool
MSGEdit::processAddCommand(msgcommand cmd)
{
	string 	c	= cmd[0];	// "ADD"
	string c1 	= cmd[1];

	if (c1.compare("ATTACH") == 0)
	{
		return processAddAttachment(cmd);
	}
	else
	{
		m_pLogger->error("MSGEdit::processAddCommand: Bad command: " + c1);
	}

	return false;	// Failure.
}

/*
** processAddAttachment()
**
** Description:
**	Add an attachment to a MSG.
**
** Example CSV entry:
**	"ADD","ATTACH","BODY_FILE","test1.msg","attachment1","attach1.txt"
**  "ADD","ATTACH","BODY_INLINE","test1.msg","attachment2","text body for attach2"
*/
bool
MSGEdit::processAddAttachment(msgcommand cmd)
{
	string	c	= cmd[0];	// "ADD"
	string	c1	= cmd[1];	// "ATTACH"
	string	c2	= cmd[2];	// "BODY_INLINE" or "BODY_FILE"
	bool	ret = false;
	
	assert( c.compare("ADD")	== 0);
	
	string cmd_msgpath		= cmd[3];
	string cmd_attachname	= cmd[4];

	Msg msg(cmd_msgpath);

	if (c2.compare("BODY_FILE") == 0) {
		string cmd_attachpath = cmd[5];
		ret = msg.addAttachFile(cmd_attachname, cmd_attachpath);
	}
	else
	if (c2.compare("BODY_INLINE") == 0) {
		string cmd_attachBodyText = cmd[5];
		ret = msg.addAttachInline(cmd_attachname, cmd_attachBodyText);
	}
	else
	{
		m_pLogger->error("MSGEdit::processAddAttachment: Bad command: " + c2);
	}
	
	return ret;	
}

/*
** processDelete_PR_RTF_COMPRESSED()
**
** Description:
**  Delete the PR_RTF_COMPRESSED property from a MSG.
**
** Example CSV entry:
**  "DELETE_PR_RTF_COMPRESSED","test1.msg"
*/
bool
MSGEdit::processDelete_PR_RTF_COMPRESSED(msgcommand cmd)
{
	string c1 = cmd[0];	// "DELETE_PR_RTF_COMPRESSED"
	bool ret = false;
	
	string cmd_msgpath = cmd[1];
	
	Msg msg(cmd_msgpath);
	
	ret = msg.delete_PR_RTF_COMPRESSED();
	
	return ret;
}

bool
MSGEdit::processUpdateRecipientsCommand(msgcommand cmd)
{
	string 	c 		= cmd[0];	// "UPDATE"
	string 	c1		= cmd[1];	// "RECIPIENTS"
	bool	ret;
	
	assert( c.compare("UPDATE")  == 0);
	assert(c1.compare("RECIPIENTS") == 0);
	
	string cmd_msgpath 		= cmd[2];
	string cmd_newrecipients= cmd[3];
	
	Msg msg(cmd_msgpath, m_pSession);
	
	if (m_pLogger->is_debug_on())
	{	
		string s("TO_BE_DETERMINED");
		msg.getRecipients(s);
		m_pLogger->debug("MSGEdit::processUpdateRecipientsCommand: Before recipients=" + s);
	}
	
	ret = msg.setRecipients(cmd_newrecipients);
	
	if (m_pLogger->is_debug_on())
	{
		string s("TO_BE_DETERMINED");
		msg.getRecipients(s);
		m_pLogger->debug("MSGEdit::processUpdateRecipientsCommand: After recipients=" + s);
	}
	
	return ret;
}

bool
MSGEdit::processUpdateBodyCommand(msgcommand cmd)
{
	string c		= cmd[0];	// "UPDATE"
	string c1		= cmd[1];	// "BODY"
	bool ret;
	
	assert( c.compare("UPDATE")  == 0);
	assert(c1.compare("BODY") == 0);
	
	string cmd_msgpath 		= cmd[2];
	string cmd_newbodyfile	= cmd[3];
	
	Msg msg(cmd_msgpath);	

	ret = msg.setBody(cmd_newbodyfile);
	
	return ret;
}

bool
MSGEdit::processUpdateSubjectCommand(msgcommand cmd)
{
	string 	c 		= cmd[0];	// "UPDATE"
	string 	c1		= cmd[1];	// "SUBJECT"
	bool	ret;
	
	assert( c.compare("UPDATE")  == 0);
	assert(c1.compare("SUBJECT") == 0);
	
	string cmd_msgpath 		= cmd[2];
	string cmd_newsubject 	= cmd[3];
	
	Msg msg(cmd_msgpath);	
	
	if (m_pLogger->is_debug_on())
	{	
		string s("TO_BE_DETERMINED");
		msg.getSubject(s);
		m_pLogger->debug("MSGEdit::processUpdateSubjectCommand: Before subject=" + s);
	}
	
	ret = msg.setSubject(cmd_newsubject);
	
	if (m_pLogger->is_debug_on())
	{
		string s("TO_BE_DETERMINED");
		msg.getSubject(s);
		m_pLogger->debug("MSGEdit::processUpdateSubjectCommand: After subject=" + s);
	}
	
	return ret;
}

void
MSGEdit::processAllCommands()
{
	msgcommand cmd;
	while (getNextCommand(cmd))
	{
		m_pLogger->debug("MSGEdit::processAllCommands: Number of args in command: " + cmd.size());
		
		// DEBUG - print the command args.
		if (m_pLogger->is_debug_on())
		{
			msgiter iter;
			int i;
			for (iter = cmd.begin(), i = 1; iter != cmd.end(); iter++, i++)
			{
				m_pLogger->debug("MSGEdit::processAllCommands: command arg: " + i + string(": ") + string(*iter));
			}
		}
		
		// Process the command.
		if (!processCommand(cmd))
		{
			m_pLogger->error("MSGEdit::processAllCommands: Error processing command: " + cmd[0]);
		}
	}
}
