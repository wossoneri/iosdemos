//
//  HPickerView.h
//  HPickerView
//
//  Created by mythware on 10/27/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HPickerViewDelegate

- (void)itemSelected:(int)index;

@end


@interface HPickerView : UIView 

@property (nonatomic, weak) NSArray *itemTitles;
@property (nonatomic, weak) id<HPickerViewDelegate> delegate;

- (void)scrollToCenter;

@end
