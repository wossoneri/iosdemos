#ifndef TLVBUFFER_H
#define TLVBUFFER_H

//
#include "CodeSnippets/Guid.h"
#include "CodeSnippets/Protocol.h"

#include "ConvertUTF.h"

//
#include "ByteBuffer.h"

class CByteItem
{
	DISABLE_COPY(CByteItem)

public:
	CByteItem()
		: dwRef(1)
		, lpbyData(NULL)
		, dwSize(0)
	{

	}

    CByteItem(Elc_U32 dwSize)
		: dwRef(1)
	{

        this->lpbyData = new Elc_U8[dwSize];
		this->dwSize = dwSize;
	}

	void AddRef()
	{
		++dwRef;
	}

	void ReleaseRef()
	{
		--dwRef;

		if (dwRef == 0)
		{
			delete this;
		}
	}


    Elc_U8 *	lpbyData;
    Elc_U32	dwSize;
    Elc_U32	dwRef;

private:

	~CByteItem()
	{
		SAFE_DELETE_ARRAY(lpbyData);
	}
};

class CTLVBuffer
{
	DISABLE_COPY(CTLVBuffer)

public:

    CTLVBuffer(Elc_U32 dwTag)
	{
		CByteItem*	item = new CByteItem(8);
        Elc_U32*	pdwOffset = (Elc_U32*)item->lpbyData;
		*pdwOffset = dwTag;
		pdwOffset++;
		*pdwOffset = 0;

		m_memorys.push_back(item);
	}

	~CTLVBuffer()
	{
		for (int i = 0; i < (int)m_memorys.size(); ++i)
		{
			m_memorys[i]->ReleaseRef();
		}
	}
	
    Elc_U32 GetDataSize()
	{
        Elc_U32*	pdwOffset = (Elc_U32*)m_memorys[0]->lpbyData;
		pdwOffset++;
		return *pdwOffset;
	}

    void PutDword(Elc_U32 dwValue)
	{
		CByteBuffer	buffer;
        buffer.dwSize = sizeof(Elc_U32);
        buffer.pbyData = new Elc_U8[buffer.dwSize];

        *((Elc_U32*)buffer.pbyData) = dwValue;

		PutBuffer(buffer);
	}

	void PutFloat(float fValue)
	{
		CByteBuffer	buffer;
		buffer.dwSize = sizeof(float);
        buffer.pbyData = new Elc_U8[buffer.dwSize];
		*((float*)buffer.pbyData) = fValue;

		PutBuffer(buffer);
	}

	void PutInt(int nValue)
	{
		CByteBuffer	buffer;
		buffer.dwSize = sizeof(int);
        buffer.pbyData = new Elc_U8[buffer.dwSize];

		*((int*)buffer.pbyData) = nValue;

		PutBuffer(buffer);
	}

    void PutString(const std::string& strText)
	{
        int len1 = (int)strText.length() + 1;
        const char* data1 = strText.data();
        
        int utf16Len = len1 * 2;
        UTF16* utf16Data = new UTF16[utf16Len];
        CConvertUTF::UTF8ToUTF16(utf16Data, utf16Len, (UTF8*)data1, len1);
        
        CByteBuffer	buffer;
        buffer.dwSize = (DWORD)utf16Len;
        buffer.pbyData = new BYTE[buffer.dwSize];
        
        memset(buffer.pbyData, 0, buffer.dwSize);
        memcpy(buffer.pbyData, (PBYTE)utf16Data, buffer.dwSize);

        delete []utf16Data;
        
        PutBuffer(buffer);
        
        // BD
        long utf8Len = utf16Len/2;
        UTF8* utf8Data = new UTF8[utf8Len];
        CConvertUTF::UTF16ToUTF8(utf8Data, utf8Len, (UTF16*)(buffer.pbyData), (long)buffer.dwSize);
        
        char a0 = utf8Data[0];
        char a1 = utf8Data[1];
        char a2 = utf8Data[2];
        char a3 = utf8Data[3];
        char a4 = utf8Data[4];

        
        int a=2;
        int b=a;
        // ED
	}

	void PutGuid(const GUID& guid)
	{
		CByteBuffer	buffer;
		buffer.dwSize = sizeof(GUID);
        buffer.pbyData = new Elc_U8[buffer.dwSize];

		*((GUID*)buffer.pbyData) = guid;

		PutBuffer(buffer);
	}

	void PutClientID(CLIENTID clientID)
	{
		CByteBuffer	buffer;
		buffer.dwSize = sizeof(CLIENTID);
        buffer.pbyData = new Elc_U8[buffer.dwSize];

		memcpy(buffer.pbyData, &clientID, buffer.dwSize);

		PutBuffer(buffer);
	}

    void PutInt64(Elc_S64 value)
	{
		CByteBuffer	buffer;
		buffer.dwSize = 6;
        buffer.pbyData = new Elc_U8[sizeof(Elc_S64)];

        *((Elc_S64*)buffer.pbyData) = value;

		PutBuffer(buffer);
	}

	void PutBuffer(const CTLVBuffer& buffer)
	{
        Elc_U32	dwAddSize = 0;
		for (int i = 0; i < (int)buffer.m_memorys.size(); ++i)
		{
			dwAddSize += buffer.m_memorys[i]->dwSize;
			buffer.m_memorys[i]->AddRef();
			m_memorys.push_back(buffer.m_memorys[i]);
		}

        Elc_U32*	pdwOffset = (Elc_U32*)m_memorys[0]->lpbyData;
		pdwOffset++;
		*pdwOffset = *pdwOffset + dwAddSize;
	}
	
	void PutBuffer(CByteBuffer buffer)
	{
		CByteItem*	item = new CByteItem();
		item->lpbyData = buffer.pbyData;
		item->dwSize = buffer.dwSize;

		m_memorys.push_back(item);

        Elc_U32*	pdwOffset = (Elc_U32*)m_memorys[0]->lpbyData;
		pdwOffset++;
		*pdwOffset = *pdwOffset + buffer.dwSize;
	}

	CByteBuffer ToByteBuffer() const
	{
        Elc_U32	dwTotalSize = 0;

		for (int i = 0; i < (int)m_memorys.size(); ++i)
		{
			dwTotalSize += m_memorys[i]->dwSize;
		}

		CByteBuffer	buffer;
        buffer.pbyData = new Elc_U8[dwTotalSize];
		buffer.dwSize = dwTotalSize;

        Elc_U32	dwOffset = 0;
		for (int i = 0; i < (int)m_memorys.size(); ++i)
		{
			memcpy(buffer.pbyData + dwOffset, m_memorys[i]->lpbyData, m_memorys[i]->dwSize);
			dwOffset += m_memorys[i]->dwSize;
		}

		return buffer;
	}

private:
	vector<CByteItem*>	m_memorys;
};

#endif
