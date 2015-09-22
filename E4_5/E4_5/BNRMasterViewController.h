//
//  BNRMasterViewController.h
//  E4_5
//
//  Created by mythware on 6/19/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRDetailViewController;

@interface BNRMasterViewController : UITableViewController

@property (strong, nonatomic) BNRDetailViewController *detailViewController;

@end
