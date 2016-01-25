//
//  HistogramDistribution.h
//  BottomPopupPickerView
//
//  Created by mythware on 10/20/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistogramOptionDelegate <NSObject>

@optional
- (void)userClickedOnOptionBar:(NSInteger)barIndex;
- (void)didUnselectBar;
@end

@interface HistogramOptionDistribution : UIView

@property (nonatomic) BOOL shouldHighlightSectorOnTouch;
@property (nonatomic, weak) id<HistogramOptionDelegate> delegate;

- (void)setHorizentalMin:(int)min Max:(int)max interval:(int)interval andUnit:(NSString *)unit;
- (void)setVerticalUnit:(NSString *)unit;
- (void)setTotalValues:(NSArray *)values options:(NSArray *)options andCorrectIndex:(int)index;

@end
