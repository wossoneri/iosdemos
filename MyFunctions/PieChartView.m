//
//  PieChartView.m
//  BottomPopupPickerView
//
//  Created by mythware on 10/20/15.
//  Copyright © 2015 magewell. All rights reserved.
//

//#define TEXT_SIZE 15
//#define RADIUS  200

#define START_ANGLE -M_PI_2 //12点方向开始

#import "PieChartView.h"
#import "Chart.h"



@implementation PieChartItem

+ (instancetype)initItemWithValue:(CGFloat)value color:(UIColor *)color textColor:(UIColor *)textColor title:(NSString *)title {
    PieChartItem *item = [PieChartItem new];
    item.value = value;
    item.color = color;
    item.textColor = color;
    item.title = title;
    
    return item;
}

@end


@interface PieChartView ()
{
    UIFont *textFont;
    NSMutableParagraphStyle *textStyle;
}

@property (nonatomic, strong) NSArray *pieChartItems;
@property (nonatomic, strong) NSArray *endPercentages;
@property (nonatomic) CGFloat radius;
@property (strong, nonatomic) CAShapeLayer *sectorHighlight;

- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index;
- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index;
- (CGFloat)ratioForItemAtIndex:(NSUInteger)index;

@end


@implementation PieChartView

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [super init]) {
        _pieChartItems = [NSArray arrayWithArray:items];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initData];

    }
    return self;
}


- (void)initData {
    _radius = CGRectGetHeight(self.bounds) / 2 - 30;
    _shouldHighlightSectorOnTouch = YES;
    
    textFont = [UIFont fontWithName: @"Helvetica Neue" size: TEXT_SIZE];
//    textColor = [UIColor blackColor];
    textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
}


- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index {
    if(index == 0){
        return 0;
    }
    
    return [_endPercentages[index - 1] floatValue];
}

- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index {
    return [_endPercentages[index] floatValue];
}

- (CGFloat)ratioForItemAtIndex:(NSUInteger)index {
    return [self endPercentageForItemAtIndex:index] - [self startPercentageForItemAtIndex:index];
}


#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self];
        [self didTouchAt:touchLocation];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(didUnselectPieItem)]) {
        [self.delegate didUnselectPieItem];
    }
    [self.sectorHighlight removeFromSuperlayer];
}


- (CGFloat)findPercentageOfAngleInCircle:(CGPoint)center fromPoint:(CGPoint)reference {
    CGFloat angleOfLine = atanf((reference.y - center.y) / (reference.x - center.x));
    CGFloat percentage = (angleOfLine + M_PI / 2) / (2 * M_PI);
    return (reference.x - center.x) > 0 ? percentage : percentage + .5;
}


- (void)didTouchAt:(CGPoint)touchLocation {
    CGPoint circleCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    if ([HelpFunctions distanceFromPoint:touchLocation toPoint:circleCenter] > _radius)
        return;
    
    CGFloat percentage = [self findPercentageOfAngleInCircle:circleCenter fromPoint:touchLocation];

    int index = 0;
    while (percentage > [self endPercentageForItemAtIndex:index]) {
        index++;
    }
    
    if ([self.delegate respondsToSelector:@selector(userClickedOnPieIndexItem:)]) {
        [self.delegate userClickedOnPieIndexItem:index];
    }
    
    
    if (self.shouldHighlightSectorOnTouch) {
        UIColor *newColor = [UIColor colorWithRed:0x3f / 255.0f green:0x51 / 255.0f blue:0xb5 / 255.0f alpha:1.0f];
        
        CGFloat startPercentage = [self startPercentageForItemAtIndex:index];
        CGFloat endPercentage = [self endPercentageForItemAtIndex:index];
        
        self.sectorHighlight = [self newCircleBorderLayerWithRadius:_radius
                                                        borderWidth:1
                                                        borderColor:newColor
                                                    startPercentage:startPercentage
                                                      endPercentage:endPercentage];
        [self.layer addSublayer:self.sectorHighlight];
    }
}


//选中区域高亮
- (CAShapeLayer *)newCircleBorderLayerWithRadius:(CGFloat)radius
                                     borderWidth:(CGFloat)borderWidth
                                     borderColor:(UIColor *)borderColor
                                 startPercentage:(CGFloat)startPercentage
                                   endPercentage:(CGFloat)endPercentage {
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:M_PI * 2 * startPercentage + START_ANGLE
                                                      endAngle:M_PI * 2 * endPercentage + START_ANGLE//M_PI_2 * 3
                                                     clockwise:YES];
    if (endPercentage - startPercentage != 1) {
        [path addLineToPoint:center];
    }

    [path closePath];
    
    
    circle.fillColor   = [UIColor clearColor].CGColor;
    circle.strokeColor = borderColor.CGColor;
    //    circle.strokeStart = startPercentage;
    //    circle.strokeEnd   = endPercentage;
    circle.lineWidth   = borderWidth;
    circle.path        = path.CGPath;
    circle.shadowColor = [UIColor whiteColor].CGColor;
    circle.shadowOffset= CGSizeMake(0, 2);
    
    return circle;
}

