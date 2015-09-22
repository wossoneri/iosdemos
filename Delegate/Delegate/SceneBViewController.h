//
//  SceneBViewController.h
//  Delegate
//
//  Created by mythware on 6/25/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//
@class SceneBViewController;

#import <UIKit/UIKit.h>

@protocol SceneBViewControllerDelegate <NSObject>

-(void)sceneBViewController:(SceneBViewController *)sceneBVC didInputed:(NSString *)string;

@end

@interface SceneBViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputInformation;
@property (weak, nonatomic) id <SceneBViewControllerDelegate> delegate;
@end
