//
//  CommonScrollHeader.h
//  Quiz
//
//  Created by mythware on 12/3/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonScrollHeader : UIView


@property (nonatomic, weak) UIScrollView *headerScrollView;

- (void)setTopView:(UIView *)top height:(float)topHeight andBottom:(UIView *)bottom height:(float)bottomHeight;

@end
