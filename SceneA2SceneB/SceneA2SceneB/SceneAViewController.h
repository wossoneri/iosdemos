//
//  SceneAViewController.h
//  SceneA2SceneB
//
//  Created by mythware on 6/24/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneAViewController : UIViewController <UIAlertViewDelegate>

-(IBAction)unwindSceneAViewController:(UIStoryboardSegue *)segue;

@end
