//
//  PieChartView.h
//  BottomPopupPickerView
//
//  Created by mythware on 10/20/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartView : UIView
{
    NSArray *results;
    NSArray *colors;
    NSInteger count;
    
    UIFont *textFont;
    UIColor *textColor;
    NSMutableParagraphStyle *textStyle;
}

@property (nonatomic) NSInteger sections;

- (void)setResults:(NSArray *)result;
- (void)setColors:(NSArray *)color;

@end
