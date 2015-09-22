//
//  SceneBViewController.m
//  Delegate
//
//  Created by mythware on 6/25/15.
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
    self.inputInformation.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.delegate)
    {
        [self.delegate sceneBViewController:self didInputed:self.inputInformation.text];
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    [textField resignFirstResponder];
    return YES;
}

@end
