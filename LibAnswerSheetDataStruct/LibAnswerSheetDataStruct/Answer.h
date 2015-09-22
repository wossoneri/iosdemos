//
//  AAnswer.h
//  LibAnswerSheet
//
//  Created by huanghao on 15-2-4.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#ifndef LibAnswerSheetDataStruct_AAnswer_h
#define LibAnswerSheetDataStruct_AAnswer_h

#include "ELC_Types_AS.h"

// old
//#include "CodeSnippets/qt_helper.h"
//
//#include "libanswersheet_global.h"
//#include "BasicMacroDefine.h"
//#include "QuestionType.h"
//#include "stdtypes.h"


#include "AnswerSheetCommon.h"

class CChoiceAnswer;
class CCompletionAnswer;
class CEssayAnswer;
class CTrueFalseAnswer;
class CHandWritingAnswer;
class CInvalidAnswer;

/**
 * All question answer are derive from AAnswer
 */
class  AAnswer
{
public:
	
	virtual ~AAnswer()
	{
        
	}
    
	QUESTION_TYPE GetType() const
	{
		return m_questionType;
	}
    
	virtual CChoiceAnswer* ToChoiceAnswer()
	{
        assert(Elc_FALSE);
		return NULL;
	}
    
	virtual const CChoiceAnswer* ToChoiceAnswer() const
	{
        assert(Elc_FALSE);
		return NULL;
	}
    
	virtual CCompletionAnswer* ToCompletionAnswer()
	{
        assert(Elc_FALSE);
		return NULL;
	}
    
	virtual const CCompletionAnswer* ToCompletionAnswer() const
	{
        assert(Elc_FALSE);
		return NULL;
	}
	
	virtual CEssayAnswer* ToEssayAnswer()
	{
        assert(Elc_FALSE);
		return NULL;
	}
    
	virtual const CEssayAnswer* ToEssayAnswer() const
	{
        assert(Elc_FALSE);
		return NULL;
	}
    
	virtual CTrueFalseAnswer* ToTrueFalseAnswer()
	{
        assert(Elc_FALSE);
		return NULL;
	}
    
	virtual const CTrueFalseAnswer* ToTrueFalseAnswer() const
	{
        assert(Elc_FALSE);
		return NULL;
	}
    
	virtual CHandWritingAnswer* ToHandWritingAnswer()
	{
        assert(Elc_FALSE);
		return NULL;
	}
    
	virtual const CHandWritingAnswer* ToHandWritingAnswer() const
	{
        assert(Elc_FALSE);
		return NULL;
	}
	
	virtual CInvalidAnswer* ToInvalidAnswer()
	{
        assert(Elc_FALSE);
		return NULL;
	}
    
	virtual const CInvalidAnswer* ToInvalidAnswer() const
	{
        assert(Elc_FALSE);
		return NULL;
	}
    
	virtual AAnswer* Clone() const = 0;
    
	/**
     * @return TRUE mean same answer
     */
    virtual Elc_BOOL Equal(const AAnswer* pOther) const = 0;
    
	/**
     * Determine the answer is valid. If it is invalid, in student side mean the question has not done,
     * in teacher side mean the question has not set answer
     */
    virtual Elc_BOOL IsValid() const = 0;
    
	/**
     * Make this answer invalid
     */
	virtual void ToInValid() = 0;
	
    virtual std::string ToString() const
	{
        return std::string("<<class-AAnswer>>(This is a answer object)");
	}
    
    virtual std::string ToAnswerString() const
	{
        assert(Elc_FALSE);
		return NULL;
	}
	
protected:
	QUESTION_TYPE	m_questionType;
};

#endif
