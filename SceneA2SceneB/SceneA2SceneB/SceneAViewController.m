//
//  SceneAViewController.m
//  SceneA2SceneB
//
//  Created by mythware on 6/24/15.
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
    [self createAlertWindow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createAlertWindow{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"场景跳转"
                                                   message:@"是否跳到写一个页面"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1)
        [self performSegueWithIdentifier:@"transfer" sender:nil];
}

-(IBAction)unwindSceneAViewController:(UIStoryboardSegue *)segue{
    NSLog(@"excuted!!!!!!!!!!");
}

@end
