//
//  UIView+Extension.m
//  MMUIKit
//
//  Created by joeykika on 15/9/18.
//  Copyright (c) 2015年 Po.Chen. All rights reserved.
//

#import "UIView+Extension.h"
#import "UIButton+Extension.h"
#import <objc/runtime.h>

#import "Masonry/Masonry.h"

@interface UIView(Extension_Private)
- (CGSize)replaceIntrinsicContentSize;
@end


@implementation UIView (Extension)

- (CGSize)replaceIntrinsicContentSize {
    if([self isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton *)self;
        if(Direction_Horizontal == [button contentDirection]){
            return [self replaceIntrinsicContentSize];
        }
        else {
            UILabel * titleLabel = button.titleLabel;
            
            CGSize imageSize = button.currentImage.size;
            CGSize titleHitSize = [titleLabel textRectForBounds:CGRectMake(0, 0, CGFLOAT_MAX, CGFLOAT_MAX)
                                         limitedToNumberOfLines:0].size;
            
            CGSize hitSize = CGSizeMake(imageSize.width > titleHitSize.width ? imageSize.width : titleHitSize.width
                                        , imageSize.height + titleHitSize.height + 2);
            
            
            return hitSize;
        }
    }
    else {
        return [self replaceIntrinsicContentSize];
    }
}

+ (void)load {
    Method sizeOri_Method =  class_getInstanceMethod([UIView class], @selector(intrinsicContentSize));
    Method sizeMy_Method = class_getInstanceMethod([UIView class], @selector(replaceIntrinsicContentSize));
    method_exchangeImplementations(sizeOri_Method, sizeMy_Method);
}

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width {
    [self setBorderColor:color];
    [self setBorderWidth:width];
}

- (void)setBorderColor:(UIColor *)color {
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderColor:color.CGColor];
}

- (void)setBorderWidth:(CGFloat)width {
    [self.layer setBorderWidth:width];
}

- (void)setCornerRadius:(CGFloat)radius {
    [self.layer setCornerRadius:radius];
}

- (void)addSubviews:(NSArray *)views {
    for (UIView *view in views) {
        [self addSubview:view];
    }
}

- (CALayer *)setUnderLine:(UIColor *)color width:(CGFloat)width {
    CALayer *border = [CALayer layer];
    border.borderColor = color.CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - width - 4, self.frame.size.width, width);
    border.borderWidth = width;
    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;
    return border;
}

- (void)bringSubviewsToFront:(NSArray *)views {
    for (UIView *view in views) {
        [self bringSubviewToFront:view];
    }
}

- (void)removeAllSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end


@implementation UIView (Masonry_EOS)

//- (void) distributeSpacingHorizontallyWith:(NSArray*)views
//{
//    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
//    
//    for ( int i = 0 ; i < views.count+1 ; ++i )
//    {
//        UIView *v = [UIView new];
//        [spaces addObject:v];
//        [self addSubview:v];
//        
//        [v mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(v.mas_height);
//        }];
//    }
//    
//    UIView *v0 = spaces[0];
//    
//    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.centerY.equalTo(((UIView*)views[0]).mas_centerY);
//    }];
//    
//    UIView *lastSpace = v0;
//    for ( int i = 0 ; i < views.count; ++i )
//    {
//        UIView *obj = views[i];
//        UIView *space = spaces[i+1];
//        
//        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(lastSpace.mas_right);
//        }];
//        
//        [space mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(obj.mas_right);
//            make.centerY.equalTo(obj.mas_centerY);
//            make.width.equalTo(v0);
//        }];
//        
//        lastSpace = space;
//    }
//    
//    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right);
//    }];
//    
//}
//
//- (void) distributeSpacingVerticallyWith:(NSArray*)views
//{
//    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
//    
//    for ( int i = 0 ; i < views.count+1 ; ++i )
//    {
//        UIView *v = [UIView new];
//        [spaces addObject:v];
//        [self addSubview:v];
//        
//        [v mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(v.mas_height);
//        }];
//    }
//    
//    
//    UIView *v0 = spaces[0];
//    
//    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.centerX.equalTo(((UIView*)views[0]).mas_centerX);
//    }];
//    
//    UIView *lastSpace = v0;
//    for ( int i = 0 ; i < views.count; ++i )
//    {
//        UIView *obj = views[i];
//        UIView *space = spaces[i+1];
//        
//        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(lastSpace.mas_bottom);
//        }];
//        
//        [space mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(obj.mas_bottom);
//            make.centerX.equalTo(obj.mas_centerX);
//            make.height.equalTo(v0);
//        }];
//        
//        lastSpace = space;
//    }
//    
//    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom);
//    }];
//    
//}

