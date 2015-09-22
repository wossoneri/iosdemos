//
//  AnswerSheetStream.cpp
//  LibAnswerSheet
//
//  Created by huanghao on 15-3-5.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

//#import "LibAnswerSheetMaker.h"

#include "DataFormat.h"
#include "HelpFunction.h"
//#include "QuestionFactory.h"

//#import "HelpFunction_IOS.h"

#include "AnswerSheetStream.h"


Elc_BOOL CAnswerSheetStream::FromStream_QuizInfo(CReadElement& quizPaperDescribe,
                                                 CReadElement& quizPaperInfo,
                                                 std::string& strPaperFirst,
                                                 std::string& strQuizName)
{
    Elc_BOOL bRet = Elc_FALSE;
    
    strQuizName = quizPaperDescribe.Element(TAG_QUIZ_NAME).GetString();
    
    CReadElement	papersInfo = quizPaperInfo.Element(TAG_PAPERS_INFO);
    Elc_U32	dwIndex = 0;
    if (TAG_INVALID != papersInfo.dwTag)
    {
        std::vector< std::string >	papersPath;
        
        while (Elc_TRUE)
        {
            CReadElement	paper = papersInfo.Element(TAG_PAPER, dwIndex++);
            
            if (TAG_INVALID == paper.dwTag)
            {
                break;
            }
            
            strPaperFirst = CHelpFunction::generateTmpImagePath();

            CHelpFunction::writeFileEntire(paper.pbyData, paper.dwSize, strPaperFirst);
            
            break;
        }
    }
    
    return Elc_TRUE;
}

Elc_BOOL CAnswerSheetStream::FromStream_Quiz(
                                             CAnswerSheet&			answerSheet,
                                             CReadElement&			quizPaperDescribe,
                                             CReadElement&			quizPaperInfo,
                                             CReadElement&			quizAnswersInfo,
                                             Elc_U32					dwVersion)

{
    std::string	strQuizPaperName = quizPaperDescribe.Element(TAG_QUIZ_NAME).GetString();
    QUESTION_NUMBER_TYPE	questionNumberType = (QUESTION_NUMBER_TYPE)quizPaperDescribe.Element(TAG_QUESTION_NUMBER_TYPE).GetDword();
    Elc_U32	dwDuration = quizPaperDescribe.Element(TAG_QUIZ_DURATION).GetDword();
    
    answerSheet.SetName(strQuizPaperName);
    answerSheet.SetQuestionNumberType(questionNumberType);
    answerSheet.SetDuration(dwDuration);
    
    CReadElement	papersInfo = quizPaperInfo.Element(TAG_PAPERS_INFO);
    Elc_U32	dwIndex = 0;
    if (TAG_INVALID != papersInfo.dwTag)
    {
        std::vector< std::string >	papersPath;
        
        while (Elc_TRUE)
        {
            CReadElement	paper = papersInfo.Element(TAG_PAPER, dwIndex++);
            
            if (TAG_INVALID == paper.dwTag)
            {
                break;
            }

            std::string strTempPath(CHelpFunction::generateTmpImagePath());
            std::string	strPath = strTempPath + std::string("/") + CHelpFunction::generateUniqueFileName(std::string(".png"));
            papersPath.push_back(strPath);
            bool success = CHelpFunction::writeFileEntire(paper.pbyData, paper.dwSize, strPath);
            if (success)
                printf("write file successfully!!!!!!!!!!!!!!!!!!");
            else
                printf("write file failed .....................");
        }
        
        answerSheet.SetPapers(papersPath);
    }
    
    CReadElement	questionInfo = quizPaperInfo.Element(TAG_QUESTIONS_INFO);
    std::vector<AQuestion*>	questions;

    if (TAG_INVALID != questionInfo.dwTag)
    {
        dwIndex = 0;
        while (Elc_TRUE)
        {
            CReadElement	question = questionInfo.Element(TAG_QUESTION, dwIndex++);
            
            if (TAG_INVALID == question.dwTag)
            {
                break;
            }

            int	iQuestionIndex = question.Element(TAG_QUESTION_INDEX).GetInt();
            std::string	strQuestionNumber = question.Element(TAG_QUESTION_NUMBER).GetString();
            std::string	strQuestionGroup = question.Element(TAG_QUESTION_GROUP).GetString();
            int	iQuestionType = question.Element(TAG_QUESTION_TYPE).GetInt();
            float fQuestionScore = question.Element(TAG_QUESTION_SCORE).GetFloat();
            
            int	posX = question.Element(TAG_QUESTION_POSITION).Element(TAG_PAGE_X_POS).GetInt();
            int	posY = question.Element(TAG_QUESTION_POSITION).Element(TAG_PAGE_Y_POS).GetInt();

//            AQuestion*	pQuestion = CQuestionFactory::CreateQuestionInstance((QUESTION_TYPE)iQuestionType, iQuestionIndex);
//            pQuestion->SetNumber(strQuestionNumber);
//            pQuestion->SetGroup(strQuestionGroup);
//            pQuestion->SetScore(fQuestionScore);
//            struct Point pt;
//            pt.v = posX;
//            pt.h = posY;
//            pQuestion->SetPos(pt);
//
//            if (choiceQuestion == pQuestion->GetType())
//            {
//                pQuestion->ToChoiceQuestion()->SetChoiceCount(question.Element(TAG_CHOICE_COUNT).GetInt());
//            }
//            else if (completionQuestion == pQuestion->GetType())
//            {
//                pQuestion->ToCompletionQuestion()->SetBlankCount(question.Element(TAG_BLANK_COUNT).GetInt());
//            }
//            
//            questions.push_back(pQuestion);
        }
    }
    
    if (TAG_INVALID != quizAnswersInfo.dwTag)
    {
        dwIndex = 0;

        while (Elc_TRUE)
        {
            CReadElement	answer = quizAnswersInfo.Element(TAG_ANSWER, dwIndex++);
            
            if (TAG_INVALID == answer.dwTag)
            {
                break;
            }

            int	iQuestionIndex = answer.Element(TAG_QUESTION_INDEX).GetInt();
            
            AQuestion*	pQuestion = NULL;
            
            for (int i = 0; i < (int)questions.size(); ++i)
            {
                if (questions[i]->GetIndex() == iQuestionIndex)
                {
                    pQuestion = questions[i];
                    break;
                }
            }
            
            //ASSERT(pQuestion != NULL);
            
            if (pQuestion)
            {
//                AAnswer* pAnswer = FromStream_AnswerData(pQuestion->GetType(), answer.Element(TAG_ANSWER_DATA));
//                pQuestion->SetAnswer(pAnswer);
            }
        }
    }
    
    answerSheet.SetQuestions(questions);
    
    return Elc_TRUE;
}

Elc_BOOL CAnswerSheetStream::FromStream_QuizNetSend(GUID& guid,
                                                    CAnswerSheet& answerSheet,
                                                    CReadElement& netSendRoot,
                                                    Elc_U32 dwVersion )
{
    if (TAG_QUIZ_NET_SEND != netSendRoot.dwTag)
    {
        return Elc_FALSE;
    }
    
    guid = netSendRoot.Element(TAG_TEST_GUID).GetGuid();
    CReadElement eleQuizDescribe = netSendRoot.Element(TAG_QUIZ_DESCRIBE);
    CReadElement eleQuizInfo = netSendRoot.Element(TAG_QUIZ_INFO);
    CReadElement eleEmpty;
    return CAnswerSheetStream::FromStream_Quiz(answerSheet,
                                               eleQuizDescribe,
                                               eleQuizInfo,
                                               eleEmpty,
                                               dwVersion);
}



