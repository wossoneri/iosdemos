//
//  UIButton+Extension.h
//  MMUIKit
//
//  Created by joeykika on 15/9/18.
//  Copyright (c) 2015年 Po.Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Direction)
{
    Direction_Horizontal = 0,
    Direction_Vertical,
};


@interface UIButton (Extension)

+ (void)load;

- (void)setContentDirection:(Direction)direction;
- (NSInteger)contentDirection;

@end


@interface UIButton (AddImageTitleOffset)

- (void)centerImageAndTitleWithSpacing:(CGFloat)spacing;    //增加图片和文字的间距

@end