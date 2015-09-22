//
//  BNRDetailViewController.h
//  E4_5
//
//  Created by mythware on 6/19/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