Elc_BOOL CAnswerSheetStream::ToStream_Quiz(CByteBuffer& buffer, const CAnswerSheet& answerSheet)
{
    Elc_BOOL	bRes = Elc_TRUE;
    
    do
    {
        CExpandedBufferElement	root(TAG_QUIZ_ROOT);
        
        // Quiz Paper Describe
        CExpandedBufferElement  quizDescribe(TAG_QUIZ_DESCRIBE);
        BulidQuizPaperDescribeElement(quizDescribe, answerSheet);
        root.AddElement(quizDescribe);
        
        // Quiz Paper Info
        CExpandedBufferElement	quizInfoElement(TAG_QUIZ_INFO);
        if (!BulidQuizPaperInfoElement(quizInfoElement, answerSheet))
        {
            bRes = Elc_FALSE;
            break;
        }
        
        root.AddElement(quizInfoElement);
        
        // Answer Sheet Answers
        CExpandedBufferElement	quizAnswersInfoElement(TAG_QUIZ_ANSWERS_INFO);
        if (!BulidAnswerSheetAnswersElement(quizAnswersInfoElement, answerSheet))
        {
            bRes = Elc_FALSE;
            break;
        }
        
        if (quizAnswersInfoElement.GetElementDataSize() > 0)
        {
            root.AddElement(quizAnswersInfoElement);
        }
        
        buffer = root.GetByteBuffer();
        bRes = Elc_TRUE;
    } while (Elc_FALSE);
    
    return bRes;
    
// Qt
//    Elc_BOOL	bRes = Elc_TRUE;
//    
//    do
//    {
//        CExpandedBufferElement	root(TAG_QUIZ_ROOT);
//        
//        // Quiz Paper Describe
//        CExpandedBufferElement  quizDescribe(TAG_QUIZ_DESCRIBE);
//        BulidQuizPaperDescribeElement(quizDescribe, answerSheet);
//        root.AddElement(quizDescribe);
//        
//        // Quiz Paper Info
//        CExpandedBufferElement	quizInfoElement(TAG_QUIZ_INFO);
//        if (!BulidQuizPaperInfoElement(quizInfoElement, answerSheet))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        root.AddElement(quizInfoElement);
//        
//        // Answer Sheet Answers
//        CExpandedBufferElement	quizAnswersInfoElement(TAG_QUIZ_ANSWERS_INFO);
//        if (!BulidAnswerSheetAnswersElement(quizAnswersInfoElement, answerSheet))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        if (quizAnswersInfoElement.GetElementDataSize() > 0)
//        {
//            root.AddElement(quizAnswersInfoElement);
//        }
//        
//        buffer = root.GetByteBuffer();
//        bRes = Elc_TRUE;
//    } while (Elc_FALSE);
//    
//    return bRes;
}

Elc_BOOL CAnswerSheetStream::ToStream_AnswerData(CDeleteableByteBuffer& buffer, const AAnswer* pAnswer)
{
    if (!pAnswer->IsValid())
    {
        return Elc_TRUE;
    }
    
    Elc_BOOL	bRes = Elc_TRUE;
//    switch (pAnswer->GetType())
//    {
//        case choiceQuestion:
//        {
//            const vector<int>&	choiceIndex = pAnswer->ToChoiceAnswer()->GetChoiceIndex();
//            buffer.dwSize = (Elc_U32)choiceIndex.size() * sizeof(int);
//            buffer.pbyData = new Elc_U8[buffer.dwSize];
//            
//            int*	pOffset = (int*)buffer.pbyData;
//            
//            for (int i = 0; i < (int)choiceIndex.size(); ++i)
//            {
//                *pOffset = choiceIndex[i];
//                ++pOffset;
//            }
//        }
//            break;
//        case trueFlaseQuestion:
//        {
//            CTrueFalseAnswer::ANSWER_VALUE answer = pAnswer->ToTrueFalseAnswer()->GetAnswer();
//            buffer.dwSize = sizeof(int);
//            buffer.pbyData = new Elc_U8[buffer.dwSize];
//            
//            int*	pOffset = (int*)buffer.pbyData;
//            *pOffset = answer;
//        }
//            break;
//        case completionQuestion:
//        {            
//            DataFormat::stringToUtf16ByteBuffer(buffer, pAnswer->ToCompletionAnswer()->GetAnswer());
//        }
//            break;
//        case essayQuestion:
//        {
//            DataFormat::stringToUtf16ByteBuffer(buffer, pAnswer->ToEssayAnswer()->GetAnswer());
//        }
//            break;
//        case handWritingQuestion:
//        {
//            Elc_U8 *	lpbyData = NULL;
//            Elc_S64     lFileLength = 0;
//            if (CHelpFunction::readFileEntire(lpbyData, lFileLength, pAnswer->ToHandWritingAnswer()->GetAnswer()))
//            {
//                buffer.pbyData = lpbyData;
//                buffer.dwSize = (Elc_U32)lFileLength;
//            }
//            else
//            {
//                bRes = Elc_FALSE;
//            }
//        }
//            break;
//        default:
//            assert(Elc_FALSE);
//            break;
//    }
    
    return bRes;
}

//AAnswer* CAnswerSheetStream::FromStream_AnswerData(QUESTION_TYPE questionType, const CReadElement& answerData)
//{
//    AAnswer*	pAnswer = CAnswerFactory::CreateAnswerInstance(questionType);
//    
//    if (TAG_INVALID == answerData.dwTag || invalidQuestion == pAnswer->GetType())
//    {
//        return pAnswer;
//    }
//    
//    switch (pAnswer->GetType())
//    {
//        case choiceQuestion:
//        {
//            int	choiceCount = answerData.dwSize / sizeof(int);
//            vector<int>	choiceIndex;
//            choiceIndex.resize(choiceCount);
//            
//            int*	pOffset = (int*)answerData.pbyData;
//            
//            for (int i = 0; i < (int)choiceCount; ++i)
//            {
//                choiceIndex[i] = *pOffset;
//                ++pOffset;
//            }
//            
//            pAnswer->ToChoiceAnswer()->SetChoiceIndex(choiceIndex);
//        }
//            break;
//        case trueFlaseQuestion:
//        {
//            pAnswer->ToTrueFalseAnswer()->SetAnswer((CTrueFalseAnswer::ANSWER_VALUE)answerData.GetInt());
//        }
//            break;
//        case completionQuestion:
//        {
//            pAnswer->ToCompletionAnswer()->SetAnswer(answerData.GetString());
//        }
//            break;
//        case essayQuestion:
//        {
//            pAnswer->ToEssayAnswer()->SetAnswer(answerData.GetString());
//        }
//            break;
//        case handWritingQuestion:
//        {
//            CByteBuffer	buffer = answerData.GetByteBuffer();
//            
//            //std::string strAsTmpPath = [[HelpFunction_IOS getAnswerSheetTmpPath] UTF8String];
//            //std::string	strPath = strAsTmpPath + std::string("/") + CHelpFunction::generateUniqueFileName(".png");
//            
//            std::string	strPath = [[HelpFunction_IOS generateTmpImagePath] UTF8String];
//            
//            if (CHelpFunction::writeFileEntire(buffer.pbyData, buffer.dwSize, strPath))
//            {
//                pAnswer->ToHandWritingAnswer()->SetAnswer(strPath);
//            }
//        }
//            break;
//        default:
//            assert(Elc_FALSE);
//            break;
//    }
//    
//    return pAnswer;
//}

