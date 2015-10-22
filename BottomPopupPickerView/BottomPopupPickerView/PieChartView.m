//
//  PieChartView.m
//  BottomPopupPickerView
//
//  Created by mythware on 10/20/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#define TEXT_SIZE 18
#define RADIUS  200

#import "PieChartView.h"

@implementation PieChartView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}


- (void)initData {
    
    
    textFont = [UIFont fontWithName: @"Helvetica Neue" size: TEXT_SIZE];
    textColor = [UIColor blackColor];
    textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setResults:(NSArray *)result {
    results = result;
    
    count = 0;
    for (int index = 0; index < result.count; index++) {
        count += [[result objectAtIndex:index] integerValue];
    }
}

- (void)setColors:(NSArray *)color {
    colors = color;
}


- (void)drawRect:(CGRect)rect {
    
    
    CGFloat startAngle = 0;
    CGFloat endAngle = 0;
    
    for (int index = 0; index < results.count; index++) {
        startAngle = endAngle;
        CGFloat rate = [[results objectAtIndex:index] integerValue] * 1.0 / count;
        endAngle = rate * 2 * M_PI + startAngle;
        UIBezierPath *circle = [UIBezierPath bezierPath];
        CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
        [circle addArcWithCenter:center
                          radius:RADIUS
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];
        [circle addLineToPoint:center];
        
        UIColor *fillColor;
        if (colors.count > index) {
            fillColor = [colors objectAtIndex:index];
        } else {
            fillColor = [UIColor colorWithRed:(index * 100) % 255  / 255.0f
                                        green:(index * 100 + 50) % 255 / 255.0f
                                         blue:(index * 100 + 100) % 255 / 255.0f
                                        alpha:1.0f];
        }
  
        [fillColor set];

        [circle fill];
        [circle closePath];
        
        NSString *text = [NSString stringWithFormat:@"%2.2f%%", rate * 100];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
        
        CGFloat angle = rate * 2 * M_PI / 2.0 + startAngle;
        CGPoint textCenter = CGPointMake(center.x + RADIUS / 2.0 * cos(angle), center.y + RADIUS / 2.0 * sin(angle));
        
        CGRect textRct = CGRectMake(textCenter.x - textSize.width / 2.0,
                                    textCenter.y - textSize.height / 2.0,
                                    textSize.width, textSize.height);
        [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];
    }
}


@end
