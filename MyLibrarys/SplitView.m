//
//  SplitView.m
//  SPUserResizableView
//
//  Created by Mythware on 15/8/31.
//  Copyright © 2015年 Brown University. All rights reserved.
//

#import "SplitView.h"
#import "ImageDefine.h"
#define MG_DEFAULT_SPLIT_POSITION		650.0
#define MG_DEFAULT_SPLIT_WIDTH		25.0

@implementation SplitView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setupDefaultAttributes];
    }
    return self;
}

- (void)setupDefaultAttributes {
    _splitPosition = MG_DEFAULT_SPLIT_POSITION;
    _splitWidth = MG_DEFAULT_SPLIT_WIDTH;
    
    CGRect divRect = self.bounds;
    divRect.origin.x = _splitPosition;
    divRect.size.width = _splitWidth;
    
    _splitLine = [[UIView alloc] initWithFrame:divRect];
    _splitLine.backgroundColor = [UIColor colorWithRed:0xed / 255.0f
                                                 green:0xed / 255.0f
                                                  blue:0xed / 255.0f
                                                 alpha:1.0f];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGE_ASRESULT_SPLITTER_ICON];
    
    [_splitLine addSubview:imageView];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_splitLine addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_splitLine]-(<=1)-[imageView]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(_splitLine, imageView)]];
    [_splitLine addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_splitLine]-(<=1)-[imageView]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_splitLine, imageView)]];
    
    
    [self addSubview:_splitLine];
    
    //    [self updateFrameSize:NO];
    
    mConstraints = [[NSMutableArray alloc] init];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _bRightViewOnly = YES;
}

- (void)addRightView:(UIView*)rightView
{
    _bRightViewOnly = YES;

    [self removeConstraints:mConstraints];
    [mConstraints removeAllObjects];
    
    [_splitLine removeFromSuperview];
    [_leftView removeFromSuperview];
    [_rightView removeFromSuperview];
    _rightView = rightView;
    
    [self addSubview:_rightView];
    
    //    _rightView.frame = self.frame;
    
    [_rightView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSArray *tmpConstarints = nil;
    tmpConstarints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_rightView]-0-|"
                                                             options:0
                                                             metrics:nil
                                                               views:NSDictionaryOfVariableBindings(_rightView)];
    
    [mConstraints addObjectsFromArray:tmpConstarints];
    
    tmpConstarints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_rightView]-0-|"
                                                             options:0
                                                             metrics:nil
                                                               views:NSDictionaryOfVariableBindings(_rightView)];
    
    [mConstraints addObjectsFromArray:tmpConstarints];
    
    [self addConstraints:mConstraints];
    
    self.userInteractionEnabled = YES;
}

- (void)addTwoView:(UIView*)leftView rightView:(UIView*)rightView
{
    _bRightViewOnly = NO;

    [self removeConstraints:mConstraints];
    [mConstraints removeAllObjects];
    
    [_splitLine removeFromSuperview];
    [_leftView removeFromSuperview];
    [_rightView removeFromSuperview];
    
    _leftView = leftView;
    _rightView = rightView;
    
    [self addSubview:_leftView];
    [self addSubview:_rightView];
    [self addSubview:_splitLine];
    
    [_leftView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_rightView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_splitLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self updateFrameSize:NO];
    
    self.userInteractionEnabled = YES;
}

- (void)updateFrameSize:(BOOL)bEnd
{
    if (_bRightViewOnly) {
        return;
    }
    
    [self removeConstraints:mConstraints];
    [mConstraints removeAllObjects];
    
    float width = self.bounds.size.width;
//    float height = self.bounds.size.height;
    
    CGRect newFrame = self.bounds;
    CGRect leftFrame = CGRectZero, splitFrame = CGRectZero, rightFrame = CGRectZero;
    
    if (_splitPosition < 0) {
        _splitPosition = 0;
    }else if (_splitPosition + _splitWidth > width) {
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
        }
    }
    
    //    _leftView.frame = leftFrame;
    //    _splitLine.frame = splitFrame;
    //    _rightView.frame = rightFrame;
    
//    NSLog(@"left frame %f, %f, %f, %f", leftFrame.origin.x, leftFrame.origin.y, leftFrame.size.width, leftFrame.size.height);
//    NSLog(@"splitFrame frame %f, %f, %f, %f", splitFrame.origin.x, splitFrame.origin.y, splitFrame.size.width, splitFrame.size.height);
//    NSLog(@"right frame %f, %f, %f, %f", rightFrame.origin.x, rightFrame.origin.y, rightFrame.size.width, rightFrame.size.height);
//    NSLog(@"self.bounds %f, %f", self.bounds.size.width, self.bounds.size.height);
    
    NSArray *tmpConstarints = nil;
    tmpConstarints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[_leftView(==%f)]-0-[_splitLine(==%f)]-0-[_rightView(==%f)]-0-|"
                                                                      , leftFrame.size.width, splitFrame.size.width, rightFrame.size.width]
                                                             options:0
                                                             metrics:nil
                                                               views:NSDictionaryOfVariableBindings(_leftView, _splitLine, _rightView)];
    
    [mConstraints addObjectsFromArray:tmpConstarints];
    
    tmpConstarints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_leftView]-0-|"
                                                             options:0
                                                             metrics:nil
                                                               views:NSDictionaryOfVariableBindings(_leftView)];
    [mConstraints addObjectsFromArray:tmpConstarints];
    
    tmpConstarints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_splitLine]-0-|"
                                                             options:0
                                                             metrics:nil
                                                               views:NSDictionaryOfVariableBindings(_splitLine)];
    [mConstraints addObjectsFromArray:tmpConstarints];
    
    tmpConstarints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_rightView]-0-|"
                                                             options:0
                                                             metrics:nil
                                                               views:NSDictionaryOfVariableBindings(_rightView)];
    [mConstraints addObjectsFromArray:tmpConstarints];
    
    
    [self addConstraints:mConstraints];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch) {
//        CGRect splitFrame = _splitLine.frame;
        //这样扩大触摸区域好像没用
        CGFloat orignX = _splitLine.frame.origin.x - 10;
        CGFloat orignY = _splitLine.frame.origin.y;
        CGFloat width  = _splitLine.frame.size.width + 20;
        CGFloat height = _splitLine.frame.size.height;
        CGRect splitFrame = CGRectMake(orignX, orignY, width, height);
        
        
        CGPoint lastPt = [touch previousLocationInView:self];
        if (CGRectContainsPoint(splitFrame, lastPt) == false) {
            return;
        }
        
        self.userInteractionEnabled = NO;
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
//    if (touch) {
//        CGRect splitFrame = _splitLine.frame;
//        CGRect splitFrame = self.frame;

        CGPoint lastPt = [touch previousLocationInView:self];
//        if (CGRectContainsPoint(splitFrame, lastPt) == false) {
//            return;
//        }
        
        CGPoint pt = [touch locationInView:self];
        float offset = pt.x - lastPt.x;
        
        _splitPosition = _splitPosition + offset;
        
        [self updateFrameSize:NO];
//    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.userInteractionEnabled = YES;
    [self updateFrameSize:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.userInteractionEnabled = YES;
    [self updateFrameSize:YES];
}

@end
