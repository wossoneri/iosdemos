
#include "AnswerSheet.h"


CAnswerSheet::CAnswerSheet()
    : m_dwDuration(DEFAULT_QUIZ_DURATION)
    , m_questionNumberType(numberTypeIncrest)
    , m_strName("")
{
    
}

CAnswerSheet::~CAnswerSheet()
{
}

void CAnswerSheet::SetName(const std::string& strName)
{
    m_strName = strName;
}

const std::string& CAnswerSheet::GetName() const
{
    return m_strName;
}

void CAnswerSheet::SetQuestions(const std::vector<AQuestion*>& questions)
{
    m_questions = questions;
}

const std::vector<AQuestion*>& CAnswerSheet::GetQuestion() const
{
    return m_questions;
}

AQuestion* CAnswerSheet::GetQuestion(int row) {
    if( m_questions.empty() ) {
        return NULL;
    }
    
    if( row < 0 || row >= m_questions.size() ) {
        return NULL;
    }
    
    AQuestion* pQs = m_questions[row];
    
    return pQs;
}

void CAnswerSheet::SetQuestion(int row, AQuestion* pQs) {
    m_questions[row] = pQs;
}

int CAnswerSheet::GetQuestionCount() {
    return (int)m_questions.size();
}

std::string CAnswerSheet::ToString() const
{
    std::string	strQuestionTest;

    int	i;
    int	iSize = (int)m_questions.size();

    for (i = 0; i < iSize; ++i)
    {
        strQuestionTest += m_questions[i]->ToString();
    }

    char szTmp[256]={0};
    sprintf(szTmp, "<<class-CAnswerSheet>>I am answer sheet, and i have some questions are{%s}",
            strQuestionTest.data());
    
    return std::string(szTmp);
}

void CAnswerSheet::AddQuestion(AQuestion* pQs)
{
    m_questions.push_back(pQs);
}

void CAnswerSheet::DeleteQuestion(AQuestion* pQuestion)
{
    bool bFind = false;

    std::vector<AQuestion*>::iterator it = m_questions.begin();
    for( ; it != m_questions.end(); it ++ ) {
        AQuestion* pInnerQuestion = *it;
        if( pInnerQuestion == pQuestion ) {
            bFind = true;
            break;
        }
    }

    if( bFind ) {
        m_questions.erase(it);
    }
}

void CAnswerSheet::DelQuestion(int row) {
    if( m_questions.empty() ) {
        return;
    }
    
    if( row < 0 || row >= m_questions.size() ) {
        return;
    }
    
    std::vector<AQuestion*>::iterator it = m_questions.begin() + row;
    m_questions.erase(it);
}

void CAnswerSheet::DeleteAllQuestion()
{
    int	i;
    int	iSize = (int)m_questions.size();

    for (i = 0; i < iSize; ++i)
    {
        SAFE_DELETE(m_questions[i]);
    }

    m_questions.clear();
}

void CAnswerSheet::SetPapers(const std::vector< std::string >& papers)
{
    m_papers = papers;
}

void CAnswerSheet::AddPaper(const std::string& paper)
{
    m_papers.push_back(paper);
}

void CAnswerSheet::RemovePaper(const std::string& paper)
{
    bool bFind = false;
    CArrayPaper::iterator it = m_papers.begin();
    for( ; it != m_papers.end(); it ++ ) {
        std::string strPaper = *it;
        if( 0 == strPaper.compare(paper) ) {

            bFind = true;
            break;
        }
    }

    if( bFind ) {
        m_papers.erase(it);
    }
}

const std::vector< std::string >& CAnswerSheet::GetPapers() const
{
    return m_papers;
}

void CAnswerSheet::SetQuestionNumberType(QUESTION_NUMBER_TYPE numberType)
{
    m_questionNumberType = numberType;
}

QUESTION_NUMBER_TYPE CAnswerSheet::GetQuestionNumberType() const
{
    return m_questionNumberType;
}

void CAnswerSheet::SetDuration(Elc_U32 dwDuration)
{
    m_dwDuration = dwDuration;
}

Elc_U32 CAnswerSheet::GetDuration() const
{
    return m_dwDuration;
}