#pragma mark - Draw
- (void)drawRect:(CGRect)rect {
    
//    NSLog(@"draw the radius is:%f", _radius);
    
    __block CGFloat currentTotal = 0;
    CGFloat total = [[self.pieChartItems valueForKeyPath:@"@sum.value"] floatValue];
    NSMutableArray *endPercentages = [NSMutableArray new];
    [_pieChartItems enumerateObjectsUsingBlock:^(PieChartItem *item, NSUInteger idx, BOOL *stop) {
        if (total == 0){
            [endPercentages addObject:@(1.0 / _pieChartItems.count * (idx + 1))];
        }else{
            currentTotal += item.value;
            [endPercentages addObject:@(currentTotal / total)];
        }
    }];
    self.endPercentages = [endPercentages copy];
    
    int index = 0;
    for (PieChartItem *item in _pieChartItems) {
        
        CGFloat startAngle = [self startPercentageForItemAtIndex:index] * 2 * M_PI + START_ANGLE; //12点方向为正
        CGFloat endAngle = [self endPercentageForItemAtIndex:index] * 2 * M_PI + START_ANGLE;
        
        UIBezierPath *circle = [UIBezierPath bezierPath];
        CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
        [circle addArcWithCenter:center
                          radius:_radius
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];
        [circle addLineToPoint:center];
        
        UIColor *fillColor = item.color;
  
        [fillColor set];

        [circle fill];
        [circle closePath];
        

        NSString *text = item.title;
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
        CGRect textRct = CGRectZero;
        
        
        CGFloat angle = [self ratioForItemAtIndex:index] * 2 * M_PI / 2.0 + startAngle;
        if (1.0 == [self ratioForItemAtIndex:index]) //一个整圆  让线指向右
            angle -= 0.75 * M_PI;
        
        CGPoint pointLineStart = CGPointMake(center.x + _radius / 6.0 * 5 * cos(angle), center.y + _radius / 6.0 * 5 * sin(angle));
        CGPoint pointLineMiddle = CGPointMake(center.x + (_radius + 10) * cos(angle), center.y + (_radius + 10) * sin(angle));

        CGPoint pointLineEnd;
        if (pointLineMiddle.x > center.x) {
            pointLineEnd = CGPointMake(pointLineMiddle.x + textSize.width, pointLineMiddle.y);
            
//            if (pointLineStart.y == pointLineMiddle.y ) {
//                pointLineMiddle.y -= 20;
//                pointLineEnd.y -= 20;
//            }

            textRct = CGRectMake(pointLineMiddle.x, pointLineMiddle.y - textSize.height - 2,
                                 textSize.width, textSize.height);
        } else {
            pointLineEnd = CGPointMake(pointLineMiddle.x - textSize.width, pointLineMiddle.y);
            
//            if (pointLineStart.y == pointLineMiddle.y) {
//                pointLineMiddle.y += 20;
//                pointLineEnd.y += 20;
//            }
            
            
            textRct = CGRectMake(pointLineEnd.x, pointLineMiddle.y - textSize.height - 2,
                                 textSize.width, textSize.height);
        }
        
        if ([self ratioForItemAtIndex:index] > 0) {
            
            UIBezierPath *line1 = [UIBezierPath bezierPath];
            [line1 moveToPoint:pointLineStart];
            [line1 addLineToPoint:pointLineMiddle];
            
            UIBezierPath *line2 = [UIBezierPath bezierPath];
            [line2 moveToPoint:pointLineMiddle];
            [line2 addLineToPoint:pointLineEnd];
            
            [[UIColor blackColor] set];
            [line1 stroke];
            [line1 closePath];
            [line2 stroke];
            [line2 closePath];
            
            
            [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:item.textColor, NSParagraphStyleAttributeName:textStyle}];
        }
        

        index++;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self refreshChart];
}


- (void)refreshChart {
    [self recompute];
    
    [self setNeedsDisplay];
}

- (void)recompute {
    _radius = CGRectGetHeight(self.bounds) / 2 - 30;
    
//    NSLog(@"refresh the radius is:%f", _radius);
}


@end
