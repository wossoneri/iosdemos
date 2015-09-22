//
//  AnswerSheetFileHelper.cpp
//  LibAnswerSheet
//
//  Created by huanghao on 15-3-5.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#include "HelpFunction.h"
#include "AnswerSheetElement.h"
#include "AnswerSheetStream.h"

//#include "AnswerSheetXmlHelper.h"
#include "AnswerSheetFileHelper.h"

Elc_BOOL CAnswerSheetFileHelper::ReadAnswerSheet_1_0(CAnswerSheet& answerSheet, Elc_BOOL& bSubVersionOverCurrent, const std::string& strFilePath, Elc_BOOL bMustQuizFile)
{
    return Elc_FALSE;
    
// Qt
//    bSubVersionOverCurrent = Elc_FALSE;
//    
//    CAnswerSheet answerSheetTmp;
//    if (!CAnswerSheetXmlHelper::ReadAnswerSheet(answerSheetTmp, strFilePath))
//    {
//        return Elc_FALSE;
//    }
//    
//    answerSheet = answerSheetTmp;
//    
//    std::vector<QString> papersList;
//    answerSheet.SetPapers(papersList);
//    
//    if (0 == answerSheet.GetDuration())
//    {
//        answerSheet.SetDuration(DEFAULT_QUIZ_DURATION);
//    }
//    return Elc_TRUE;
}

Elc_BOOL CAnswerSheetFileHelper::ReadAnswerSheet_2_0(CAnswerSheet& answerSheet, Elc_BOOL& bSubVersionOverCurrent, const std::string& strFilePath, Elc_BOOL bMustQuizFile)
{
    return Elc_FALSE;
    
// Qt
//    bSubVersionOverCurrent = Elc_FALSE;
//    
//    QString szPath = getAnswerSheetTmpPath() + "/AnswerSheet.astm";
//    QFile file(szPath);
//    if( file.exists() ) {
//        file.remove();
//    }
//    
//    CPicpathArray picPathList;
//    std::vector<QString> papersList;
//    CPaperFile paper(&picPathList, szPath, strFilePath);
//    
//    if( !paper.CreateAnswerAndPngByPaper() ) {
//        return Elc_FALSE;
//    }
//    
//    int iHeight = 0;
//    for (int i = 0; i < (int)picPathList.size(); i++)
//    {
//        QString strPath = picPathList[i];
//        
//        QImage image(strPath);
//        if( !image.isNull() ) {
//            iHeight += image.height();
//        }
//        
//        papersList.push_back(strPath);
//    }
//    
//    //
//    CAnswerSheet answerSheetTmp;
//    if( !CAnswerSheetXmlHelper::ReadAnswerSheet(answerSheetTmp, szPath) ) {
//        return Elc_FALSE;
//    }
//    
//    answerSheet = answerSheetTmp;
//    answerSheet.SetPapers(papersList);
//    
//    if (0 == answerSheet.GetDuration())
//    {
//        answerSheet.SetDuration(DEFAULT_QUIZ_DURATION);
//    }
//    
//    if (iHeight > 0)
//    {
//        vector<AQuestion*> questionList = answerSheet.GetQuestion();
//        
//        int x = LARGE_ITEM_H_MARGIN, y = LARGE_ITEM_V_MARGIN;
//        for (int i = 0; i < (int)questionList.size(); i++)
//        {
//            if (y > iHeight - LARGE_ITEM_V_MARGIN)
//            {
//                x +=  LARGE_ITEM_H_MARGIN;
//                y = iHeight - LARGE_ITEM_V_MARGIN;
//            }
//            
//            QPoint pt(x, y);
//            questionList[i]->SetPos(pt);
//            y += LARGE_ITEM_V_MARGIN;
//        }
//    }
//    
//    return Elc_TRUE;
}

