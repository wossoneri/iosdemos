//
//  SceneAViewController.m
//  Delegate
//
//  Created by mythware on 6/25/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//

#import "SceneAViewController.h"


@interface SceneAViewController ()

@end

@implementation SceneAViewController

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Segue_ID_AB"])
    {
        SceneBViewController *sceneBVC = segue.destinationViewController;
        sceneBVC.delegate = self;
    }
}

-(void)sceneBViewController:(SceneBViewController *)sceneBVC didInputed:(NSString *)string
{
    self.showInformation.text = string;
}

@end
