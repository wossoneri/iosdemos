//
//  UIButton+Extension.m
//  MMUIKit
//
//  Created by joeykika on 15/9/18.
//  Copyright (c) 2015年 Po.Chen. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

@interface UIButton(Extension_Private)

- (void)replaceLayoutSubviews;

@end

@implementation UIButton(Extension_Private)

- (void)replaceLayoutSubviews {
    if(Direction_Horizontal == [self contentDirection]) {
        [self replaceLayoutSubviews];
    }
    else {
        UIImageView * imageView = self.imageView;
        UILabel * titleLabel = self.titleLabel;
        UIView * contentView = [imageView superview];
        CGSize imageSize = self.currentImage.size;
        
        imageView.image = self.currentImage;
        
        CGSize buttonSize = contentView.frame.size;
        CGSize titleHitSize = [titleLabel textRectForBounds:CGRectMake(0, 0, buttonSize.width, buttonSize.height)
                                     limitedToNumberOfLines:0].size;
        
        [titleLabel setFrame:CGRectMake(0
                                        , buttonSize.height - titleHitSize.height
                                        , buttonSize.width
                                        , titleHitSize.height)];
        [imageView setFrame:CGRectMake((buttonSize.width - imageSize.width) / 2
                                       , 0
                                       , imageSize.width
                                       , imageSize.height)];
    }
}

@end



@implementation UIButton (Extension)
static char directionKey;

+ (void)load {
    Method ori_Method =  class_getInstanceMethod([UIButton class], @selector(layoutSubviews));
    Method my_Method = class_getInstanceMethod([UIButton class], @selector(replaceLayoutSubviews));
    method_exchangeImplementations(ori_Method, my_Method);
}

- (void)setContentDirection:(Direction)direction {
    if(direction == [self contentDirection]) {
        return;
    }
    
    objc_setAssociatedObject(self
                             , &directionKey
                             , [NSNumber numberWithInteger:direction]
                             , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (NSInteger)contentDirection {
    return [(NSNumber *)objc_getAssociatedObject(self, &directionKey) integerValue];
}

@end

@implementation UIButton (AddImageTitleOffset)

- (void)centerImageAndTitleWithSpacing:(CGFloat)spacing {
    CGFloat insetAmount = spacing / 2.0;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -insetAmount, 0, insetAmount);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, -insetAmount);
    self.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
}

@end


