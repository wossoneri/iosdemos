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
    
    [self.contentView addSubview:self.image];
    
    [self.image setTranslatesAutoresizingMaskIntoConstraints:NO];

    
    UIView *tmpView = self.contentView;
    UIImageView *imageView = self.image;

    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[tmpView]-(<=1)-[imageView]"]
                                                                    options:NSLayoutFormatAlignAllCenterX
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(tmpView, imageView)]];
    
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[tmpView]-(<=1)-[imageView]"]
                                                                    options:NSLayoutFormatAlignAllCenterY
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(tmpView, imageView)]];
    
//    [tmpView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
//                                                        attribute:NSLayoutAttributeCenterY
//                                                        relatedBy:NSLayoutRelationEqual
//                                                           toItem:tmpView
//                                                        attribute:NSLayoutAttributeCenterY
//                                                       multiplier:1.0
//                                                         constant:0]];

    
//    NSLog(@"cell x: %f", self.bounds.origin.x);
//    NSLog(@"cell y: %f", self.bounds.origin.y);
//    NSLog(@"cell width: %f", self.bounds.size.width);
//    NSLog(@"cell height: %f", self.bounds.size.height);
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
}


@end
