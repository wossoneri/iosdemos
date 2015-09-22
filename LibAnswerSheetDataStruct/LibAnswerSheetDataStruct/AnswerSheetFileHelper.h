//
//  AnswerSheetFileHelper.h
//  LibAnswerSheet
//
//  Created by huanghao on 15-3-5.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#ifndef __LibAnswerSheetDataStruct__AnswerSheetFileHelper__
#define __LibAnswerSheetDataStruct__AnswerSheetFileHelper__


#include "CodeSnippets/Guid.h"
#include "AnswerSheet.h"
#include "ByteBuffer.h"

#ifndef LOWORD
#define LOWORD(l)           ((unsigned short)((unsigned int)(l) & 0xffff))
#endif// LOWORD

#ifndef HIWORD
#define HIWORD(l)           ((unsigned short)((unsigned int)(l) >> 16))
#endif// HIWORD

#ifndef MAKELONG
#define MAKELONG(a, b)      ((Elc_U32)(((Elc_U16)((Elc_U32)(a) & 0xffff)) | ((Elc_U32)((Elc_U16)((Elc_U32)(b) & 0xffff))) << 16))
#endif // MAKELONG

#define ASHEADER_MAGIC	'ASTP'
#define TESTHEADE_MAGIC	'ASTR'

#define LAST_SUPPORT_VERSION		MAKELONG(2, 0)
#define CURRENT_SUPPORT_VERSION		MAKELONG(3, 0)
#define MAIN_VERSION(x)				LOWORD(x)
#define SUB_VERSION(x)				HIWORD(x)

#define QUIZ_EXTEND_NAME			std::string(".astp")
#define QUIZ_EXTEND_NAME_NO_DOT		std::string("astp")

#define OLD_QUIZ_EXTEND_NAME        std::string(".astm")
#define OLD_QUIZ_EXTEND_NAME_NO_DOT std::string("astm")

#define TEST_EXTEND_NAME            std::string(".astr")

#pragma pack(push, 1)

typedef struct tagANSWERSHEET_FILE_HEADER_BASE
{
    Elc_U32 dwMagic; // 'ASTP'
    Elc_U32 dwVersion;
    Elc_U32 cbSize;
} ANSWERSHEET_FILE_HEADER_BASE, *pANSWERSHEET_FILE_HEADER_BASE;

typedef struct tagSTUDENT_QUIZ_PAPER_CACHE_BASE
{
	GUID	guidTest;
    Elc_U32	dwStartTestTime;
}STUDENT_QUIZ_PAPER_CACHE_BASE, *PSTUDENT_QUIZ_PAPER_CACHE_BASE;

#pragma pack(pop)

class CAnswerSheetFileHelper
{
public:
    //1.0
    static Elc_BOOL ReadAnswerSheet_1_0(CAnswerSheet& answerSheet, Elc_BOOL& bSubVersionOverCurrent, const std::string& strFilePath, Elc_BOOL bMustQuizFile);

    //2.0
    static Elc_BOOL ReadAnswerSheet_2_0(CAnswerSheet& answerSheet, Elc_BOOL& bSubVersionOverCurrent, const std::string& strFilePath, Elc_BOOL bMustQuizFile);

    //3.0
//    static Elc_BOOL ReadAnswerSheet(CAnswerSheet& answerSheet, Elc_BOOL& bSubVersionOverCurrent, const std::string& strFilePath, Elc_BOOL bMustQuizFile);

    
    // in use
    static Elc_BOOL ReadAnswerSheet(CAnswerSheet& answerSheet, CByteBuffer& netBuf, const std::string& strFilePath, GUID& guid, Elc_BOOL bMustQuizFile);
    
    
    
    static Elc_BOOL WriteAnswerSheet(const CAnswerSheet& answerSheet, const std::string& strFilePath);
    
    static Elc_BOOL getQuizFileInfoAtPath(const std::string& strFilePath,
                                                std::string& strPaperFirst,
                                                std::string& strQuizName);
    
private:
    static Elc_BOOL GetFileHead(ANSWERSHEET_FILE_HEADER_BASE &head, const std::string &strFilePath);
};

