//
//  ViewController.m
//  PNChartPlus
//
//  Created by 杜博文 on 15/11/18.
//  Copyright © 2015年 wossoneri. All rights reserved.
//

#define PNLightGreen    [UIColor colorWithRed:77.0 / 255.0 green:216.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]
#define PNFreshGreen    [UIColor colorWithRed:77.0 / 255.0 green:196.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]
#define PNDeepGreen     [UIColor colorWithRed:77.0 / 255.0 green:176.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]


#import "ViewController.h"
#import "Masonry.h"
#import "PNPieChart.h"
#import "SearchView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen],
                       [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"WWDC"],
                       [PNPieChartDataItem dataItemWithValue:70 color:PNDeepGreen description:@"GOOG I/O"],
                       ];

    
//    PNPieChart *pieChart = [[PNPieChart alloc] initWithItems:items];
//    [pieChart strokeChart];
//    
//    [self.view addSubview:pieChart];
//    
//    [pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.width.mas_equalTo(200);
//        make.height.mas_equalTo(200);
//    }];
    
    SearchView *search = [[SearchView alloc] init];
    [self.view addSubview:search];
    
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(30);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
