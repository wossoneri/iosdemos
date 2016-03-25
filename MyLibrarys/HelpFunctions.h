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

#pragma mark - UIImage
+ (UIImage *)stringToUIImage:(NSString *)string;
+ (UIImage *)stringToUIImage:(NSString *)string withImageScale:(float)scale;
///把一个View生成图片
+ (UIImage *)createImageByView:(UIView *)view;
+ (UIImage *)combineViewsToOneImage:(NSArray *)views;

//+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize originScale:(BOOL)origin;
// 给图片加边框  后者效率要高一点
+ (UIImage *)addBorderToImage:(UIImage *)image borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor;
+ (UIImage *)imageBorderedWithImage:(UIImage *)image Color:(UIColor *)color BorderWidth:(CGFloat)width;
/**
 把所有图像按列表顺序覆盖在一张图上
 列表最前的在图像最下方
 */
+ (UIImage *)combineImages:(NSArray *)images;

+ (NSDictionary *)getQuizBundleRootDictionary;
+ (NSArray *)getChoiceStyleArrays;
+ (NSArray *)getTrueFalseStyleArrays;

+ (void)setUIViewSize:(UIView *)view byWidth:(CGFloat)width andHeight:(CGFloat)height;

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

+ (double)distanceFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB;

/// just show logs
+ (void)logCurrentTimeMS;
+ (long long)getCurrentTimeLong;

+ (CGSize)resizeImageViewFromImageSize:(CGSize)imageSize toFitShowSize:(CGSize)showSize;

/**
 由于使用自动布局，一些布局在界面show出来之前是没有宽高值的
 加上没有viewController，所以没法控制viewWillAppear的周期
 所以要解决比如：有些需要计算的地方比如画layer必须要view的frame大小 这类问题就比较棘手
 所以添加这个方法，把block当成viewWillAppear即可
 
 @param view 即将要show出来的view
 @param checkViewShowStateBlock 界面刚show出来需要做的操作
 */
- (void)checkTheView:(UIView *)view runAtFirstShow:(checkViewShowStateBlock)checkViewState;

@end
