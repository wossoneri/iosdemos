//
//  HPickerView.h
//  HorizontalPickerView
//
//  Created by mythware on 10/12/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPickerView;

@protocol HPickerViewDataSource <NSObject>
@required
- (NSUInteger)numberOfItemsInPickerView:(HPickerView *)pickerView;
@optional
- (NSString *)pickerView:(HPickerView *)pickerView titleForItem:(NSInteger)item;
- (UIImage *)pickerView:(HPickerView *)pickerView imageForItem:(NSInteger)item;
@end

@protocol HPickerViewDelegate <UIScrollViewDelegate>
@optional
- (void)pickerView:(HPickerView *)pickerView didSelectItem:(NSInteger)item;
- (CGSize)pickerView:(HPickerView *)pickerView marginForItem:(NSInteger)item;
- (void)pickerView:(HPickerView *)pickerView configureLabel:(UILabel * const)label forItem:(NSInteger)item;
@end


@interface HPickerView : UIView

@property (nonatomic, weak)id <HPickerViewDataSource> dataSource;
@property (nonatomic, weak)id <HPickerViewDelegate> delegate;



@end
