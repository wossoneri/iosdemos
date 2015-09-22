//
//  AnswerSheetElement.h
//  LibAnswerSheet
//
//  Created by huanghao on 15-2-4.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#ifndef LibAnswerSheetDataStruct_AnswerSheetElement_h
#define LibAnswerSheetDataStruct_AnswerSheetElement_h



#include "TLVBuffer.h"

#include "LibConvertUTF/ConvertUTF.h"

#define TAG_INVALID							0
#define TAG_QUIZ_ROOT						1
#define TAG_QUIZ_DESCRIBE					2
#define TAG_QUIZ_NAME                       3
#define TAG_PAPER_COUNT						4
#define TAG_QUESTION_COUNT					5
#define TAG_QUESTION_NUMBER_TYPE			6
#define TAG_QUIZ_DURATION					7
#define TAG_QUIZ_INFO						8
#define TAG_PAPERS_INFO						9
#define TAG_PAPER							10
#define TAG_QUESTIONS_INFO					11
#define TAG_QUESTION						12
#define TAG_QUESTION_INDEX					13
#define TAG_QUESTION_TYPE					14
#define TAG_QUESTION_SCORE					15
#define TAG_QUESTION_POSITION				16
#define TAG_PAGE_X_POS						17
#define TAG_PAGE_Y_POS						18
#define TAG_CHOICE_COUNT					19
#define TAG_BLANK_COUNT						20
#define TAG_QUESTION_NUMBER					21
#define TAG_QUESTION_GROUP					22
#define TAG_QUIZ_ANSWERS_INFO				23
#define TAG_ANSWER							24
#define TAG_ANSWER_DATA						25
#define TAG_QUIZ_NET_SEND					26
#define TAG_TEST_GUID						27
#define TAG_TEST_ROOT						28
#define TAG_TEST_DESCRIBE					29
#define TAG_TEST_TIME						30
#define TAG_COST_TIME						31
#define TAG_CLASS_MODEL						32
#define TAG_STUDENT_DESCRIBE				33
#define	TAG_STUDENT_INFO					34
#define TAG_STUDENT_NAME					35
#define TAG_STUDENT_MAC						36
#define TAG_STUDENT_USE_TIME				37
#define TAG_QUIZ_PAPER_CACHE_ROOT			38
#define TAG_STUDENT_CLIENTID				39
#define TAG_STUDENT_ANSWERS_INFO			40
#define TAG_STUDENT_ANSWER					41
#define TAG_ANSWER_SCORE					42


class CByteBufferElement
{
	DISABLE_COPY(CByteBufferElement)
    
public:
    
	CByteBufferElement(DWORD dwTag)
    : m_buffer(dwTag)
	{
        
	}
	
	virtual ~CByteBufferElement()
	{
        
	}
    
	CByteBufferElement& SetData(CByteBuffer& buffer)
	{
		m_buffer.PutBuffer(buffer);
		return *this;
	}
    
	CByteBuffer GetByteBuffer()
	{
		return m_buffer.ToByteBuffer();
	}
    
	const CTLVBuffer& GetBuffer()
	{
		return m_buffer;
	}
	
	DWORD GetElementDataSize()
	{
		return m_buffer.GetDataSize();
	}
    
protected:
    
	CTLVBuffer	m_buffer;
};

class CExpandedBufferElement : public CByteBufferElement
{
	DISABLE_COPY(CExpandedBufferElement)
    
public:
    
	CExpandedBufferElement(DWORD dwTag)
    : CByteBufferElement(dwTag)
	{
        
	}
    
	CExpandedBufferElement& AddElement(CByteBufferElement& element)
	{
		m_buffer.PutBuffer(element.GetBuffer());
		return *this;
	}
};

class CDwordElement : public CByteBufferElement
{
	DISABLE_COPY(CDwordElement)
    
public:
    
	CDwordElement(DWORD dwTag)
    : CByteBufferElement(dwTag)
	{
        
	}
    
	CDwordElement& SetData(DWORD dwValue)
	{
		m_buffer.PutDword(dwValue);
        
		return *this;
	}
};

class CFloatElement : public CByteBufferElement
{
	DISABLE_COPY(CFloatElement)
    
public:
    
	CFloatElement(DWORD dwTag)
    : CByteBufferElement(dwTag)
	{
        
	}
    
	CFloatElement& SetData(float fValue)
	{
		m_buffer.PutFloat(fValue);
        
		return *this;
	}
};

class CIntElement : public CByteBufferElement
{
	DISABLE_COPY(CIntElement)
    
public:
    
	CIntElement(DWORD dwTag)
    : CByteBufferElement(dwTag)
	{
        
	}
    
	CIntElement& SetData(int nValue)
	{
		m_buffer.PutInt(nValue);
        
		return *this;
	}
};

class CStringElement : public CByteBufferElement
{
	DISABLE_COPY(CStringElement)
    
public:
    
