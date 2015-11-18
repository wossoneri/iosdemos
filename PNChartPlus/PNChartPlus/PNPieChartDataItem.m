//
//  PNPieChartDataItem.m
//  PNChartPlus
//
//  Created by 杜博文 on 15/11/18.
//  Copyright © 2015年 wossoneri. All rights reserved.
//

#import "PNPieChartDataItem.h"

@implementation PNPieChartDataItem

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color{
    PNPieChartDataItem *item = [PNPieChartDataItem new];
    item.value = value;
    item.color  = color;
    return item;
}

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color
                      description:(NSString *)description {
    PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:value color:color];
    item.textDescription = description;
    return item;
}

- (void)setValue:(CGFloat)value{
    NSAssert(value >= 0, @"value should >= 0");
    if (value != _value){
        _value = value;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
