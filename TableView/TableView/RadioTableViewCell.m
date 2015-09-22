//
//  RadioTableViewCell.m
//  TableView
//
//  Created by mythware on 6/26/15.
//  Copyright (c) 2015 mythware. All rights reserved.
//

#import "RadioTableViewCell.h"

@implementation RadioTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