	CStringElement(DWORD dwTag)
    : CByteBufferElement(dwTag)
	{
		
	}
    
	CStringElement& SetData(const std::string& strValue)
	{
		m_buffer.PutString(strValue);

		return *this;
	}
};

class CGuidElement : public CByteBufferElement
{
	DISABLE_COPY(CGuidElement)
    
public:
    
	CGuidElement(DWORD dwTag)
    : CByteBufferElement(dwTag)
	{
        
	}
    
	CGuidElement& SetData(const GUID& guid)
	{
		m_buffer.PutGuid(guid);
		return *this;
	}
};

class CInt64Element : public CByteBufferElement
{
	DISABLE_COPY(CInt64Element)
    
public:
    
	CInt64Element(DWORD dwTag)
    : CByteBufferElement(dwTag)
	{
        
	}
    
	CInt64Element& SetData(__int64_t value)
	{
		m_buffer.PutInt64(value);
		return *this;
	}
};

class CClientIDElement : public CByteBufferElement
{
	DISABLE_COPY(CClientIDElement)
    
public:
    
	CClientIDElement(DWORD dwTag)
    : CByteBufferElement(dwTag)
	{
        
	}
    
	CClientIDElement& SetData(CLIENTID value)
	{
		m_buffer.PutClientID(value);
		return *this;
	}
};

class CReadElement
{
public:
    
	DWORD	dwTag;
	DWORD	dwSize;
	PBYTE	pbyData;		// Not manage the memory resource
	
	CReadElement()
    : dwTag(TAG_INVALID)
    , dwSize(0)
    , pbyData(NULL)
	{
        
	}
    
	CReadElement(LPBYTE pbyData, DWORD dwSize)
	{
		this->dwTag = TAG_INVALID;
        
		if (NULL != pbyData && dwSize >= sizeof(DWORD) * 2)
		{
			DWORD*	pdwOffset = (DWORD*)pbyData;
            
			this->dwTag = *pdwOffset;
			pdwOffset++;
			this->dwSize = *pdwOffset;
			pdwOffset++;
			this->pbyData = (PBYTE)pdwOffset;
		}
	}
    
	CReadElement Element(DWORD dwTag, DWORD dwIndex = 0)
	{
		DWORD	dwFindCount = 0;
		CReadElement	element;
		element.dwTag = 0;
        
		DWORD	dwOffset = 0;
        
		while (TRUE)
		{
			DWORD*	pdwOffset = (DWORD*)(pbyData + dwOffset);
            
			if (*pdwOffset == dwTag)
			{
				if (dwFindCount == dwIndex)
				{
					++pdwOffset;
					element.dwTag = dwTag;
					element.dwSize =  *pdwOffset;
					++pdwOffset;
					element.pbyData = (PBYTE)pdwOffset;
					break;
				}
				else
				{
					++dwFindCount;
				}
			}
            
			++pdwOffset;
            
			dwOffset += (8 + (*pdwOffset));
            
			if (dwOffset >= dwSize)
			{
				break;
			}
		}
        
		return element;
	}
    
	DWORD GetDword() const
	{
        DWORD* pValue = (DWORD*)pbyData;
        DWORD value = *pValue;
        
		return value;
        
        // default
		//return *((DWORD*)pbyData);
	}
	
	int GetInt() const
	{
        int* pValue = (int*)pbyData;
        int value = *pValue;
        
		return value;
	}
    
	float GetFloat() const
	{
        float fValue;
        memcpy(&fValue, pbyData, sizeof(fValue));
        
        return fValue;
	}
    
    std::string GetString() const
	{
        long dstLen = dwSize * 2;
        UTF8* dst = new UTF8[dstLen];
        CConvertUTF::UTF16ToUTF8(dst, dstLen, (const UTF16*)pbyData, dwSize);
        
        std::string str((char*)dst);
        
        delete []dst;
        
        return str;
	}
	
	CByteBuffer GetByteBuffer() const
	{
		CByteBuffer	buffer;
		buffer.pbyData = pbyData;
		buffer.dwSize = dwSize;
        
		return buffer;
	}
    
	GUID GetGuid() const
	{
		return *((GUID*)pbyData);
	}
    
	Elc_S64 GetInt64() const
	{
		return *((__int64_t*)pbyData);
	}
    
	CLIENTID GetClientID() const
	{
		return *((CLIENTID*)pbyData);
	}
};

typedef CReadElement	CDeleteableReadElement;	// Should release pbyData of this CReadElement

class CFileReadElement
{
	DISABLE_COPY(CFileReadElement)
    
public:
    
	DWORD	dwTag;
	DWORD	dwSize;
    
