//
//  MWCircleTimer.m
//  MWUIKit
//
//  Created by mythware on 10/28/15.
//  Copyright © 2015 Po.Chen. All rights reserved.
//

//#define RADIUS 200
#define POINT_RADIUS 15
#define CIRCLE_WIDTH 6
#define PROGRESS_WIDTH 6
//#define TEXT_SIZE 140
#define TIMER_INTERVAL 0.05
#define OFFSET  20



#import "MWCircleTimer.h"

#import "UIColor+Extension.h"

@interface MarkBallView : UIView

//@property (nonatomic, assign) CGPoint ballCenter;

@end

@interface MWCircleTimer ()
{
    CGFloat startAngle;
    CGFloat endAngle;
    CGFloat angleCount;
    NSInteger totalTime;
    
    UIFont *textFont;
    UIColor *textColor;
    NSMutableParagraphStyle *textStyle;
    
    NSTimer *m_timer;
    
    bool isTimerRunning;
    
    CGFloat radius;
    CGFloat fontSize;
    CGFloat leftTime;
    
    MarkBallView *markBall;
    
    CGPoint relativeCenter;
    CGPoint startPoint;
    CGPoint endPoint;
//    CGPoint lastPoint;
}

@end


@implementation MWCircleTimer

@synthesize delegate;

- (id)init {
    if (self = [super init]) {
        [self initData];
        self.backgroundColor = [UIColor clearColor];
        markBall = nil;
    }
    return self;
}

//- (id)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initData];
//        [self initView];
//    }
//    return self;
//}

- (void)initData {
    // 圆周为 2 * pi * R, 默认起始点于正右方向为 0 度， 改为正上为起始点
    startAngle = -0.5 * M_PI;
    endAngle = startAngle;
    angleCount = 0;
    
    totalTime = 0;
    radius = 0;
}

- (void)calculateData {
    
    if (radius == 0) { //未初始化过
        
        radius = (MIN(self.bounds.size.width, self.bounds.size.height) - OFFSET * 2) / 2;
        fontSize = radius / 2;
        
        textFont = [UIFont fontWithName: @"Helvetica Neue" size: fontSize];
        textColor = [UIColor lightGrayColor];
        textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentCenter;
        
        isTimerRunning = NO;
        
        relativeCenter = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2);
        startPoint = CGPointMake(relativeCenter.x, relativeCenter.y - radius);
    }
    
    if (markBall) {
        return;
    }
    markBall = [[MarkBallView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - POINT_RADIUS, OFFSET - POINT_RADIUS, POINT_RADIUS * 2, POINT_RADIUS * 2)];
    [self addSubview:markBall];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [markBall addGestureRecognizer:panGesture];


}