//Elc_BOOL CAnswerSheetFileHelper::ReadAnswerSheet(CAnswerSheet& answerSheet,
//                                                 Elc_BOOL& bSubVersionOverCurrent,
//                                                 const std::string& strFilePath,
//                                                 Elc_BOOL bMustQuizFile)
//{
////    return Elc_FALSE;
//    //Elc_U32 timeBeg = GetTickCount();
//
//    Elc_BOOL	bRes = Elc_TRUE;
//    Elc_U8 *	lpbyFileData = NULL;
//    Elc_S64	lFileLength = 0;
//    
//    do
//    {
//        NSString* nsstrFilePath = [NSString stringWithCString:strFilePath.c_str() encoding:NSUTF8StringEncoding];
//        std::string strSuffix = [[nsstrFilePath pathExtension] UTF8String];
//        
//        if( 0 == strSuffix.compare(OLD_QUIZ_EXTEND_NAME_NO_DOT) ) {
//            return ReadAnswerSheet_1_0(answerSheet, bSubVersionOverCurrent, strFilePath, bMustQuizFile);
//        }
//        
//        ANSWERSHEET_FILE_HEADER_BASE head = {0};
//        if (!GetFileHead(head, strFilePath))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        if (ASHEADER_MAGIC != head.dwMagic)
//        {
//            if (bMustQuizFile || TESTHEADE_MAGIC != head.dwMagic)
//            {
//                bRes = Elc_FALSE;
//                break;
//            }
//        }
//        
//        if (MAIN_VERSION(head.dwVersion) == MAIN_VERSION(LAST_SUPPORT_VERSION))
//        {
//            return ReadAnswerSheet_2_0(answerSheet, bSubVersionOverCurrent, strFilePath, bMustQuizFile);
//        } else if (MAIN_VERSION(head.dwVersion) != MAIN_VERSION(CURRENT_SUPPORT_VERSION))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        bSubVersionOverCurrent = (SUB_VERSION(head.dwVersion) > SUB_VERSION(CURRENT_SUPPORT_VERSION));
//        
//        if (!CHelpFunction::readFileEntire(lpbyFileData, lFileLength, strFilePath))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        Elc_U8 *	lpbyOffset = lpbyFileData;
//        lpbyOffset += sizeof(ANSWERSHEET_FILE_HEADER_BASE);
//        
//        CReadElement	root(lpbyOffset, (Elc_U32)lFileLength - sizeof(ANSWERSHEET_FILE_HEADER_BASE));
//        
//        if (TAG_INVALID == root.dwTag)
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        CReadElement	quizDescribe = root.Element(TAG_QUIZ_DESCRIBE);
//        CReadElement	quizInfo = root.Element(TAG_QUIZ_INFO);
//        CReadElement	quizAnswersInfo = root.Element(TAG_QUIZ_ANSWERS_INFO);
//        
//        bRes = CAnswerSheetStream::FromStream_Quiz(answerSheet, quizDescribe, quizInfo, quizAnswersInfo, head.dwVersion);
//    } while (Elc_FALSE);
//    
//    SAFE_DELETE_ARRAY(lpbyFileData);
//    
//    //Elc_U32 timeElapse = GetTickCount() - timeBeg;
//    //qDebug("ReadAnswerSheet cost time: %d", timeElapse);
//    
//    return bRes;
//}


Elc_BOOL CAnswerSheetFileHelper::ReadAnswerSheet(CAnswerSheet& answerSheet, CByteBuffer& netBuf, const std::string&strFilePath, GUID& guid, Elc_BOOL bMustQuizFile) {
    
    if (strFilePath.empty()) {
        return Elc_FALSE;
    }
    
    Elc_BOOL    bRet = Elc_TRUE;
    Elc_U8 *    lpbyFileData = NULL;
    Elc_S64     lFileLength = 0;
    
    do {
        ANSWERSHEET_FILE_HEADER_BASE head = {0};
        
        if (!GetFileHead(head, strFilePath)) {
            bRet = Elc_FALSE;
            break;
        }
        
        if (ASHEADER_MAGIC != head.dwMagic) {
            if (bMustQuizFile || TESTHEADE_MAGIC != head.dwMagic) {
                bRet = Elc_FALSE;
                break;
            }
        }
        
        if (!CHelpFunction::readFileEntire(lpbyFileData, lFileLength, strFilePath))
        {
            bRet = Elc_FALSE;
            break;
        }
        
        Elc_U8 * lpbyOffset = lpbyFileData;
        lpbyOffset += sizeof(ANSWERSHEET_FILE_HEADER_BASE);
        
        CReadElement root(lpbyOffset, (Elc_U32)lFileLength - sizeof(ANSWERSHEET_FILE_HEADER_BASE));
        
        if (TAG_INVALID == root.dwTag) {
            bRet = Elc_FALSE;
            break;
        }
        
        CReadElement quizDescribe = root.Element(TAG_QUIZ_DESCRIBE);
        CReadElement quizInfo = root.Element(TAG_QUIZ_INFO);
        CReadElement quizAnswersInfo = root.Element(TAG_QUIZ_ANSWERS_INFO);
        
        bRet = CAnswerSheetStream::FromStream_Quiz(answerSheet, quizDescribe, quizInfo, quizAnswersInfo, head.dwVersion);
        
        CAnswerSheetStream::ToStream_QuizNetSend(netBuf, guid, quizDescribe, quizInfo);
        
    } while (Elc_FALSE);
    
    SAFE_DELETE_ARRAY(lpbyFileData);
    
    return bRet;
    
}


