//
//  PNPieChartPlusDataItem.h
//  Quiz
//
//  Created by mythware on 11/18/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PNPieChartPlusDataItem : NSObject

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color;

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color
                      description:(NSString *)description;

@property (nonatomic) CGFloat  value;
@property (nonatomic) UIColor  *color;
@property (nonatomic) NSString *textDescription;

@end