    CFileReadElement(FILE* & file)
	{
        m_pFile = file;
        
        Elc_U64 pos = ftell(m_pFile);
        
        fread(&dwTag, sizeof(DWORD), 1, m_pFile);
        fread(&dwSize, sizeof(DWORD), 1, m_pFile);
        
        fseek(m_pFile, pos, SEEK_SET);
        
        // old
        //	CFileReadElement(CFile& file)
        //	{
        //		m_pFile = &file;
        //
        //		ULONGLONG pos = m_pFile->GetPosition();
        //
        //		m_pFile->Read(&dwTag, sizeof(DWORD));
        //		m_pFile->Read(&dwSize, sizeof(DWORD));
        //
        //		m_pFile->Seek(pos, FILE_BEGIN);
        //	}
	}
    
	
	CDeleteableReadElement Element(DWORD dwTag, DWORD dwIndex = 0)
	{
        Elc_U64 pos = ftell(m_pFile);
        fseek(m_pFile, sizeof(DWORD)*2, SEEK_CUR);
        CDeleteableReadElement	element;
        DWORD			dwFindCount = 0;
        DWORD			dwOffset = 0;
        
        while( TRUE ) {
            DWORD	dwNextTag;
            DWORD	dwNetTagDataSize;
            fread(&dwNextTag, sizeof(DWORD), 1, m_pFile);
            fread(&dwNetTagDataSize, sizeof(DWORD), 1, m_pFile);
            
            if (dwTag == dwNextTag)
			{
				if (dwFindCount == dwIndex)
				{
					element.dwTag = dwNextTag;
					element.dwSize = dwNetTagDataSize;
					element.pbyData = new BYTE[element.dwSize];
                    
                    fread(element.pbyData, element.dwSize, 1, m_pFile);
					break;
				}
                
				++dwFindCount;
			}
            
            dwOffset += sizeof(DWORD) * 2 + dwNetTagDataSize;
            
			if (dwOffset >= dwSize)
			{
				break;
			}
            
            fseek(m_pFile, dwNetTagDataSize, SEEK_CUR);
        }
        
        fseek(m_pFile, pos, SEEK_SET);
		return element;
        
        
        // old
        //		ULONGLONG pos = m_pFile->GetPosition();
        //		m_pFile->Seek(sizeof(DWORD) * 2, FILE_CURRENT);
        //
        //		CDeleteableReadElement	element;
        //		DWORD			dwFindCount = 0;
        //		DWORD			dwOffset = 0;
        //
        //		while (TRUE)
        //		{
        //			DWORD	dwNextTag;
        //			DWORD	dwNetTagDataSize;
        //			m_pFile->Read(&dwNextTag, sizeof(DWORD));
        //			m_pFile->Read(&dwNetTagDataSize, sizeof(DWORD));
        //
        //			if (dwTag == dwNextTag)
        //			{
        //				if (dwFindCount == dwIndex)
        //				{
        //					element.dwTag = dwNextTag;
        //					element.dwSize = dwNetTagDataSize;
        //					element.pbyData = new BYTE[element.dwSize];
        //
        //					m_pFile->Read(element.pbyData, element.dwSize);
        //					break;
        //				}
        //
        //				++dwFindCount;
        //			}
        //
        //			dwOffset += sizeof(DWORD) * 2 + dwNetTagDataSize;
        //
        //			if (dwOffset >= dwSize)
        //			{
        //				break;
        //			}
        //
        //			m_pFile->Seek(dwNetTagDataSize, FILE_CURRENT);
        //		}
        //
        //		m_pFile->Seek(pos, FILE_BEGIN);
        //		return element;
	}
	
	// Return the offset of child element from parent element
	LONGLONG FindElement(DWORD dwTag, DWORD dwIndex = 0)
	{
		Elc_U64 pos = ftell(m_pFile);
        fseek(m_pFile, sizeof(DWORD) * 2, SEEK_CUR);
		
		LONGLONG		lRes = -1;
		DWORD			dwFindCount = 0;
		DWORD			dwOffset = 0;
        
		while (TRUE)
		{
			DWORD	dwNextTag;
			DWORD	dwNetTagDataSize;
            fread(&dwNextTag, sizeof(DWORD), 1, m_pFile);
            fread(&dwNetTagDataSize, sizeof(DWORD), 1, m_pFile);
            
			if (dwTag == dwNextTag)
			{
				if (dwFindCount == dwIndex)
				{
					Elc_U64 currentPos = ftell(m_pFile);
					lRes = currentPos - pos - sizeof(DWORD) * 2;
					break;
				}
                
				++dwFindCount;
			}
            
			dwOffset += sizeof(DWORD) * 2 + dwNetTagDataSize;
            
			if (dwOffset >= dwSize)
			{
				break;
			}
            
            fseek(m_pFile, dwNetTagDataSize, SEEK_CUR);
		}
        
        fseek(m_pFile, pos, SEEK_SET);
        
		return -1;
	}
    
protected:
    FILE*       m_pFile;
};



#endif
