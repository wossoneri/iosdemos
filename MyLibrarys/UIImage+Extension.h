//
//  UIImage+Extension.h
//  MMUIKit
//
//  Created by joeykika on 15/9/18.
//  Copyright (c) 2015年 Po.Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)singleColorImage:(UIColor *)color;
+ (UIImage *)imageNamed:(NSString *)name whitBundleName:(NSString *)bundleName;

@end
