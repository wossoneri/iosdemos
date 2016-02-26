//
//  HelpFunctions.h
//  Quiz
//
//  Created by mythware on 11/11/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^checkViewShowStateBlock)(void);

@interface HelpFunctions : NSObject

@property (nonatomic, strong) NSThread *helpThread;
@property (nonatomic, strong) checkViewShowStateBlock viewStateBlock;

///input 90 seconds output 01:30 str
+ (NSString *)formatTimeWithSecond:(CGFloat)secondTime;

// functions with image
+ (NSString *)imageToNSString:(UIImage *)image;
+ (NSString *)imageToNSString:(UIImage *)image imageQuality:(float)quality;

+ (UIImage *)stringToUIImage:(NSString *)string;
+ (UIImage *)stringToUIImage:(NSString *)string withImageScale:(float)scale;
///把一个View生成图片
+ (UIImage *)createImageByView:(UIView *)view;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;



+ (NSDictionary *)getQuizBundleRootDictionary;
+ (NSArray *)getChoiceStyleArrays;
+ (NSArray *)getTrueFalseStyleArrays;

+ (void)setUIViewSize:(UIView *)view byWidth:(CGFloat)width andHeight:(CGFloat)height;

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

+ (double)distanceFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB;



+ (CGSize)resizeImageViewFromImageSize:(CGSize)imageSize toFitShowSize:(CGSize)showSize;

- (void)checkTheView:(UIView *)view showState:(checkViewShowStateBlock)checkViewState;

@end
