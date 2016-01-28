//
//  HelpFunctions.h
//  Quiz
//
//  Created by mythware on 11/11/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HelpFunctions : NSObject

///input 90 seconds output 01:30 str
+ (NSString *)formatTimeWithSecond:(CGFloat)secondTime;

+ (NSString *)imageToNSString:(UIImage *)image;
+ (NSString *)imageToNSString:(UIImage *)image imageQuality:(float)quality;

+ (UIImage *)stringToUIImage:(NSString *)string;
+ (UIImage *)stringToUIImage:(NSString *)string withImageScale:(float)scale;

+ (NSDictionary *)getQuizBundleRootDictionary;
+ (NSArray *)getChoiceStyleArrays;
+ (NSArray *)getTrueFalseStyleArrays;

+ (void)setUIViewSize:(UIView *)view byWidth:(CGFloat)width andHeight:(CGFloat)height;

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

+ (double)distanceFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB;

+ (UIImage *)createImageByView:(UIView *)view;

@end
