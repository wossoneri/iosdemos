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

- (void)onScrollOffsetChange:(float)scrollOffset;
- (void)recalculateScrollViewSize;

@end

/** 在list里用该方法  增加滑动特性
//结束手指拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat y = scrollView.contentOffset.y;
    CGFloat center = - (RESULT_HEADER_TOP + RESULT_HEADER_BOTTOM) / 2;
    if (y > -RESULT_HEADER_BOTTOM && y < center) {
        [scrollView setContentOffset:CGPointMake(0, -RESULT_HEADER_BOTTOM) animated:YES];
    }
    if (y > center && y < -RESULT_HEADER_TOP) {
        [scrollView setContentOffset:CGPointMake(0, -RESULT_HEADER_TOP) animated:YES];
    }
}

//结束减速滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    CGFloat center = - (RESULT_HEADER_TOP + RESULT_HEADER_BOTTOM) / 2;
    if (y > -RESULT_HEADER_BOTTOM && y < center) {
        [scrollView setContentOffset:CGPointMake(0, -RESULT_HEADER_BOTTOM) animated:YES];
    }
    if (y > center && y < -RESULT_HEADER_TOP) {
        [scrollView setContentOffset:CGPointMake(0, -RESULT_HEADER_TOP) animated:YES];
    }
}

*/