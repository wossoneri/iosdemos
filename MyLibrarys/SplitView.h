//
//  SplitView.h
//  LibAnswerSheet
//
//  Created by mythware on 9/1/15.
//  Copyright © 2015 mythware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SplitViewDelegate <NSObject>

@optional

- (void)onViewHide:(BOOL)bLeft;

@end

@interface SplitView : UIView
{
    UIView *_leftView;
    UIView *_rightView;
    UIView *_splitLine;
    
    float _splitPosition;
    float _splitWidth;
    //    CGPoint _touchStart;
    NSMutableArray *mConstraints;
    
    BOOL _bRightViewOnly;
}

- (void)addRightView:(UIView*)rightView;
- (void)addTwoView:(UIView*)leftView rightView:(UIView*)rightView;

@property (nonatomic, weak) id <SplitViewDelegate> delegate;

@end
