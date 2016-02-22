//
//  UIView+Extension.h
//  MMUIKit
//
//  Created by joeykika on 15/9/18.
//  Copyright (c) 2015年 Po.Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width;
- (void)setBorderColor:(UIColor *)color;
- (void)setBorderWidth:(CGFloat)width;
- (void)setCornerRadius:(CGFloat)radius;

- (void)addSubviews:(NSArray *)views;
- (void)removeAllSubviews;

@end


@interface UIView (Masonry_EOS)

//- (void) distributeSpacingHorizontallyWith:(NSArray *)views;
//- (void) distributeSpacingVerticallyWith:(NSArray *)views;

- (void) distributeSpacingHorizontallyWith:(NSArray *)views withMargin:(int)margin eachWidth:(float)width eachHeight:(float)height;
- (void) distributeSpacingVerticallyWith:(NSArray *)views withMargin:(int)margin eachWidth:(float)width eachHeight:(float)height;
///等间距排列views 与parent view顶端对齐
- (void) distributeSpacingHorizontallyWith:(NSArray *)views withMargin:(int)margin;
- (void) distributeSpacingVerticallyWith:(NSArray *)views withMargin:(int)margin;

@end