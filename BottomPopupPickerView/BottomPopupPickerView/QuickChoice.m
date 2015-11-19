//
//  QuickChoice.m
//  BottomPopupPickerView
//
//  Created by mythware on 10/22/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "QuickChoice.h"




@interface QuickChoice ()
{
    UIButton *btnA;
    UIButton *btnB;
    UIButton *btnC;
    UIButton *btnD;
    UIButton *btnE;
    UIButton *btnF;
    UIButton *btnG;
    UIButton *btnH;
    
    UIButton *btnAdd;
    UIButton *btnDel;
    UIButton *btnStyle;

    NSMutableArray *buttons;
    
    NSArray *arr_capital;
    NSArray *arr_lowercase;
    NSArray *arr_number;
    NSArray *arr_rome;
    
    UIColor *btnTextColor;
    UIColor *btnBgColor;
    UIColor *btnSelectColor;
    
    int showCount;
}
@end


@implementation QuickChoice

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

- (void)initData {
    arr_capital = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H"];
    arr_lowercase = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h"];
    arr_number = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"];
    arr_rome = @[@"Ⅰ", @"Ⅱ", @"Ⅲ", @"Ⅳ", @"Ⅴ", @"Ⅵ", @"Ⅶ", @"Ⅷ"];
    
    btnTextColor = [UIColor whiteColor];
    btnBgColor = [UIColor colorWithRed:0x66 / 255.0f green:0x66 / 255.0f blue:0x66 / 255.0f alpha:1.0f];
    btnSelectColor = [UIColor colorWithRed:0x33 / 255.0f green:0x99 / 255.0f blue:0x66 / 255.0f alpha:1.0f];
    
    buttons = [NSMutableArray array];
    
    showCount = 4;
}

- (void)initView {
    
    btnA = [UIButton buttonWithType:UIButtonTypeCustom];
    btnB = [UIButton buttonWithType:UIButtonTypeCustom];
    btnC = [UIButton buttonWithType:UIButtonTypeCustom];
    btnD = [UIButton buttonWithType:UIButtonTypeCustom];
    btnE = [UIButton buttonWithType:UIButtonTypeCustom];
    btnF = [UIButton buttonWithType:UIButtonTypeCustom];
    btnG = [UIButton buttonWithType:UIButtonTypeCustom];
    btnH = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttons addObject:btnA];
    [buttons addObject:btnB];
    [buttons addObject:btnC];
    [buttons addObject:btnD];
    [buttons addObject:btnE];
    [buttons addObject:btnF];
    [buttons addObject:btnG];
    [buttons addObject:btnH];
    
    btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStyle = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self initButtons];
}

- (void)initButtons {

    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    
    int index = 0;
    
    for(UIButton *btn in buttons) {
        [btn.titleLabel setFont:font];
        [btn setTitle:[arr_capital objectAtIndex:index] forState:UIControlStateNormal];
        [btn setTitleColor:btnTextColor forState:UIControlStateNormal];
        [btn setBackgroundColor:btnBgColor];
        [btn setTag:index];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        ++index;
    }
        
    [btnAdd.titleLabel setFont:font];
    [btnAdd setTitle:@"＋" forState:UIControlStateNormal];
    [btnAdd setTitleColor:btnTextColor forState:UIControlStateNormal];
    [btnAdd setBackgroundColor:btnBgColor];
    [btnAdd setTag:10];
    [btnAdd addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnDel.titleLabel setFont:font];
    [btnDel setTitle:@"－" forState:UIControlStateNormal];
    [btnDel setTitleColor:btnTextColor forState:UIControlStateNormal];
    [btnDel setBackgroundColor:btnBgColor];
    [btnDel setTag:11];
    [btnDel addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnStyle.titleLabel setFont:font];
    [btnStyle setTitle:@"..." forState:UIControlStateNormal];
    [btnStyle setTitleColor:btnTextColor forState:UIControlStateNormal];
    [btnStyle setBackgroundColor:btnBgColor];
    [btnStyle setTag:12];
    [btnStyle addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)changeButtonStyle:(int)index {
    NSArray *texts;
    
    switch (index) {
        case 1:
            texts = arr_capital;
            break;
        case 2:
            texts = arr_lowercase;
            break;
        case 3:
            texts = arr_number;
            break;
        case 4:
            texts = arr_rome;
            break;
        default:
            texts = arr_capital;
            break;
    }
    
    int i = 0;
    for (UIButton *btn in buttons) {
        [btn setTitle:[texts objectAtIndex:i] forState:UIControlStateNormal];
        ++index;
    }
}

- (void)buttonClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
            
            break;
            
        default:
            break;
    }
}
@end
