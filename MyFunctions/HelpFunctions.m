//
//  HelpFunctions.m
//  Quiz
//
//  Created by mythware on 11/11/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "HelpFunctions.h"

@implementation HelpFunctions

+ (NSString *)formatTimeWithSecond:(CGFloat)secondTime {
    //    left_time % 60
    
    NSString *str_sec;
    int sec = (int)ceil(secondTime) % 60; //ceil 向上取整
    if (sec < 10) {
        str_sec = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%d", sec]];
    } else {
        str_sec = [NSString stringWithFormat:@"%d", sec];
    }
    
    NSString *str_min;
    int min = (int)ceil(secondTime) / 60;
    if (min < 10) {
        str_min = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%d", min]];
    } else {
        str_min = [NSString stringWithFormat:@"%d", min];
    }
    
    NSString *str = [str_min stringByAppendingString:@":"];
    str = [str stringByAppendingString:str_sec];
    return str;

}


+ (NSString *)imageToNSString:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    //    NSLog(@"image data %@", data);
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

+ (UIImage *)stringToUIImage:(NSString *)string {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [UIImage imageWithData:data];
}



+ (NSDictionary *)getQuizBundleRootDictionary {
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"Quiz.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString *path = [bundle pathForResource:@"questions" ofType:@"plist"];
    return [[NSDictionary alloc] initWithContentsOfFile:path];

}

+ (NSArray *)getChoiceStyleArrays {
    NSDictionary *rootDictionary = [HelpFunctions getQuizBundleRootDictionary];
    return [rootDictionary objectForKey:@"choiceStyles"];
}

+ (NSArray *)getTrueFalseStyleArrays {

    NSDictionary *rootDictionary = [HelpFunctions getQuizBundleRootDictionary];
    return [rootDictionary objectForKey:@"trueFalseStyles"];
}


+ (void)setUIViewSize:(UIView *)view byWidth:(CGFloat)width andHeight:(CGFloat)height {
    CGRect rct = view.frame;
    rct.size.width = width;
    rct.size.height = height;
    [view setFrame:rct];
}

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}


+ (double)distanceFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB {
    return sqrt(pow(pointA.x - pointB.x, 2) + pow(pointA.y - pointB.y, 2));
}

+ (UIImage *)createImageByView:(UIView *)view {
    [view layoutIfNeeded];
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    return image;
}


@end
