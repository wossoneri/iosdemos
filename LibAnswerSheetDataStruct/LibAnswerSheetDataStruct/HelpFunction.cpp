//
//  HelpFunction.cpp
//  LibAnswerSheet
//
//  Created by huanghao on 15-2-27.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//
//#include "LibAnswerSheetMaker.h"
#include "HelpFunction.h"
#include "ELC_Types_AS.h"
#include <uuid/uuid.h>
//#include "CompletionAnswer.h"

// used in HandWrittingAnswer.mm
//BOOL CHelpFunction::compareFileContext(const std::string &strSourceFilePath, const std::string &strDestFilePath)
//{
//    //创建文件管理器
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    NSString *filePath = [NSString stringWithCString:strSourceFilePath.c_str() encoding:[NSString defaultCStringEncoding]];
//    NSString *filePath2 = [NSString stringWithCString:strSourceFilePath.c_str() encoding:[NSString defaultCStringEncoding]];
//    
//    BOOL bEqual = [fileManager contentsEqualAtPath:filePath andPath:filePath2];
//    
//    return bEqual;
//}

bool CHelpFunction::readFileEntire(Elc_U8 *& data, Elc_S64& size, const std::string& filePath) {

    FILE* f = fopen(filePath.data(), "rb");
    if( f == NULL ) {
        return false;
    }
    
    size = 0;
    fseek(f, 0, SEEK_END);
    size = ftell(f);
    fseek(f, 0, SEEK_SET);
    
    data = new Elc_U8[size];
    
    if ( size != fread(data, 1, size, f)) {
        delete [] data;
        data = NULL;
        size = 0;
        
        return false;
    }
    
    return true;
}

bool CHelpFunction::writeFileEntire(Elc_U8 * data, Elc_S64 size, const std::string &filePath)
{
    if( access(filePath.data(), 0) == 0) {
        remove(filePath.data());
    }
    
    FILE* f = fopen(filePath.c_str(), "wb");
    
    size_t sWrited = fwrite(data, 1, (Elc_ULONG)size, f);
    
    return ((Elc_ULONG)size == sWrited);
    
// Qt
//    QFile file(filePath);
//
//    if (!file.open(QIODevice::WriteOnly))
//    {
//        return false;
//    }
//
//    return (file.write((char*)data, size) == size);
}

GUID CHelpFunction::generateGuid() {
    GUID guid;
    unsigned char data[16];
    uuid_generate(data);
    memcpy(guid.data, data, sizeof(data));
    
    return guid;
}

std::string CHelpFunction::generateUniqueFileName(const std::string& extendName) {
    
    GUID guid = generateGuid();
    
    char szTmp[260];
    
    sprintf(szTmp, "%c%c%c%c-%c%c%c%c-%c%c%c%c-%c%c%c%c%s",
            guid.data[0],guid.data[1],guid.data[2],guid.data[3],
            guid.data[4],guid.data[5],guid.data[6],guid.data[7],
            guid.data[8],guid.data[9],guid.data[10],guid.data[11],
            guid.data[12],guid.data[13],guid.data[14],guid.data[15],
            extendName.data());
    
    return std::string(szTmp);
}
// not used now
//std::string CHelpFunction::getCompletionFmtAnswer(const CCompletionAnswer* pAnswer, int iBlankCount) {
//    
//    std::string strRet;
//    
//    const std::string& strAnswer = pAnswer->GetAnswer();
//    vector<std::string> arrAnswer = CCompletionAnswer::AnswerStringToAnswerItem(strAnswer, iBlankCount);
//    
//    for(int i=0; i < arrAnswer.size(); i ++ ) {
//        char szTmp[512] = {0};
//        
//        if( arrAnswer[i].empty() ) {
//            sprintf(szTmp, "(%d). ____", i+1);
//        } else {
//            sprintf(szTmp, "(%d). %s", i+1, arrAnswer[i].data());
//        }
//        std::string strTmp(szTmp);
//        
//        strRet += strTmp;
//    }
//    
//    return strRet;
//}


std::string CHelpFunction::generateTmpImagePath (){
    std::string strTmp = getAnswerSheetTmpPath() + std::string("/");
    
    GUID guid = generateGuid();
    std::string strGuid;
    GuidToStdString(&guid, strGuid);
    
    strTmp.append(strGuid.c_str());
    strTmp.append(".png");
    printf("tmp image path is%s \n", strTmp.c_str());
    return strTmp;
}

std::string CHelpFunction::getAnswerSheetTmpPath(){
    
    return "/var/mobile/Applications/109E32FB-9902-4B02-A8FB-A4BA438ADB32/Documents/Quiz/AnswerSheet/AnswerSheetTemp/QuizPaperImageTemp";
}




