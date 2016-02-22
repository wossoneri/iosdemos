//
//  HistogramStatistics.m
//  BottomPopupPickerView
//
//  Created by mythware on 10/20/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#define RGB_R_MIN   15.0
#define RGB_G_MIN   197.0
#define RGB_B_MIN   198.0

#define RGB_R_MAX   2.0
#define RGB_G_MAX   125.0
#define RGB_B_MAX   126.0

#define STU_BASE_COUNT  5

//水平每格最小时间单位
#define H_INTERVAL_MIN  5
//水平每格单位增加值
#define H_INTERVAL_ADD  5




#import "HistogramTimeDistribution.h"
#import "Chart.h"

@interface HistogramTimeDistribution ()
{
    NSArray *array;
    
//    UIColor *lightColor;
//    UIColor *deepColor;
    UIColor *drawColor;
    
    UIFont *textFont;
    UIColor *textColor;
    NSMutableParagraphStyle *textStyle;
    
//    NSDictionary *hDic;
//    NSDictionary *vDic;
    
    int hValue[3];
    int vValue[3];
    NSString *hUnit;
    NSString *vUnit;
    
    NSMutableArray *arrayOfRects;
}

@property (strong, nonatomic) CAShapeLayer *sectorHighlight;

@end

@implementation HistogramTimeDistribution

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

- (void)initData {
//    lightColor = [UIColor colorWithRed:0x11 / 255.0 green:0x71 / 255.0 blue:0x71 / 255.0 alpha:1.0];
//    deepColor = [UIColor colorWithRed:0x1C / 255.0 green:0xBB / 255.0 blue:0xBB / 255.0 alpha:1.0];
    arrayOfRects = [NSMutableArray array];
    self.shouldHighlightSectorOnTouch = YES;
}

- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    
    textFont = [UIFont fontWithName: @"Helvetica Neue" size: TEXT_SIZE];
    textColor = [UIColor blackColor];
    textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;

}

