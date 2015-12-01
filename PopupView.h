//
//  PopupView.h
//  Quiz
//
//  Created by mythware on 11/2/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView

- (void)setTitle:(NSString *)text andTitleSize:(int)size;
- (void)setContentView:(UIView *)view;
- (void)highlightItem:(int)index;
/// default 600 * 400
- (void)setViewSize:(CGSize)size;


@end
