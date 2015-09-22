//
//  SceneAViewController.h
//  Delegate
//
//  Created by mythware on 6/25/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneBViewController.h"

@interface SceneAViewController : UIViewController <SceneBViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *showInformation;

@end