- (void)drawRect:(CGRect)rect {
    
    
    CGPoint startPoint = CGPointMake(rect.origin.x + MARGIN_LEFT, rect.origin.y + rect.size.height - MARGIN_BOTTOM);
    CGPoint hEndPoint = CGPointMake(rect.origin.x + rect.size.width - MARGIN_RIGHT, rect.origin.y + rect.size.height - MARGIN_BOTTOM);
    CGPoint vEndPoint = CGPointMake(rect.origin.x + MARGIN_LEFT, rect.origin.y + MARGIN_TOP);
    
    CGFloat draw_Width = rect.size.width - MARGIN_RIGHT - MARGIN_LEFT;
    CGFloat draw_Height = rect.size.height - MARGIN_BOTTOM - MARGIN_TOP;
    
    ////draw H and V lines first
    UIBezierPath *Hline = [UIBezierPath bezierPath];
    [Hline moveToPoint:startPoint];
    [Hline addLineToPoint:hEndPoint];
    
    UIBezierPath *Vline = [UIBezierPath bezierPath];
    [Vline moveToPoint:startPoint];
    [Vline addLineToPoint:vEndPoint];
    
    [[UIColor blackColor] set];
    [Hline stroke];
    [Hline closePath];
    [Vline stroke];
    [Vline closePath];
    

    UIBezierPath *BP = [UIBezierPath bezierPath];
    
    ////画横向坐标
    int hCount = (int)ceil((hValue[1] - hValue[0]) / hValue[2]); //间隔的数量
    CGFloat hInterval = draw_Width / hCount;
    //记录每个断点坐标
    CGFloat hDots[hCount + 1];
    hDots[0] = startPoint.x;
    for (int index = 1; index <= hCount; index++) {
        hDots[index] = hDots[index - 1] + hInterval;
    }
    
    //画每个断点
    for(int index = 0; index <= hCount; index++) {
        [BP moveToPoint:CGPointMake(hDots[index], startPoint.y)];
        [BP addLineToPoint:CGPointMake(hDots[index], startPoint.y + DOTWIDTH)];
        [BP stroke];
        
        NSString *text = [NSString stringWithFormat:@"%d", hValue[2] * index];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
        
        CGPoint textOrigin = CGPointMake(hDots[index] - textSize.width / 2, startPoint.y + DOTWIDTH + 2);
        
        CGRect textRct = CGRectMake(textOrigin.x, textOrigin.y,
                                    textSize.width, textSize.height);
        [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];

    }
    
    //画单位
    NSString *text = [NSString stringWithFormat:@"%@", hUnit];
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
    
    CGPoint textOrigin = CGPointMake(hEndPoint.x + 8, hEndPoint.y - textSize.height / 2);
    
    CGRect textRct = CGRectMake(textOrigin.x, textOrigin.y,
                                textSize.width, textSize.height);
    [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];

    ////画纵向坐标
    int vCount = vValue[2];//(int)ceil((vValue[1] - vValue[0]) / vValue[2]);
    CGFloat vInterval = draw_Height / vCount;
    //记录每个断点坐标
    CGFloat vDots[vCount + 1];
    vDots[0] = startPoint.y;
    for (int index = 1; index <= vCount; index++) {
        vDots[index] = vDots[index - 1] - vInterval;
    }
    
    int valueInterval = vValue[1] / vValue[2];
    
    //画每个断点
    for(int index = 0; index <= vCount; index++) {
        [BP moveToPoint:CGPointMake(startPoint.x, vDots[index])];
        [BP addLineToPoint:CGPointMake(startPoint.x - DOTWIDTH, vDots[index])];
        [BP stroke];
        
        NSString *text = [NSString stringWithFormat:@"%d", valueInterval * index];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
        
        CGPoint textOrigin = CGPointMake(startPoint.x - DOTWIDTH - 16, vDots[index] - textSize.height / 2);
        
        CGRect textRct = CGRectMake(textOrigin.x, textOrigin.y,
                                    textSize.width, textSize.height);
        [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];
        
    }
    
    //画单位
    text = [NSString stringWithFormat:@"%@", vUnit];
    textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
    
    textOrigin = CGPointMake(vEndPoint.x - textSize.width / 2, vEndPoint.y - 26);
    
    textRct = CGRectMake(textOrigin.x, textOrigin.y,
                         textSize.width, textSize.height);
    [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];

    [BP closePath];
    
    //画纵向阴影
    for(int i = 0; i < hCount; i++) {
        if (i % 2) {
            [[UIColor colorWithRed:0xf1 / 255.0 green:0xf1 / 255.0 blue:0xf1 / 255.0 alpha:1.0] set];
        } else {
            [[UIColor whiteColor] set];
        }
        CGRect drawRect = CGRectMake(hDots[i], vEndPoint.y, hInterval, draw_Height - 1);
        UIBezierPath *rct = [UIBezierPath bezierPathWithRect:drawRect];
        [rct fill];
        [rct closePath];
        
        [arrayOfRects addObject:[NSValue valueWithCGRect:drawRect]];
        
    }
    
    //画纵向条
    for(int i = 0; i < hCount; ++i) {
        
        float ratio;
        if (1 == hCount)
            ratio = 0;
        else
            ratio = i * 1.0 / (hCount - 1);
        
        float red = RGB_R_MIN + (RGB_R_MAX - RGB_R_MIN) * ratio;
        float green = RGB_G_MIN + (RGB_G_MAX - RGB_G_MIN) * ratio;
        float blue = RGB_B_MIN + (RGB_B_MAX - RGB_B_MIN) * ratio;
        
//        NSLog(@"ratio:%f,RGB:%f,%f,%f", ratio, red, green, blue);
        
        drawColor = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
        [drawColor set];
//        if (i % 2) {
//            [lightColor set];
//        } else {
//            [deepColor set];
//        }
        
        NSInteger val = [[array objectAtIndex:i] integerValue];
        CGFloat h = val * 1.0 / vValue[1] * draw_Height;
        
        CGRect drawRct = CGRectMake(hDots[i], startPoint.y - h, hInterval, h - 1);
        UIBezierPath *rct = [UIBezierPath bezierPathWithRect:drawRct];
        [rct fill];
        [rct closePath];
        
        //对应文字
        if (val > 0) {
            text = [NSString stringWithFormat:@"%ld", (long)val];
            textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
            
            textOrigin = CGPointMake(drawRct.origin.x + (hInterval - textSize.width) / 2, drawRct.origin.y - textSize.height - 2);
            
            textRct = CGRectMake(textOrigin.x, textOrigin.y,
                                 textSize.width, textSize.height);
            [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self];
        
        UIColor *newColor = [UIColor colorWithRed:0x3f / 255.0f green:0x51 / 255.0f blue:0xb5 / 255.0f alpha:1.0f];

        int index = 0;
        for (NSValue *val in arrayOfRects) {
            CGRect barRct = [val CGRectValue];
            if (CGRectContainsPoint(barRct, touchLocation)) {
                if (self.shouldHighlightSectorOnTouch) {
                    if ([self.delegate respondsToSelector:@selector(userClickedOnTimeBar:)]) {
                        [self.delegate userClickedOnTimeBar:index];
                    }
                    
                    self.sectorHighlight = [self newBarBorderLayerWithRect:barRct borderWidth:1 borderColor:newColor];
                    [self.layer addSublayer:self.sectorHighlight];

//                    NSLog(@"index is :%d", index);
                }
                break;
            }
            index++;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(didUnselectBar)]) {
        [self.delegate didUnselectBar];
    }
    [self.sectorHighlight removeFromSuperlayer];
}

- (CAShapeLayer *)newBarBorderLayerWithRect:(CGRect)rect borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    
    CAShapeLayer *rctLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [path closePath];
    
    rctLayer.fillColor = [UIColor clearColor].CGColor;
    rctLayer.strokeColor = borderColor.CGColor;
    rctLayer.lineWidth   = borderWidth;
    rctLayer.path        = path.CGPath;
    rctLayer.shadowColor = [UIColor whiteColor].CGColor;
    rctLayer.shadowOffset= CGSizeMake(0, 2);
    
    return rctLayer;
}

#pragma mark - public

- (void)setHorizentalMin:(int)min Max:(int)max interval:(int)interval andUnit:(NSString *)unit {
//    hDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:min], @"min",
//                                                      [NSNumber numberWithInteger:max], @"max",
//                                                      [NSNumber numberWithInteger:interval], @"interval",
//                                                      unit, @"unit", nil];

    
    hValue[0] = min;
    hValue[1] = max;
    hValue[2] = interval;
    
    hUnit = unit;
    
}

- (void)setVerticalMin:(int)min Max:(int)max andUnit:(NSString *)unit {
//    vDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:min], @"min",
//                                                      [NSNumber numberWithInteger:max], @"max",
//                                                      [NSNumber numberWithInteger:interval], @"interval",
//                                                      unit, @"unit", nil];
    
    //人数换算成5的倍数
    int num = max / STU_BASE_COUNT;
    if (max % STU_BASE_COUNT > 0) {
        num += 1;
    }
    num *= STU_BASE_COUNT;
    
    vValue[0] = min;
    vValue[1] = num;
    vValue[2] = DEFAULT_V_COUNT;
    
    vUnit = unit;

}

- (void)setTotalValues:(NSArray *)values {
    array = values;
}

@end
