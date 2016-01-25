//
//  CommonScrollHeader.h
//  Quiz
//
//  Created by mythware on 12/3/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>


//typedef NS_ENUM(int, ANSWER_STATE) {
//    ANSWER_CORRECT = 0,
//    ANSWER_WRONG,
//    ANSWER_UNFINISHED
//};


@interface CommonScrollHeader : UIView


@property (nonatomic, weak) UIScrollView *headerScrollView;

- (void)setTopView:(UIView *)top height:(float)topHeight andBottom:(UIView *)bottom height:(float)bottomHeight;

- (NSArray *)createStringArrayWithPercentages:(NSArray *)percentage;
- (NSString *)createStringTimes:(NSArray *)timeArr andCount:(NSArray *)countArr;
- (NSString *)createStringOptions:(NSArray *)optionArr andCount:(NSArray *)countArr;

@end