Elc_BOOL CAnswerSheetFileHelper::WriteAnswerSheet(const CAnswerSheet& answerSheet, const std::string& strFilePath)
{
    return Elc_FALSE;
//    Elc_BOOL	bRes = Elc_TRUE;
//    CByteBuffer	buffer;
//    
//    do
//    {
//        // check version
//        NSString* nsstrFilePath = [NSString stringWithCString:strFilePath.c_str() encoding:NSUTF8StringEncoding];
//        std::string strSuffix = [[nsstrFilePath pathExtension] UTF8String];
//        
//        // version 1.0
//        if( 0 == strSuffix.compare(OLD_QUIZ_EXTEND_NAME_NO_DOT) ) {
//            return CAnswerSheetXmlHelper::WriteAnswerSheet(strFilePath, answerSheet.GetQuestion());
//        }
//        
//        //
//        if (!CAnswerSheetStream::ToStream_Quiz(buffer, answerSheet))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        remove(strFilePath.data());
//        
//        //
//        FILE* file = fopen(strFilePath.data(), "wb");
//        if( file == NULL ) {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        ANSWERSHEET_FILE_HEADER_BASE	head;
//        head.dwMagic = ASHEADER_MAGIC;
//        head.dwVersion = CURRENT_SUPPORT_VERSION;
//        head.cbSize = sizeof(ANSWERSHEET_FILE_HEADER_BASE);
//        
//        if (sizeof(head) != fwrite((char*)&head, 1, sizeof(head), file))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        if (buffer.dwSize != fwrite((char*)buffer.pbyData, 1, buffer.dwSize, file))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        // BD
//        long length = 0;
//        fseek(file, 0, SEEK_END);
//        length = ftell(file);
//        fseek(file, 0, SEEK_SET);
//        // ED
//        
//        fclose(file);
//        
//        bRes = Elc_TRUE;
//    } while (Elc_FALSE);
//    
//    SAFE_DELETE_ARRAY(buffer.pbyData);
//    return bRes;
}

Elc_BOOL CAnswerSheetFileHelper::getQuizFileInfoAtPath(const std::string& strFilePath,
                                                             std::string& strPaperFirst,
                                                             std::string& strQuizName)
{
    return Elc_FALSE;
//    Elc_BOOL	bRet = Elc_TRUE;
//    
//    Elc_U8 *	lpbyFileData = NULL;
//    Elc_S64	lFileLength = 0;
//    
//    do {
//        NSString* nsstrFilePath = [NSString stringWithCString:strFilePath.c_str() encoding:NSUTF8StringEncoding];
//        std::string strSuffix = [[nsstrFilePath pathExtension] UTF8String];
//        
//        if( 0 == strSuffix.compare(OLD_QUIZ_EXTEND_NAME_NO_DOT) ) {
//            // 2.0
//            // later parse 2.0's version file, we temporary return Elc_FALSE
//            bRet = Elc_FALSE;
//            break;
//        }
//        
//        ANSWERSHEET_FILE_HEADER_BASE head = {0};
//        if (!GetFileHead(head, strFilePath)) {
//            bRet = Elc_FALSE;
//            break;
//        }
//        
//        if (ASHEADER_MAGIC != head.dwMagic) {
//            if (TRUE || TESTHEADE_MAGIC != head.dwMagic) {
//                bRet = Elc_FALSE;
//                break;
//            }
//        }        
//        
//        if (MAIN_VERSION(head.dwVersion) == MAIN_VERSION(LAST_SUPPORT_VERSION)) {
//            // 2.0
//            // later parse 2.0's version file, we temporary return Elc_FALSE
//            bRet = Elc_FALSE;
//            break;
//        } else if (MAIN_VERSION(head.dwVersion) != MAIN_VERSION(CURRENT_SUPPORT_VERSION)) {
//            bRet = Elc_FALSE;
//            break;
//        }
//
//        if( !CHelpFunction::readFileEntire(lpbyFileData, lFileLength, strFilePath)) {
//            bRet = Elc_FALSE;
//            break;
//        }
//        
//        Elc_U8 *	lpbyOffset = lpbyFileData;
//        lpbyOffset += sizeof(ANSWERSHEET_FILE_HEADER_BASE);
//        
//        CReadElement	root(lpbyOffset, (Elc_U32)lFileLength - sizeof(ANSWERSHEET_FILE_HEADER_BASE));
//        
//        if (TAG_INVALID == root.dwTag) {
//            bRet = Elc_FALSE;
//            break;
//        }
//        
//        CReadElement	quizDescribe = root.Element(TAG_QUIZ_DESCRIBE);
//        CReadElement	quizInfo = root.Element(TAG_QUIZ_INFO);
//        
//        bRet = CAnswerSheetStream::FromStream_QuizInfo(quizDescribe, quizInfo, strPaperFirst, strQuizName);
//    } while (Elc_FALSE);
//    
//    SAFE_DELETE_ARRAY(lpbyFileData);
//    
//    return bRet;
}

Elc_BOOL CAnswerSheetFileHelper::GetFileHead(ANSWERSHEET_FILE_HEADER_BASE &head, const std::string &strFilePath)
{
    Elc_BOOL bRet = Elc_TRUE;
    
    FILE* f = fopen(strFilePath.data(), "rb");
    
    // BD
    long length = 0;
    fseek(f, 0, SEEK_END);
    length = ftell(f);
    fseek(f, 0, SEEK_SET);
    // ED
    
    if( f == NULL ) {
        bRet = Elc_FALSE;
    } else {
        size_t sRead = fread((char*)&head, 1, sizeof(ANSWERSHEET_FILE_HEADER_BASE), f);
        if (sizeof(ANSWERSHEET_FILE_HEADER_BASE) != sRead ) {
            bRet = Elc_FALSE;
        }
    }
    
    return bRet;
}



