//
//  SplitterView.m
//  Quiz
//
//  Created by mythware on 11/4/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "SplitterView.h"

#define MG_DEFAULT_SPLIT_POSITION   650.0
#define MG_DEFAULT_SPLIT_WIDTH		25.0
#define MG_DEFAULT_RIGHTVIEW_WIDTH      280.0

@interface SplitterView ()
{
    UIView *_leftView;
    UIView *_rightView;
    UIView *_splitLine;
    
    float _splitPosition;
    float _splitWidth;
    //    CGPoint _touchStart;
    
    BOOL _bRightViewOnly;
    
    UIImageView *arrow_left;
    UIImageView *arrow_right;
}

@end

@implementation SplitterView

- (id)init {
    if (self = [super init]) {
        [self setupDefaultAttributes];
    }
    return self;
}

//- (id)initWithFrame:(CGRect)frame {
//    if ((self = [super initWithFrame:frame])) {
//        [self setupDefaultAttributes];
//    }
//    return self;
//}

- (void)setupDefaultAttributes {
//    _splitPosition = MG_DEFAULT_SPLIT_POSITION;
    _splitWidth = MG_DEFAULT_SPLIT_WIDTH;
    
    _dragable = YES;
    

    CGRect divRect = self.bounds;
    divRect.origin.x = _splitPosition;
    divRect.size.width = _splitWidth;
    
    _splitLine = [[UIView alloc] initWithFrame:divRect];
    _splitLine.backgroundColor = [UIColor colorWithHexString:@"0xededed"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splitterbar_indicator"]];
    
    [_splitLine addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_splitLine);
//        make.left.right.equalTo(_splitLine);
    }];
    
    
    
    [self addSubview:_splitLine];

    
    //    [self updateFrameSize:NO];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _bRightViewOnly = YES;
}

- (void)addRightView:(UIView*)rightView
{
    _bRightViewOnly = YES;
    
    [_splitLine removeFromSuperview];
    [_leftView removeFromSuperview];
    [_rightView removeFromSuperview];
    _rightView = rightView;
    
    [self addSubview:_rightView];
    
    //    _rightView.frame = self.frame;
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    self.userInteractionEnabled = YES;
}

- (void)addTwoView:(UIView*)leftView rightView:(UIView*)rightView
{
    _bRightViewOnly = NO;
    
    [_splitLine removeFromSuperview];
    [_leftView removeFromSuperview];
    [_rightView removeFromSuperview];
    
    _leftView = leftView;
    _rightView = rightView;
    
    [self addSubview:_leftView];
    [self addSubview:_rightView];
    [self addSubview:_splitLine];
    
    arrow_left = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"split_left"]];
    arrow_left.hidden = YES;
    arrow_right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"split_right"]];
    arrow_right.hidden = YES;
    [self addSubview:arrow_left];
    [self addSubview:arrow_right];
    [self bringSubviewToFront:arrow_left];
    [self bringSubviewToFront:arrow_right];
    
    
//    [self updateFrameSize:NO];
//    [self createFrame];
    
    self.userInteractionEnabled = YES;
}

- (void)createArrowFrame {
    [arrow_left mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(_splitLine.mas_left);
    }];
    
    [arrow_right mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_splitLine.mas_right);
    }];
}

//- (void)createFrame {
//    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.bottom.equalTo(self);
//        make.right.equalTo(_splitLine.mas_left);
////        make.width.mas_equalTo(leftFrame.size.width);
//    }];
//    
//    [_splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self);
//        make.left.equalTo(_leftView.mas_right);
//        make.right.equalTo(_rightView.mas_left);
//        make.width.mas_equalTo(MG_DEFAULT_SPLIT_WIDTH);
//    }];
//    
//    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.equalTo(self);
//        make.left.equalTo(_splitLine.mas_right);
//        make.width.mas_equalTo(MG_DEFAULT_RIGHTVIEW_WIDTH);
//    }];
//    
//
//}

- (void)createFrameByLeftWidth:(float)width {
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(_splitLine.mas_left);
        make.width.mas_equalTo(width);
    }];
    
    [_splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_leftView.mas_right);
        make.right.equalTo(_rightView.mas_left);
        make.width.mas_equalTo(MG_DEFAULT_SPLIT_WIDTH);
    }];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(_splitLine.mas_right);
    }];
    
    [self createArrowFrame];
}

- (void)createFrameByRightWidth:(float)width {
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(_splitLine.mas_left);
    }];
    
    [_splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_leftView.mas_right);
        make.right.equalTo(_rightView.mas_left);
        make.width.mas_equalTo(MG_DEFAULT_SPLIT_WIDTH);
    }];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(_splitLine.mas_right);
        make.width.mas_equalTo(width);
    }];
    [self createArrowFrame];
}



