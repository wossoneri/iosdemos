//
//  HelpFunction.h
//  LibAnswerSheet
//
//  Created by huanghao on 15-2-27.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#ifndef __LibAnswerSheet__HelpFunction__
#define __LibAnswerSheet__HelpFunction__

#include <iostream>

#include "CodeSnippets/Guid.h"
//#include "CompletionQuestion.h"

#include "ELC_Types_AS.h"

class CHelpFunction
{
public:

//    static BOOL compareFileContext(const std::string &strSourceFilePath, const std::string &strDestFilePath);
    

    static bool readFileEntire(Elc_U8 *& data, Elc_S64& size, const std::string& filePath);
    static bool writeFileEntire(Elc_U8 * data, Elc_S64 size, const std::string& filePath);
    
    static GUID generateGuid();
    static std::string generateUniqueFileName(const std::string& extendName);
    
    // for completion
//    static std::string getCompletionFmtAnswer(const CCompletionAnswer* pAnswer, int iBlankCount);
    
    
    
    static std::string generateTmpImagePath();
    static std::string getAnswerSheetTmpPath();
};





#endif /* defined(__LibAnswerSheet__HelpFunction__) */


// Qt
//#ifndef HELPFUNCTION_H
//#define HELPFUNCTION_H
//
//#ifndef FLT_PRECISION
//#define FLT_PRECISION   0.000000000001
//#endif
//
//#include "../libanswersheet_global.h"
//
//#include <QtGlobal>
//#include <QPixmap>
//#include <QIcon>
//#include <qmath.h>
//#include <QPainter>
//
//#include "CodeSnippets/Guid.h"
//#include "CodeSnippets/Protocol.h"
//
//#include "SkinImage.h"
//
//#include "TrueFalseAnswer.h"
//#include "StudentAnswer.h"
//
//#define CHOICE_ANSWER_GAP_CHAR				","
////#define CHOICE_MAX_SUPPORT					((int)g_choices.size())
//#define QUIZ_IMAGE_SAVE_EXTEND_NAME			".png"
//
//
//class LIBANSWERSHEETSHARED_EXPORT CHelpFunction
//{
//public:
//    static int floatToInt(float value);
//    
//    static bool compareFloat(float value1, float value2);
//    
//    static QPixmap fromImage(const QImage& image);
//    
//    static QIcon iconFromImage(const QImage &image);
//    
//    static float distanceOfPoint(const QPoint& pt1, const QPoint& pt2);
//    
//    static void drawSkinImage(const QRect& rect, const SkinImage& skinImage, QPainter& painter, bool bShowLog = false);
//    
//    static void drawImageCenterWithScale(const QRect& rect, const QImage& image, QPainter& painter);
//    static void drawPixmapCenterWithScale(const QRect& rect, const QPixmap& pixmap, QPainter& painter);
//    
//    static QSize getTextSize(const QString& text, const QFont& font);
//    static QSize getTextSize(const QString& text, const QFont& font, int width);
//    
//    static GUID generateGuid();
//    
//    static QString generateUniqueFildName(const QString& extendName);
//    
//    static bool writeFileEntire(Elc_U8 * data, qint64 size, const QString& filePath);
//    
//    static bool readFileEntire(Elc_U8 *& data, qint64& size, const QString& filePath);
//    
//    static QSize getSuggestIconSizeOnPushButton(const QImage& icon);
//    
//    static bool compareFileContext(const QString &strSourceFilePath, const QString &strDestFilePath);
//    
//    static void drawTextAutoHCenter(const QRect& rect, const QString& text, QPainter& painter);
//    
//    static QString getRealEditText(QLineEdit& edit);
//    
//    static void ParseChoiceAnswerByString(vector<QString>& answers, const QString& strText);
//    
//    // new add by HH
//    /**
//     * Change the choice answer by user choose the index(By mouse clicked)
//     *
//     * @param pAnswer
//     *			Choice answer
//     * @param iIndex
//     *			Choice index of answer(From 0)
//     */
//	static void OptionChoiceAnswerByIndex(__inout vector<int>& choiceIndexs, __in int iIndex);
//    
//    static void OptionTrueFalseAnswerByIndex(CTrueFalseAnswer::ANSWER_VALUE& answer, int iIndex);
//    
//    static Elc_BOOL CompareClientID(CLIENTID id1, CLIENTID id2);
//    
//    static void ClearStudentAnswer(std::vector<CStudentAnswer*>& studentAnswers);
//    
//    static Elc_BOOL CompareQuestionScore(float fScore1, float fScore2);
//    
//    static QString GenerateGroupQuestionScoreInfo(const vector<AQuestion*>& questions);
//    
//    static QString ScoreFloat2String(float fScore);
//    
//    static QString GetAnswerShow(const AAnswer* pAnswer);
//    
//    static int GetFileLength(const QString& strPath);
//    
//    static QString InetDwordToString(Elc_U32 dwIpAddress);
//    
//    static void ListFile(__out std::vector<QString>* pFilePaths, __in const QString& strDir, __in const QString* pStrFileExtendName);
//    
//    static QString GenerateUniqueFileName(const QString& strExtendName);
//    
//    /*
//     * Compare two file context is same or not. Best to ensure that the source file and purpose file is
//     * not the same file
//     *
//     */
//    static bool CompareFileContext(
//                                   __in const QString& strSourceFilePath,
//                                   __in const QString& strDestFilePath
//                                   );
//    
//    static void DrawImageInProportional(QPainter& painter, QImage* pImage, const QRect& drawImage);
//    
//    static Elc_BOOL SaveImage(QImage* pImage, const QString& strImagePath);
//    
//    static void drawTextElided(QPainter& painter, QString& strText, QRect rcItem);
//    static void drawTextElidedLeft(QPainter& painter, QString& strText, QRect rcItem);
//    
//    
//    static QImage* AddWhiteMask(const QPixmap& pixmap, const QSize& sizeImage);
//    static QImage* AddWhiteMaskWithEdge(const QPixmap& pixmap, const QSize& sizeImage);
//    
//    static QImage* addWhiteMaskWithEdge(const QImage& image, const QSize& sizeImage);
//    
//    
//};
//
//#endif // HELPFUNCTION_H
