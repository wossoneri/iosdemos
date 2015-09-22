#ifndef BYTEBUFFER_H
#define BYTEBUFFER_H

#include "AnswerSheetCommon.h"

#include "ELC_Types_AS.h"

class CByteBuffer
{
public:

	CByteBuffer()
		: pbyData(NULL)
		, dwSize(0)
	{

	}

    CByteBuffer(Elc_U8 * pbyData, Elc_U32 dwSize)
	{
		this->pbyData = pbyData;
		this->dwSize = dwSize;
	}

    Elc_U8 *	pbyData;
    Elc_U32	dwSize;
};

typedef CByteBuffer CDeleteableByteBuffer;	// Should release the pbyData of this buffer

#endif
