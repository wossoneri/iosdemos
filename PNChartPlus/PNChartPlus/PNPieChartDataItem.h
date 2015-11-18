//
//  PNPieChartDataItem.h
//  PNChartPlus
//
//  Created by 杜博文 on 15/11/18.
//  Copyright © 2015年 wossoneri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PNPieChartDataItem : NSObject

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color;

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color
                      description:(NSString *)description;

@property (nonatomic) CGFloat   value;
@property (nonatomic) UIColor  *color;
@property (nonatomic) NSString *textDescription;

@end
