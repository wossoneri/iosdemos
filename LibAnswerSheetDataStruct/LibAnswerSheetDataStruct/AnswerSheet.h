#ifndef ANSWERSHEET_H
#define ANSWERSHEET_H

#include "QuestionType.h"
#include "QuestionNumberType.h"
#include "Question.h"

using namespace std;

class AQuestion;

#define QUIZ_NAME_MAX_LENGTH		100

#define DEFAULT_QUIZ_DURATION		10
#define QUIZ_DURATION_MIN           1
#define QUIZ_DURATION_MAX           1000

typedef std::vector<std::string>        CArrayPaper;

class CAnswerSheet
{
public:
    CAnswerSheet();
    ~CAnswerSheet();

    void SetName(const std::string& strName);
    const std::string& GetName() const;

    void SetQuestions(const std::vector<AQuestion*>& questions);
    const std::vector<AQuestion*>& GetQuestion() const;
    
    AQuestion* GetQuestion(int row);
    void SetQuestion(int row, AQuestion* pQs);
    
    int GetQuestionCount();

    std::string ToString() const;

    void AddQuestion(AQuestion* pQs);
    void DeleteQuestion(AQuestion* pQuestion);
    void DelQuestion(int row);
    void DeleteAllQuestion();

    void AddPaper(const std::string& paper);
    void RemovePaper(const std::string& paper);

    void SetPapers(const std::vector< std::string >& papers);
    const std::vector< std::string >& GetPapers() const;

    class CGroupItem
    {
    public:

        std::string	strGroup;
        vector<AQuestion*>	questions;
    };

    void SetQuestionNumberType(QUESTION_NUMBER_TYPE numberType);
    QUESTION_NUMBER_TYPE GetQuestionNumberType() const;

    void SetDuration(Elc_U32 dwDuration);
    Elc_U32 GetDuration() const;

    void GenerateGroups(vector<CGroupItem>& groupItems);

protected:

private:
    std::string                 m_strName;
    QUESTION_NUMBER_TYPE        m_questionNumberType;
    Elc_U32                     m_dwDuration;
    CArrayPaper                 m_papers;
    std::vector<AQuestion*>     m_questions;		// Answer sheet's questions
};



#endif

//==============================================================================
// windows
//#define QUIZ_NAME_MAX_LENGTH		100

//#define DEFAULT_QUIZ_DURATION		10



//class LIB_ANSWERSHEET_API CAnswerSheet
//{
//public:

//	CAnswerSheet();

//	~CAnswerSheet();

//	void SetName(const CString& strName);

//	const CString& GetName() const;

//	void SetQuestions(const std::vector<AQuestion*>& questions);

//	const std::vector<AQuestion*>& GetQuestion() const;

//	CString ToString() const;

//	void DeleteAllQuestion();

//	void SetPapers(const std::vector<CString>& papers);

//	const std::vector<CString>& GetPapers() const;

//	class CGroupItem
//	{
//	public:

//		CString	strGroup;
//		vector<AQuestion*>	questions;
//	};

//	void GenerateGroups(vector<CGroupItem>& groupItems);

//	void SetQuestionNumberType(QUESTION_NUMBER_TYPE numberType);

//	QUESTION_NUMBER_TYPE GetQuestionNumberType() const;

//	void SetDuration(Elc_U32 dwDuration);

//	Elc_U32 GetDuration() const;

//protected:

//private:

//	CString	m_strName;
//	QUESTION_NUMBER_TYPE	m_questionNumberType;
//	Elc_U32					m_dwDuration;
//	std::vector<CString>	m_papers;
//	std::vector<AQuestion*>	m_questions;		// Answer sheet's questions
//};
