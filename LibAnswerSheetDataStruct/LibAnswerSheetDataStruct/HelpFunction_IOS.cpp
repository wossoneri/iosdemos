//
//  HelpFunction_IOS.m
//  LibAnswerSheet
//
//  Created by huanghao on 15-3-6.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#include "HelpFunction.h"

//#import "CompletionQuestion.h"
#import "HelpFunction_IOS.h"

@implementation HelpFunction_IOS

//+ (int)getMaxBlankCount {
//    return MAX_BLANK_COUNT;
//}


+ (NSString*)generateGuid
{
    GUID guid = CHelpFunction::generateGuid();
    
    
    std::string strGuid;
    GuidToStdString(&guid, strGuid);
    
    NSString *nsString = [NSString stringWithCString:strGuid.c_str() encoding:[NSString defaultCStringEncoding]];
    
    return nsString;
}

+ (NSString*)getAnswerSheetTmpPath {
    // 获取应用沙盒根路径
    NSString *tmpDir = NSTemporaryDirectory();
    NSLog(@"app_tmp_home: %@", tmpDir);
    
    return tmpDir;
}

+ (NSString*)generateTmpImagePath {
    
    NSString *tmpDir = [HelpFunction_IOS getAnswerSheetTmpPath];
    NSString* aGuid = [HelpFunction_IOS generateGuid];

    NSString* strImagePath = [NSString stringWithFormat:@"%@%@.png", tmpDir, aGuid];
    
    return strImagePath;
}

+ (NSString*)generateAstpSavePath:(NSString*)nsName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    //
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    
    NSString* dateTime = [formatter stringFromDate:[NSDate date]];
    
    NSString* strFilePath = [NSString stringWithFormat:@"%@/%@_%@.astp", docDir, nsName, dateTime];
    
    return strFilePath;
}

//+ (BOOL)saveImage:(UIImage*)image toFileAtPath:(NSString*)aPath
//{
//    if( (image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]) ) {
//        return FALSE;
//    }
//    
//    @try {
//        NSData *imageData = nil;
//        
//        NSString *ext = [aPath pathExtension];
//        
//        if( [ext isEqualToString:@"png"] ) {
//            imageData = UIImagePNGRepresentation(image);
//        } else {
//            // the rest, we write to jpeg
//            // 0. best, 1. lost. about compress.
//            
//            imageData = UIImageJPEGRepresentation(image, 0);
//        }
//        
//        if( (imageData == nil) || ([imageData length] <= 0) ) {
//            return FALSE;
//        }
//        
//        [imageData writeToFile:aPath atomically:TRUE];
//        
//        return TRUE;
//    } @catch (NSException *e) {
//        NSLog(@"create thumbnail exception.");
//    }
//    
//    return FALSE;
//}

//+ (CGRect)offsetView:(UIView*)view toKeyboard:(CGFloat)fKBHeight {
//    CGRect rcOldFrame = view.frame;
//    
//    //
//    CGRect rcScreen = [DimensionUtils screenRect:true];
//    
//    CGRect rcFrame = view.frame;
//    CGRect rcSupFrame = view.superview.frame;
//    
//    CGRect rcFrame2Screen = rcFrame;
//    rcFrame2Screen.origin.x += rcSupFrame.origin.x;
//    rcFrame2Screen.origin.y += rcSupFrame.origin.y;
//    
//    CGFloat fOffset = (rcScreen.size.height - fKBHeight) - rcFrame2Screen.size.height;
//    
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    CGRect rcFrameMyself = rcFrame2Screen;
//    rcFrameMyself.origin.y = fOffset - 20.0f;
//    
//    view.frame = rcFrameMyself;
//    
//    [UIView commitAnimations];
//    
//    return rcOldFrame;
//}
//
//+ (void)offsetView:(UIView*)view toOrigin:(CGRect)rcFrame {
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    view.frame = rcFrame;
//    
//    [UIView commitAnimations];
//}
//
//+ (void)scrollTableToFoot:(UITableView*) tableView withAnimated:(BOOL)animated {
//    NSInteger s = [tableView numberOfSections];
//    if( s < 1 ) {
//        return;
//    }
//    
//    NSInteger r = [tableView numberOfRowsInSection:s-1];
//    if( r < 1 ) {
//        return;
//    }
//    
//    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
//    
//    [tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
//}

@end
