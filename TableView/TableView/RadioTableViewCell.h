//
//  RadioTableViewCell.h
//  TableView
//
//  Created by mythware on 6/26/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end
