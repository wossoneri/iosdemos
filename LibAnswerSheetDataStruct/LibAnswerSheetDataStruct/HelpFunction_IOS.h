//
//  HelpFunction_IOS.h
//  LibAnswerSheet
//
//  Created by huanghao on 15-3-6.
//  Copyright (c) 2015年 com.mythware. All rights reserved.
//

#import <Foundation/Foundation.h>


// Wrapper HelpFunction.h

@interface HelpFunction_IOS : NSObject

//
//+ (int)getMaxBlankCount;


//
+ (std::string*)generateGuid;

+ (std::string*)getAnswerSheetTmpPath;



// Path reference
// /<user-name>/
//
+ (std::string*)generateTmpImagePath;
+ (std::string*)generateAstpSavePath:(std::string*)nsName;

//+ (BOOL)saveImage:(UIImage*)image toFileAtPath:(NSString*)aPath;

// UIView help function
//+ (CGRect)offsetView:(UIView*)view toKeyboard:(CGFloat)fKBHeight;
//+ (void)offsetView:(UIView*)view toOrigin:(CGRect)rcFrame;

// UITableView help function
//+ (void)scrollTableToFoot:(UITableView*) tableView withAnimated:(BOOL)animated;

@end
