//
//  QuestionType.h
//  LibAnswerSheet
//
//  Created by huanghao on 15-2-4.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#ifndef LibAnswerSheetDataStruct_QuestionType_h
#define LibAnswerSheetDataStruct_QuestionType_h


enum QUESTION_TYPE
{
    choiceQuestion,
    trueFlaseQuestion,
    completionQuestion,
    essayQuestion,
    oralQuestion,
    handWritingQuestion,
    
    // Here add new question type
    
    // Invalid type question
    invalidQuestion = 10000,			// Invalid question
};

inline enum QUESTION_TYPE CheckQuestionTypeInvalid(enum QUESTION_TYPE questionType)
{
    if (questionType > handWritingQuestion)
    {
        return invalidQuestion;
    }
    
    return questionType;
}

#endif
