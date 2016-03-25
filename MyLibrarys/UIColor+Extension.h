//
//  UIColor+Hex.h
//  MMUIKit
//
//  Created by joeykika on 15/9/17.
//  Copyright (c) 2015年 Po.Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ColorFromStr(colorStr) [UIColor colorWithHexString:colorStr]

@interface UIColor (Hex)

+ (UIColor *) colorWithHexString:(NSString *)color;
+ (UIColor *) colorWithHexString:(NSString *)color andAlpha:(float)alpha;

+ (UIColor *) colorWithHex:(long)hexColor;
+ (UIColor *) colorWithHex:(long)hexColor alpha:(float)opacity;

@end
