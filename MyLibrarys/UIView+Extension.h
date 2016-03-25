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

/**
 绘制下划线  返回添加的layer
 @param color 绘制颜色
 @param width 绘制线宽
 @return 绘制的layer，方便remove
 
 */
- (CALayer *)setUnderLine:(UIColor *)color width:(CGFloat)width;

- (void)addSubviews:(NSArray *)views;
- (void)bringSubviewsToFront:(NSArray *)views;

- (void)removeAllSubviews;

@end


@interface UIView (Masonry_EOS)

//- (void) distributeSpacingHorizontallyWith:(NSArray *)views;
//- (void) distributeSpacingVerticallyWith:(NSArray *)views;
///等间距水平排列views 设置每个view的宽高 每个view纵向居中 顶端与parent对齐
- (void) distributeSpacingHorizontallyWith:(NSArray *)views withMargin:(int)margin eachWidth:(float)width eachHeight:(float)height;
///等间距垂直排列views 设置每个view的宽高 每个view水平居中 顶端与parent对齐
- (void) distributeSpacingVerticallyWith:(NSArray *)views withMargin:(int)margin eachWidth:(float)width eachHeight:(float)height;
///等间距水平排列views 与parent view顶端对齐
- (void) distributeSpacingHorizontallyWith:(NSArray *)views withMargin:(int)margin;
///等间距垂直排列views 与parent view顶端对齐
- (void) distributeSpacingVerticallyWith:(NSArray *)views withMargin:(int)margin;

@end