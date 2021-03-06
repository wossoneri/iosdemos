//
//  ViewController.m
//  HorizontalPickerView
//
//  Created by mythware on 10/12/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pickerView = [[HPickerView alloc] initWithFrame:self.view.bounds];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pickerView];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"titles" ofType:@"plist"];
    NSDictionary *rootDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.itemTitles = [rootDictionary objectForKey:@"heros"];
    NSLog(@"%@", self.itemTitles);
    
    
    
}

//- (NSArray *)getImages


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - HPickerViewDataSource
- (NSUInteger)numberOfItemsInPickerView:(HPickerView *)pickerView {
    return [self.itemTitles count];
}

- (NSString *)pickerView:(HPickerView *)pickerView titleForItem:(NSInteger)item {
    return self.itemTitles[item];
}

#pragma mark - HPickerViewDelegate

- (void)pickerView:(HPickerView *)pickerView didSelectItem:(NSInteger)item
{
    NSLog(@"%@", self.itemTitles[item]);
}




@end