void CAnswerSheetStream::BulidQuizPaperDescribeElement(CExpandedBufferElement& element, const CAnswerSheet& answerSheet)
{
    element.AddElement(CStringElement(TAG_QUIZ_NAME).SetData(answerSheet.GetName()));
    element.AddElement(CDwordElement(TAG_PAPER_COUNT).SetData((Elc_U32)answerSheet.GetPapers().size()));
    element.AddElement(CDwordElement(TAG_QUESTION_COUNT).SetData((Elc_U32)answerSheet.GetQuestion().size()));
    element.AddElement(CIntElement(TAG_QUESTION_NUMBER_TYPE).SetData((Elc_U32)answerSheet.GetQuestionNumberType()));
    element.AddElement(CIntElement(TAG_QUIZ_DURATION).SetData(answerSheet.GetDuration()));
}

Elc_BOOL CAnswerSheetStream::BulidQuizPaperInfoElement(CExpandedBufferElement& element, const CAnswerSheet& answerSheet)
{
    const std::vector< std::string >& papers = answerSheet.GetPapers();
    Elc_BOOL	bFailed = Elc_FALSE;
    
    if (!papers.empty())
    {
        // Papers Info
        CExpandedBufferElement	papersInfoElement(TAG_PAPERS_INFO);
        
        int i;
        for (i = 0; i < (int)papers.size(); ++i)
        {
            Elc_U8 *	lpbyData = NULL;
            Elc_S64 length = 0;
            
            if (!CHelpFunction::readFileEntire(lpbyData, length, papers[i]))
            {
                bFailed = Elc_TRUE;
                break;
            }
            
            CByteBuffer	buffer;
            buffer.dwSize = (Elc_U32)length;
            buffer.pbyData = lpbyData;
            papersInfoElement.AddElement(CByteBufferElement(TAG_PAPER).SetData(buffer));
        }
        
        if (i == (int)papers.size())
        {
            element.AddElement(papersInfoElement);
        }
        else
        {
            return Elc_FALSE;
        }
    }
    
    const vector<AQuestion*>& questions = answerSheet.GetQuestion();
    // Question Infos
    if (!questions.empty())
    {
        CExpandedBufferElement	questionsInfoElement(TAG_QUESTIONS_INFO);
        
        for (int i = 0; i < (int)questions.size(); ++i)
        {
            CExpandedBufferElement questionElement(TAG_QUESTION);
            questionElement.AddElement(CDwordElement(TAG_QUESTION_INDEX).SetData(questions[i]->GetIndex()))
            .AddElement(CStringElement(TAG_QUESTION_NUMBER).SetData(questions[i]->GetNumber()))
            .AddElement(CStringElement(TAG_QUESTION_GROUP).SetData(questions[i]->GetGroup()))
            .AddElement(CDwordElement(TAG_QUESTION_TYPE).SetData((Elc_U32)questions[i]->GetType()))
            .AddElement(CFloatElement(TAG_QUESTION_SCORE).SetData(questions[i]->GetScore()))
            .AddElement(CExpandedBufferElement(TAG_QUESTION_POSITION)
                        .AddElement(CDwordElement(TAG_PAGE_X_POS).SetData(questions[i]->GetPos().h))
                        .AddElement(CDwordElement(TAG_PAGE_Y_POS).SetData(questions[i]->GetPos().v)));
            
            if (choiceQuestion == questions[i]->GetType())
            {
//                questionElement.AddElement(CDwordElement(TAG_CHOICE_COUNT).SetData(questions[i]->ToChoiceQuestion()->GetChoiceCount()));
            }
            else if (completionQuestion == questions[i]->GetType())
            {
//                questionElement.AddElement(CDwordElement(TAG_BLANK_COUNT).SetData(questions[i]->ToCompletionQuestion()->GetBlankCount()));
            }
            
            questionsInfoElement.AddElement(questionElement);
        }
        
        element.AddElement(questionsInfoElement);
    }
    
    return Elc_TRUE;
}

Elc_BOOL CAnswerSheetStream::BulidAnswerSheetAnswersElement(CExpandedBufferElement& element, const CAnswerSheet& answerSheet)
{
    // Answer Sheet Answers
    const vector<AQuestion*>& questions = answerSheet.GetQuestion();
    int	i;
    for (i = 0; i < (int)questions.size(); ++i)
    {
        if (questions[i]->GetAnswer()->IsValid())
        {
            CExpandedBufferElement	answerElement(TAG_ANSWER);
            answerElement.AddElement(CDwordElement(TAG_QUESTION_INDEX).SetData(questions[i]->GetIndex()));
            
            CByteBuffer	buffer;
            if (!ToStream_AnswerData(buffer, questions[i]->GetAnswer()))
            {
                break;
            }
            
            answerElement.AddElement(CByteBufferElement(TAG_ANSWER_DATA).SetData(buffer));
            element.AddElement(answerElement);
        }
    }
    
    return i == (int)questions.size();
}

