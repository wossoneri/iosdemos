//
//  CollectionViewCell.m
//  HorizontalPickerView2
//
//  Created by mythware on 10/14/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}



- (void)initialize {
    self.layer.doubleSided = NO;
    
    self.image = [[UIImageView alloc] init];
    self.image.backgroundColor = [UIColor clearColor];
    self.image.contentMode = UIViewContentModeCenter;
    self.image.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.name = [[UILabel alloc] init];
    self.name.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    self.name.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.image];
    [self.contentView addSubview:self.name];
    
    [self.image setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.name setTranslatesAutoresizingMaskIntoConstraints:NO];

    
    UIView *tmpView = self.contentView;
//    UIImageView *imageView = self.image;

    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[tmpView]-(<=1)-[_image]"]
                                                                    options:NSLayoutFormatAlignAllCenterX
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(tmpView, _image)]];
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[tmpView]-(<=1)-[_name]"]
                                                                    options:NSLayoutFormatAlignAllCenterX
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(tmpView, _name)]];
    
    [tmpView addConstraint:[NSLayoutConstraint constraintWithItem:_image
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:tmpView
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:-15]];
    [tmpView addConstraint:[NSLayoutConstraint constraintWithItem:_name
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:tmpView
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:30]];

    
//    NSLog(@"cell x: %f", self.bounds.origin.x);
//    NSLog(@"cell y: %f", self.bounds.origin.y);
//    NSLog(@"cell width: %f", self.bounds.size.width);
//    NSLog(@"cell height: %f", self.bounds.size.height);
}

//
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.name.hidden = !selected;
}


@end
