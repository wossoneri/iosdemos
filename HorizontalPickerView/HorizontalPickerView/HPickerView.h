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

@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, assign) CGFloat fisheyeFactor; // 0...1; slight value recommended such as 0.0001
@property (nonatomic, assign, getter=isMaskDisabled) BOOL maskDisabled;
@property (nonatomic, assign, readonly) NSUInteger selectedItem;
@property (nonatomic, assign, readonly) CGPoint contentOffset;


- (void)reloadData;
- (void)scrollToItem:(NSUInteger)item animated:(BOOL)animated;
- (void)selectItem:(NSUInteger)item animated:(BOOL)animated;

@end

