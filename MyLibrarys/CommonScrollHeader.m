//
//  CommonScrollHeader.m
//  Quiz
//
//  Created by mythware on 12/3/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "CommonScrollHeader.h"
#import "HelpHeader.h"

@interface CommonScrollHeader () //<UIScrollViewDelegate>
{
//    UIView *contentView;
    
    float _topHeight;
    float _bottomHeight;
    UIView *topView;
    UIView *bottomView;
    
    float currentOffset;
    float destinaOffset;
    
    BOOL isInit;
}

@end


@implementation CommonScrollHeader

- (id)init {
    if (self = [super init]) {
        isInit = YES;
    }
    return self;
}

- (void)dealloc {
    @try {
        [self.headerScrollView removeObserver:self forKeyPath:@"contentOffset"];
        NSLog(@"common header dealloc remove observer successful");
    }
    @catch (NSException *exception) {
        NSLog(@"common header dealloc remove observer failed");
    }

}

- (void)setTopView:(UIView *)top height:(float)topHeight andBottom:(UIView *)bottom height:(float)bottomHeight {
    destinaOffset = - topHeight;
    
    _topHeight = topHeight;
    _bottomHeight = bottomHeight;
    topView = top;
    topView.alpha = 0;
    bottomView = bottom;
    bottomView.userInteractionEnabled = YES;
    
//    contentView = [[UIView alloc] init];
//    [contentView addSubview:topView];
//    [contentView addSubview:bottomView];
    
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(contentView);
////        make.bottom.equalTo(bottomView.mas_top);
//        make.height.mas_equalTo(topHeight);
//    }];
//    
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(contentView);
//        make.top.equalTo(topView.mas_bottom);
//        make.height.mas_equalTo(bottomHeight);
//    }];
    
//    [self addSubview:contentView];
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self);
//        make.top.equalTo(self).offset(- topHeight);
//    }];
    
    [self addSubview:topView];
    [self addSubview:bottomView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(topHeight);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(bottomHeight);
    }];
    
    
    self.clipsToBounds = YES;
    [self.layer setMasksToBounds:YES];
 
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTop)];
//    singleTap.numberOfTapsRequired = 1;
    [topView setUserInteractionEnabled:YES];
    [topView addGestureRecognizer:singleTap];
    
}

- (NSArray *)createStringArrayWithPercentages:(NSArray *)percent {
    
    NSString *strCorrect;
    NSString *strWrong;
    NSString *strUnfinished;
    NSString *str;
    
    if ([percent[ANSWER_CORRECT] floatValue] <= 0) {
        strCorrect = @"";
    } else {
        str = [self getPercentageArrayString:[percent[ANSWER_CORRECT] floatValue]];
        strCorrect = [NSLocalizedString(@"studentAnsRight", nil) stringByAppendingString:str];
    }
        
    if ([percent[ANSWER_WRONG] floatValue] <= 0) {
        strWrong = @"";
    } else {
        str = [self getPercentageArrayString:[percent[ANSWER_WRONG] floatValue]];
        strWrong = [NSLocalizedString(@"studentAnsWrong", nil) stringByAppendingString:str];
    }
    
    if ([percent[ANSWER_UNFINISHED] floatValue] <= 0) {
        strUnfinished = @"";
    } else {
        str = [self getPercentageArrayString:[percent[ANSWER_UNFINISHED] floatValue]];
        strUnfinished = [NSLocalizedString(@"studentAnsUnfinished", nil) stringByAppendingString:str];
    }

    NSMutableArray *array = [NSMutableArray array];
    [array addObject:strCorrect];
    [array addObject:strWrong];
    [array addObject:strUnfinished];
    
    return array;
}

- (NSString *)getPercentageArrayString:(float)value {
    float fValue = value;
    int iValue = floorf(value);
    NSString *str;
    
    if (fValue - iValue > 0) {
        str = [NSString stringWithFormat:@":%.2lf%%", fValue];
    } else {
        str = [NSString stringWithFormat:@":%d%%", iValue];
    }
    
    return str;
}



- (NSString *)createStringTimes:(NSArray *)timeArr andCount:(NSArray *)countArr {
    
    NSString *strTimeDistribution = [NSLocalizedString(@"timeDistribution", nil) stringByAppendingString:@" : "];
    int i = 0;
    for (; i < [timeArr count]; i++) {
        if ([countArr[i] integerValue] <= 0) {
            continue;
        }
        
        NSString *str = [NSString stringWithFormat:NSLocalizedString(@"timeDistributionSecond", nil), [timeArr[i] integerValue], [countArr[i] integerValue]];
        str = [str stringByAppendingString:@" "];
        strTimeDistribution = [strTimeDistribution stringByAppendingString:str];
    }
//    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"timeDistributionSecond", nil), [timeArr[i] integerValue], [countArr[i] integerValue]];
//    strTimeDistribution = [strTimeDistribution stringByAppendingString:str];
    
    return strTimeDistribution;
}

