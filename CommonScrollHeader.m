//
//  CommonScrollHeader.m
//  Quiz
//
//  Created by mythware on 12/3/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "CommonScrollHeader.h"
#import "HelpHeader.h"

@interface CommonScrollHeader ()
{
    UIView *contentView;
    
    float _topHeight;
    float _bottomHeight;
    UIView *topView;
    UIView *bottomView;
    
    float currentOffset;
    float destinaOffset;
}

@end


@implementation CommonScrollHeader

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

//- (void)dealloc {
//    [self.headerScrollView removeObserver:self forKeyPath:@"contentOffset"];
//}

- (void)setTopView:(UIView *)top height:(float)topHeight andBottom:(UIView *)bottom height:(float)bottomHeight {
    destinaOffset = - topHeight;
    
    _topHeight = topHeight;
    _bottomHeight = bottomHeight;
    topView = top;
    bottomView = bottom;
    bottomView.userInteractionEnabled = YES;
    
    contentView = [[UIView alloc] init];
    [contentView addSubview:topView];
    [contentView addSubview:bottomView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(contentView);
        make.bottom.equalTo(bottomView.mas_top);
        make.height.mas_equalTo(topHeight);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(contentView);
        make.top.equalTo(topView.mas_bottom);
        make.height.mas_equalTo(bottomHeight);
    }];
    
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).offset(- topHeight);
    }];
    
    self.clipsToBounds = YES;
    [self.layer setMasksToBounds:YES];
 
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTop)];
//    singleTap.numberOfTapsRequired = 1;
    [topView setUserInteractionEnabled:YES];
    [topView addGestureRecognizer:singleTap];
    
    
}

- (NSArray *)createStringArrayWithPercentages:(NSArray *)percent {
    
    NSString *strCorrect = [NSLocalizedString(@"studentAnsRight", nil) stringByAppendingString:
                          [NSString stringWithFormat:@":%.2lf%%", [[percent objectAtIndex:ANSWER_CORRECT] floatValue]]];
    NSString *strWrong = [NSLocalizedString(@"studentAnsWrong", nil) stringByAppendingString:
                [NSString stringWithFormat:@":%.2lf%%", [[percent objectAtIndex:ANSWER_WRONG] floatValue]]];
    
    NSString *strUnfinished = [NSLocalizedString(@"studentAnsUnfinished", nil) stringByAppendingString:
                     [NSString stringWithFormat:@":%.2lf%%", [[percent objectAtIndex:ANSWER_UNFINISHED] floatValue]]];

    NSMutableArray *array = [NSMutableArray array];
    [array addObject:strCorrect];
    [array addObject:strWrong];
    [array addObject:strUnfinished];
    
    return array;
}

- (NSString *)createStringTimes:(NSArray *)timeArr andCount:(NSArray *)countArr {
    
    NSString *strTimeDistribution = [NSLocalizedString(@"timeDistribution", nil) stringByAppendingString:@" : "];
    int i = 0;
    for (; i < [timeArr count] - 1; i++) {
        NSString *str = [NSString stringWithFormat:NSLocalizedString(@"timeDistributionSecond", nil), [[timeArr objectAtIndex:i] integerValue], [[countArr objectAtIndex:i] integerValue]];
        
        str = [str stringByAppendingString:@", "];
        strTimeDistribution = [strTimeDistribution stringByAppendingString:str];
    }
    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"timeDistributionSecond", nil), [[timeArr objectAtIndex:i] integerValue], [[countArr objectAtIndex:i] integerValue]];
    strTimeDistribution = [strTimeDistribution stringByAppendingString:str];
    
    return strTimeDistribution;
}

- (NSString *)createStringOptions:(NSArray *)optionArr andCount:(NSArray *)countArr {
    
    NSString *strOptionDistribution = [NSLocalizedString(@"ansDistribution", nil) stringByAppendingString:@" : "];
    int i = 0;
    for (; i < [optionArr count] - 1; i++) {
        NSString *str = [NSString stringWithFormat:NSLocalizedString(@"ansDistributionItem", nil), [optionArr objectAtIndex:i], [[countArr objectAtIndex:i] intValue]];
        str = [str stringByAppendingString:@", "];
        strOptionDistribution = [strOptionDistribution stringByAppendingString:str];
    }
    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"ansDistributionItem", nil), [optionArr objectAtIndex:i], [[countArr objectAtIndex:i] intValue]];
    strOptionDistribution = [strOptionDistribution stringByAppendingString:str];
    
    return strOptionDistribution;
}



#pragma mark - tap gesture
- (void)tapTop {
    if (currentOffset == destinaOffset) {
        NSLog(@"tapppppppped");
        

        
    }
}

#pragma mark -
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [self.headerScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:Nil];
    self.headerScrollView.contentInset = UIEdgeInsetsMake(_bottomHeight, 0 ,0, 0);
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    CGPoint newOffset = [change[@"new"] CGPointValue];
    [self updateSubViewsWithScrollOffset:newOffset];
}

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset{

//    NSLog(@"newOffset : %f", newOffset.y);
    
    float startChangeOffset = - self.headerScrollView.contentInset.top;
    
    newOffset = CGPointMake(newOffset.x, newOffset.y < startChangeOffset ? startChangeOffset : (newOffset.y > destinaOffset ?destinaOffset : newOffset.y));
    
    float newY = - newOffset.y - self.headerScrollView.contentInset.top;
    float d = destinaOffset - startChangeOffset;
    float alpha = 1 - (newOffset.y - startChangeOffset) / d;
    
    self.frame = CGRectMake(0, newY, self.frame.size.width, self.frame.size.height);
    
    contentView.frame = CGRectMake(0, destinaOffset + self.frame.size.height * (1 - alpha), contentView.frame.size.width, contentView.frame.size.height);
    
    
    topView.alpha = 1 - alpha;
    bottomView.alpha = alpha;
    
    
    currentOffset = newOffset.y;

}

@end
