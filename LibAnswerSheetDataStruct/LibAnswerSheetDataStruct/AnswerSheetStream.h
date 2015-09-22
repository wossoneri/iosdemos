//
//  AnswerSheetStream.h
//  LibAnswerSheet
//
//  Created by huanghao on 15-3-5.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#ifndef __LibAnswerSheetDataStruct__AnswerSheetStream__
#define __LibAnswerSheetDataStruct__AnswerSheetStream__

#include <iostream>

#include "AnswerSheet.h"
#include "AnswerSheetElement.h"

class CAnswerSheetStream
{
public:
    static Elc_BOOL FromStream_QuizInfo(CReadElement& quizPaperDescribe,
                                        CReadElement& quizPaperInfo,
                                        std::string& strPaperFirst,
                                        std::string& strQuizName);
    
    static Elc_BOOL FromStream_Quiz(
                                    CAnswerSheet&			answerSheet,
                                    CReadElement&			quizPaperDescribe,
                                    CReadElement&			quizPaperInfo,
                                    CReadElement&			quizAnswersInfo,
                                    Elc_U32					dwVersion
                                    );
    
    static Elc_BOOL FromStream_QuizNetSend(
                                           GUID&					guid,
                                           CAnswerSheet&			answerSheet,
                                           CReadElement&			netSendRoot,
                                           Elc_U32					dwVersion
                                           );
    
    static void ToStream_QuizNetSend(
                                    CDeleteableByteBuffer&      buffer,
                                    GUID&						guid,
                                    CReadElement&				quizPaperDescribe,
                                    CReadElement&				quizPaperInfo
                                     );
    
public:
    static Elc_BOOL ToStream_Quiz(CByteBuffer& buffer, const CAnswerSheet& answerSheet);
    
    
private:
    static Elc_BOOL ToStream_AnswerData(CDeleteableByteBuffer& buffer, const AAnswer* pAnswer);
//    static AAnswer* FromStream_AnswerData(QUESTION_TYPE questionType, const CReadElement& answerData);
    
    static void BulidQuizPaperDescribeElement(CExpandedBufferElement& element, const CAnswerSheet& answerSheet);
    static Elc_BOOL BulidQuizPaperInfoElement(CExpandedBufferElement& element, const CAnswerSheet& answerSheet);
    static Elc_BOOL BulidAnswerSheetAnswersElement(CExpandedBufferElement& element, const CAnswerSheet& answerSheet);
    
    
};


#endif /* defined(__LibAnswerSheet__AnswerSheetStream__) */


// Qt
//#ifndef ANSWERSHEET_STREAM_H
//#define ANSWERSHEET_STREAM_H
//
//#include "AnswerSheetElement.h"
//
//#include "BasicMacroDefine.h"
//#include "CodeSnippets/basic_helper.h"
//#include "AnswerSheetTestInfo.h"
//#include "CodeSnippets/Guid.h"
//#include "../DataStruct/StudentAnswer.h"
//
//class LIBANSWERSHEETSHARED_EXPORT CAnswerSheetStream
//{
//public:
//    static Elc_BOOL FromStream_Quiz(
//                                    CAnswerSheet&			answerSheet,
//                                    CReadElement&			quizPaperDescribe,
//                                    CReadElement&			quizPaperInfo,
//                                    CReadElement&			quizAnswersInfo,
//                                    Elc_U32					dwVersion
//                                    );
//    
//    
//    static deleteable Elc_BOOL ToStream_Quiz(CByteBuffer& buffer, const CAnswerSheet& answerSheet);
//    static deleteable Elc_BOOL ToStream_QuizPaper(__out CByteBuffer& buffer, __in const CAnswerSheet& answerSheet);
//    static deleteable Elc_BOOL ToStream_QuizAnswers(__out CByteBuffer& buffer, __in const CAnswerSheet& answerSheet);
//    
//    static void ToStream_QuizNetSend(
//                                     __out CDeleteableByteBuffer&	buffer,
//                                     __in GUID&						guid,
//                                     __in CReadElement&				quizPaperDescribe,
//                                     __in CReadElement&				quizPaperInfo
//                                     );
//    
//    static Elc_BOOL FromStream_TestInfo(
//                                        __out CAnswerSheetTestInfo& info,
//                                        __in CReadElement&			testDescribeElement,
//                                        __in CReadElement&			quizDescribeElement,
//                                        __in Elc_U32					dwVersion
//                                        );
//    
//    static Elc_BOOL FromStream_TestInfo(
//                                        __out CAnswerSheet&				answerSheet,
//                                        __out CAnswerSheetTestInfo&		info,
//                                        __out vector<CStudentAnswer*>&	studentAnswers,
//                                        __in CReadElement&						testDescribeElement,
//                                        __in CReadElement&						quizDescribeElement,
//                                        __in CReadElement&						quizInfoElement,
//                                        __in CReadElement&						quizAnswersInfoElement,
//                                        __in CReadElement&						studentAnswersInfoElement,
//                                        __in Elc_U32								dwVersion
//                                        );
//    
//    static Elc_BOOL ToStream_TestInfo(
//                                      __out CDeleteableByteBuffer& buffer,
//                                      __in const CAnswerSheet& answerSheet,
//                                      __in const CAnswerSheetTestInfo& info,
//                                      __in const vector<CStudentAnswer*>& studentAnswers );
//    
//    static AAnswer* FromStream_AnswerNetSend(__in QUESTION_TYPE questionType, __in CReadElement& answer);
//    
//    static Elc_BOOL FromStream_QuizNetSend(
//                                           __out GUID&					guid,
//                                           __out CAnswerSheet&			answerSheet,
//                                           __in CReadElement&			netSendRoot,
//                                           __in Elc_U32					dwVersion
//                                           );
//    
//    static Elc_BOOL ToStream_AnswerNetSend(
//                                           __out CDeleteableByteBuffer&	buffer,
//                                           __in int						iQuestionIndex,
//                                           __in const AAnswer*				pAnswer
//                                           );
//    
//private:
//    
//    static Elc_BOOL ToStream_AnswerData(CDeleteableByteBuffer& buffer, const AAnswer* pAnswer);
//    static deleteable AAnswer* FromStream_AnswerData(QUESTION_TYPE questionType, const CReadElement& answerData);
//    
//    static void BulidTestDescribeElement(__out CExpandedBufferElement& element, __in const CAnswerSheetTestInfo& info);
//    static void BulidQuizPaperDescribeElement(CExpandedBufferElement& element, const CAnswerSheet& answerSheet);
//    static Elc_BOOL BulidQuizPaperInfoElement(CExpandedBufferElement& element, const CAnswerSheet& answerSheet);
//    static Elc_BOOL BulidAnswerSheetAnswersElement(CExpandedBufferElement& element, const CAnswerSheet& answerSheet);
//    
//    static Elc_BOOL BulidStudentAnswersElement(__out CExpandedBufferElement& element, __in const vector<CStudentAnswer*>& studentAnswers);
//    
//    static Elc_BOOL FromStream_StudentAnswersInfo(__out vector<CStudentAnswer*>& studentAnswers, __in const CAnswerSheet& answerSheet, __in CReadElement& studentAnswersInfoElement);
//};
//
//
//
//#endif