// Qt
//#include "stdafx.h"
//#include "HelpFunction.h"
//#include <uuid/uuid.h>
//
//
//int CHelpFunction::floatToInt(float value)
//{
//    return value < 0 ? (int)(value - 0.5f) : (int)(value + 0.5f);
//}
//
//bool CHelpFunction::compareFloat(float value1, float value2)
//{
//    return qAbs(value1 - value2) <= FLT_PRECISION;
//}
//
//QPixmap CHelpFunction::fromImage(const QImage& image) {
//    QPixmap pixmap;
//    pixmap.convertFromImage(image);
//    
//    return pixmap;
//}
//
//QIcon CHelpFunction::iconFromImage(const QImage &image)
//{
//    return QIcon(fromImage(image));
//}
//
//float CHelpFunction::distanceOfPoint(const QPoint& pt1, const QPoint& pt2)
//{
//    return qSqrt((pt1.x() - pt2.x()) * (pt1.x() - pt2.x()) + (pt1.y() - pt2.y()) * (pt1.y() - pt2.y()));
//}
//
//void CHelpFunction::drawSkinImage(const QRect& rect, const SkinImage& skinImage, QPainter& painter, bool bShowLog/* = false*/)
//{
//    QRect topLeftRect(0, 0, skinImage.m_margin.left(), skinImage.m_margin.top());
//    QRect topRect(topLeftRect.right() + 1, 0, skinImage.m_image->width() - skinImage.m_margin.left() - skinImage.m_margin.right(), topLeftRect.height());
//    QRect topRightRect(topRect.right() + 1, 0, skinImage.m_margin.right(), topLeftRect.height());
//    
//    QRect middleLeftRect(topLeftRect.left(), topLeftRect.bottom() + 1, topLeftRect.width(), skinImage.m_image->height() - skinImage.m_margin.top() - skinImage.m_margin.bottom());
//    QRect middleRect(middleLeftRect.right() + 1, middleLeftRect.top(), topRect.width(), middleLeftRect.height());
//    QRect middleRightRect(middleRect.right() + 1, middleLeftRect.top(), topRightRect.width(), middleLeftRect.height());
//    
//    QRect bottomLeftRect(topLeftRect.left(), middleLeftRect.bottom() + 1, topLeftRect.width(), skinImage.m_margin.bottom());
//    QRect bottomRect(bottomLeftRect.right() + 1, bottomLeftRect.top(), topRect.width(), bottomLeftRect.height());
//    QRect bottomRightRect(bottomRect.right() + 1, bottomLeftRect.top(), topRightRect.width(), bottomLeftRect.height());
//    
//    QRect drawTopLeftRect(rect.left(), rect.top(), skinImage.m_margin.left(), skinImage.m_margin.top());
//    QRect drawTopRect(drawTopLeftRect.right() + 1, drawTopLeftRect.top(), rect.width() - skinImage.m_margin.left() - skinImage.m_margin.right(), drawTopLeftRect.height());
//    QRect drawTopRightRect(drawTopRect.right() + 1, drawTopLeftRect.top(), skinImage.m_margin.right(), drawTopLeftRect.height());
//    
//    QRect drawMiddleLeftRect(drawTopLeftRect.left(), drawTopLeftRect.bottom() + 1, drawTopLeftRect.width(), rect.height() - skinImage.m_margin.top() - skinImage.m_margin.bottom());
//    QRect drawMiddleRect(drawMiddleLeftRect.right() + 1, drawMiddleLeftRect.top(), drawTopRect.width(), drawMiddleLeftRect.height());
//    QRect drawMiddleRightRect(drawMiddleRect.right() + 1, drawMiddleLeftRect.top(), drawTopRightRect.width(), drawMiddleLeftRect.height());
//    
//    QRect drawBottomLeftRect(drawTopLeftRect.left(), drawMiddleLeftRect.bottom() + 1, drawTopLeftRect.width(), skinImage.m_margin.bottom());
//    QRect drawBottomRect(drawBottomLeftRect.right() + 1, drawBottomLeftRect.top(), drawTopRect.width(), drawBottomLeftRect.height());
//    QRect drawBottomRightRect(drawBottomRect.right() + 1, drawBottomLeftRect.top(), drawTopRightRect.width(), drawBottomLeftRect.height());
//    
//    if( bShowLog ) {
//        //        qDebug("CHelpFunction::drawSkinImage--[QSize(%d,%d)][QMargin(left: %d, top:%d, right:%d, bottom:%d)]--top\
//        //               (TopLeft:%d,%d)(TopMiddle:%d,%d)(TopRight:%d,%d)",
//        //               skinImage.m_image->width(),skinImage.m_image->height(),
//        //               skinImage.m_margin.left(),skinImage.m_margin.top(),skinImage.m_margin.right(),skinImage.m_margin.bottom(),
//        //               topLeftRect.width(), topLeftRect.height(), topRect.width(), topRect.height(), topRightRect.width(), topRightRect.height());
//    }
//    painter.drawImage(drawTopLeftRect, skinImage.m_image->copy(topLeftRect));
//    painter.drawImage(drawTopRect, skinImage.m_image->copy(topRect));
//    painter.drawImage(drawTopRightRect, skinImage.m_image->copy(topRightRect));
//    
//    painter.drawImage(drawMiddleLeftRect, skinImage.m_image->copy(middleLeftRect));
//    painter.drawImage(drawMiddleRect, skinImage.m_image->copy(middleRect));
//    painter.drawImage(drawMiddleRightRect, skinImage.m_image->copy(middleRightRect));
//    
//    painter.drawImage(drawBottomLeftRect, skinImage.m_image->copy(bottomLeftRect));
//    painter.drawImage(drawBottomRect, skinImage.m_image->copy(bottomRect));
//    painter.drawImage(drawBottomRightRect, skinImage.m_image->copy(bottomRightRect));
//}
//
//void CHelpFunction::drawImageCenterWithScale(const QRect& rect, const QImage& image, QPainter& painter)
//{
//    float hscaleRatio = 1.0f;
//    
//    if (image.width() > rect.width())
//    {
//        hscaleRatio = rect.width() / (float)image.width();
//    }
//    
//    float vscaleRatio = 1.0f;
//    
//    if (image.height() > rect.height())
//    {
//        vscaleRatio = rect.height() / (float)image.height();
//    }
//    
//    float scaleRatio = qMin(hscaleRatio, vscaleRatio);
//    
//    if (!CHelpFunction::compareFloat(scaleRatio, 1.0f))
//    {
//        QImage tempImage = image.scaled(image.size() * scaleRatio);
//        
//        int xOffset = (rect.width() - tempImage.width()) / 2;
//        int yOffset = (rect.height() - tempImage.height()) / 2;
//        
//        painter.drawImage(QPoint(rect.left() + xOffset, rect.top() + yOffset), tempImage);
//    }
//    else
//    {
//        int xOffset = (rect.width() - image.width()) / 2;
//        int yOffset = (rect.height() - image.height()) / 2;
//        
//        painter.drawImage(QPoint(rect.left() + xOffset, rect.top() + yOffset), image);
//    }
//}
//
//void CHelpFunction::drawPixmapCenterWithScale(const QRect& rect, const QPixmap& pixmap, QPainter& painter)
//{
//    float hscaleRatio = 1.0f;
//    
//    if (pixmap.width() > rect.width())
//    {
//        hscaleRatio = rect.width() / (float)pixmap.width();
//    }
//    
//    float vscaleRatio = 1.0f;
//    
//    if (pixmap.height() > rect.height())
//    {
//        vscaleRatio = rect.height() / (float)pixmap.height();
//    }
//    
//    float scaleRatio = qMin(hscaleRatio, vscaleRatio);
//    
//    if (!CHelpFunction::compareFloat(scaleRatio, 1.0f))
//    {
//        QPixmap tempPixmap = pixmap.scaled(pixmap.size() * scaleRatio);
//        
//        int xOffset = (rect.width() - tempPixmap.width()) / 2;
//        int yOffset = (rect.height() - tempPixmap.height()) / 2;
//        
//        painter.drawPixmap(QPoint(rect.left() + xOffset, rect.top() + yOffset), tempPixmap);
//    }
//    else
//    {
//        int xOffset = (rect.width() - pixmap.width()) / 2;
//        int yOffset = (rect.height() - pixmap.height()) / 2;
//        
//        painter.drawPixmap(QPoint(rect.left() + xOffset, rect.top() + yOffset), pixmap);
//    }
//}
//
//QSize CHelpFunction::getTextSize(const QString &text, const QFont& font)
//{
//    QFontMetrics metrics(font);
//    QRectF rect = metrics.boundingRect(text);
//    return QSize(rect.width(), rect.height());
//}
//
//QSize CHelpFunction::getTextSize(const QString &text, const QFont& font, int width)
//{
//    QFontMetrics fm(font);
//    QRect rcText = fm.boundingRect(QRect(0,0,width,0), Qt::AlignLeft | Qt::TextWordWrap | Qt::TextWrapAnywhere, text);
//    return rcText.size();
//}
//
//GUID CHelpFunction::generateGuid()
//{
//    GUID guid;
//    unsigned char data[16];
//    uuid_generate(data);
//    memcpy(guid.data, data, sizeof(data));
//    
//    return guid;
//}
//
//QString CHelpFunction::generateUniqueFildName(const QString& extendName)
//{
//    GUID guid = generateGuid();
//    return QString("%1%2%3%4-%5%6%7%8-%9%10%11%12-%13%14%15%16%17").arg(guid.data[0]).arg(guid.data[1]).arg(guid.data[2]).arg(guid.data[3]).arg(guid.data[4]).arg(guid.data[5]).arg(guid.data[6])
//    .arg(guid.data[7]).arg(guid.data[8]).arg(guid.data[9]).arg(guid.data[10]).arg(guid.data[11]).arg(guid.data[12]).arg(guid.data[13]).arg(guid.data[14]).arg(guid.data[15]).arg(extendName);
//}
//
//bool CHelpFunction::writeFileEntire(Elc_U8 * data, qint64 size, const QString &filePath)
//{
//    QFile file(filePath);
//    
//    if (!file.open(QIODevice::WriteOnly))
//    {
//        return false;
//    }
//    
//    return (file.write((char*)data, size) == size);
//}
//
//bool CHelpFunction::readFileEntire(Elc_U8 *& data, qint64& size, const QString &filePath)
//{
//    QFile file(filePath);
//    if (!file.open(QIODevice::ReadOnly))
//    {
//        return false;
//    }
//    
//    size = file.size();
//    data = new Elc_U8[size];
//    
//    
//    if (size != file.read((char*)data, size))
//    {
//        delete[] data;
//        data = NULL;
//        size = 0;
//        return false;
//    }
//    
//    return true;
//}
//
//QSize CHelpFunction::getSuggestIconSizeOnPushButton(const QImage &icon)
//{
//    QSize imgSize = icon.size();
//    
//    int widthSpacing = 6;
//    int heightSpacing = (imgSize.height() / (float)imgSize.width()) * widthSpacing;
//    
//    return QSize(imgSize.width() - widthSpacing, imgSize.height() - heightSpacing);
//}
//
//bool CHelpFunction::compareFileContext(const QString &strSourceFilePath, const QString &strDestFilePath)
//{
//    Elc_BOOL	bRes = Elc_TRUE;
//    
//    char*	lpbyDestFileData = NULL;
//    char*	lpbySourceFileData = NULL;
//    
//    qint64	lDestFileLength = 0;
//    qint64	lSourceFileLength = 0;
//    
//    do
//    {
//        QFile	destFile(strDestFilePath);
//        QFile	sourceFile(strSourceFilePath);
//        
//        if (!destFile.open(QIODevice::ReadOnly))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        if (!sourceFile.open(QIODevice::ReadOnly))
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        lDestFileLength = destFile.size();
//        lSourceFileLength = sourceFile.size();
//        
//        if (lSourceFileLength != lDestFileLength)
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        if (0 == lSourceFileLength && 0 == lDestFileLength)
//        {
//            bRes = Elc_TRUE;
//            break;
//        }
//        
//        qint64	lOnceCompareLength = 1024;
//        qint64	lComparedLength = 0;
//        
//        lpbyDestFileData = new char[1024];
//        lpbySourceFileData = new char[1024];
//        
//        Elc_BOOL	bCompareBlockResult = Elc_TRUE;
//        
//        while (Elc_TRUE)
//        {
//            lOnceCompareLength = 1024;
//            
//            if (lSourceFileLength - lComparedLength < lOnceCompareLength)
//            {
//                lOnceCompareLength = lSourceFileLength - lComparedLength;
//            }
//            
//            if (lOnceCompareLength <= 0)
//            {
//                bCompareBlockResult = Elc_TRUE;
//                break;
//            }
//            
//            destFile.read(lpbyDestFileData, lOnceCompareLength);
//            sourceFile.read(lpbySourceFileData, lOnceCompareLength);
//            
//            if (0 != memcmp(lpbyDestFileData, lpbySourceFileData, (size_t)lOnceCompareLength))
//            {
//                bCompareBlockResult = Elc_FALSE;
//                break;
//            }
//            
//            lComparedLength += lOnceCompareLength;
//        }
//        
//        if (!bCompareBlockResult)
//        {
//            bRes = Elc_FALSE;
//            break;
//        }
//        
//        bRes = Elc_TRUE;
//    } while (Elc_FALSE);
//    
//    SAFE_DELETE_ARRAY(lpbyDestFileData);
//    SAFE_DELETE_ARRAY(lpbySourceFileData);
//    
//    return bRes;
//}
//
//void CHelpFunction::drawTextAutoHCenter(const QRect &rect, const QString &text, QPainter &painter)
//{
//    QSize size = getTextSize(text, painter.font());
//    
//    if (rect.width() >= size.width())
//    {
//        painter.drawText(rect, Qt::AlignCenter, text);
//    }
//    else
//    {
//        painter.drawText(rect, Qt::AlignVCenter | Qt::AlignLeft, text);
//    }
//}
//
//QString CHelpFunction::getRealEditText(QLineEdit &edit)
//{
//    QString text = edit.text();
//    const QValidator* validator = edit.validator();
//    
//    if( validator->objectName().compare("QIntValidator") ) {
//        int value = text.toInt();
//        int bottom = ((QIntValidator*)validator)->bottom();
//        int top = ((QIntValidator*)validator)->top();
//        
//        if (value < bottom)
//        {
//            value = bottom;
//        } else if (value > top)
//        {
//            value = top;
//        }
//        
//        QString strText;
//        strText.sprintf("%d", value);
//        
//        return strText;
//    }
//    
//    return text;
//}
//
//void CHelpFunction::ParseChoiceAnswerByString(vector<QString>& answers, const QString& strText)
//{
//    int	startIndex = 0;
//    while( Elc_TRUE ) {
//        int index = strText.indexOf(CHOICE_ANSWER_GAP_CHAR, startIndex);
//        if( -1 == index ) {
//            answers.push_back(strText.mid(startIndex, strText.length() - startIndex));
//            break;
//        } else {
//            answers.push_back(strText.mid(startIndex, index - startIndex));
//            startIndex = index + 1;
//        }
//    }
//}
//
//
//void CHelpFunction::OptionChoiceAnswerByIndex(__inout vector<int>& choiceIndexs, int iIndex)
//{
//    ASSERT(iIndex >= 0);
//    
//    if (choiceIndexs.empty())
//    {
//        choiceIndexs.push_back(iIndex);
//    }
//    else
//    {
//        int	i;
//        int	iSize = (int)choiceIndexs.size();
//        
//        for (i = 0; i < iSize; ++i)
//        {
//            if (iIndex == choiceIndexs[i])
//            {
//                /*
//                 * Already have a same choice, delete it
//                 */
//                choiceIndexs.erase(choiceIndexs.begin() + i);
//                break;
//            }
//            else if (iIndex < choiceIndexs[i])
//            {
//                choiceIndexs.insert(choiceIndexs.begin() + i, iIndex);
//                break;
//            }
//        }
//        
//        if (iSize == i)
//        {
//            choiceIndexs.push_back(iIndex);
//        }
//    }
//}
//
//void CHelpFunction::OptionTrueFalseAnswerByIndex(CTrueFalseAnswer::ANSWER_VALUE& answer, int iIndex)
//{
//    ASSERT(iIndex >= 0);
//    
//    switch (answer)
//    {
//        case CTrueFalseAnswer::correct:
//        {
//            if (0 == iIndex)
//            {
//                answer = CTrueFalseAnswer::null;
//            }
//            else
//            {
//                answer = CTrueFalseAnswer::wrong;
//            }
//        }
//            break;
//        case CTrueFalseAnswer::wrong:
//        {
//            if (0 == iIndex)
//            {
//                answer = CTrueFalseAnswer::correct;
//            }
//            else
//            {
//                answer = CTrueFalseAnswer::null;
//            }
//        }
//            break;
//        case CTrueFalseAnswer::null:
//        {
//            if (0 == iIndex)
//            {
//                answer = CTrueFalseAnswer::correct;
//            }
//            else
//            {
//                answer = CTrueFalseAnswer::wrong;
//            }
//        }
//            break;
//        default:
//            ASSERT(Elc_FALSE);
//            break;
//    }
//}
//
//Elc_BOOL CHelpFunction::CompareClientID(CLIENTID id1, CLIENTID id2)
//{
//    return memcmp(&id1, &id2, sizeof(CLIENTID)) == 0;
//}
//
//void CHelpFunction::ClearStudentAnswer(std::vector<CStudentAnswer*>& studentAnswers)
//{
//    if (studentAnswers.empty())
//    {
//        return;
//    }
//    
//    int	i;
//    int	iSize = (int)studentAnswers.size();
//    
//    for (i = 0; i < iSize; ++i)
//    {
//        SAFE_DELETE(studentAnswers[i]);
//    }
//    
//    studentAnswers.clear();
//}
//
//Elc_BOOL CHelpFunction::CompareQuestionScore(float fScore1, float fScore2)
//{
//    QString	strScore1;
//    QString	strScore2;
//    
//    strScore1.sprintf("%g", fScore1);
//    strScore2.sprintf("%g", fScore2);
//    
//    return (strScore1.compare(strScore2) == 0);
//}
//
//QString CHelpFunction::GenerateGroupQuestionScoreInfo(const vector<AQuestion*>& questions)
//{
//    if (questions.empty())
//    {
//        return QString("");
//    }
//    
//    float	fFirstQuestionScore = questions[0]->GetScore();;
//    float	fTotalScore = fFirstQuestionScore;
//    Elc_BOOL	bSameScore = Elc_TRUE;
//    
//    for (int i = 1; i < (int)questions.size(); ++i)
//    {
//        if (!CHelpFunction::CompareQuestionScore(questions[i]->GetScore(), fFirstQuestionScore))
//        {
//            bSameScore = Elc_FALSE;
//        }
//        
//        fTotalScore += questions[i]->GetScore();
//    }
//    
//    QString	strPreQuestionScore;
//    if (bSameScore)
//    {
//        strPreQuestionScore.sprintf("each score %g", fFirstQuestionScore);
//        strPreQuestionScore.append(',');
//    }
//    
//    QString strGroupInfo;
//    strGroupInfo.sprintf("%d questions, %s total score %g", questions.size(), strPreQuestionScore.toStdString().data(), fTotalScore);
//    
//    return QString("(") + strGroupInfo + QString(")");
//    
//    // windows
//    //    if (questions.empty())
//    //    {
//    //        return QString(TEXT(""));
//    //    }
//    
//    //    float	fFirstQuestionScore = questions[0]->GetScore();;
//    //    float	fTotalScore = fFirstQuestionScore;
//    //    Elc_BOOL	bSameScore = Elc_TRUE;
//    
//    //    for (int i = 1; i < (int)questions.size(); ++i)
//    //    {
//    //        if (!CHelpFunction::CompareQuestionScore(questions[i]->GetScore(), fFirstQuestionScore))
//    //        {
//    //            bSameScore = Elc_FALSE;
//    //        }
//    
//    //        fTotalScore += questions[i]->GetScore();
//    //    }
//    
//    
//    //    CString	strPreQuestionScore;
//    //    if (bSameScore)
//    //    {
//    //        strPreQuestionScore.Format(ElcGetString(TEXT("IDS_ANSWERSHEET_QUESTION_SCORE")), fFirstQuestionScore);
//    //        strPreQuestionScore.Append(_T(","));
//    //    }
//    
//    //    CString strGroupInfo;
//    //    strGroupInfo.Format(ElcGetString(TEXT("IDS_ANSWERSHEET_GROUP_QUESTION_INFO")), questions.size(), strPreQuestionScore, fTotalScore);
//    
//    //    return TEXT("(") + strGroupInfo + TEXT(")");
//}
//
//QString CHelpFunction::ScoreFloat2String(float fScore)
//{
//    QString	strRes;
//    strRes.sprintf("%g", fScore);
//    
//    return strRes;
//}
//
//QString CHelpFunction::GetAnswerShow(const AAnswer* pAnswer)
//{
//    QString	strText;
//    
//    if (pAnswer->IsValid())
//    {
//        switch (pAnswer->GetType())
//        {
//            case choiceQuestion:
//            {
//                const vector<int>& choiceIndex = pAnswer->ToChoiceAnswer()->GetChoiceIndex();
//                
//                for (int i = 0; i < (int)choiceIndex.size(); ++i)
//                {
//                    strText.append(g_choices[choiceIndex[i]]);
//                }
//            }
//                break;
//            case trueFlaseQuestion:
//            {
//                CTrueFalseAnswer::ANSWER_VALUE answer = pAnswer->ToTrueFalseAnswer()->GetAnswer();
//                if (answer == CTrueFalseAnswer::correct)
//                {
//                    strText = "√";
//                }
//                else if (answer == CTrueFalseAnswer::wrong)
//                {
//                    strText = "×";
//                }
//            }
//                break;
//            case completionQuestion:
//            {
//                vector<QString> answerItems = CCompletionAnswer::AnswerStringToAnswerItem(pAnswer->ToCompletionAnswer()->GetAnswer(), 0);
//                QString strTempText;
//                QString strNum;
//                for (int i = 0; i < (int)answerItems.size(); ++i) {
//                    if (answerItems[i].isEmpty()) {
//                        strTempText.sprintf(" %d.  ____  " ,i + 1);
//                        strText.append(strTempText);
//                    } else {
//                        strTempText.sprintf(" %d.   %s  " ,i + 1 ,answerItems[i].toLatin1().data());
//                        strText.append(strTempText);
//                    }
//                }
//                
//                strText.remove(strText.length() - 1, 1);
//            }
//                break;
//            case essayQuestion:
//                strText = pAnswer->ToEssayAnswer()->GetAnswer();
//                break;
//        }
//    }
//    
//    return strText;
//    // windows
//    //    CString	strText;
//    
//    //    if (pAnswer->IsValid())
//    //    {
//    //        switch (pAnswer->GetType())
//    //        {
//    //        case choiceQuestion:
//    //        {
//    //            const vector<int>& choiceIndex = pAnswer->ToChoiceAnswer()->GetChoiceIndex();
//    
//    //            for (int i = 0; i < (int)choiceIndex.size(); ++i)
//    //            {
//    //                strText.Append(g_choices[choiceIndex[i]]);
//    //            }
//    //        }
//    //            break;
//    //        case trueFlaseQuestion:
//    //        {
//    //            CTrueFalseAnswer::ANSWER_VALUE answer = pAnswer->ToTrueFalseAnswer()->GetAnswer();
//    //            if (answer == CTrueFalseAnswer::correct)
//    //            {
//    //                strText = _T("��");
//    //            }
//    //            else if (answer == CTrueFalseAnswer::wrong)
//    //            {
//    //                strText = _T("��");
//    //            }
//    //        }
//    //            break;
//    //        case completionQuestion:
//    //        {
//    //            vector<CString> answerItems = CCompletionAnswer::AnswerStringToAnswerItem(pAnswer->ToCompletionAnswer()->GetAnswer(), 0);
//    //            CString strTempText;
//    //            CString strNum;
//    //            for (int i = 0; i < (int)answerItems.size(); ++i) {
//    //                if (answerItems[i].IsEmpty()) {
//    //                    strTempText.Format(_T(" %d.  ____  ") ,i + 1);
//    //                    strText.Append(strTempText);
//    //                } else {
//    //                    strTempText.Format(_T(" %d.   %s  ") ,i + 1 ,answerItems[i]);
//    //                    strText.Append(strTempText);
//    //                }
//    //            }
//    
//    //            strText.Delete(strText.GetLength() - 1);
//    //        }
//    //            break;
//    //        case essayQuestion:
//    //            strText = pAnswer->ToEssayAnswer()->GetAnswer();
//    //            break;
//    //        }
//    //    }
//    
//    //    return strText;
//}
//
//int CHelpFunction::GetFileLength(const QString& strPath)
//{
//    qint64 fileSize = -1;
//    
//    QFile file(strPath);
//    if( file.exists() ) {
//        fileSize = file.size();
//    }
//    
//    return fileSize;
//}
//
//QString CHelpFunction::InetDwordToString(quint32 ipaddr)
//{
//    char* pIPAddr = inet_ntoa(*((in_addr*)&ipaddr));
//    
//    QString strIPAddr = QString::fromLocal8Bit(pIPAddr);
//    return strIPAddr;
//}
//
//void CHelpFunction::ListFile(__out std::vector<QString>* pFilePaths, __in const QString& strDir, __in const QString* pStrFileExtendName)
//{
//    if (NULL == pFilePaths)
//    {
//        return;
//    }
//    
//    QDir dir(strDir);
//    dir.setFilter(QDir::Files|QDir::NoDotAndDotDot);
//    
//    // remove child
//    QFileInfoList fileInfoList = dir.entryInfoList();
//    if( !fileInfoList.empty() ) {
//        int iSize = fileInfoList.size();
//        for( int i=0; i < iSize; i ++) {
//            QFileInfo fileInfo = fileInfoList.at(i);
//            
//            if( NULL == pStrFileExtendName || 0 == fileInfo.suffix().compare(*pStrFileExtendName, Qt::CaseInsensitive) ) {
//                pFilePaths->push_back(fileInfo.absoluteFilePath());
//            }
//        }
//    }
//}
//
//QString CHelpFunction::GenerateUniqueFileName(const QString& strExtendName)
//{
//    GUID    guid;
//    uuid_generate(guid.data);
//    
//    string strGuid;
//    GuidToStdString(&guid, strGuid);
//    
//    if( !strExtendName.isEmpty() ) {
//        strGuid.append(strExtendName.toStdString());
//    }
//    
//    return QString::fromStdString(strGuid);
//}
//
//bool CHelpFunction::CompareFileContext(
//                                       __in const QString& strSourceFilePath,
//                                       __in const QString& strDestFilePath
//                                       )
//{
//    //
//    bool    bRet = false;
//    
//    char*   lpbyDestFileData = NULL;
//    char*   lpbySourceFileData = NULL;
//    
//    qint64  lDestFileLength = 0;
//    qint64  lSourceFileLength = 0;
//    
//    do {
//        QFile destFile(strDestFilePath);
//        QFile sourceFile(strSourceFilePath);
//        destFile.open(QIODevice::ReadOnly);
//        sourceFile.open(QIODevice::ReadOnly);
//        
//        lDestFileLength = destFile.size();
//        lSourceFileLength = sourceFile.size();
//        
//        if (0 == lSourceFileLength && 0 == lDestFileLength) {
//            bRet = true;
//            break;
//        }
//        
//        if( lSourceFileLength != lDestFileLength ) {
//            break;
//        }
//        
//        //
//        qint64	lOnceCompareLength = 1024;
//        qint64	lComparedLength = 0;
//        
//        lpbyDestFileData = new char[1024];
//        lpbySourceFileData = new char[1024];
//        
//        // 默认不相等
//        bool bContextRet = false;
//        while( true ) {
//            lOnceCompareLength = 1024;
//            
//            if( lSourceFileLength - lComparedLength < lOnceCompareLength ) {
//                lOnceCompareLength = lSourceFileLength - lComparedLength;
//            }
//            
//            if( lOnceCompareLength <= 0 ) {
//                bContextRet = true;
//                break;
//            }
//            
//            int n1 = destFile.read(lpbyDestFileData, (qint64)lOnceCompareLength);
//            int n2 = sourceFile.read(lpbySourceFileData, (qint64)lOnceCompareLength);
//            if( 0 != memcmp(lpbyDestFileData, lpbySourceFileData, (size_t)lOnceCompareLength) ) {
//                break;
//            }
//            
//            lComparedLength += lOnceCompareLength;
//        }
//        
//        if( !bContextRet ) {
//            break;
//        }
//        
//        // 千难万险，才达到true
//        bRet = true;
//    } while( false );
//    
//    SAFE_DELETE_ARRAY(lpbyDestFileData);
//    SAFE_DELETE_ARRAY(lpbySourceFileData);
//    
//    return bRet;
//}
//
//void CHelpFunction::DrawImageInProportional(QPainter& painter, QImage* pImage, const QRect& drawImage)
//{
//    int	iImageWidth = (int)pImage->width();
//    int	iImageHeight = (int)pImage->height();
//    
//    float fWH = (float)iImageWidth / (float)iImageHeight;
//    
//    QRect   imageDrawRect;
//    imageDrawRect.setWidth(drawImage.width());
//    imageDrawRect.setHeight(drawImage.height());
//    
//    if( imageDrawRect.height() > drawImage.height() ) {
//        imageDrawRect.setHeight(drawImage.height());
//        imageDrawRect.setWidth((int)imageDrawRect.height() * fWH);
//    }
//    
//    imageDrawRect.setLeft( (drawImage.width() - imageDrawRect.width())/2 + drawImage.left());
//    imageDrawRect.setTop( (drawImage.height() - imageDrawRect.height())/2 + drawImage.top() );
//    
//    painter.drawImage(imageDrawRect, *pImage);
//    
//    // windows
//    //    int	iImageWidth = (int)pImage->GetWidth();
//    //    int	iImageHeight = (int)pImage->GetHeight();
//    
//    //    float fWH = (float)iImageWidth / (float)iImageHeight;
//    
//    //    Rect	imageDrawRect;
//    //    imageDrawRect.Width = drawImage.Width();
//    //    imageDrawRect.Height = (int)(imageDrawRect.Width / fWH);
//    
//    //    if (imageDrawRect.Height > drawImage.Height())
//    //    {
//    //        imageDrawRect.Height = drawImage.Height();
//    //        imageDrawRect.Width = (int)(imageDrawRect.Height * fWH);
//    //    }
//    
//    //    imageDrawRect.X = (drawImage.Width() - imageDrawRect.Width) / 2 + drawImage.left;
//    //    imageDrawRect.Y = (drawImage.Height() - imageDrawRect.Height) / 2 + drawImage.top;
//    
//    //    gh.DrawImage(pImage, imageDrawRect);
//}
//
//Elc_BOOL CHelpFunction::SaveImage(QImage* pImage, const QString& strImagePath)
//{
//    return pImage->save(strImagePath, "png") ? Elc_TRUE : Elc_FALSE;
//    
//    // windows
//    //    static CLSID	png = CLSID_NULL;
//    
//    //    if (CLSID_NULL == png)
//    //    {
//    //        GetEncoderClsid(TEXT( "image/png" ), &png);
//    //    }
//    
//    //    return pImage->Save(strImagePath, &png, NULL) == Gdiplus::Ok;
//}
//
//void CHelpFunction::drawTextElided(QPainter& painter, QString& strText, QRect rcItem)
//{
//    QFontMetrics fm(painter.font());
//    
//    int textWidth = fm.width(strText);
//    if( textWidth < rcItem.width() ) {
//        painter.drawText(rcItem, Qt::AlignHCenter | Qt::AlignVCenter, strText);
//    } else {
//        QString strNew = fm.elidedText(strText, Qt::ElideRight, rcItem.width());
//        painter.drawText(rcItem, Qt::AlignLeft | Qt::AlignVCenter, strNew);
//    }
//}
//
//void CHelpFunction::drawTextElidedLeft(QPainter& painter, QString& strText, QRect rcItem)
//{
//    QFontMetrics fm(painter.font());
//    
//    int textWidth = fm.width(strText);
//    if( textWidth < rcItem.width() ) {
//        painter.drawText(rcItem, Qt::AlignLeft | Qt::AlignVCenter, strText);
//    } else {
//        QString strNew = fm.elidedText(strText, Qt::ElideRight, rcItem.width());
//        painter.drawText(rcItem, Qt::AlignLeft | Qt::AlignVCenter, strNew);
//    }
//}
//
//QImage* CHelpFunction::AddWhiteMask(const QPixmap& pixmap, const QSize& sizeImage)
//{
//    QImage* pImage = new QImage(sizeImage, QImage::Format_ARGB32);
//    
//    QPainter painter(pImage);
//    
//    painter.fillRect(0, 0, sizeImage.width(), sizeImage.height(), QBrush(Qt::white));
//    
//    int dstWidth = sizeImage.width();
//    int dstHeight = sizeImage.height();
//    
//    int srcWidth = pixmap.width();
//    int srcHeight = pixmap.height();
//    
//    if( srcWidth <= dstWidth && srcHeight <= dstHeight ) {
//        painter.drawPixmap( QPoint( (sizeImage.width() - pixmap.width())/2, (sizeImage.height() - pixmap.height())/2), pixmap );
//    } else {
//        float fSrc = (float)srcHeight/(float)srcWidth;
//        float fDst = (float)dstHeight/(float)dstWidth;
//        
//        QSize sizeDst;
//        if( fSrc <= fDst ) {
//            // 取dst的宽
//            sizeDst.setWidth(dstWidth);
//            float fDstHeight = (float)(dstWidth * srcHeight)/srcWidth;
//            sizeDst.setHeight(fDstHeight);
//        } else {
//            // 取src的高
//            sizeDst.setHeight(dstHeight);
//            float fDstWidth = (float)(srcWidth * dstHeight)/srcHeight;
//            sizeDst.setWidth(fDstWidth);
//        }
//        
//        painter.drawPixmap( QRect( (sizeImage.width() - sizeDst.width())/2,
//                                  (sizeImage.height() - sizeDst.height())/2,
//                                  sizeDst.width(), sizeDst.height()), pixmap );
//    }
//    
//    return pImage;
//}
//
//QImage* CHelpFunction::AddWhiteMaskWithEdge(const QPixmap& pixmap, const QSize& sizeImage)
//{
//    QImage* pImage = new QImage(sizeImage, QImage::Format_ARGB32);
//    
//    QPainter painter(pImage);
//    
//    painter.fillRect(0, 0, sizeImage.width(), sizeImage.height(), QBrush(Qt::white));
//    
//    int dstWidth = sizeImage.width();
//    int dstHeight = sizeImage.height();
//    
//    int srcWidth = pixmap.width();
//    int srcHeight = pixmap.height();
//    
//    if( srcWidth <= dstWidth && srcHeight <= dstHeight ) {
//        painter.drawPixmap( QPoint( (sizeImage.width() - pixmap.width())/2, (sizeImage.height() - pixmap.height())/2), pixmap );
//    } else {
//        float fSrc = (float)srcHeight/(float)srcWidth;
//        float fDst = (float)dstHeight/(float)dstWidth;
//        
//        QSize sizeDst;
//        if( fSrc <= fDst ) {
//            // 取dst的宽
//            sizeDst.setWidth(dstWidth);
//            float fDstHeight = (float)(dstWidth * srcHeight)/srcWidth;
//            sizeDst.setHeight(fDstHeight);
//        } else {
//            // 取src的高
//            sizeDst.setHeight(dstHeight);
//            float fDstWidth = (float)(srcWidth * dstHeight)/srcHeight;
//            sizeDst.setWidth(fDstWidth);
//        }
//        
//        painter.drawPixmap( QRect( (sizeImage.width() - sizeDst.width())/2,
//                                  (sizeImage.height() - sizeDst.height())/2,
//                                  sizeDst.width(), sizeDst.height()), pixmap );
//    }
//    
//    painter.drawRect(QRect(0,0,sizeImage.width() - 1,sizeImage.height() -1 ));
//    
//    return pImage;
//}
//
//QImage* CHelpFunction::addWhiteMaskWithEdge(const QImage& image, const QSize& sizeImage)
//{
//    QImage* pImage = new QImage(sizeImage, QImage::Format_ARGB32);
//    
//    QPainter painter(pImage);
//    
//    painter.fillRect(0, 0, sizeImage.width(), sizeImage.height(), QBrush(Qt::white));
//    
//    int dstWidth = sizeImage.width();
//    int dstHeight = sizeImage.height();
//    
//    int srcWidth = image.width();
//    int srcHeight = image.height();
//    
//    if( srcWidth <= dstWidth && srcHeight <= dstHeight ) {
//        painter.drawImage( QPoint( (sizeImage.width() - image.width())/2, (sizeImage.height() - image.height())/2), image );
//    } else {
//        float fSrc = (float)srcHeight/(float)srcWidth;
//        float fDst = (float)dstHeight/(float)dstWidth;
//        
//        QSize sizeDst;
//        if( fSrc <= fDst ) {
//            // 取dst的宽
//            sizeDst.setWidth(dstWidth);
//            float fDstHeight = (float)(dstWidth * srcHeight)/srcWidth;
//            sizeDst.setHeight(fDstHeight);
//        } else {
//            // 取src的高
//            sizeDst.setHeight(dstHeight);
//            float fDstWidth = (float)(srcWidth * dstHeight)/srcHeight;
//            sizeDst.setWidth(fDstWidth);
//        }
//        
//        painter.drawImage( QRect( (sizeImage.width() - sizeDst.width())/2,
//                                 (sizeImage.height() - sizeDst.height())/2,
//                                 sizeDst.width(), sizeDst.height()), image );
//    }
//    
//    painter.drawRect(QRect(0,0,sizeImage.width() - 1,sizeImage.height() -1 ));
//    
//    return pImage;
//}

