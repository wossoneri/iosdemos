//
//  HelpFunctions.m
//  Quiz
//
//  Created by mythware on 11/11/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "HelpFunctions.h"

@interface HelpFunctions ()
{
    UIView *viewToCheckState;
}

@end

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

#pragma mark - Functions with UIImage

/// use PNG format
+ (NSString *)imageToNSString:(UIImage *)image {
    if (!image) {
        NSLog(@"the image converted to string is null");
        return @"";
    }
    NSData *data = UIImagePNGRepresentation(image);
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

/// use JPG format, quality between 0(min) to 1(max) , image compress as jpeg
+ (NSString *)imageToNSString:(UIImage *)image imageQuality:(float)quality {
    if (!image) {
        NSLog(@"the image converted to string is null");
        return @"";
    }
    
    if (quality > 1) {
        quality = 1;
    }
    
    if (quality < 0) {
        quality = 0;
    }
    
    NSData *data = UIImageJPEGRepresentation(image, quality);
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}


+ (UIImage *)stringToUIImage:(NSString *)string {
    if (string.length == 0) {
        NSLog(@"the string converted to image is null");
        return nil;
    }
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data ];
}

+ (UIImage *)stringToUIImage:(NSString *)string withImageScale:(float)scale {
    if (string.length == 0) {
        NSLog(@"the string converted to image is null");
        return nil;
    }
    if (scale == 0) {
        scale = [[UIScreen mainScreen] scale];
    }
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data scale:scale];
}

+ (UIImage *)createImageByView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0f);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];  //low efficient out of date
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    return image;
}

+ (UIImage *)combineViewsToOneImage:(NSArray *)views {
    UIGraphicsBeginImageContext(((UIView *)views[0]).bounds.size);
    for (UIView *view in views) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    }
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize originScale:(BOOL)origin {
    
    if (origin) {
        // we want to save imageScale
        CGFloat ratioW = image.size.width / newSize.width;
        CGFloat ratioH = image.size.height / newSize.height;
        
        CGFloat ratio = image.size.width / image.size.height;
        
        CGSize showSize = image.size;
        if (ratioW > 1 && ratioH > 1) { // 宽高都超过屏幕，需要根据两个值来判断缩放程度
            if (ratioW > ratioH) { //以宽进行缩放
                showSize.width = newSize.width;
                showSize.height = showSize.width / ratio;
            } else {
                showSize.height = newSize.height;
                showSize.width = showSize.height * ratio;
            }
        } else if (ratioW > 1) {
            showSize.width = showSize.width;
            showSize.height = showSize.width / ratio;
        } else if (ratioH > 1) {
            showSize.height = showSize.height;
            showSize.width = showSize.height * ratio;
        }
        
        //UIGraphicsBeginImageContext(newSize);
        // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
        // Pass 1.0 to force exact pixel size.
        UIGraphicsBeginImageContextWithOptions(showSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, showSize.width, showSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
//        UIGraphicsBeginImageContext(newSize);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }

}


+ (UIImage *)addBorderToImage:(UIImage *)image borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor {
    CGImageRef bgimage = [image CGImage];
    float width = CGImageGetWidth(bgimage);
    float height = CGImageGetHeight(bgimage);
    
    // Create a temporary texture data buffer
    void *data = malloc(width * height * 4);
    
    // Draw image to buffer
    CGContextRef ctx = CGBitmapContextCreate(data,
                                             width,
                                             height,
                                             8,
                                             width * 4,
                                             CGImageGetColorSpace(image.CGImage),
                                             kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(ctx, CGRectMake(0, 0, (CGFloat)width, (CGFloat)height), bgimage);
    
    //Set the stroke (pen) color
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    
    //Set the width of the pen mark
//    CGFloat borderWidth = (float)width * 0.05;
    CGContextSetLineWidth(ctx, borderWidth);
    
    //Start at 0,0 and draw a square
    CGContextMoveToPoint(ctx, 0.0, 0.0);
    CGContextAddLineToPoint(ctx, 0.0, height);
    CGContextAddLineToPoint(ctx, width, height);
    CGContextAddLineToPoint(ctx, width, 0.0);
    CGContextAddLineToPoint(ctx, 0.0, 0.0);
    
    //Draw it
    CGContextStrokePath(ctx);
    
    // write it to a new image
    CGImageRef cgimage = CGBitmapContextCreateImage(ctx);
    UIImage *newImage = [UIImage imageWithCGImage:cgimage];
    CFRelease(cgimage);
    CGContextRelease(ctx);
    
    // auto-released
    return newImage;
}

+ (UIImage *)imageBorderedWithImage:(UIImage *)image Color:(UIColor *)color BorderWidth:(CGFloat)width {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawAtPoint:CGPointZero];
    [color setStroke];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    path.lineWidth = width;
    [path stroke];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)combineImages:(NSArray *)images {
    CGSize drawSize = ((UIImage *)[images firstObject]).size;
    
    UIGraphicsBeginImageContext(drawSize);
    for (UIImage *img in images) {
        [img drawInRect:CGRectMake(0, 0, drawSize.width, drawSize.height)];
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
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

#pragma mark - current time
+ (void)logCurrentTimeMS {
    NSString* date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //[formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@", [[NSString alloc] initWithFormat:@"%@", date]);
}

+ (long long)getCurrentTimeLong {
    return (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
}

/// resize image to fit in show area without changing image scale
+ (CGSize)resizeImageViewFromImageSize:(CGSize)imageSize toFitShowSize:(CGSize)showSize {
    CGFloat ratioW = imageSize.width / showSize.width;
    CGFloat ratioH = imageSize.height / showSize.height;
    
    CGFloat ratio = imageSize.width / imageSize.height;
    
    if (ratioW > 1 && ratioH > 1) { // 宽高都超过屏幕，需要根据两个值来判断缩放程度
        
        if (ratioW > ratioH) { //以宽进行缩放
            imageSize.width = showSize.width;
            imageSize.height = imageSize.width / ratio;
        } else {
            imageSize.height = showSize.height;
            imageSize.width = imageSize.height * ratio;
        }
        
    } else if (ratioW > 1) {
        
        imageSize.width = showSize.width;
        imageSize.height = imageSize.width / ratio;
        
    } else if (ratioH > 1) {
        
        imageSize.height = showSize.height;
        imageSize.width = imageSize.height * ratio;
        
    } else { //宽高都小于屏幕，可以处理为拉伸全屏
        
        if (ratioW > ratioH) { //宽铺满
            
            if (showSize.width / imageSize.width <= 2) {   //最大放2倍
                imageSize.width = showSize.width;
                imageSize.height = imageSize.width / ratio;
            }

        } else {
            
            if (showSize.height / imageSize.height <= 2) {
                imageSize.height = showSize.height;
                imageSize.width = imageSize.height * ratio;
            }

        }
        
    }

    return imageSize;
}

#pragma mark - Check View Until Showing
- (void)checkTheView:(UIView *)view runAtFirstShow:(checkViewShowStateBlock)checkViewState {

    viewToCheckState = view;
    _viewStateBlock = checkViewState;
    
    _helpThread = [[NSThread alloc] initWithTarget:self selector:@selector(checkIfViewIsShowing) object:nil];
    [_helpThread start];
    
    
}

- (void)checkIfViewIsShowing {
    while (1) {
        if (viewToCheckState.window != nil) {
            break;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _viewStateBlock();
    });
    
    [_helpThread cancel];
    _helpThread = nil;
}

@end
