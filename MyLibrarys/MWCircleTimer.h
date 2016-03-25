//
//  MWCircleTimer.h
//  MWUIKit
//
//  Created by mythware on 10/28/15.
//  Copyright © 2015 Po.Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleTimerDelegate

- (void)CircleTimerEnd;

@end


@interface MWCircleTimer : UIView

///time interval,second
@property (nonatomic) int interval;
///intervalCount per round
@property (nonatomic) int intervalCount;
///set YES to scroll the ball
@property (nonatomic) bool edit;
@property (nonatomic, assign) id<CircleTimerDelegate> delegate;

- (void)startTimer;
- (void)stopTimer;
- (void)pauseTimer;

- (void)setTotalSecondTime:(CGFloat)time;
- (void)setTotalMinuteTime:(CGFloat)time;

- (int)getLeftTime;

@end
