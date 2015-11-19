//
//  CircleTimerView.h
//  CircleTimerControl
//
//  Created by mythware on 10/26/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleTimerDelegate

- (void)CircleTimerEnd;

@end


@interface CircleTimerView : UIView

//time interval,second
@property (nonatomic) int interval;
//intervalCount per round
@property (nonatomic) int intervalCount;
//set YES u can drag the ball
@property (nonatomic) bool edit;
@property (nonatomic, assign) id<CircleTimerDelegate> delegate;

- (void)startTimer;
- (void)stopTimer;
- (void)pauseTimer;

- (void)setTotalSecondTime:(CGFloat)time;
- (void)setTotalMinuteTime:(CGFloat)time;



@end