- (NSString *)createStringOptions:(NSArray *)optionArr andCount:(NSArray *)countArr {
    
    NSString *strOptionDistribution = [NSLocalizedString(@"ansDistribution", nil) stringByAppendingString:@" : "];
    int i = 0;
    for (; i < [optionArr count]; i++) {
        if ([countArr[i] intValue] <= 0) {
            continue;
        }
        
        NSString *str = [NSString stringWithFormat:NSLocalizedString(@"ansDistributionItem", nil), optionArr[i], [countArr[i] intValue]];
        str = [str stringByAppendingString:@" "];
        strOptionDistribution = [strOptionDistribution stringByAppendingString:str];
    }
//    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"ansDistributionItem", nil), optionArr[i], [countArr[i] intValue]];
//    strOptionDistribution = [strOptionDistribution stringByAppendingString:str];
    
    return strOptionDistribution;
}

- (void)onScrollOffsetChange:(float)scrollOffset {
    
}

- (void)recalculateScrollViewSize {
    [self.headerScrollView layoutIfNeeded];
    
    int offset = [[UIScreen mainScreen] bounds].size.height - TOOLBAR_HEIGHT - _topHeight - _headerScrollView.contentSize.height;
    if (offset < 0) {
        offset = 0;
    }
    self.headerScrollView.contentInset = UIEdgeInsetsMake(_bottomHeight, 0, offset, 0);
    
    if (isInit) {
        isInit = NO;
        self.headerScrollView.contentOffset = CGPointMake(0, -_bottomHeight);
    }
    //
    //    NSLog(@"offset:%f", newOffset.y);

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
    self.headerScrollView.contentInset = UIEdgeInsetsMake(_bottomHeight, 0, 0, 0);

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    CGPoint newOffset = [change[@"new"] CGPointValue];
    
    //这里用这段代码会导致dealloc exc_bad_access  why
//    [self.headerScrollView layoutIfNeeded];
//    
//    int offset = [[UIScreen mainScreen] bounds].size.height - TOOLBAR_HEIGHT - _topHeight - _headerScrollView.contentSize.height;
//    if (offset < 0) {
//        offset = 0;
//    }
//    self.headerScrollView.contentInset = UIEdgeInsetsMake(_bottomHeight, 0, offset, 0);
//    
//    if (isInit) {
//        isInit = NO;
//        self.headerScrollView.contentOffset = CGPointMake(0, -_bottomHeight);
//    }

    
    [self updateSubViewsWithScrollOffset:newOffset];
}

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset {

//    NSLog(@"scrollview inset top:%f", self.headerScrollView.contentInset.top);
//    NSLog(@"new offset before:%f", newOffset.y);
//    NSLog(@"newOffset : %f", newOffset.y);
    
    float startChangeOffset = - self.headerScrollView.contentInset.top;
    
    newOffset = CGPointMake(newOffset.x, newOffset.y < startChangeOffset ? startChangeOffset : (newOffset.y > destinaOffset ? destinaOffset : newOffset.y));
//    NSLog(@"new offset after:%f", newOffset.y);

    
    float newY = - newOffset.y - _bottomHeight;//self.headerScrollView.contentInset.top;
    float d = destinaOffset - startChangeOffset;
    float alpha = 1 - (newOffset.y - startChangeOffset) / d;
    
    
    
//    self.headerScrollView.contentInset = UIEdgeInsetsMake(_bottomHeight, 0, 0, 0);
    self.frame = CGRectMake(0, newY, self.frame.size.width, self.frame.size.height);
    topView.frame = CGRectMake(0, -newY, self.frame.size.width, self.frame.size.height);
//    contentView.frame = CGRectMake(0, destinaOffset + self.frame.size.height * (1 - alpha), contentView.frame.size.width, contentView.frame.size.height);
//    bottomView.frame = CGRectMake(0, self.frame.size.height * (1 - alpha), bottomView.frame.size.width, bottomView.frame.size.height);
    
    topView.alpha = 1 - alpha;
    bottomView.alpha = alpha;
    
    
    currentOffset = newOffset.y;

}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrolllll");
//    
//}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    CGFloat y = scrollView.contentOffset.y;
//    CGFloat center = - (_topHeight + _bottomHeight) / 2;
//    if (y > -_bottomHeight && y < center) {
//        [scrollView setContentOffset:CGPointMake(0, -_bottomHeight) animated:YES];
//    }
//    if (y > center && y < -_topHeight) {
//        [scrollView setContentOffset:CGPointMake(0, -_topHeight) animated:YES];
//    }
//}



@end
