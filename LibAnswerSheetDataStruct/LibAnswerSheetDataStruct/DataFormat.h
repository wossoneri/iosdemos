//
//  DataFormat.h
//  LibAnswerSheet
//
//  Created by huanghao on 15-3-5.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#ifndef __LibAnswerSheetDataStruct__DataFormat__
#define __LibAnswerSheetDataStruct__DataFormat__

#include <iostream>


#include "ByteBuffer.h"

class DataFormat
{
public:
    DataFormat();
    
    static void stringToUtf16ByteBuffer(CByteBuffer& buffer, const std::string& text);
};


#endif /* defined(__LibAnswerSheet__DataFormat__) */
