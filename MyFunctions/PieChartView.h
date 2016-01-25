//
//  PieChartView.h
//  BottomPopupPickerView
//
//  Created by mythware on 10/20/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PieChartDelegate <NSObject>

@optional
- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex;
- (void)didUnselectPieItem;
@end

@interface PieChartItem : NSObject

@property (nonatomic) CGFloat value;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *title;

+ (instancetype)initItemWithValue:(CGFloat)value color:(UIColor *)color textColor:(UIColor *)textColor title:(NSString *)title;

@end




@interface PieChartView : UIView


@property (nonatomic) NSInteger sections;
@property (nonatomic) BOOL shouldHighlightSectorOnTouch;
@property (nonatomic, weak) id<PieChartDelegate> delegate;


- (instancetype)initWithItems:(NSArray *)items;

- (void)refreshChart;


@end
