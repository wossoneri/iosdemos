//
//  CommonTopBar.m
//  Quiz
//
//  Created by mythware on 11/5/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "CommonToolBar.h"
#import "HelpHeader.h"


@interface CommonToolBar ()
{
    
}

@end

@implementation CommonToolBar

- (id)init {
    if (self = [super init]) {
        
        
    }
    return self;
}

- (void)addLeftView:(UIView *)view andWidth:(float)width {
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(MARGIN_BUTTON);
        make.bottom.equalTo(self).offset(-MARGIN_BUTTON);
        if (width > 0) {
            make.width.mas_equalTo(width);
        }
    }];
}

- (void)addLeftViewCenterY:(UIView *)view andWidth:(float)width {
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(MARGIN_BUTTON);
        make.centerY.equalTo(self);
        if (width > 0) {
            make.width.mas_equalTo(width);
        }
    }];
}


- (void)addCenterView:(UIView *)view andWidth:(float)width {
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(MARGIN_BUTTON);
        make.bottom.equalTo(self).offset(-MARGIN_BUTTON);
        make.centerX.equalTo(self);
        if (width > 0) {
            make.width.mas_equalTo(width);
        }
    }];
}

- (void)addCenterViewCenterY:(UIView *)view andWidth:(float)width {
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
        if (width > 0) {
            make.width.mas_equalTo(width);
        }
    }];
}




- (void)addRightView:(UIView *)view andWidth:(float)width {
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(MARGIN_BUTTON);
        make.right.bottom.equalTo(self).offset(-MARGIN_BUTTON);
        if (width > 0) {
            make.width.mas_equalTo(width);
        }
    }];
}

- (void)addRightView:(UIView *)view andHeight:(float)height {
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(MARGIN_BUTTON);
        make.right.bottom.equalTo(self).offset(-MARGIN_BUTTON);
        if (height > 0) {
            make.height.mas_equalTo(height);
        }
    }];

}


- (void)addRightViewCenterY:(UIView *)view andWidth:(float)width {
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-MARGIN_BUTTON);
        if (width > 0) {
            make.width.mas_equalTo(width);
        }
    }];
}

@end
