//
//  StuAnsShowStuList.h
//  Quiz
//
//  Created by mythware on 11/19/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelQuestionItem.h"
#define SEARCH_LIST_WIDTH   320.0f

@protocol StuAnsShowStuListDelegate <NSObject>

- (void)getSelectedStudentAccountID:(NSString *)stuID;

@end

@interface StuAnsShowStuList : UIView

@property (nonatomic, weak) id<StuAnsShowStuListDelegate> delegate;

- (instancetype)initWithStudentList:(NSArray *)stuList
                       StudentEvent:(NSArray *)stuEvent
                       QuestionType:(QUESTION_TYPE)type;

@end
