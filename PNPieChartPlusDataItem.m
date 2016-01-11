//
//  PNPieChartPlusDataItem.m
//  Quiz
//
//  Created by mythware on 11/18/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "PNPieChartPlusDataItem.h"
#import <UIKit/UIKit.h>

@implementation PNPieChartPlusDataItem

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color{
    PNPieChartPlusDataItem *item = [PNPieChartPlusDataItem new];
    item.value = value;
    item.color  = color;
    return item;
}

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color
                      description:(NSString *)description {
    PNPieChartPlusDataItem *item = [PNPieChartPlusDataItem dataItemWithValue:value color:color];
    item.textDescription = description;
    return item;
}

- (void)setValue:(CGFloat)value{
    NSAssert(value >= 0, @"value should >= 0");
    if (value != _value){
        _value = value;
    }
}

@end
