//
//  CircleTimerView.m
//  CircleTimerControl
//
//  Created by mythware on 10/26/15.
//  Copyright © 2015 magewell. All rights reserved.
//

//#define RADIUS 200
#define POINT_RADIUS 10
#define CIRCLE_WIDTH 4
#define PROGRESS_WIDTH 4
//#define TEXT_SIZE 140
#define TIMER_INTERVAL 0.05
#define OFFSET  20

#import "CircleTimerView.h"
#import "TimeHelper.h"


@interface MarkBallView : UIView

//@property (nonatomic, assign) CGPoint ballCenter;

@end


@interface CircleTimerView ()
{
    CGFloat startAngle;
    CGFloat endAngle;
    int     totalTime;
    
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
    
}

@end

@implementation CircleTimerView

@synthesize delegate;

- (id)init {
    if (self = [super init]) {
        [self initData];
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

- (void)initData {
    // 圆周为 2 * pi * R, 默认起始点于正右方向为 0 度， 改为正上为起始点
    startAngle = -0.5 * M_PI;
    endAngle = startAngle;
    
    totalTime = 0;
    
    radius = (MIN(self.bounds.size.width, self.bounds.size.height) - OFFSET * 2) / 2;
    fontSize = radius / 2;
    
    textFont = [UIFont fontWithName: @"Helvetica Neue" size: fontSize];
    textColor = [UIColor lightGrayColor];
    textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
    
    
//    [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
    
    isTimerRunning = NO;
//    self.edit = YES;
    
    relativeCenter = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2);
    startPoint = CGPointMake(relativeCenter.x, relativeCenter.y - radius);

}

- (void)initView {
    self.backgroundColor = [UIColor darkGrayColor];

    
    markBall = [[MarkBallView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - POINT_RADIUS, OFFSET - POINT_RADIUS, POINT_RADIUS * 2, POINT_RADIUS * 2)];
    [self addSubview:markBall];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [markBall addGestureRecognizer:panGesture];
    
}

- (void)handlePan : (UIPanGestureRecognizer *)recognizer {
    
    if (self.edit) {
        CGPoint translation = [recognizer translationInView:self];
        
        //当前view对于markBallView的中点  self.center是当前view对于整个屏幕的中点
        //    CGPoint relativeCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        
        CGFloat xOffset = recognizer.view.center.x + translation.x - relativeCenter.x;
        CGFloat yOffset = recognizer.view.center.y + translation.y - relativeCenter.y;
        double length = sqrt(pow(xOffset , 2) + pow(yOffset , 2));
        double ratio = radius / length;
        CGFloat x = xOffset * ratio + relativeCenter.x;
        CGFloat y = yOffset * ratio + relativeCenter.y;
        
        
        //    startPoint = CGPointMake(relativeCenter.x, relativeCenter.y - radius);
        endPoint = CGPointMake(x, y);
        
        
        CGFloat distance = sqrt(pow(startPoint.x - endPoint.x , 2) + pow(startPoint.y - endPoint.y , 2));
        CGFloat angle = acos(1 - pow(distance, 2) / 2 / pow(radius, 2));
        CGFloat xx = 2 * M_PI / self.intervalCount;
        if (angle >= xx) {
            startPoint = endPoint;
            leftTime += self.interval;
            [self setNeedsDisplay];
        }
        
        recognizer.view.center = endPoint;
        
        
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}


- (void)drawRect:(CGRect)rect {
    
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
        
        CGPoint pos = [self getCurrentPointAtAngle:endAngle inRect:rect];
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

- (CGPoint)getCurrentPointAtAngle:(CGFloat)angle inRect:(CGRect)rect {
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

- (NSString *)formatTimeWithSecond:(CGFloat)left_time {
    //    left_time % 60
    
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
    [[UIColor redColor] set];
    [dot fill];
}

@end