- (void) distributeSpacingHorizontallyWith:(NSArray *)views withMargin:(int)margin eachWidth:(float)width eachHeight:(float)height {
    __block UIView *lastView;
    __block UIView *nextView;
    __block UIView *thisView;
    
    __block float viewWidth = width;
    __block float viewHeight = height;
    
    if (views.count == 1) {
        thisView = (UIView *)[views objectAtIndex:0];
        [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.right.equalTo(self);
            if (viewWidth > 0)
                make.width.mas_equalTo(viewWidth);
            if (viewHeight > 0)
                make.height.mas_equalTo(viewHeight);
        }];
        return;
    }
    
    for (int i = 0; i < views.count; i++) {
        thisView = (UIView *)[views objectAtIndex:i];
        if (i == 0) {
            nextView = (UIView *)[views objectAtIndex:i + 1];
            
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.top.bottom.equalTo(self);
                make.right.equalTo(nextView.mas_left).offset(-margin);
                if (viewWidth > 0)
                    make.width.mas_equalTo(viewWidth);
                if (viewHeight > 0)
                    make.height.mas_equalTo(viewHeight);
            }];
        } else if (i == views.count - 1) {
            lastView = (UIView *)[views objectAtIndex:i - 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(margin);
                make.top.bottom.equalTo(self);
                make.right.equalTo(self);
                if (viewWidth > 0)
                    make.width.mas_equalTo(viewWidth);
                if (viewHeight > 0)
                    make.height.mas_equalTo(viewHeight);
            }];
        } else {
            nextView = (UIView *)[views objectAtIndex:i + 1];
            lastView = (UIView *)[views objectAtIndex:i - 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(lastView.mas_right).offset(margin);
                make.right.equalTo(nextView.mas_left).offset(-margin);
                if (viewWidth > 0)
                    make.width.mas_equalTo(viewWidth);
                if (viewHeight > 0)
                    make.height.mas_equalTo(viewHeight);
            }];
        }
    }
}


- (void) distributeSpacingVerticallyWith:(NSArray *)views withMargin:(int)margin eachWidth:(float)width eachHeight:(float)height {
    UIView *lastView;
    UIView *nextView;
    UIView *thisView;
    
    if (views.count == 1) {
        thisView = (UIView *)[views objectAtIndex:0];
        [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.bottom.equalTo(self);
            if (width > 0)
                make.width.mas_equalTo(width);
            if (height > 0)
                make.height.mas_equalTo(height);
        }];
        return;
    }
    
    for (int i = 0; i < views.count; i++) {
        thisView = (UIView *)[views objectAtIndex:i];
        if (i == 0) {
            nextView = (UIView *)[views objectAtIndex:i + 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.left.right.equalTo(self);
                make.bottom.equalTo(nextView.mas_top).offset(-margin);
                if (width > 0)
                    make.width.mas_equalTo(width);
                if (height > 0)
                    make.height.mas_equalTo(height);
            }];
        } else if (i == views.count - 1) {
            lastView = (UIView *)[views objectAtIndex:i - 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(margin);
                make.left.right.equalTo(self);
                make.bottom.equalTo(self);
                if (width > 0)
                    make.width.mas_equalTo(width);
                if (height > 0)
                    make.height.mas_equalTo(height);
            }];
        } else {
            nextView = (UIView *)[views objectAtIndex:i + 1];
            lastView = (UIView *)[views objectAtIndex:i - 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(lastView.mas_bottom).offset(margin);
                make.bottom.equalTo(nextView.mas_top).offset(-margin);
                if (width > 0)
                    make.width.mas_equalTo(width);
                if (height > 0)
                    make.height.mas_equalTo(height);
            }];
        }
    }
}


- (void) distributeSpacingHorizontallyWith:(NSArray *)views withMargin:(int)margin {
    UIView *lastView;
    UIView *nextView;
    UIView *thisView;
    
    if (views.count == 1) {
        thisView = (UIView *)[views objectAtIndex:0];
        [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
//            make.centerX.equalTo(self);//会导致parent没有width
            make.left.right.equalTo(self);
        }];
        return;
    }
    
    for (int i = 0; i < views.count; i++) {
        thisView = (UIView *)[views objectAtIndex:i];
        if (i == 0) {
            nextView = (UIView *)[views objectAtIndex:i + 1];
            
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.top.bottom.equalTo(self);
                make.right.equalTo(nextView.mas_left).offset(-margin);
            }];
        } else if (i == views.count - 1) {
            lastView = (UIView *)[views objectAtIndex:i - 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(margin);
                make.top.bottom.equalTo(self);
                make.right.equalTo(self);
            }];
        } else {
            nextView = (UIView *)[views objectAtIndex:i + 1];
            lastView = (UIView *)[views objectAtIndex:i - 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(lastView.mas_right).offset(margin);
                make.right.equalTo(nextView.mas_left).offset(-margin);
            }];
        }
    }
}


- (void) distributeSpacingVerticallyWith:(NSArray *)views withMargin:(int)margin {
    UIView *lastView;
    UIView *nextView;
    UIView *thisView;
    
    if (views.count == 1) {
        thisView = (UIView *)[views objectAtIndex:0];
        [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.bottom.equalTo(self);
        }];
        return;
    }
    
    for (int i = 0; i < views.count; i++) {
        thisView = (UIView *)[views objectAtIndex:i];
        if (i == 0) {
            nextView = (UIView *)[views objectAtIndex:i + 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.left.right.equalTo(self);
                make.bottom.equalTo(nextView.mas_top).offset(-margin);
            }];
        } else if (i == views.count - 1) {
            lastView = (UIView *)[views objectAtIndex:i - 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(margin);
                make.left.right.equalTo(self);
                make.bottom.equalTo(self);
            }];
        } else {
            nextView = (UIView *)[views objectAtIndex:i + 1];
            lastView = (UIView *)[views objectAtIndex:i - 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(lastView.mas_bottom).offset(margin);
                make.bottom.equalTo(nextView.mas_top).offset(-margin);
            }];
        }
    }
}

@end