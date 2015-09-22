//
//  BNRViewController.m
//  demo_calculator
//
//  Created by mythware on 6/19/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//

#import "BNRViewController.h"

@interface BNRViewController ()

@end

@implementation BNRViewController

@synthesize display;

-(IBAction) click1
{
    display.text = @"1";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