void CAnswerSheetStream::ToStream_QuizNetSend(CDeleteableByteBuffer& buffer, GUID& guid,  CReadElement& quizPaperDescribe,  CReadElement& quizPaperInfo)
{
	CByteBuffer	describeBuffer;
	describeBuffer.dwSize = quizPaperDescribe.dwSize;
	describeBuffer.pbyData = new BYTE[quizPaperDescribe.dwSize];
	memcpy(describeBuffer.pbyData, quizPaperDescribe.pbyData, quizPaperDescribe.dwSize);
    
	CByteBuffer	infoBuffer;
	infoBuffer.dwSize = quizPaperInfo.dwSize;
	infoBuffer.pbyData = new BYTE[infoBuffer.dwSize];
	memcpy(infoBuffer.pbyData, quizPaperInfo.pbyData, quizPaperInfo.dwSize);
    
	CExpandedBufferElement	root(TAG_QUIZ_NET_SEND);
	root.AddElement(CGuidElement(TAG_TEST_GUID).SetData(guid))
    .AddElement(CByteBufferElement(TAG_QUIZ_DESCRIBE).SetData(describeBuffer))
    .AddElement(CByteBufferElement(TAG_QUIZ_INFO).SetData(infoBuffer));
    
	buffer = root.GetByteBuffer();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Qt
//#include "stdafx.h"
//#include "LibAnswerSheet.h"
//#include "AnswerSheetStream.h"
//
//#include "AnswerSheetElement.h"
//
//// Quiz file element format
//// TAG_QUIZ_ROOT
////		TAG_QUIZ_DESCRIBE
////			TAG_QUIZ_NAME
////			TAG_PAPER_COUNT
////			TAG_QUESTION_COUNT
////			TAG_QUESTION_NUMBER_TYPE
////			TAG_QUIZ_DURATION
////		TAG_QUIZ_INFO
////			TAG_PAPERS_INFO
////				TAG_PAPER
////				...
////			TAG_QUESTIONS_INFO
////				TAG_QUESTION
////					TAG_QUESTION_INDEX
////					TAG_QUESTION_NUMBER
////					TAG_QUESTION_GROUP
////					TAG_QUESTION_TYPE
////					TAG_QUESTION_SCORE
////					TAG_QUESTION_POSITION
////						TAG_PAGE_X_POS
////						TAG_PAGE_Y_POS
////					TAG_CHOICE_COUNT
////					TAG_BLANK_COUNT
////				...
////		TAG_QUIZ_ANSWERS_INFO
////			TAG_ANSWER
////				TAG_QUESTION_INDEX
////				TAG_ANSWER_DATE
////			...
//
//// Test file element format
//// TAG_TEST_ROOT
////		TAG_TEST_DESCRIBE
////			TAG_TEST_TIME
////			TAG_COST_TIME
////			TAG_CLASS_MODEL
////			TAG_TEST_GUID
////			TAG_STUDENT_DESCRIBE
////				TAG_STUDENT_INFO
////					TAG_STUDENT_NAME
////					TAG_STUDENT_MAC
////					TAG_STUDENT_USE_TIME
////				...
////		TAG_QUIZ_DESCRIBE
////			TAG_QUIZ_NAME
////			TAG_PAPER_COUNT
////			TAG_QUESTION_COUNT
////			TAG_QUESTION_NUMBER_TYPE
////			TAG_QUIZ_DURATION
////		TAG_QUIZ_INFO
////			TAG_PAPERS_INFO
////				TAG_PAPER
////				...
////			TAG_QUESTIONS_INFO
////				TAG_QUESTION
////					TAG_QUESTION_INDEX
////					TAG_QUESTION_NUMBER
////					TAG_QUESTION_GROUP
////					TAG_QUESTION_TYPE
////					TAG_QUESTION_SCORE
////					TAG_QUESTION_POSITION
////						TAG_PAGE_X_POS
////						TAG_PAGE_Y_POS
////					TAG_CHOICE_COUNT
////					TAG_BLANK_COUNT
////				...
////		TAG_QUIZ_ANSWERS_INFO
////			TAG_ANSWER
////				TAG_QUESTION_INDEX
////				TAG_ANSWER_DATE
////			...
////		TAG_STUDENT_ANSWERS_INFO
////			TAG_STUDENT_ANSWER
////				TAG_STUDENT_NAME
////				TAG_STUDENT_MAC
////				TAG_QUESTION_INDEX
////				TAG_ANSWER_SCORE
////				TAG_ANSWER_DATE
////			...
//
//// Answer Sheet Net Send element format
//// TAG_QUIZ_NET_SEND
////		TAG_QUIZ_DESCRIBE
////			TAG_QUIZ_NAME
////			TAG_PAPER_COUNT
////			TAG_QUESTION_COUNT
////			TAG_QUESTION_NUMBER_TYPE
////			TAG_QUIZ_DURATION
////		TAG_QUIZ_INFO
////			TAG_PAPERS_INFO
////				TAG_PAPER
////				...
////			TAG_QUESTIONS_INFO
////				TAG_QUESTION
////					TAG_QUESTION_INDEX
////					TAG_QUESTION_NUMBER
////					TAG_QUESTION_GROUP
////					TAG_QUESTION_TYPE
////					TAG_QUESTION_SCORE
////					TAG_QUESTION_POSITION
////						TAG_PAGE_X_POS
////						TAG_PAGE_Y_POS
////					TAG_CHOICE_COUNT
////					TAG_BLANK_COUNT
////				...
//
//
///*** Student side ***/
//
//// Quiz Cache elemet format
//// TAG_QUIZ_PAPER_CACHE_ROOT
////		TAG_QUIZ_DESCRIBE
////			TAG_QUIZ_NAME
////			TAG_PAPER_COUNT
////			TAG_QUESTION_COUNT
////			TAG_QUESTION_NUMBER_TYPE
////			TAG_QUIZ_DURATION
////		TAG_QUIZ_INFO
////			TAG_PAPERS_INFO
////				TAG_PAPER
////				...
////			TAG_QUESTIONS_INFO
////				TAG_QUESTION
////					TAG_QUESTION_INDEX
////					TAG_QUESTION_NUMBER
////					TAG_QUESTION_GROUP
////					TAG_QUESTION_TYPE
////					TAG_QUESTION_SCORE
////					TAG_QUESTION_POSITION
////						TAG_PAGE_X_POS
////						TAG_PAGE_Y_POS
////					TAG_CHOICE_COUNT
////					TAG_BLANK_COUNT
////				...
//
//// Student answer save element format
////		TAG_QUIZ_ANSWERS_INFO
////			TAG_ANSWER
////				TAG_QUESTION_INDEX
////				TAG_ANSWER_DATE
////			...
//
//
//// Student answer net send format
////		TAG_ANSWER
////				TAG_QUESTION_INDEX
////				TAG_ANSWER_DATE
//
//Elc_BOOL CAnswerSheetStream::FromStream_Quiz(CAnswerSheet& answerSheet, CReadElement& quizPaperDescribe, CReadElement& quizPaperInfo, CReadElement& quizAnswersInfo, Elc_U32 dwVersion)
//{
//    QString	strQuizPaperName = quizPaperDescribe.Element(TAG_QUIZ_NAME).GetString();
//    QUESTION_NUMBER_TYPE	questionNumberType = (QUESTION_NUMBER_TYPE)quizPaperDescribe.Element(TAG_QUESTION_NUMBER_TYPE).GetDword();
//    Elc_U32	dwDuration = quizPaperDescribe.Element(TAG_QUIZ_DURATION).GetDword();
//    
//    answerSheet.SetName(strQuizPaperName);
//    answerSheet.SetQuestionNumberType(questionNumberType);
//    answerSheet.SetDuration(dwDuration);
//    
//    CReadElement	papersInfo = quizPaperInfo.Element(TAG_PAPERS_INFO);
//    Elc_U32	dwIndex = 0;
//    if (TAG_INVALID != papersInfo.dwTag)
//    {
//        vector<QString>	papersPath;
//        
//        while (Elc_TRUE)
//        {
//            CReadElement	paper = papersInfo.Element(TAG_PAPER, dwIndex++);
//            
//            if (TAG_INVALID == paper.dwTag)
//            {
//                break;
//            }
//            
//            QString strTempPath(getAnswerSheetTmpPath());
//            QString	strPath = strTempPath + QString("/") + CHelpFunction::generateUniqueFildName(QString(".png"));
//            papersPath.push_back(strPath);
//            CHelpFunction::writeFileEntire(paper.pbyData, paper.dwSize, strPath);
//        }
//        
//        answerSheet.SetPapers(papersPath);
//    }
//
//    CReadElement	questionInfo = quizPaperInfo.Element(TAG_QUESTIONS_INFO);
//    vector<AQuestion*>	questions;
//    
//    if (TAG_INVALID != questionInfo.dwTag)
//    {
//        dwIndex = 0;
//        while (Elc_TRUE)
//        {
//            CReadElement	question = questionInfo.Element(TAG_QUESTION, dwIndex++);
//            
//            if (TAG_INVALID == question.dwTag)
//            {
//                break;
//            }
//            
//            int	iQuestionIndex = question.Element(TAG_QUESTION_INDEX).GetInt();
//            QString	strQuestionNumber = question.Element(TAG_QUESTION_NUMBER).GetString();
//            QString	strQuestionGroup = question.Element(TAG_QUESTION_GROUP).GetString();
//            int	iQuestionType = question.Element(TAG_QUESTION_TYPE).GetInt();
//            float fQuestionScore = question.Element(TAG_QUESTION_SCORE).GetFloat();
//            
//            int	posX = question.Element(TAG_QUESTION_POSITION).Element(TAG_PAGE_X_POS).GetInt();
//            int	posY = question.Element(TAG_QUESTION_POSITION).Element(TAG_PAGE_Y_POS).GetInt();
//            
//            AQuestion*	pQuestion = CQuestionFactory::CreateQuestionInstance((QUESTION_TYPE)iQuestionType, iQuestionIndex);
//            pQuestion->SetNumber(strQuestionNumber);
//            pQuestion->SetGroup(strQuestionGroup);
//            pQuestion->SetScore(fQuestionScore);
//            pQuestion->SetPos(QPoint(posX, posY));
//            
//            if (choiceQuestion == pQuestion->GetType())
//            {
//                pQuestion->ToChoiceQuestion()->SetChoiceCount(question.Element(TAG_CHOICE_COUNT).GetInt());
//            }
//            else if (completionQuestion == pQuestion->GetType())
//            {
//                pQuestion->ToCompletionQuestion()->SetBlankCount(question.Element(TAG_BLANK_COUNT).GetInt());
//            }
//            
//            questions.push_back(pQuestion);
//        }
//    }
//    
//    if (TAG_INVALID != quizAnswersInfo.dwTag)
//    {
//        dwIndex = 0;
//        
//        while (Elc_TRUE)
//        {
//            CReadElement	answer = quizAnswersInfo.Element(TAG_ANSWER, dwIndex++);
//            
//            if (TAG_INVALID == answer.dwTag)
//            {
//                break;
//            }
//            
//            int	iQuestionIndex = answer.Element(TAG_QUESTION_INDEX).GetInt();
//            
//            AQuestion*	pQuestion = NULL;
//            
//            for (int i = 0; i < (int)questions.size(); ++i)
//            {
//                if (questions[i]->GetIndex() == iQuestionIndex)
//                {
//                    pQuestion = questions[i];
//                    break;
//                }
//            }
//            
//            //ASSERT(pQuestion != NULL);
//            
//            if (pQuestion)
//            {
//                AAnswer*	pAnswer = FromStream_AnswerData(pQuestion->GetType(), answer.Element(TAG_ANSWER_DATA));
//                pQuestion->SetAnswer(pAnswer);
//            }
//        }
//    }
//    
//    answerSheet.SetQuestions(questions);
//    return Elc_TRUE;
//}
//
//Elc_BOOL CAnswerSheetStream::ToStream_Quiz(CByteBuffer& buffer, const CAnswerSheet& answerSheet)
//{
//    Elc_BOOL	bRes = Elc_TRUE;
//    
//    do
//    {
//        CExpandedBufferElement	root(TAG_QUIZ_ROOT);
//        
//        // Quiz Paper Describe
//        CExpandedBufferElement  quizDescribe(TAG_QUIZ_DESCRIBE);
//        BulidQuizPaperDescribeElement(quizDescribe, answerSheet);
//        root.AddElement(quizDescribe);
//        
//        // Quiz Paper Info
//        CExpandedBufferElement	quizInfoElement(TAG_QUIZ_INFO);
//        if (!BulidQuizPaperInfoElement(quizInfoElement, answerSheet))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        root.AddElement(quizInfoElement);
//        
//        // Answer Sheet Answers
//        CExpandedBufferElement	quizAnswersInfoElement(TAG_QUIZ_ANSWERS_INFO);
//        if (!BulidAnswerSheetAnswersElement(quizAnswersInfoElement, answerSheet))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        if (quizAnswersInfoElement.GetElementDataSize() > 0)
//        {
//            root.AddElement(quizAnswersInfoElement);
//        }
//        
//        buffer = root.GetByteBuffer();
//        bRes = Elc_TRUE;
//    } while (Elc_FALSE);
//    
//    return bRes;
//}
//
//Elc_BOOL CAnswerSheetStream::ToStream_QuizPaper(__out CByteBuffer& buffer, const CAnswerSheet& answerSheet)
//{
//    Elc_BOOL	bRes = Elc_TRUE;
//    
//    do
//    {
//        CExpandedBufferElement	root(TAG_QUIZ_ROOT);
//        CExpandedBufferElement  quizPaperDescribe(TAG_QUIZ_DESCRIBE);
//        
//        BulidQuizPaperDescribeElement(quizPaperDescribe, answerSheet);
//        // Quiz Paper Describe
//        root.AddElement(quizPaperDescribe);
//        
//        // Quiz Paper Info
//        CExpandedBufferElement	quizPaperInfoElement(TAG_QUIZ_INFO);
//        if (!BulidQuizPaperInfoElement(quizPaperInfoElement, answerSheet))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        root.AddElement(quizPaperInfoElement);
//        buffer = root.GetByteBuffer();
//        
//        bRes = Elc_TRUE;
//    } while (Elc_FALSE);
//    
//    return bRes;
//}
//
//Elc_BOOL CAnswerSheetStream::ToStream_QuizAnswers(__out CByteBuffer& buffer, __in const CAnswerSheet& answerSheet)
//{
//    // Answer Sheet Answers
//    CExpandedBufferElement	answersElement(TAG_QUIZ_ANSWERS_INFO);
//    if (BulidAnswerSheetAnswersElement(answersElement, answerSheet))
//    {
//        if (answersElement.GetElementDataSize() > 0)
//        {
//            buffer = answersElement.GetByteBuffer();
//        }
//        
//        return Elc_TRUE;
//    }
//    else
//    {
//        return Elc_FALSE;
//    }
//}
//
//Elc_BOOL CAnswerSheetStream::FromStream_TestInfo(
//                                                 __out CAnswerSheetTestInfo&	info,
//                                                 __in CReadElement&			testDescribeElement,
//                                                 __in CReadElement&			quizDescribeElement,
//                                                 __in Elc_U32					dwVersion
//                                                 )
//{
//    info.SetAnswerSheetName(quizDescribeElement.Element(TAG_QUIZ_NAME).GetString());
//    info.SetQuestionCount(quizDescribeElement.Element(TAG_QUESTION_COUNT).GetDword());
//    info.SetTestTime(testDescribeElement.Element(TAG_TEST_TIME).GetString());
//    info.SetCostTime(testDescribeElement.Element(TAG_COST_TIME).GetDword());
//    info.SetClassModel(testDescribeElement.Element(TAG_CLASS_MODEL).GetString());
//    
//    CReadElement	studentDescribe = testDescribeElement.Element(TAG_STUDENT_DESCRIBE);
//    
//    if (TAG_INVALID != studentDescribe.dwTag)
//    {
//        vector<CAnswerSheetTestInfo::CStudentTestInfo>	studentInfos;
//        Elc_U32	dwIndex = 0;
//        
//        while (Elc_TRUE)
//        {
//            CReadElement	studentInfoElement = studentDescribe.Element(TAG_STUDENT_INFO, dwIndex++);
//            
//            if (TAG_INVALID == studentInfoElement.dwTag)
//            {
//                break;
//            }
//            
//            CAnswerSheetTestInfo::CStudentTestInfo studentInfo;
//            studentInfo.strStudentName = studentInfoElement.Element(TAG_STUDENT_NAME).GetString();
//            studentInfo.dwCostTime = studentInfoElement.Element(TAG_STUDENT_USE_TIME).GetDword();
//            studentInfo.clientID = studentInfoElement.Element(TAG_STUDENT_CLIENTID).GetClientID();
//            
//            studentInfos.push_back(studentInfo);
//        }
//        
//        info.SetStudentInfo(studentInfos);
//    }
//    
//    return Elc_TRUE;
//}
//
//Elc_BOOL CAnswerSheetStream::FromStream_TestInfo(
//                                                 __out CAnswerSheet&						answerSheet,
//                                                 __out CAnswerSheetTestInfo&				info,
//                                                 __out vector<CStudentAnswer*>&			studentAnswers,
//                                                 __in CReadElement&						testDescribeElement,
//                                                 __in CReadElement&						quizDescribeElement,
//                                                 __in CReadElement&						quizInfoElement,
//                                                 __in CReadElement&						quizAnswersInfoElement,
//                                                 __in CReadElement&						studentAnswersInfoElement,
//                                                 __in Elc_U32								dwVersion
//                                                 )
//{
//    Elc_BOOL	bRes = Elc_TRUE;
//    
//    do
//    {
//        if (!FromStream_TestInfo(info, testDescribeElement, quizDescribeElement, dwVersion))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        if (!FromStream_Quiz(answerSheet, quizDescribeElement, quizInfoElement, quizAnswersInfoElement, dwVersion))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        if (!FromStream_StudentAnswersInfo(studentAnswers, answerSheet, studentAnswersInfoElement))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//    } while (Elc_FALSE);
//    
//    return Elc_TRUE;
//}
//
//Elc_BOOL CAnswerSheetStream::ToStream_TestInfo(
//                                               __out CDeleteableByteBuffer& buffer,
//                                               __in const CAnswerSheet& answerSheet,
//                                               __in const CAnswerSheetTestInfo& info,
//                                               __in const vector<CStudentAnswer*>& studentAnswers )
//{
//    Elc_BOOL	bRes = Elc_TRUE;
//    
//    do
//    {
//        CExpandedBufferElement	root(TAG_TEST_ROOT);
//        
//        // Test describe
//        CExpandedBufferElement  testDescribe(TAG_TEST_DESCRIBE);
//        BulidTestDescribeElement(testDescribe, info);
//        root.AddElement(testDescribe);
//        
//        // Quiz describe
//        CExpandedBufferElement  quizPaperDescribe(TAG_QUIZ_DESCRIBE);
//        BulidQuizPaperDescribeElement(quizPaperDescribe, answerSheet);
//        root.AddElement(quizPaperDescribe);
//        
//        // Quiz Info
//        CExpandedBufferElement	quizPaperInfoElement(TAG_QUIZ_INFO);
//        if (!BulidQuizPaperInfoElement(quizPaperInfoElement, answerSheet))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        root.AddElement(quizPaperInfoElement);
//        
//        // Quiz answers info
//        CExpandedBufferElement	answersElement(TAG_QUIZ_ANSWERS_INFO);
//        if (!BulidAnswerSheetAnswersElement(answersElement, answerSheet))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        if (answersElement.GetElementDataSize() > 0)
//        {
//            root.AddElement(answersElement);
//        }
//        
//        // Student answers info
//        CExpandedBufferElement studentAnswersElement(TAG_STUDENT_ANSWERS_INFO);
//        if (!BulidStudentAnswersElement(studentAnswersElement, studentAnswers))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        if (studentAnswersElement.GetElementDataSize() > 0)
//        {
//            root.AddElement(studentAnswersElement);
//        }
//        
//        buffer = root.GetByteBuffer();
//        
//        bRes = Elc_TRUE;
//    } while (Elc_FALSE);
//    
//    return bRes;
//}
//
//AAnswer* CAnswerSheetStream::FromStream_AnswerNetSend(__in QUESTION_TYPE questionType, __in CReadElement& answer)
//{
//    return FromStream_AnswerData(questionType, answer.Element(TAG_ANSWER_DATA));
//}
//
//Elc_BOOL CAnswerSheetStream::FromStream_QuizNetSend( __out GUID& guid,
//                                                    __out CAnswerSheet& answerSheet,
//                                                    __in CReadElement& netSendRoot,
//                                                    __in Elc_U32 dwVersion )
//{
//    if (TAG_QUIZ_NET_SEND != netSendRoot.dwTag)
//    {
//        return Elc_FALSE;
//    }
//    
//    guid = netSendRoot.Element(TAG_TEST_GUID).GetGuid();
//    CReadElement eleQuizDescribe = netSendRoot.Element(TAG_QUIZ_DESCRIBE);
//    CReadElement eleQuizInfo = netSendRoot.Element(TAG_QUIZ_INFO);
//    CReadElement eleEmpty;
//    return CAnswerSheetStream::FromStream_Quiz(answerSheet,
//                                               eleQuizDescribe,
//                                               eleQuizInfo,
//                                               eleEmpty,
//                                               dwVersion);
//}
//
//Elc_BOOL CAnswerSheetStream::ToStream_AnswerNetSend(__out CDeleteableByteBuffer& buffer, __in int iQuestionIndex, __in const AAnswer* pAnswer)
//{
//    Elc_BOOL	bRes = Elc_TRUE;
//    
//    do
//    {
//        CExpandedBufferElement	element(TAG_ANSWER);
//        element.AddElement(CIntElement(TAG_QUESTION_INDEX).SetData(iQuestionIndex));
//        
//        if (pAnswer->IsValid())
//        {
//            CDeleteableByteBuffer	buffer;
//            if (!ToStream_AnswerData(buffer, pAnswer))
//            {
//                bRes = Elc_FALSE;
//                break;
//            }
//            
//            element.AddElement(CByteBufferElement(TAG_ANSWER_DATA).SetData(buffer));
//        }
//        
//        buffer = element.GetByteBuffer();
//        bRes = Elc_TRUE;
//    } while (Elc_FALSE);
//    
//    return bRes;
//}
//
//Elc_BOOL CAnswerSheetStream::ToStream_AnswerData(CDeleteableByteBuffer& buffer, const AAnswer* pAnswer)
//{
//    if (!pAnswer->IsValid())
//    {
//        return Elc_TRUE;
//    }
//    
//    Elc_BOOL	bRes = Elc_TRUE;
//    switch (pAnswer->GetType())
//    {
//        case choiceQuestion:
//        {
//            const vector<int>&	choiceIndex = pAnswer->ToChoiceAnswer()->GetChoiceIndex();
//            buffer.dwSize = (Elc_U32)choiceIndex.size() * sizeof(int);
//            buffer.pbyData = new Elc_U8[buffer.dwSize];
//            
//            int*	pOffset = (int*)buffer.pbyData;
//            
//            for (int i = 0; i < (int)choiceIndex.size(); ++i)
//            {
//                *pOffset = choiceIndex[i];
//                ++pOffset;
//            }
//        }
//            break;
//        case trueFlaseQuestion:
//        {
//            CTrueFalseAnswer::ANSWER_VALUE answer = pAnswer->ToTrueFalseAnswer()->GetAnswer();
//            buffer.dwSize = sizeof(int);
//            buffer.pbyData = new Elc_U8[buffer.dwSize];
//            
//            int*	pOffset = (int*)buffer.pbyData;
//            *pOffset = answer;
//        }
//            break;
//        case completionQuestion:
//        {
//            DataFormat::qstringToUtf16ByteBuffer(buffer, pAnswer->ToCompletionAnswer()->GetAnswer());
//        }
//            break;
//        case essayQuestion:
//        {
//            DataFormat::qstringToUtf16ByteBuffer(buffer, pAnswer->ToEssayAnswer()->GetAnswer());
//        }
//            break;
//        case handWritingQuestion:
//        {
//            Elc_U8 *	lpbyData = NULL;
//            qint64	lFileLength = 0;
//            if (CHelpFunction::readFileEntire(lpbyData, lFileLength, pAnswer->ToHandWritingAnswer()->GetAnswer()))
//            {
//                buffer.pbyData = lpbyData;
//                buffer.dwSize = (Elc_U32)lFileLength;
//            }
//            else
//            {
//                bRes = Elc_FALSE;
//            }
//        }
//            break;
//        default:
//            ASSERT(Elc_FALSE);
//            break;
//    }
//    
//    return bRes;
//}
//
//AAnswer* CAnswerSheetStream::FromStream_AnswerData(QUESTION_TYPE questionType, const CReadElement& answerData)
//{
//    AAnswer*	pAnswer = CAnswerFactory::CreateAnswerInstance(questionType);
//    
//    if (TAG_INVALID == answerData.dwTag || invalidQuestion == pAnswer->GetType())
//    {
//        return pAnswer;
//    }
//    
//    switch (pAnswer->GetType())
//    {
//        case choiceQuestion:
//        {
//            int	choiceCount = answerData.dwSize / sizeof(int);
//            vector<int>	choiceIndex;
//            choiceIndex.resize(choiceCount);
//            
//            int*	pOffset = (int*)answerData.pbyData;
//            
//            for (int i = 0; i < (int)choiceCount; ++i)
//            {
//                choiceIndex[i] = *pOffset;
//                ++pOffset;
//            }
//            
//            pAnswer->ToChoiceAnswer()->SetChoiceIndex(choiceIndex);
//        }
//            break;
//        case trueFlaseQuestion:
//        {
//            pAnswer->ToTrueFalseAnswer()->SetAnswer((CTrueFalseAnswer::ANSWER_VALUE)answerData.GetInt());
//        }
//            break;
//        case completionQuestion:
//        {
//            pAnswer->ToCompletionAnswer()->SetAnswer(answerData.GetString());
//        }
//            break;
//        case essayQuestion:
//        {
//            pAnswer->ToEssayAnswer()->SetAnswer(answerData.GetString());
//        }
//            break;
//        case handWritingQuestion:
//        {
//            CByteBuffer	buffer = answerData.GetByteBuffer();
//            QString	strPath = getAnswerSheetTmpPath() + QString("/") + CHelpFunction::generateUniqueFildName(".png");
//            if (CHelpFunction::writeFileEntire(buffer.pbyData, buffer.dwSize, strPath))
//            {
//                pAnswer->ToHandWritingAnswer()->SetAnswer(strPath);
//            }
//        }
//            break;
//        default:
//            ASSERT(Elc_FALSE);
//            break;
//    }
//    
//    return pAnswer;
//}
//
//void CAnswerSheetStream::ToStream_QuizNetSend(CDeleteableByteBuffer& buffer, __in GUID& guid, __in CReadElement& quizPaperDescribe, __in CReadElement& quizPaperInfo)
//{
//    CByteBuffer	describeBuffer;
//    describeBuffer.dwSize = quizPaperDescribe.dwSize;
//    describeBuffer.pbyData = new Elc_U8[quizPaperDescribe.dwSize];
//    memcpy(describeBuffer.pbyData, quizPaperDescribe.pbyData, quizPaperDescribe.dwSize);
//    
//    CByteBuffer	infoBuffer;
//    infoBuffer.dwSize = quizPaperInfo.dwSize;
//    infoBuffer.pbyData = new Elc_U8[infoBuffer.dwSize];
//    memcpy(infoBuffer.pbyData, quizPaperInfo.pbyData, quizPaperInfo.dwSize);
//    
//    CExpandedBufferElement	root(TAG_QUIZ_NET_SEND);
//    root.AddElement(CGuidElement(TAG_TEST_GUID).SetData(guid))
//    .AddElement(CByteBufferElement(TAG_QUIZ_DESCRIBE).SetData(describeBuffer))
//    .AddElement(CByteBufferElement(TAG_QUIZ_INFO).SetData(infoBuffer));
//    
//    buffer = root.GetByteBuffer();
//}
//
////==
//void CAnswerSheetStream::BulidTestDescribeElement(__out CExpandedBufferElement& element, __in const CAnswerSheetTestInfo& info)
//{
//    //		TAG_TEST_DESCRIBE
//    //			TAG_TEST_TIME
//    //			TAG_COST_TIME
//    //			TAG_CLASS_MODEL
//    //			TAG_TEST_GUID
//    //			TAG_STUDENT_DESCRIBE
//    //				TAG_STUDENT_INFO
//    //					TAG_STUDENT_NAME
//    //					TAG_STUDENT_MAC
//    //					TAG_STUDENT_USE_TIME
//    
//    element.AddElement(CStringElement(TAG_TEST_TIME).SetData(info.GetTestTime()))
//    .AddElement(CDwordElement(TAG_COST_TIME).SetData(info.GetCostTime()))
//    .AddElement(CStringElement(TAG_CLASS_MODEL).SetData(info.GetClassModel()));
//    
//    const vector<CAnswerSheetTestInfo::CStudentTestInfo>& studentInfos = info.GetStudentInfo();
//    
//    if (!studentInfos.empty())
//    {
//        CExpandedBufferElement	studentDescribeElement(TAG_STUDENT_DESCRIBE);
//        
//        for (int i = 0; i < (int)studentInfos.size(); ++i)
//        {
//            CExpandedBufferElement	studentInfoElement(TAG_STUDENT_INFO);
//            studentInfoElement.AddElement(CStringElement(TAG_STUDENT_NAME).SetData(studentInfos[i].strStudentName))
//            .AddElement(CClientIDElement(TAG_STUDENT_CLIENTID).SetData(studentInfos[i].clientID))
//            .AddElement(CDwordElement(TAG_STUDENT_USE_TIME).SetData(studentInfos[i].dwCostTime));
//            
//            studentDescribeElement.AddElement(studentInfoElement);
//        }
//        
//        element.AddElement(studentDescribeElement);
//    }
//}
//
//void CAnswerSheetStream::BulidQuizPaperDescribeElement(CExpandedBufferElement& element, const CAnswerSheet& answerSheet)
//{
//    element.AddElement(CStringElement(TAG_QUIZ_NAME).SetData(answerSheet.GetName()))
//    .AddElement(CDwordElement(TAG_PAPER_COUNT).SetData((Elc_U32)answerSheet.GetPapers().size()))
//    .AddElement(CDwordElement(TAG_QUESTION_COUNT).SetData((Elc_U32)answerSheet.GetQuestion().size()))
//    .AddElement(CIntElement(TAG_QUESTION_NUMBER_TYPE).SetData((Elc_U32)answerSheet.GetQuestionNumberType()))
//    .AddElement(CIntElement(TAG_QUIZ_DURATION).SetData(answerSheet.GetDuration()));
//}
//
//Elc_BOOL CAnswerSheetStream::BulidQuizPaperInfoElement(CExpandedBufferElement& element, const CAnswerSheet& answerSheet)
//{
//    const vector<QString>& papers = answerSheet.GetPapers();
//    Elc_BOOL	bFailed = Elc_FALSE;
//    
//    if (!papers.empty())
//    {
//        // Papers Info
//        CExpandedBufferElement	papersInfoElement(TAG_PAPERS_INFO);
//        
//        int i;
//        for (i = 0; i < (int)papers.size(); ++i)
//        {
//            Elc_U8 *	lpbyData = NULL;
//            Elc_S64 length = 0;
//            
//            if (!CHelpFunction::readFileEntire(lpbyData, length, papers[i]))
//            {
//                bFailed = Elc_TRUE;
//                break;
//            }
//            
//            CByteBuffer	buffer;
//            buffer.dwSize = (Elc_U32)length;
//            buffer.pbyData = lpbyData;
//            papersInfoElement.AddElement(CByteBufferElement(TAG_PAPER).SetData(buffer));
//        }
//        
//        if (i == (int)papers.size())
//        {
//            element.AddElement(papersInfoElement);
//        }
//        else
//        {
//            return Elc_FALSE;
//        }
//    }
//    
//    const vector<AQuestion*>& questions = answerSheet.GetQuestion();
//    // Question Infos
//    if (!questions.empty())
//    {
//        CExpandedBufferElement	questionsInfoElement(TAG_QUESTIONS_INFO);
//        
//        for (int i = 0; i < (int)questions.size(); ++i)
//        {
//            CExpandedBufferElement questionElement(TAG_QUESTION);
//            questionElement.AddElement(CDwordElement(TAG_QUESTION_INDEX).SetData(questions[i]->GetIndex()))
//            .AddElement(CStringElement(TAG_QUESTION_NUMBER).SetData(questions[i]->GetNumber()))
//            .AddElement(CStringElement(TAG_QUESTION_GROUP).SetData(questions[i]->GetGroup()))
//            .AddElement(CDwordElement(TAG_QUESTION_TYPE).SetData((Elc_U32)questions[i]->GetType()))
//            .AddElement(CFloatElement(TAG_QUESTION_SCORE).SetData(questions[i]->GetScore()))
//            .AddElement(CExpandedBufferElement(TAG_QUESTION_POSITION)
//                        .AddElement(CDwordElement(TAG_PAGE_X_POS).SetData(questions[i]->GetPos().x()))
//                        .AddElement(CDwordElement(TAG_PAGE_Y_POS).SetData(questions[i]->GetPos().y())));
//            
//            if (choiceQuestion == questions[i]->GetType())
//            {
//                questionElement.AddElement(CDwordElement(TAG_CHOICE_COUNT).SetData(questions[i]->ToChoiceQuestion()->GetChoiceCount()));
//            }
//            else if (completionQuestion == questions[i]->GetType())
//            {
//                questionElement.AddElement(CDwordElement(TAG_BLANK_COUNT).SetData(questions[i]->ToCompletionQuestion()->GetBlankCount()));
//            }
//            
//            questionsInfoElement.AddElement(questionElement);
//        }
//        
//        element.AddElement(questionsInfoElement);
//    }
//    
//    return Elc_TRUE;
//}
//
//Elc_BOOL CAnswerSheetStream::BulidAnswerSheetAnswersElement(CExpandedBufferElement& element, const CAnswerSheet& answerSheet)
//{
//    // Answer Sheet Answers
//    const vector<AQuestion*>& questions = answerSheet.GetQuestion();
//    int	i;
//    for (i = 0; i < (int)questions.size(); ++i)
//    {
//        if (questions[i]->GetAnswer()->IsValid())
//        {
//            CExpandedBufferElement	answerElement(TAG_ANSWER);
//            answerElement.AddElement(CDwordElement(TAG_QUESTION_INDEX).SetData(questions[i]->GetIndex()));
//            
//            CByteBuffer	buffer;
//            if (!ToStream_AnswerData(buffer, questions[i]->GetAnswer()))
//            {
//                break;
//            }
//            
//            answerElement.AddElement(CByteBufferElement(TAG_ANSWER_DATA).SetData(buffer));
//            element.AddElement(answerElement);
//        }
//    }
//    
//    return i == (int)questions.size();
//}
//
//Elc_BOOL CAnswerSheetStream::BulidStudentAnswersElement(__out CExpandedBufferElement& element, __in const vector<CStudentAnswer*>& studentAnswers)
//{
//	int i = 0;
//	for (i = 0; i < (int)studentAnswers.size(); ++i)
//	{
//		CExpandedBufferElement	studentAnswerElement(TAG_STUDENT_ANSWER);
//		studentAnswerElement.AddElement(CStringElement(TAG_STUDENT_NAME).SetData(studentAnswers[i]->GetStudentName()))
//        .AddElement(CClientIDElement(TAG_STUDENT_CLIENTID).SetData(studentAnswers[i]->GetClientID()))
//        .AddElement(CIntElement(TAG_QUESTION_INDEX).SetData(studentAnswers[i]->GetQuestionIndex()))
//        .AddElement(CFloatElement(TAG_ANSWER_SCORE).SetData(studentAnswers[i]->GetScore()));
//        
//		CByteBuffer	buffer;
//		if (!ToStream_AnswerData(buffer, studentAnswers[i]->GetAnswer()))
//		{
//			break;
//		}
//        
//		studentAnswerElement.AddElement(CByteBufferElement(TAG_ANSWER_DATA).SetData(buffer));
//		element.AddElement(studentAnswerElement);
//	}
//    
//	return i == studentAnswers.size();
//}
//
//Elc_BOOL CAnswerSheetStream::FromStream_StudentAnswersInfo(__out vector<CStudentAnswer*>& studentAnswers, __in const CAnswerSheet& answerSheet, __in CReadElement& studentAnswersInfoElement)
//{
//    if (TAG_INVALID == studentAnswersInfoElement.dwTag)
//    {
//        return Elc_TRUE;
//    }
//    
//    Elc_BOOL	bRes = Elc_TRUE;
//    const vector<AQuestion*>&	currentQuestions = answerSheet.GetQuestion();
//    
//    Elc_U32	dwIndex = 0;
//    
//    while (Elc_TRUE)
//    {
//        CReadElement	studentAnswerElement = studentAnswersInfoElement.Element(TAG_STUDENT_ANSWER, dwIndex++);
//        
//        if (TAG_INVALID == studentAnswerElement.dwTag)
//        {
//            break;
//        }
//        
//        int	iQuestionIndex = studentAnswerElement.Element(TAG_QUESTION_INDEX).GetInt();
//        QString strStudentName = studentAnswerElement.Element(TAG_STUDENT_NAME).GetString();
//        CLIENTID clientID = studentAnswerElement.Element(TAG_STUDENT_CLIENTID).GetClientID();
//        float fScore = studentAnswerElement.Element(TAG_ANSWER_SCORE).GetFloat();
//        
//        QUESTION_TYPE	questionType;
//        Elc_BOOL	bFind = Elc_FALSE;
//        for (int i = 0; i < (int)currentQuestions.size(); ++i)
//        {
//            if (iQuestionIndex == currentQuestions[i]->GetIndex())
//            {
//                questionType = currentQuestions[i]->GetType();
//                bFind = Elc_TRUE;
//                break;
//            }
//        }
//        
//        if (!bFind)
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        AAnswer* pAnswer = FromStream_AnswerData(questionType, studentAnswerElement.Element(TAG_ANSWER_DATA));
//        
//        if (NULL == pAnswer)
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        CStudentAnswer*	pStudentAnswer = new CStudentAnswer();
//        pStudentAnswer->SetStudentInfo(strStudentName, clientID);
//        pStudentAnswer->SetQuestionIndex(iQuestionIndex);
//        pStudentAnswer->SetAnswer(pAnswer);
//        pStudentAnswer->SetScore(fScore);
//        
//        studentAnswers.push_back(pStudentAnswer);
//    }
//    
//    if (!bRes)
//    {
//        CHelpFunction::ClearStudentAnswer(studentAnswers);
//    }
//    
//    return bRes;
//}
