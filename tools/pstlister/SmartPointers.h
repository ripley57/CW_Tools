#ifndef SMART_POINTERS_H_
#define SMART_POINTERS_H_ 

class MapiResource
{
public:
	MapiResource(IUnknown *res) : m_res(res) {}
	~MapiResource(void) { UlRelease(m_res); }

private:
	IUnknown *m_res;
};

class MapiTableRowsResource
{
public:
	MapiTableRowsResource(SRowSet *prows) : m_prows(prows) {}
	~MapiTableRowsResource(void) { FreeProws(m_prows); }

	private:
	SRowSet *m_prows;
};

class MapiSessionResource
{
public:
	MapiSessionResource(IMAPISession *isession) : m_isession(isession) {}
	~MapiSessionResource(void) {
		if (m_isession)
			m_isession->Logoff(0, 0, 0);
		UlRelease(m_isession);
	}
	
private:
	IMAPISession *m_isession;
};

class MapiBufferResource
{
public:
	MapiBufferResource(void *buffer) : m_buffer(buffer) {}
	~MapiBufferResource(void) { MAPIFreeBuffer(m_buffer); }

	private:
	void *m_buffer;
};

#endif