// Qt--default
//#define ASHEADER_MAGIC	'ASTP'
//#define TESTHEADE_MAGIC	'ASTR'
//
//#define LAST_SUPPORT_VERSION		MAKELONG(2, 0)
//#define CURRENT_SUPPORT_VERSION		MAKELONG(3, 0)
//#define MAIN_VERSION(x)				LOWORD(x)
//#define SUB_VERSION(x)				HIWORD(x)
//
//#define QUIZ_EXTEND_NAME			QString(".astp")
//#define QUIZ_EXTEND_NAME_NO_DOT		QString("astp")
//
//#define OLD_QUIZ_EXTEND_NAME        QString(".astm")
//#define OLD_QUIZ_EXTEND_NAME_NO_DOT QString("astm")
//
//#define TEST_EXTEND_NAME            QString(".astr")
//
//#pragma pack(push, 1)
//
//typedef struct tagANSWERSHEET_FILE_HEADER_BASE
//{
//    Elc_U32 dwMagic; // 'ASTP'
//    Elc_U32 dwVersion;
//    Elc_U32 cbSize;
//} ANSWERSHEET_FILE_HEADER_BASE, *pANSWERSHEET_FILE_HEADER_BASE;
//
//typedef struct tagSTUDENT_QUIZ_PAPER_CACHE_BASE
//{
//	GUID	guidTest;
//    Elc_U32	dwStartTestTime;
//}STUDENT_QUIZ_PAPER_CACHE_BASE, *PSTUDENT_QUIZ_PAPER_CACHE_BASE;
//
//#pragma pack(pop)
//
//class LIBANSWERSHEETSHARED_EXPORT CAnswerSheetFileHelper
//{
//public:
//    //1.0
//    static Elc_BOOL ReadAnswerSheet_1_0(CAnswerSheet& answerSheet, Elc_BOOL& bSubVersionOverCurrent, const QString& strFilePath, Elc_BOOL bMustQuizFile);
//    
//    //2.0
//    static Elc_BOOL ReadAnswerSheet_2_0(CAnswerSheet& answerSheet, Elc_BOOL& bSubVersionOverCurrent, const QString& strFilePath, Elc_BOOL bMustQuizFile);
//    
//    //3.0
//    static Elc_BOOL ReadAnswerSheet(CAnswerSheet& answerSheet, Elc_BOOL& bSubVersionOverCurrent, const QString& strFilePath, Elc_BOOL bMustQuizFile);
//    
//    //
//    static Elc_BOOL ReadAnswerSheet(
//                                    __out CAnswerSheet&			answerSheet,
//                                    __out CByteBuffer&			answerSheetNetSend,
//                                    __out Elc_BOOL&					bSubVersionOverCurrent,
//                                    __in GUID&					guid,
//                                    __in const QString&			strFilePath,
//                                    __in Elc_BOOL					bMustQuizFile
//                                    );
//    
//    static Elc_BOOL WriteAnswerSheet(const CAnswerSheet& answerSheet, const QString& strFilePath);
//    
//    //
//    static Elc_BOOL WriteTestInfo(
//                                  __in const CAnswerSheet&				answerSheet,
//                                  __in const CAnswerSheetTestInfo&		info,
//                                  __in const vector<CStudentAnswer*>&		studentAnswers
//                                  );
//    
//    static Elc_BOOL ReadTestInfo(
//                                 __out CAnswerSheet&				answerSheet,
//                                 __out CAnswerSheetTestInfo&		info,
//                                 __out vector<CStudentAnswer*>&	studentAnswers,
//                                 __out Elc_BOOL&						bSubVersionOverCurrent,
//                                 __in const QString&				strFilePath
//                                 );
//    static Elc_BOOL ReadTestInfo(__out CAnswerSheetTestInfo& info, __out Elc_BOOL&	bSubVersionOverCurrent, __in const QString& strFilePath);
//    
//    // student part
//    static Elc_BOOL ReadAnswerSheet(
//                                    __out CAnswerSheet&				answerSheet,
//                                    __in const QString&				strQuizPaperCachePath,
//                                    __in const QString&				strQuizAnswerPath,
//                                    __in Elc_U32						dwVersion
//                                    );
//    
//    static Elc_BOOL GetSaveTestFlag(STUDENT_QUIZ_PAPER_CACHE_BASE& head, const QString& strQuizPaperPath);
//    
//    static Elc_BOOL WriteQuizPaperCache(
//                                        __in STUDENT_QUIZ_PAPER_CACHE_BASE& head,
//                                        __in const CAnswerSheet&			answerSheet,
//                                        __in const QString&					strQuizPaperPath
//                                        );
//    
//    static Elc_BOOL WriteQuizAnswers(__in const CAnswerSheet& answerSheet, __in const QString& strAnswerPath);
//    
//    
//private:
//    
//    static Elc_BOOL GetFileHead(ANSWERSHEET_FILE_HEADER_BASE& head, const QString& strFilePath);
//};


#endif /* defined(__LibAnswerSheet__AnswerSheetFileHelper__) */
