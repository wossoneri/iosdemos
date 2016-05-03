//
//  ViewController.m
//  KVO_Try
//
//  Created by wossoneri on 16/4/30.
//  Copyright © 2016年 wossoneri. All rights reserved.
//

#import "ViewController.h"

#import "LastDays.h"
#import "LastdaysObserver.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)test {
    LastdaysObserver *lastdaysObserver = [[LastdaysObserver alloc] init];
    LastDays *lastdays = [[LastDays alloc] init];
    
    
    NSString *name = @"lastdays";
    lastdays.name = name;//@"OK";
    [lastdays addObserver:lastdaysObserver
               forKeyPath:@"name"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:(void*)self];
    
    if ([lastdays validateValue:&name forKey:@"name" error:nil]) {
        NSLog(@"Data not empty");
    } else {
        NSLog(@"Data empty");
    }
    
    lastdays.name = @"Lastdays";
    [lastdays removeObserver:lastdaysObserver forKeyPath:@"name"];
    
}


@end
