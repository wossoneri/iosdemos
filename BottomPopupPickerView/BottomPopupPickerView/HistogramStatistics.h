//
//  HistogramStatistics.h
//  BottomPopupPickerView
//
//  Created by mythware on 10/20/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Histogram.h"

@interface HistogramStatistics : UIView

- (void)setHorizentalMin:(int)min Max:(int)max interval:(int)interval andUnit:(NSString *)unit;
- (void)setVerticalMin:(int)min Max:(int)max interval:(int)interval andUnit:(NSString *)unit;
- (void)setTotalValues:(NSArray *)values;

@end
