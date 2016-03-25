//
//  UIImage+Extension.m
//  MMUIKit
//
//  Created by joeykika on 15/9/18.
//  Copyright (c) 2015年 Po.Chen. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)singleColorImage:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageNamed:(NSString *)name whitBundleName:(NSString *)bundleName {
    NSString * bundlePath = [NSString stringWithFormat:@"%@/%@.bundle"
                                , [NSBundle mainBundle].resourcePath
                                , bundleName];
    NSBundle * bundle = [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

@end
