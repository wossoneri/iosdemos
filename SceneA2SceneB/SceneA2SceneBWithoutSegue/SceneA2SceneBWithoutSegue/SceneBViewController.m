//
//  SceneBViewController.m
//  SceneA2SceneBWithoutSegue
//
//  Created by mythware on 6/24/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//

#import "SceneBViewController.h"

@interface SceneBViewController ()

@end

@implementation SceneBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
