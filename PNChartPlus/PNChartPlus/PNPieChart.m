//
//  PNPieChart.m
//  PNChartPlus
//
//  Created by 杜博文 on 15/11/18.
//  Copyright © 2015年 wossoneri. All rights reserved.
//

#import "PNPieChart.h"

@interface PNPieChart()

@property (nonatomic) NSArray *items;
@property (nonatomic) NSArray *endPercentages;

@property (nonatomic) UIView         *contentView;
@property (nonatomic) CAShapeLayer   *pieLayer;
@property (nonatomic) NSMutableArray *descriptionLabels;
@property (strong, nonatomic) CAShapeLayer *sectorHighlight;

@property (nonatomic, strong) NSMutableDictionary *selectedItems;

- (void)loadDefault;

//- (UILabel *)descriptionLabelForItemAtIndex:(NSUInteger)index;
- (PNPieChartDataItem *)dataItemForIndex:(NSUInteger)index;
- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index;
- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index;
- (CGFloat)ratioForItemAtIndex:(NSUInteger)index;

- (CAShapeLayer *)newCircleLayerWithRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                 fillColor:(UIColor *)fillColor
                               borderColor:(UIColor *)borderColor
                           startPercentage:(CGFloat)startPercentage
                             endPercentage:(CGFloat)endPercentage;

@end

@implementation PNPieChart

- (id)initWithItems:(NSArray *)items {
    if (self = [super init]) {
//        self.backgroundColor = [UIColor grayColor];
        
        _items = [NSArray arrayWithArray:items];
        _selectedItems = [NSMutableDictionary dictionary];
        _circleRadius = CGRectGetWidth(self.bounds) / 2;
//        _outerCircleRadius  = CGRectGetWidth(self.bounds) / 2;
//        _descriptionTextColor = [UIColor whiteColor];
//        _descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
//        _descriptionTextShadowColor  = [[UIColor blackColor] colorWithAlphaComponent:0.4];
//        _descriptionTextShadowOffset =  CGSizeMake(0, 1);
        _duration = 1.0;
        _shouldHighlightSectorOnTouch = YES;
        _enableMultipleSelection = NO;
        
//        [super setupDefaultValues];
        [self loadDefault];

        
    }
    return self;
}



#pragma mark - Private Methods
- (void)loadDefault{
    __block CGFloat currentTotal = 0;
    CGFloat total = [[self.items valueForKeyPath:@"@sum.value"] floatValue];
    NSMutableArray *endPercentages = [NSMutableArray new];
    [_items enumerateObjectsUsingBlock:^(PNPieChartDataItem *item, NSUInteger idx, BOOL *stop) {
        if (total == 0){
            [endPercentages addObject:@(1.0 / _items.count * (idx + 1))];
        }else{
            currentTotal += item.value;
            [endPercentages addObject:@(currentTotal / total)];
        }
    }];
    self.endPercentages = [endPercentages copy];
    
    [_contentView removeFromSuperview];
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_contentView];
    _descriptionLabels = [NSMutableArray new];
    
    _pieLayer = [CAShapeLayer layer];
    [_contentView.layer addSublayer:_pieLayer];
    
}

- (void)updateChartData:(NSArray *)items {
    self.items = items;
}

- (PNPieChartDataItem *)dataItemForIndex:(NSUInteger)index{
    return self.items[index];
}

- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index{
    if(index == 0){
        return 0;
    }
    
    return [_endPercentages[index - 1] floatValue];
}

- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index{
    return [_endPercentages[index] floatValue];
}

- (CGFloat)ratioForItemAtIndex:(NSUInteger)index{
    return [self endPercentageForItemAtIndex:index] - [self startPercentageForItemAtIndex:index];
}

#pragma mark -
- (CAShapeLayer *)newCircleLayerWithRadius:(CGFloat)radius
                               borderWidth:(CGFloat)borderWidth
                                 fillColor:(UIColor *)fillColor
                               borderColor:(UIColor *)borderColor
                           startPercentage:(CGFloat)startPercentage
                             endPercentage:(CGFloat)endPercentage{
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:0
                                                      endAngle:M_PI * 2
                                                     clockwise:YES];
    
    ///终于明白空心圆的原理了！！
    ///先以radius为半径画一个圆圈，这圈线的宽度为1
    ///然后以 borderwidth 为线圈的宽度向里和外分别拓展 borderWidth / 2 的宽度
    ///如果 radius == borderWidth / 2，结果当然是实心的，否则肯定是空心的 bravo!
    
    circle.fillColor   = fillColor.CGColor;
    circle.strokeColor = borderColor.CGColor;
    circle.strokeStart = startPercentage;
    circle.strokeEnd   = endPercentage;
    circle.lineWidth   = borderWidth;
    circle.path        = path.CGPath;
    
    
    return circle;
}

- (void)maskChart{
    CGFloat radius = _circleRadius / 2;
    CGFloat borderWidth = _circleRadius;
    CAShapeLayer *maskLayer = [self newCircleLayerWithRadius:radius
                                                 borderWidth:borderWidth
                                                   fillColor:[UIColor clearColor]
                                                 borderColor:[UIColor blackColor]
                                             startPercentage:0
                                               endPercentage:1];
    
    _pieLayer.mask = maskLayer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = _duration;
    animation.fromValue = @0;
    animation.toValue   = @1;
    animation.delegate  = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [maskLayer addAnimation:animation forKey:@"circleAnimation"];
}

