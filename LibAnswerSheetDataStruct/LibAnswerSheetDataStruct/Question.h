//
//  AAnswer.h
//  LibAnswerSheet
//
//  Created by huanghao on 15-2-4.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#ifndef LibAnswerSheetDataStruct_Question_h
#define LibAnswerSheetDataStruct_Question_h

#include "Answer.h"
//#include "ELC_Types_AS.h"

class CChoiceQuestion;
class CCompletionQuestion;
class CEssayQuestion;
class CTrueFalseQuestion;
class CHandWritingQuestion;

#define QUESTION_NUMBER_LENGTH_MIN	1
#define QUESTION_NUMBER_LENGTH_MAX	32 


#define QUESTION_SCORE_MIN	1
#define QUESTION_SCORE_MAX	100 

#define QUESTION_COUNT_MIN	1
#define QUESTION_COUNT_MAX	200

#define DEFAULT_QUESTION_CHOICE_SCORE		1.0f
#define DEFAULT_QUESTION_TRUEFALSE_SCORE	1.0f
#define DEFAULT_QUESTION_COMPLETION_SCORE	1.0f
#define DEFAULT_QUESTION_ESSAY_SCORE		10.0f
#define DEFAULT_QUESTION_HANDWRITING_SCORE	10.0f

#define INVALID_QUESTION_INDEX		-1
#define GROUP_NAME_MAX_LENGTH		100
#define QUESTION_NUMBER_MAX_LENGTH	50

#define COPY_INDEX		0x00000001
#define COPY_POS		0x00000002
#define COPY_SCORE		0x00000004
#define COPY_GROUP		0x00000008
#define COPY_NUMBER		0x00000010



/**
* Abstract class for all question
* 
*/
class AQuestion
{
public:
	AQuestion(QUESTION_TYPE questionType, AAnswer* pAnswer, int iQuestionIndex)
		: m_questionType(questionType)
		, m_pAnswer(pAnswer)
		, m_iIndex(iQuestionIndex)
	{
		assert(m_iIndex != INVALID_QUESTION_INDEX);
		assert(NULL != m_pAnswer);
        
        char szIndex[10]={0};
        sprintf(szIndex, "%d", m_iIndex);
        m_strNumber = std::string(szIndex);
        
        m_pos.v = m_pos.h = 0;
	}

	virtual ~AQuestion()
	{
		SAFE_DELETE(m_pAnswer);
	}
	
	/**
	* Get questio type
	*
	* @return Question type
	* @see "QuestionType.h"
	*/
	QUESTION_TYPE GetType() const
	{
		return m_questionType;
	}
	
	void SetIndex(int iIndex)
	{
		assert(iIndex != INVALID_QUESTION_INDEX);

		m_iIndex = iIndex;
	}

	/**
	* Get question number id, from zero
	*
	* @return Question number
	*/
	int GetIndex() const
	{
		return m_iIndex;
	}

    void SetNumber(const string& strNumber)
	{
		m_strNumber = strNumber;
	}

    const string& GetNumber() const
	{
		return m_strNumber;
	}

    void SetGroup(const string& strGroup)
	{
		m_strGroup = strGroup;
	}

    const string& GetGroup() const
	{
		return m_strGroup;
	}
	
	void SetAnswer(AAnswer* pAnswer)
	{
		SAFE_DELETE(m_pAnswer);
		m_pAnswer = pAnswer;
	}

	/**
	* Get the question answer, for objective item is the standard answer, and for subjective item
	* is the reference answer. Every question has a own answer, and the question object control the
	* answer object life
	*
	* @return Question answer
	*/
	const AAnswer* GetAnswer() const
	{
		return m_pAnswer;
	}

    const CPoint& GetPos() const
	{
		return m_pos;
	}

    void SetPos(const CPoint& pos)
	{
		m_pos = pos;
	}
	
	void SetScore(float score)
	{
		m_score = score;
	}

	float GetScore() const
	{
		return m_score;
	}
	
    void CopyFrom(AQuestion* pQuestion, Elc_U32 dwCopyParams)
	{
		if (dwCopyParams & COPY_INDEX)
		{
			m_iIndex = pQuestion->GetIndex();
		}

		if (dwCopyParams & COPY_POS)
		{
			m_pos = pQuestion->GetPos();
		}

		if (dwCopyParams & COPY_SCORE)
		{
			m_score = pQuestion->GetScore();
		}

		if (dwCopyParams & COPY_GROUP)
		{
			m_strGroup = pQuestion->GetGroup();
		}

		if (dwCopyParams & COPY_NUMBER)
		{
			m_strNumber = pQuestion->GetNumber();
		}
	}

	virtual CChoiceQuestion* ToChoiceQuestion()
	{
        assert(Elc_FALSE);
		return NULL;
	}

	virtual const CChoiceQuestion* ToChoiceQuestion() const
	{
        assert(Elc_FALSE);
		return NULL;
	}

	virtual CCompletionQuestion* ToCompletionQuestion()
	{
        assert(Elc_FALSE);
		return NULL;
	}

	virtual const CCompletionQuestion* ToCompletionQuestion() const
	{
        assert(Elc_FALSE);
		return NULL;
	}

	virtual CEssayQuestion* ToEssayQuestion()
	{
        assert(Elc_FALSE);
		return NULL;
	}

	virtual const CEssayQuestion* ToEssayQuestion() const
	{
        assert(Elc_FALSE);
		return NULL;
	}

	virtual CTrueFalseQuestion* ToTrueFlaseQuestion()
	{
        assert(Elc_FALSE);
		return NULL;
	}

	virtual const CTrueFalseQuestion* ToTrueFlaseQuestion() const
	{
        assert(Elc_FALSE);
		return NULL;
	}

	virtual CHandWritingQuestion* ToHandWritingQuestion()
	{
        assert(Elc_FALSE);
		return NULL;
	}

	virtual const CHandWritingQuestion* ToHandWritingQuestion() const
	{
        assert(Elc_FALSE);
		return NULL;
	}

	virtual AQuestion* Clone() const = 0;
	
    virtual string ToString() const
	{
        return string("<<class-AQuestion>>(This is a question object)");
	}

protected:
	QUESTION_TYPE           m_questionType;									// Question type
	AAnswer*		m_pAnswer;								// Question answer
	int                     m_iIndex;										// Question number id
    string                  m_strNumber;
    string                  m_strGroup;

    CPoint                   m_pos;
	float                   m_score;
};

typedef std::vector<AQuestion*>     CArrayQuestion;





#endif // LibAnswerSheet_Question_h