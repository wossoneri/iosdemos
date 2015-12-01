//
//  PopupView.m
//  Quiz
//
//  Created by mythware on 11/2/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "PopupView.h"
#import "HelpHeader.h"

@interface PopupView ()
{
    UILabel *label;
    UIView *line;
    UIView *contentView;
    
    UIView *centerView;
    
    CGSize centerSize;
}
@end

@implementation PopupView

-(id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"000000" andAlpha:0.5];
        
        centerSize = CGSizeMake(600, 400);
        
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        
        line = [[UIView alloc] init];
        line.backgroundColor = ColorFromStr(@"0xC4C4C4");
        
        contentView = [[UIView alloc] init];

        [self updateCenterView];
        
    }
    return self;
}

- (UIView *)createCenterView {
    UIView *tmp = [[UIView alloc] init];
    tmp.backgroundColor = ColorFromStr(@"0xF6F6F6");
    
    [tmp addSubviews:@[label, line, contentView]];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(tmp);
        make.top.equalTo(tmp).offset(10);
        make.bottom.equalTo(line.mas_top).offset(-10);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.right.equalTo(tmp);
        make.bottom.equalTo(contentView.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.right.bottom.equalTo(tmp);
    }];
    
    return tmp;
    
}

- (void)updateCenterView {
    if (centerView) {
        [centerView removeFromSuperview];
        centerView = nil;
    }
    
    centerView = [self createCenterView];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(centerSize);
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
//    NSLog(@"x:%f,   y:%f", point.x, point.y);
    if (!CGRectContainsPoint(centerView.frame, point)) {
        [self removeFromSuperview];
    }
    
}




- (void)setTitle:(NSString *)text andTitleSize:(int)size {
    [label setText:text];
    [label setFont:FONT(size)];
}

- (void)setContentView:(UIView *)view {
    [contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(contentView);
    }];

}

- (void)highlightItem:(int)index {
    
}

- (void)setViewSize:(CGSize)size {
    centerSize = size;
    [self updateCenterView];
    [self updateConstraints];
}

@end
