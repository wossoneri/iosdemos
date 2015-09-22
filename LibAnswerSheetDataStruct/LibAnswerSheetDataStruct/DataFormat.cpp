//
//  DataFormat.cpp
//  LibAnswerSheet
//
//  Created by huanghao on 15-3-5.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#include "DataFormat.h"




void DataFormat::stringToUtf16ByteBuffer(CByteBuffer& buffer, const std::string& text)
{
    std::wstring strTmp(text.begin(), text.end());
    
    
    const wchar_t* utf16Text = strTmp.data();
    int length = 0;
    
    while (0 != *(utf16Text+length))
    {
        ++length;
    }
    
    buffer.dwSize = (length + 1) * sizeof(unsigned short);
    buffer.pbyData = new Elc_U8[buffer.dwSize];
    
    unsigned short*	pbyData = (unsigned short*)buffer.pbyData;
    pbyData[length] = 0;
    
    for (int i = 0; i < length; ++i)
    {
        pbyData[i] = utf16Text[i];
    }
    
}

// Qt
//void DataFormat::qstringToUtf16ByteBuffer(CByteBuffer &buffer, const QString &text)
//{
//    const ushort* utf16Text = text.utf16();
//    int length = 0;
//    
//    while (0 != *(utf16Text+length))
//    {
//        ++length;
//    }
//    
//    buffer.dwSize = (length + 1) * sizeof(ushort);
//    buffer.pbyData = new Elc_U8[buffer.dwSize];
//    
//    ushort*	pbyData = (ushort*)buffer.pbyData;
//    pbyData[length] = 0;
//    
//    for (int i = 0; i < length; ++i)
//    {
//        pbyData[i] = utf16Text[i];
//    }
//}