- (void)updateFrameSize:(BOOL)bEnd
{
    
    if (_bRightViewOnly) {
        return;
    }


    
    float width = self.bounds.size.width;

    CGRect newFrame = self.bounds;
    CGRect leftFrame = CGRectZero, splitFrame = CGRectZero, rightFrame = CGRectZero;
    
    
    
    if (_splitPosition < 0) {
        _splitPosition = 0;
    }else if (width > 0 && _splitPosition + _splitWidth > width) {
        _splitPosition = width - _splitWidth;
    }
    
    newFrame.size.width = _splitPosition;
    leftFrame = newFrame;
    
    newFrame.origin.x += newFrame.size.width;
    newFrame.size.width = _splitWidth;
    splitFrame = newFrame;
    
    newFrame.origin.x += newFrame.size.width;
    newFrame.size.width = width - newFrame.origin.x;
    rightFrame = newFrame;
    
    if (bEnd) {
        if (leftFrame.size.width < 200) {
            leftFrame.size.width = 0;
            splitFrame.origin.x = 0;
            rightFrame.origin.x = splitFrame.size.width;
            rightFrame.size.width = width - _splitWidth;
            _splitPosition = 0;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(onViewHide:)]) {
                [self.delegate onViewHide:YES];
            }
        }
        else if (rightFrame.size.width < 200) {
            rightFrame.origin.x = width;
            rightFrame.size.width = 0;
            splitFrame.origin.x = width - _splitWidth;
            leftFrame.size.width = splitFrame.origin.x;
            _splitPosition = splitFrame.origin.x;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(onViewHide:)]) {
                [self.delegate onViewHide:NO];
            }
            
            if (_delegate) { 
                [_delegate onRightViewChange:0];
            }
        }
    }
    
    //    _leftView.frame = leftFrame;
    //    _splitLine.frame = splitFrame;
    //    _rightView.frame = rightFrame;
    
    //    NSLog(@"left frame %f, %f, %f, %f", leftFrame.origin.x, leftFrame.origin.y, leftFrame.size.width, leftFrame.size.height);
    //    NSLog(@"splitFrame frame %f, %f, %f, %f", splitFrame.origin.x, splitFrame.origin.y, splitFrame.size.width, splitFrame.size.height);
    //    NSLog(@"right frame %f, %f, %f, %f", rightFrame.origin.x, rightFrame.origin.y, rightFrame.size.width, rightFrame.size.height);
    //    NSLog(@"self.bounds %f, %f", self.bounds.size.width, self.bounds.size.height);
    

    [self removeConstraints:self.constraints];
//    [self updateConstraints];
    
    [_leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(_splitLine.mas_left);
        make.width.mas_equalTo(leftFrame.size.width);
    }];
    
    [_splitLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_leftView.mas_right);
        make.right.equalTo(_rightView.mas_left);
        make.width.mas_equalTo(splitFrame.size.width);
    }];
    
    [_rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(_splitLine.mas_right);
        make.width.mas_equalTo(rightFrame.size.width);
    }];
    
    [self createArrowFrame];
    
    [self updateConstraints];
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(_leftView.frame, point)) {
        if (_delegate && [self.delegate respondsToSelector:@selector(onTouchLeftView)])
            [_delegate onTouchLeftView];
    }
    if (CGRectContainsPoint(_rightView.frame, point)) {
        if (_delegate && [self.delegate respondsToSelector:@selector(onTouchRightView)])
            [_delegate onTouchRightView];
    }
    
    if (!_dragable) {
        return;
    }
    
    
    
    _splitPosition = _splitLine.frame.origin.x;
    
    if (touch) {
        CGRect splitFrame = _splitLine.frame;
        //这样扩大触摸区域好像没用
//        CGFloat orignX = _splitLine.frame.origin.x - 10;
//        CGFloat orignY = _splitLine.frame.origin.y;
//        CGFloat width  = _splitLine.frame.size.width + 20;
//        CGFloat height = _splitLine.frame.size.height;
//        CGRect splitFrame = CGRectMake(orignX, orignY, width, height);

        CGPoint lastPt = [touch previousLocationInView:self];
        if (CGRectContainsPoint(splitFrame, lastPt) == false) {
            return;
        }
        
        arrow_left.hidden = NO;
        arrow_right.hidden = NO;
        
        self.userInteractionEnabled = NO;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_dragable) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
//        if (touch) {
            CGRect splitFrame = _splitLine.frame;
//            CGRect splitFrame = self.frame;
    
    CGPoint lastPt = [touch previousLocationInView:self];
            if (CGRectContainsPoint(splitFrame, lastPt) == false) {
                return;
            }
    
    CGPoint pt = [touch locationInView:self];
    float offset = pt.x - lastPt.x;
    
    _splitPosition = _splitPosition + offset;
    
    CGFloat scale = (_rightView.bounds.size.width - 50) / (MG_DEFAULT_RIGHTVIEW_WIDTH - 50);
    if (_delegate && [self.delegate respondsToSelector:@selector(onRightViewChange:)]) {
        [_delegate onRightViewChange:scale];
    }
    
    [self updateFrameSize:NO];
    //    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_dragable) {
        return;
    }
    arrow_left.hidden = YES;
    arrow_right.hidden = YES;
    self.userInteractionEnabled = YES;
    [self updateFrameSize:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_dragable) {
        return;
    }
    
    arrow_left.hidden = YES;
    arrow_right.hidden = YES;
    self.userInteractionEnabled = YES;
    [self updateFrameSize:YES];
}




@end
