//
//  HistogramStatistics.h
//  BottomPopupPickerView
//
//  Created by mythware on 10/20/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#define DEFAULT_V_COUNT  5
#define H_COUNT_MAX      6
//阈值 3 分钟， 超过 3 分钟 单位以minute计
#define TIME_THRESHOLD_SECOND       180

#import <UIKit/UIKit.h>

@protocol HistogramTimeDelegate <NSObject>

@optional
- (void)userClickedOnTimeBar:(NSInteger)barIndex;
- (void)didUnselectBar;
@end


@interface HistogramTimeDistribution : UIView

@property (nonatomic) BOOL shouldHighlightSectorOnTouch;
@property (nonatomic, weak) id<HistogramTimeDelegate> delegate;


- (void)setHorizentalMin:(int)min Max:(int)max interval:(int)interval andUnit:(NSString *)unit;


//- (void)setVerticalMin:(int)min Max:(int)max interval:(int)interval andUnit:(NSString *)unit;
- (void)setVerticalMin:(int)min Max:(int)max andUnit:(NSString *)unit;

- (void)setTotalValues:(NSArray *)values;

@end
