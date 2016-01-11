//
//  PNPieChartPlus.h
//  Quiz
//
//  Created by mythware on 11/18/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNPieChartPlusDataItem.h"

@protocol PNPieChartPlusDelegate <NSObject>

@optional
- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex;
- (void)didUnselectPieItem;

@end


@interface PNPieChartPlus : UIView

- (id)initWithItems:(NSArray *)items;

@property (nonatomic, readonly) NSArray	*items;

/** Default is 1.0. */
@property (nonatomic) NSTimeInterval duration;

/** Hide percentage labels less than cutoff value */
@property (nonatomic, assign) CGFloat labelPercentageCutoff;

/** Default YES. */
@property (nonatomic) BOOL shouldHighlightSectorOnTouch;

@property (nonatomic) CGFloat circleRadius;

@property (nonatomic, weak) id<PNPieChartPlusDelegate> delegate;

/** Update chart items. Does not update chart itself. */
- (void)updateChartData:(NSArray *)data;

/** Multiple selection */
@property (nonatomic, assign) BOOL enableMultipleSelection;

- (void)strokeChart;

- (void)recompute;

@end
