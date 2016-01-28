//
//  HelpHeader.h
//  Quiz
//
//  Created by mythware on 11/5/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#ifndef HelpHeader_h
#define HelpHeader_h

#define STRETCHIMAGE(imageName, top, left, bottom, right) [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch]

#define FONT_Headline       [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]
#define FONT_Subheadline    [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
#define FONT_Body           [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
#define FONT_Footnote       [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]
#define FONT_Caption1       [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]
#define FONT_Caption2       [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]

#define FONT(SIZE)          [UIFont fontWithName:@"Helvetica Neue" size:(SIZE)]
#define FONT_TOOLBAR        FONT(20)
#define FONT_BUTTON         FONT(14)

typedef NS_ENUM(int, ANSWER_STATE) {
    ANSWER_CORRECT = 0,
    ANSWER_WRONG,
    ANSWER_UNFINISHED,
    ANSWER_NORMAL
};

#pragma mark - >>>>>>>>>>>>>>>>>>>> Headers <<<<<<<<<<<<<<<<<<<<
///
#import "Masonry/Masonry.h"

#import "Protocol/MWTypes.h"
#import "HelpFunctions.h"

#import "MWJson/MWJson.h"
#import "MWModel/Account.h"
#import "MWUIKit/MWUIKit.h"
#import "JsonTransform.h"


#pragma mark - >>>>>>>>>>>>>>>>>>>> Margins/Offsets <<<<<<<<<<<<<<<<<<<<

#define COMMON_OFFSET       15
///
#define PROGRESS_LEFT_OFFSET    90
#define PROGRESS_RIGHT_OFFSET   30

#define STU_MARGIN_H    10
#define STU_BTN_WIDTH   40
#define STU_BTN_HEIGHT  40



#define TEA_BTN_WIDTH   48
#define TEA_BTN_HEIGHT  48

#define MARGIN_BUTTON   8
#define TOOLBAR_HEIGHT   44

#define OFFSET_BETWEEN_IMAGE_TEXT_IN_BUTTON 10.0f





#pragma mark - >>>>>>>>>>>>>>>>>>>> COMMON DIMENS <<<<<<<<<<<<<<<<<<<<
#define PORTRAIT_HEIGHT         44

///uilabel default font.capHeight is 12.138, set 16 looks good
#define COMMON_LABEL_HEIGHT    16

#define POPUP_TEXT_SIZE     16
#define HEADER_FONT_SIZE    16


#define HEADER_HEIGHT_PROGRESS  60

#define CELL_HEIGHT_PROGRESS    60
#define PROGRESS_ITEM_HEIGHT    CELL_HEIGHT_PROGRESS + COMMON_LABEL_HEIGHT + 25


#define COMPLETION_LABEL_WIDTH  20
#define COMPLETION_BLANK_WIDTH  100
#define COMPLETION_BLANK_HEIGHT 28

#define PORTRAIT_HEIGHT     44

#define RESULT_COLLECTION_OFFSET_LARGE    40
#define RESULT_COLLECTION_OFFSET_SMALL    20
                                            //150
#define QUES_RESULT_CELL_WIDTH_SMALL    170
#define QUES_RESULT_CELL_WIDTH_LARGE    230



#pragma mark - >>>>>>>>>>>>>>>>>>>> Value <<<<<<<<<<<<<<<<<<<<
#define EVENT_INTERVAL      2




#pragma mark - >>>>>>>>>>>>>>>>>>>> Colors <<<<<<<<<<<<<<<<<<<<
#define GREEN_TEXT_IN_RESULT   @"47b04a"
#define RED_TEXT_IN_RESULT     @"f7412d"
#define GRAY_TEXT_IN_RESULT    @"777777"

#define GRAY_TEXT_DISABLE    @"b4b4b4"

#define GREEN_IN_CHART      @"47b04a"
#define RED_IN_CHART        @"fa6655"
#define GRAY_IN_CHART       @"a3a3a3"




#pragma mark - >>>>>>>>>>>>>>>>>>>> Notification Name <<<<<<<<<<<<<<<<<<<<
//#define NOTI_PRACTICE_RETURN    @"PracticeReturn"
//#define NOTI_PRACTICE_START     @"PracticeStart"
#define NOTI_STOP_PRACTICE      @"TeacherStopPractice"
#define NOTI_STU_SHOW_RESULT    @"StudentShowResult"
#define NOTI_STU_SHOW_IMAGE_RESULT  @"StudentShowImageResult"

#define NOTI_STU_CELL_CLICKED   @"ClickStudentCell"
#define NOTI_SEND_STU_EVENT     @"SendStuEvent"
#define NOTI_RECV_STU_EVENT     @"RecvStuEvent"


#endif /* HelpHeader_h */
