//
//  PieChartView.m
//  BottomPopupPickerView
//
//  Created by mythware on 10/20/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#define TEXT_SIZE 16
//#define RADIUS  200

#import "PieChartView.h"




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
    _radius = (MIN(self.bounds.size.width, self.bounds.size.height) - 10 * 2) / 2;
    
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


- (void)drawRect:(CGRect)rect {
    
    NSLog(@"draw the radius is:%f", _radius);
    
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
        
        CGFloat startAngle = [self startPercentageForItemAtIndex:index] * 2 * M_PI;
        CGFloat endAngle = [self endPercentageForItemAtIndex:index] * 2 * M_PI;
        
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
        CGPoint pointLineStart = CGPointMake(center.x + _radius / 6.0 * 5 * cos(angle), center.y + _radius / 6.0 * 5 * sin(angle));
        CGPoint pointLineMiddle = CGPointMake(center.x + (_radius + 10) * cos(angle), center.y + (_radius + 10) * sin(angle));
        
        CGPoint pointLineEnd;
        if (pointLineMiddle.x > center.x) {
            pointLineEnd = CGPointMake(pointLineMiddle.x + textSize.width, pointLineMiddle.y);
            textRct = CGRectMake(pointLineMiddle.x, pointLineMiddle.y - textSize.height - 2,
                                 textSize.width, textSize.height);
        } else {
            pointLineEnd = CGPointMake(pointLineMiddle.x - textSize.width, pointLineMiddle.y);
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
    _radius = CGRectGetHeight(self.bounds) / 2 - 20;
    
    NSLog(@"refresh the radius is:%f", _radius);
}


@end