- (void)createArcAnimationForLayer:(CAShapeLayer *)layer
                            forKey:(NSString *)key
                         fromValue:(NSNumber *)from
                           toValue:(NSNumber *)to
                          delegate:(id)delegate{
    CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:key];
    arcAnimation.fromValue         = @0;
    arcAnimation.toValue           = to;
    arcAnimation.delegate          = delegate;
    arcAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [layer addAnimation:arcAnimation forKey:key];
    [layer setValue:to forKey:key];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_descriptionLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [UIView animateWithDuration:0.2 animations:^(){
            [obj setAlpha:1];
        }];
    }];
}

- (void)didTouchAt:(CGPoint)touchLocation
{
    CGPoint circleCenter = CGPointMake(_contentView.bounds.size.width/2, _contentView.bounds.size.height/2);
    
    CGFloat distanceFromCenter = sqrtf(powf((touchLocation.y - circleCenter.y),2) + powf((touchLocation.x - circleCenter.x),2));
    
    if (distanceFromCenter < 0) {
        if ([self.delegate respondsToSelector:@selector(didUnselectPieItem)]) {
            [self.delegate didUnselectPieItem];
        }
        [self.sectorHighlight removeFromSuperlayer];
        return;
    }
    
    CGFloat percentage = [self findPercentageOfAngleInCircle:circleCenter fromPoint:touchLocation];
    int index = 0;
    while (percentage > [self endPercentageForItemAtIndex:index]) {
        index ++;
    }
    
    if ([self.delegate respondsToSelector:@selector(userClickedOnPieIndexItem:)]) {
        [self.delegate userClickedOnPieIndexItem:index];
    }
    
    if (self.shouldHighlightSectorOnTouch)
    {
        if (!self.enableMultipleSelection)
        {
            if (self.sectorHighlight)
                [self.sectorHighlight removeFromSuperlayer];
        }
        
        PNPieChartDataItem *currentItem = [self dataItemForIndex:index];
        
        CGFloat red,green,blue,alpha;
        UIColor *old = currentItem.color;
        [old getRed:&red green:&green blue:&blue alpha:&alpha];
        alpha /= 2;
        UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        
        CGFloat startPercnetage = [self startPercentageForItemAtIndex:index];
        CGFloat endPercentage   = [self endPercentageForItemAtIndex:index];
        
        self.sectorHighlight = [self newCircleLayerWithRadius:_circleRadius + 5
                                                  borderWidth:10
                                                    fillColor:[UIColor clearColor]
                                                  borderColor:newColor
                                              startPercentage:startPercnetage
                                                endPercentage:endPercentage];
        
        if (self.enableMultipleSelection)
        {
            NSString *dictIndex = [NSString stringWithFormat:@"%d", index];
            CAShapeLayer *indexShape = [self.selectedItems valueForKey:dictIndex];
            if (indexShape)
            {
                [indexShape removeFromSuperlayer];
                [self.selectedItems removeObjectForKey:dictIndex];
            }
            else
            {
                [self.selectedItems setObject:self.sectorHighlight forKey:dictIndex];
                [_contentView.layer addSublayer:self.sectorHighlight];
            }
        }
        else
        {
            [_contentView.layer addSublayer:self.sectorHighlight];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:_contentView];
        [self didTouchAt:touchLocation];
    }
}

- (CGFloat) findPercentageOfAngleInCircle:(CGPoint)center fromPoint:(CGPoint)reference{
    //Find angle of line Passing In Reference And Center
    CGFloat angleOfLine = atanf((reference.y - center.y) / (reference.x - center.x));
//    CGFloat percentage = (angleOfLine)/(2 * M_PI);
    CGFloat percentage;
    if (reference.x - center.x > 0) {
        if (reference.y - center.y > 0)
            percentage = (angleOfLine) / (2 * M_PI);
        else
            percentage = (angleOfLine + 2 * M_PI) / (2 * M_PI);
    }else {
        percentage = (angleOfLine + M_PI) / (2 * M_PI);
    }
    
    return percentage;
    
//    return (reference.y - center.y) > 0 ? percentage : percentage + .5;
}

/* Redraw the chart on autolayout */
-(void)layoutSubviews {
    [super layoutSubviews];
    [self strokeChart];
}


#pragma mark - Public Methods
/** Override this to change how inner attributes are computed. **/
- (void)recompute {
    self.circleRadius = CGRectGetWidth(self.bounds) / 2;
//    self.outerCircleRadius = CGRectGetWidth(self.bounds) / 2;
}

- (void)strokeChart{
    [self loadDefault];
    [self recompute];
    
    PNPieChartDataItem *currentItem;
    for (int i = 0; i < _items.count; i++) {
        currentItem = [self dataItemForIndex:i];
        
        
        CGFloat startPercnetage = [self startPercentageForItemAtIndex:i];
        CGFloat endPercentage   = [self endPercentageForItemAtIndex:i];
        
        CGFloat radius = _circleRadius / 2;
        CGFloat borderWidth = _circleRadius;
        
        CAShapeLayer *currentPieLayer =	[self newCircleLayerWithRadius:radius
                                                           borderWidth:borderWidth
                                                             fillColor:[UIColor clearColor]
                                                           borderColor:currentItem.color
                                                       startPercentage:startPercnetage
                                                         endPercentage:endPercentage];
        [_pieLayer addSublayer:currentPieLayer];
    }
    
    [self maskChart];
    
//    for (int i = 0; i < _items.count; i++) {
//        UILabel *descriptionLabel =  [self descriptionLabelForItemAtIndex:i];
//        [_contentView addSubview:descriptionLabel];
//        [_descriptionLabels addObject:descriptionLabel];
//    }
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
