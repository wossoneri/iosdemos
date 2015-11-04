//
//  ViewController.m
//  UIViewAttributeTest
//
//  Created by 杜博文 on 15/10/29.
//  Copyright © 2015年 wossoneri. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()
{
    UIView *view1;
    UIView *view2;
    UIView *view3;
    UIView *view4;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    view1 = [[UIView alloc] init];
    view1.backgroundColor =[UIColor blueColor];
    UILabel *label1 = [[UILabel alloc] init];
    [label1 setText:@"1"];
    [label1 setTextColor:[UIColor whiteColor]];
    [view1 addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view1);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    view2 = [[UIView alloc] init];
    view2.backgroundColor =[UIColor lightGrayColor];
    UILabel *label2 = [[UILabel alloc] init];
    [label2 setText:@"2"];
    [label2 setTextColor:[UIColor whiteColor]];
    [view2 addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view2);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    view3 = [[UIView alloc] init];
    view3.backgroundColor =[UIColor redColor];
    UILabel *label3 = [[UILabel alloc] init];
    [label3 setText:@"3"];
    [label3 setTextColor:[UIColor whiteColor]];
    [view3 addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view3);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    view4 = [[UIView alloc] init];
    view4.backgroundColor =[UIColor orangeColor];
    UILabel *label4 = [[UILabel alloc] init];
    [label4 setText:@"4"];
    [label4 setTextColor:[UIColor whiteColor]];
    [view4 addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view4);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    [self.view addSubview:view4];
    
    
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewDidAppear:(BOOL)animated {
    [self showLogsOfView:self.view];
    [self showLogsOfView:view1];
    [self showLogsOfView:view2];
    [self showLogsOfView:view3];
    [self showLogsOfView:view4];
}

- (void)showLogsOfView:(UIView *)view {
    
    NSLog(@"View frame is:(%f, %f, %f, %f)", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    NSLog(@"View bound is:(%f, %f, %f, %f)", view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height);
    NSLog(@"View center is:(%f, %f)", view.center.x, view.center.y);
    NSLog(@"View intrinsicContentSize is:(%f, %f)", view.intrinsicContentSize.width, view.intrinsicContentSize.height);
    NSLog(@"----------------------------------------------------------------");
//    view.layer.anchorPoint;
//    view.layer.accessibilityFrame;
//    view.layer.bounds;
//    view.layer.contentsCenter;
//    view.layer.contentsRect;
//    view.layer.frame;
//    view.layer.position;

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