- (void)handlePan : (UIPanGestureRecognizer *)recognizer {

    
    CGPoint touchPoint = [recognizer locationInView:self];
    
    
//    NSLog(@"touch x: %f ", touchPoint.x);
//    NSLog(@"touch y: %f ", touchPoint.y);
//    double distanceFromTouchToCenter = [self distanceFromPoint:touchPoint toPoint:markBall.center];
//    NSLog(@"distance: %f", distanceFromTouchToCenter);
    

//    if (distanceFromTouchToCenter > POINT_RADIUS * 2) {
//        return;
//    }
    
    if (self.edit) {
        
//        CGPoint translation = [recognizer translationInView:self];
//        NSLog(@"translation x: %f ", translation.x);
//        NSLog(@"translation y: %f ", translation.y);
        //当前view对于markBallView的中点  self.center是当前view对于整个屏幕的中点
        //    CGPoint relativeCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        
        
//        NSLog(@"recognizer.view.center x: %f ", recognizer.view.center.x);
//        NSLog(@"recognizer.view.center y: %f ", recognizer.view.center.y);
        
//        CGFloat xOffset = recognizer.view.center.x + translation.x - relativeCenter.x;
//        CGFloat yOffset = recognizer.view.center.y + translation.y - relativeCenter.y;
        CGFloat xOffset = touchPoint.x - relativeCenter.x;
        CGFloat yOffset = touchPoint.y - relativeCenter.y;
        double length = sqrt(pow(xOffset , 2) + pow(yOffset , 2));
        double ratio = radius / length;
        CGFloat x = xOffset * ratio + relativeCenter.x;
        CGFloat y = yOffset * ratio + relativeCenter.y;
        
        
        //    startPoint = CGPointMake(relativeCenter.x, relativeCenter.y - radius);
        

        endPoint = CGPointMake(x, y);
//        lastPoint = [self getCenterPointOfPointA:startPoint PointB:endPoint];
//        
//        CGPoint a = startPoint;
//        CGPoint b = lastPoint;
//        CGPoint c = endPoint;
//        CGFloat dir = a.x * b.y - a.y * b.x + a.y * c.x - a.x * c.y + b.x * c.y - c.x * b.y;
        CGFloat k1,k2, dir; //计算斜率判断方向
        if (startPoint.x - relativeCenter.x == 0)
            k1 = MAXFLOAT;
        else
            k1 = (startPoint.y - relativeCenter.y) / (startPoint.x - relativeCenter.x);
        
        if (endPoint.x - relativeCenter.x == 0)
            k2 = MAXFLOAT;
        else
            k2 = (endPoint.y - relativeCenter.y) / (endPoint.x - relativeCenter.x);
        
        if (k1 == MAXFLOAT) {
            if (k2 > 0)
                dir = -1;
            else
                dir = 1;
        } else if (k2 == MAXFLOAT) {
            if (k1 > 0)
                dir = 1;
            else
                dir = -1;
        } else {
            if (k1 > k2)
                dir = -1;
            else
                dir = 1;
        }
        
        if (leftTime <= 0 && dir < 0) { //时间为0 且逆时针转动  不予理会
            return;
        }


        
        CGFloat distance = sqrt(pow(startPoint.x - endPoint.x , 2) + pow(startPoint.y - endPoint.y , 2));
        CGFloat angle = acos(1 - pow(distance, 2) / 2 / pow(radius, 2));
        CGFloat baseAngle = 2 * M_PI / _intervalCount;
        
        if (dir > 0)
            angleCount += angle;
        else
            angleCount -= angle;
//        NSLog(@"angleCount:%f, angle:%f, baseAngle:%f", angleCount, angle, baseAngle);
        
        if (fabs(angleCount) >= baseAngle) {
//            angleCount = 0；//会清除掉部分多出来的角度，产生误差
            
            if (dir > 0) {
                int count = fabs(angleCount) / baseAngle;
                leftTime += _interval * count;
                angleCount -= baseAngle * count;    //对多出来的一部分角度进行校正
            }
            if (dir < 0) {
                int count = fabs(angleCount) / baseAngle;
                leftTime -= _interval * count;
                angleCount += baseAngle * count;    //对多出来的一部分角度进行保留
                
                if (leftTime < 0) {
                    leftTime = 0;
                }
            }
            
            [self setNeedsDisplay];
        }
        
//        startPoint = lastPoint;
        startPoint = endPoint;
        recognizer.view.center = endPoint;
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

//- (CGPoint)getCenterPointOfPointA:(CGPoint)pointA PointB:(CGPoint)pointB {
//    CGPoint centerPoint = CGPointMake((pointA.x + pointB.x) / 2, (pointA.y + pointB.y) / 2);
//    CGFloat x, y, k;
//    k = (centerPoint.y - relativeCenter.y) / (centerPoint.x - relativeCenter.x); //斜率
//    
//    if (centerPoint.x - relativeCenter.x != 0) {
//        
//        x = sqrt(pow(radius, 2) / (1 + pow(k, 2)));
//        y = k * x;
//        if (centerPoint.x - relativeCenter.x < 0) {
//            x *= -1;
//        }
//    } else {
//        x = 0;
//        y = radius;
//        if (centerPoint.y - relativeCenter.y < 0) {
//            y *= -1;
//        }
//    }
//    
//    return CGPointMake(x + relativeCenter.x, y + relativeCenter.y);
//    
//}

- (double)distanceFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB {
    return sqrt(pow(pointA.x - pointB.x, 2) + pow(pointA.y - pointB.y, 2));
}

- (void)drawRect:(CGRect)rect {
    [self calculateData];
    
    //draw circle
    UIBezierPath *circle = [UIBezierPath bezierPath];
    [circle addArcWithCenter:relativeCenter//CGPointMake(rect.size.width / 2, rect.size.height / 2)
                      radius:radius
                  startAngle:0
                    endAngle:2 * M_PI
                   clockwise:YES];
    circle.lineWidth = CIRCLE_WIDTH;
    [[UIColor lightGrayColor] set];
    [circle stroke];
    [circle closePath];
    
    
    if (!self.edit) {
        
        if (totalTime == 0)
            endAngle = startAngle;
        else
            endAngle = (1 - leftTime / totalTime) * 2 * M_PI + startAngle;
        
        UIBezierPath *progress = [UIBezierPath bezierPath];
        [progress addArcWithCenter:relativeCenter//CGPointMake(rect.size.width / 2, rect.size.height / 2)
                            radius:radius
                        startAngle:startAngle
                          endAngle:endAngle
                         clockwise:YES];
        progress.lineWidth = PROGRESS_WIDTH;
        [[UIColor redColor] set];
        [progress stroke];
        [progress closePath];
        
        CGPoint pos = [self getCurrentPointAtAngle:endAngle];
        //    [self drawPointAt:pos];
        markBall.center = pos;
    }
    
    
    
    //draw text in  center
    NSString *textContent = [self formatTimeWithSecond:leftTime]; //[TimeHelper formatTimeWithSecond:leftTime];
    CGSize textSize = [textContent sizeWithAttributes:@{NSFontAttributeName:textFont}];
    CGRect textRect = CGRectMake(relativeCenter.x - textSize.width / 2,
                                 relativeCenter.y - textSize.height / 2,
                                 textSize.width , textSize.height);
    [textContent drawInRect:textRect withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];
    
}

- (CGPoint)getCurrentPointAtAngle:(CGFloat)angle {
    //画个图就知道怎么用角度算了
    CGFloat y = sin(angle) * radius;
    CGFloat x = cos(angle) * radius;
    
    CGPoint pos = relativeCenter;//CGPointMake(rect.size.width / 2, rect.size.height / 2);
    pos.x += x;
    pos.y += y;
    return pos;
}

//- (void)drawPointAt:(CGPoint)point {
//
//    UIBezierPath *dot = [UIBezierPath bezierPath];
//    [dot addArcWithCenter:CGPointMake(point.x, point.y)
//                   radius:POINT_RADIUS
//               startAngle:0
//                 endAngle:2 * M_PI
//                clockwise:YES];
//    dot.lineWidth = 1;
//    //    [[UIColor redColor] setFill];
//    [dot fill];
//
//}

- (void)setTotalSecondTime:(CGFloat)time {
    totalTime = time;
    leftTime = totalTime;
}

- (void)setTotalMinuteTime:(CGFloat)time {
    totalTime = time * 60;
    leftTime = totalTime;
}

- (void)startTimer {
    if (!isTimerRunning) {
        m_timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(setProgress) userInfo:nil repeats:YES];
        isTimerRunning = YES;
    }
}

- (void)pauseTimer {
    if (isTimerRunning) {
        [m_timer invalidate];
        m_timer = nil;
        isTimerRunning = NO;
    }
}

- (void)setProgress {
    if (leftTime > 0) {
        leftTime -= TIMER_INTERVAL;
        [self setNeedsDisplay];
    } else {
        [self pauseTimer];
        
        if (delegate) {
            [delegate CircleTimerEnd];
        }
    }
}

- (void)stopTimer {
    [self pauseTimer];
    
    startAngle = -0.5 * M_PI;
    endAngle = startAngle;
    leftTime = totalTime;
    [self setNeedsDisplay];
    
}

- (int)getLeftTime {
    return leftTime;
}

- (NSString *)formatTimeWithSecond:(CGFloat)left_time {
    //    left_time % 60
    
    if (left_time <= 0) {
        left_time = 0;
    }
    
    NSString *str_sec;
    int sec = (int)ceil(left_time) % 60; //ceil 向上取整
    if (sec < 10) {
        str_sec = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%d", sec]];
    } else {
        str_sec = [NSString stringWithFormat:@"%d", sec];
    }
    
    NSString *str_min;
    int min = (int)ceil(left_time) / 60;
    if (min < 10) {
        str_min = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%d", min]];
    } else {
        str_min = [NSString stringWithFormat:@"%d", min];
    }
    
    NSString *str = [str_min stringByAppendingString:@":"];
    str = [str stringByAppendingString:str_sec];
    return str;
}


@end


@implementation MarkBallView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    UIBezierPath *dot = [UIBezierPath bezierPath];
    [dot addArcWithCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                   radius:POINT_RADIUS
               startAngle:0
                 endAngle:2 * M_PI
                clockwise:YES];
    dot.lineWidth = 1;
    [[UIColor colorWithHexString:@"ff4081"] set];
    [dot fill];
}

@end