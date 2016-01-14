//
//  PieChartView.h
//  BottomPopupPickerView
//
//  Created by mythware on 10/20/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartItem : NSObject

@property (nonatomic) CGFloat value;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *title;

+ (instancetype)initItemWithValue:(CGFloat)value color:(UIColor *)color textColor:(UIColor *)textColor title:(NSString *)title;

@end




@interface PieChartView : UIView


@property (nonatomic) NSInteger sections;

- (instancetype)initWithItems:(NSArray *)items;

- (void)refreshChart;

@end