void CAnswerSheet::GenerateGroups(vector<CGroupItem>& groupItems)
{
    groupItems.clear();

    for (int i = 0; i < (int)m_questions.size(); ++i)
    {
        if (groupItems.empty())
        {
            CGroupItem	item;
            item.strGroup = m_questions[i]->GetGroup();
            item.questions.push_back(m_questions[i]);
            groupItems.push_back(item);
        }
        else
        {
            if (groupItems[groupItems.size() - 1].strGroup != m_questions[i]->GetGroup())
            {
                CGroupItem	item;
                item.strGroup = m_questions[i]->GetGroup();
                item.questions.push_back(m_questions[i]);
                groupItems.push_back(item);
            }
            else
            {
                groupItems[groupItems.size() - 1].questions.push_back(m_questions[i]);
            }
        }
    }

    //===============================================================
    // windows
    //	groupItems.clear();

    //	for (int i = 0; i < (int)m_questions.size(); ++i)
    //	{
    //		if (groupItems.empty())
    //		{
    //			CGroupItem	item;
    //			item.strGroup = m_questions[i]->GetGroup();
    //			item.questions.push_back(m_questions[i]);
    //			groupItems.push_back(item);
    //		}
    //		else
    //		{
    //			if (groupItems[groupItems.size() - 1].strGroup != m_questions[i]->GetGroup())
    //			{
    //				CGroupItem	item;
    //				item.strGroup = m_questions[i]->GetGroup();
    //				item.questions.push_back(m_questions[i]);
    //				groupItems.push_back(item);
    //			}
    //			else
    //			{
    //				groupItems[groupItems.size() - 1].questions.push_back(m_questions[i]);
    //			}
    //		}
    //	}
}




//==============================================================================
//#include "stdafx.h"


//#include "AnswerSheet.h"
//#include "Question.h"

//CAnswerSheet::CAnswerSheet()
//: m_questionNumberType(numberTypeIncrest)
//, m_dwDuration(0)
//{
//}

//CAnswerSheet::~CAnswerSheet()
//{
//}

//void CAnswerSheet::SetName(const CString& strName)
//{
//	m_strName = strName;
//}

//const CString& CAnswerSheet::GetName() const
//{
//	return m_strName;
//}

//void CAnswerSheet::SetQuestions(const std::vector<AQuestion*>& questions)
//{
//	m_questions = questions;
//}

//const std::vector<AQuestion*>& CAnswerSheet::GetQuestion() const
//{
//	return m_questions;
//}

//CString CAnswerSheet::ToString() const
//{
//	CString	strQuestionTest;

//	int	i;
//	int	iSize = (int)m_questions.size();

//	for (i = 0; i < iSize; ++i)
//	{
//		strQuestionTest += m_questions[i]->ToString();
//	}

//	CString	strText;
//	strText.Format(TEXT("<<class-CAnswerSheet>>I am answer sheet, and i have some questions are{%s}"), strQuestionTest);
//	return strText;
//}

//void CAnswerSheet::DeleteAllQuestion()
//{
//	int	i;
//	int	iSize = (int)m_questions.size();

//	for (i = 0; i < iSize; ++i)
//	{
//		SAFE_DELETE(m_questions[i]);
//	}

//	m_questions.clear();
//}

//void CAnswerSheet::SetPapers(const std::vector<CString>& papers)
//{
//	m_papers = papers;
//}

//const std::vector<CString>& CAnswerSheet::GetPapers() const
//{
//	return m_papers;
//}

//void CAnswerSheet::GenerateGroups(vector<CAnswerSheet::CGroupItem>& groupItems)
//{
//	groupItems.clear();

//	for (int i = 0; i < (int)m_questions.size(); ++i)
//	{
//		if (groupItems.empty())
//		{
//			CGroupItem	item;
//			item.strGroup = m_questions[i]->GetGroup();
//			item.questions.push_back(m_questions[i]);
//			groupItems.push_back(item);
//		}
//		else
//		{
//			if (groupItems[groupItems.size() - 1].strGroup != m_questions[i]->GetGroup())
//			{
//				CGroupItem	item;
//				item.strGroup = m_questions[i]->GetGroup();
//				item.questions.push_back(m_questions[i]);
//				groupItems.push_back(item);
//			}
//			else
//			{
//				groupItems[groupItems.size() - 1].questions.push_back(m_questions[i]);
//			}
//		}
//	}
//}

//void CAnswerSheet::SetQuestionNumberType(QUESTION_NUMBER_TYPE numberType)
//{
//	m_questionNumberType = numberType;
//}

//QUESTION_NUMBER_TYPE CAnswerSheet::GetQuestionNumberType() const
//{
//	return m_questionNumberType;
//}

//void CAnswerSheet::SetDuration(Elc_U32 dwDuration)
//{
//	m_dwDuration = dwDuration;
//}

//Elc_U32 CAnswerSheet::GetDuration() const
//{
//	return m_dwDuration;
//}
