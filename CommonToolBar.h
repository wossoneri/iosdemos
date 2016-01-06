//
//  CommonTopBar.h
//  Quiz
//
//  Created by mythware on 11/5/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonToolBar : UIView

- (void)addLeftView:(UIView *)view andWidth:(float)width;
- (void)addCenterView:(UIView *)view andWidth:(float)width;
- (void)addRightView:(UIView *)view andWidth:(float)width;

- (void)addRightView:(UIView *)view andHeight:(float)height;

- (void)addLeftViewCenterY:(UIView *)view andWidth:(float)width;
- (void)addCenterViewCenterY:(UIView *)view andWidth:(float)width;
- (void)addRightViewCenterY:(UIView *)view andWidth:(float)width;


@end

