//
//  ViewController.h
//  HorizontalPickerView
//
//  Created by mythware on 10/12/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPickerView.h"

@interface ViewController : UIViewController <HPickerViewDataSource, HPickerViewDelegate>

@property (nonatomic, strong) HPickerView *pickerView;
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSArray *itemImages;

@end

