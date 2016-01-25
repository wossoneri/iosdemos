//
//  HistogramDistribution.m
//  BottomPopupPickerView
//
//  Created by mythware on 10/20/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "HistogramOptionDistribution.h"
#import "Chart.h"



@interface HistogramOptionDistribution ()
{
    NSArray *barResults;
    NSArray *barOptions;
    int correctIndex;
    
    UIFont *textFont;
    UIColor *textColor;
    NSMutableParagraphStyle *textStyle;
    
    int hValue[3];
//    int vValue[3];
    NSString *hUnit;
    NSString *vUnit;
    
    UIColor *barGray;
    UIColor *barBlue;
    UIColor *barCorrect;
    UIColor *barWrong;
    
    NSMutableArray *arrayOfRects;
}

@property (strong, nonatomic) CAShapeLayer *sectorHighlight;

@end

@implementation HistogramOptionDistribution

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

- (void)initData {
    arrayOfRects = [NSMutableArray array];
    self.shouldHighlightSectorOnTouch = YES;
    
    barGray = [UIColor colorWithHexString:@"f1f1f1"];
    barBlue = [UIColor colorWithHexString:@"00a0e9"];
    barCorrect = [UIColor colorWithHexString:GREEN_IN_CHART];
    barWrong = [UIColor colorWithHexString:RED_IN_CHART];
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
    
    [BP closePath];
    
    ////画纵向bar的起始坐标
    //先算间隔  还是从startPoint开始
    CGFloat vInterval = (draw_Height - OFFSET_V * (barOptions.count - 1)) / barOptions.count;
    
    CGFloat vDots[barOptions.count];
    vDots[0] = startPoint.y;
    for (int i = 1; i < barOptions.count; i++) {
        vDots[i] = vDots[i - 1] - vInterval - OFFSET_V;
    }
    
    
    //画阴影和矩形
    for(int i = 0; i < barOptions.count; i++) {
        //背景阴影
        CGRect drawRct = CGRectMake(startPoint.x, vDots[i] - vInterval, draw_Width, vInterval);
        UIBezierPath *rct = [UIBezierPath bezierPathWithRect:drawRct];
        [barGray set];
        [rct fill];
        
        [arrayOfRects addObject:[NSValue valueWithCGRect:drawRct]];
        
        //蓝色条
        CGFloat w = draw_Width * [[barResults objectAtIndex:barResults.count - i - 1] integerValue] * 1.0 / hValue[1];
        if (0 == hValue[1]) {
            w = 0;
        }
        
        drawRct = CGRectMake(startPoint.x, vDots[i] - vInterval, w, vInterval);
        rct = [UIBezierPath bezierPathWithRect:drawRct];
        if (-1 == correctIndex)
            [barBlue set];
        else if (i == (barOptions.count - 1 - correctIndex))//correctIndex 和绘制的 i 是反的
            [barCorrect set];
        else
            [barWrong set];

        [rct fill];
        [rct closePath];
        
        //左边选项
        text = [NSString stringWithFormat:@"%@", [barOptions objectAtIndex:barResults.count - i - 1]];
        textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
        
        textOrigin = CGPointMake(drawRct.origin.x - textSize.width - 8, drawRct.origin.y + (vInterval - textSize.height) / 2);
        
        textRct = CGRectMake(textOrigin.x, textOrigin.y,
                             textSize.width, textSize.height);
        [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];
        
        
        //右边值
        NSInteger val = [[barResults objectAtIndex:barResults.count - i - 1] integerValue];
        if (val > 0) {
            text = [NSString stringWithFormat:@"%ld", (long)val];
            textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
            
            textOrigin = CGPointMake(drawRct.origin.x + w + 4, drawRct.origin.y + (vInterval - textSize.height) / 2);
            
            textRct = CGRectMake(textOrigin.x, textOrigin.y,
                                 textSize.width, textSize.height);
            [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];
        }
    }

    //画单位
    text = [NSString stringWithFormat:@"%@", vUnit];
    textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
    
    textOrigin = CGPointMake(vEndPoint.x - textSize.width / 2, vEndPoint.y - 26);
    
    textRct = CGRectMake(textOrigin.x, textOrigin.y,
                         textSize.width, textSize.height);
    [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];
    
//    int vCount = (int)ceil((vValue[1] - vValue[0]) / vValue[2]);
//    CGFloat vInterval = draw_Height / hCount;
//    //记录每个断点坐标
//    CGFloat vDots[vCount + 1];
//    vDots[0] = startPoint.y;
//    for (int index = 1; index <= vCount; index++) {
//        vDots[index] = vDots[index - 1] - vInterval;
//    }
//    
//    //画每个断点
//    for(int index = 0; index <= vCount; index++) {
//        [BP moveToPoint:CGPointMake(startPoint.x, vDots[index])];
//        [BP addLineToPoint:CGPointMake(startPoint.x - DOTWIDTH, vDots[index])];
//        [BP stroke];
//        
//        NSString *text = [NSString stringWithFormat:@"%d", vValue[2] * index];
//        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
//        
//        CGPoint textOrigin = CGPointMake(startPoint.x - DOTWIDTH - 16, vDots[index] - textSize.height / 2);
//        
//        CGRect textRct = CGRectMake(textOrigin.x, textOrigin.y,
//                                    textSize.width, textSize.height);
//        [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];
//        
//    }
//    
//    //画单位
//    text = [NSString stringWithFormat:@"%@", vUnit];
//    textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
//    
//    textOrigin = CGPointMake(vEndPoint.x - textSize.width / 2, vEndPoint.y - 26);
//    
//    textRct = CGRectMake(textOrigin.x, textOrigin.y,
//                         textSize.width, textSize.height);
//    [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];
//    
//    [BP closePath];
    
//    //画纵向条
//    for(int i = 0; i < hCount; i++) {
//        if (i % 2) {
//            [lightColor set];
//        } else {
//            [deepColor set];
//        }
//        
//        NSInteger val = [[array objectAtIndex:i] integerValue];
//        CGFloat h = val * 1.0 / vValue[1] * draw_Height;
//        
//        CGRect drawRct = CGRectMake(hDots[i], startPoint.y - h, hInterval, h);
//        UIBezierPath *rct = [UIBezierPath bezierPathWithRect:drawRct];
//        [rct fill];
//        [rct closePath];
//        
//        //对应文字
//        text = [NSString stringWithFormat:@"%ld", (long)val];
//        textSize = [text sizeWithAttributes:@{NSFontAttributeName:textFont}];
//        
//        textOrigin = CGPointMake(drawRct.origin.x + (hInterval - textSize.width) / 2, drawRct.origin.y - textSize.height - 2);
//        
//        textRct = CGRectMake(textOrigin.x, textOrigin.y,
//                             textSize.width, textSize.height);
//        [text drawInRect:textRct withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:textStyle}];
//        
//    }

    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self];
        
        UIColor *newColor = [UIColor colorWithRed:0x3f / 255.0f green:0x51 / 255.0f blue:0xb5 / 255.0f alpha:1.0f];

        int index = (int)arrayOfRects.count - 1;
        for (NSValue *val in arrayOfRects) {
            CGRect barRct = [val CGRectValue];
            if (CGRectContainsPoint(barRct, touchLocation)) {
                
                if (self.shouldHighlightSectorOnTouch) {
                    if ([self.delegate respondsToSelector:@selector(userClickedOnOptionBar:)]) {
                        [self.delegate userClickedOnOptionBar:index];
                    }
                    
                    self.sectorHighlight = [self newBarBorderLayerWithRect:barRct borderWidth:1 borderColor:newColor];
                    [self.layer addSublayer:self.sectorHighlight];

                    
                }
                
//                NSLog(@"index is :%d", index);
                
                break;
            }
            index--;
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

//- (void)setVerticalMin:(int)min Max:(int)max interval:(int)interval andUnit:(NSString *)unit {
//    //    vDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:min], @"min",
//    //                                                      [NSNumber numberWithInteger:max], @"max",
//    //                                                      [NSNumber numberWithInteger:interval], @"interval",
//    //                                                      unit, @"unit", nil];
//    vValue[0] = min;
//    vValue[1] = max;
//    vValue[2] = interval;
//    
//    vUnit = unit;
//    
//}

- (void)setVerticalUnit:(NSString *)unit {
    vUnit = unit;
}

- (void)setTotalValues:(NSArray *)values options:(NSArray *)options andCorrectIndex:(int)index {
    barResults = values;
    barOptions = options;
    correctIndex = index;
}

@end
