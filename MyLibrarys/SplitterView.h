//
//  SplitterView.h
//  Quiz
//
//  Created by mythware on 11/4/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpHeader.h"

@protocol SplitViewDelegate <NSObject>

@optional
- (void)onViewHide:(BOOL)bLeft;
- (void)onRightViewChange:(CGFloat)scale;
- (void)onTouchLeftView;
- (void)onTouchRightView;

@end


@interface SplitterView : UIView



- (void)addRightView:(UIView*)rightView;
- (void)addTwoView:(UIView*)leftView rightView:(UIView*)rightView;

- (void)createFrameByLeftWidth:(float)width;
- (void)createFrameByRightWidth:(float)width;

@property (nonatomic, weak) id <SplitViewDelegate> delegate;

@property BOOL dragable;




@end
