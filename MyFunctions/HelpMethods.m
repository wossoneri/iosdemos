//image 编码
+ (NSString *)imageToNSString:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

+ (UIImage *)stringToUIImage:(NSString *)string {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [UIImage imageWithData:data];
}


//extension for uiview
- (void)addSubviews:(NSArray *)views {
    for (UIView *view in views) {
        [self addSubview:view];
    }
}

//masonry 等间距排列
- (void) distributeSpacingHorizontallyWith:(NSArray *)views withMargin:(int)margin {
    UIView *lastView;
    UIView *nextView;
    UIView *thisView;
    
    if (views.count == 1) {
        thisView = (UIView *)[views objectAtIndex:0];
        [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.centerX.equalTo(self);
        }];
        return;
    }
    
    for (int i = 0; i < views.count; i++) {
        thisView = (UIView *)[views objectAtIndex:i];
        if (i == 0) {
            nextView = (UIView *)[views objectAtIndex:i + 1];
            
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.top.bottom.equalTo(self);
                make.right.equalTo(nextView.mas_left).offset(-margin);
            }];
        } else if (i == views.count - 1) {
            lastView = (UIView *)[views objectAtIndex:i - 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(margin);
                make.top.bottom.equalTo(self);
                make.right.equalTo(self);
            }];
        } else {
            nextView = (UIView *)[views objectAtIndex:i + 1];
            lastView = (UIView *)[views objectAtIndex:i - 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(lastView.mas_right).offset(margin);
                make.right.equalTo(nextView.mas_left).offset(-margin);
            }];
        }
    }
}


- (void) distributeSpacingVerticallyWith:(NSArray *)views withMargin:(int)margin {
    UIView *lastView;
    UIView *nextView;
    UIView *thisView;
    
    if (views.count == 1) {
        thisView = (UIView *)[views objectAtIndex:0];
        [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.centerY.equalTo(self);
        }];
        return;
    }
    
    for (int i = 0; i < views.count; i++) {
        thisView = (UIView *)[views objectAtIndex:i];
        if (i == 0) {
            nextView = (UIView *)[views objectAtIndex:i + 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.left.right.equalTo(self);
                make.bottom.equalTo(nextView.mas_top).offset(-margin);
            }];
        } else if (i == views.count - 1) {
            lastView = (UIView *)[views objectAtIndex:i - 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(margin);
                make.left.right.equalTo(self);
                make.bottom.equalTo(self);
            }];
        } else {
            nextView = (UIView *)[views objectAtIndex:i + 1];
            lastView = (UIView *)[views objectAtIndex:i - 1];
            [thisView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(lastView.mas_bottom).offset(margin);
                make.bottom.equalTo(nextView.mas_top).offset(-margin);
            }];
        }
    }
}


//uicolor
+ (UIColor *) colorWithHexString:(NSString *)color andAlpha:(float)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

//button 图片和文字间距
- (void)centerImageAndTitleWithSpacing:(CGFloat)spacing {
    CGFloat insetAmount = spacing / 2.0;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -insetAmount, 0, insetAmount);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, -insetAmount);
    self.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
}

//segment control 圆角
NSArray *itemArr = [NSArray arrayWithObjects:NSLocalizedString(@"a", nil), NSLocalizedString(@"s", nil), nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArr];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self action:@selector(switchContent:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setTintColor:[UIColor whiteColor]];
    //    [segmentedControl setBorderColor:[UIColor whiteColor] width:2];
    [segmentedControl setBackgroundColor:[UIColor colorWithHexString:@"3f51b5"]];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline], NSFontAttributeName,
                                nil];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    segmentedControl.layer.cornerRadius = 8;
    segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    segmentedControl.layer.borderWidth = 1.0f;
    segmentedControl.layer.masksToBounds = YES;


NSArray *itemArr = [NSArray arrayWithObjects:NSLocalizedString(@"a", nil), NSLocalizedString(@"s ", nil), NSLocalizedString(@"d", nil), nil];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:itemArr];
    [segmentControl setSelectedSegmentIndex:0];
    [segmentControl addTarget:self action:@selector(switchAnalysis:) forControlEvents:UIControlEventValueChanged];
    [segmentControl setTintColor:[UIColor clearColor]];
    [segmentControl setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *titleAttrNormal = [NSDictionary dictionaryWithObjectsAndKeys:FONT_Headline, NSFontAttributeName, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
    [segmentControl setTitleTextAttributes:titleAttrNormal forState:UIControlStateNormal];
    
    NSDictionary *titleAttrSelected = [NSDictionary dictionaryWithObjectsAndKeys:FONT_Headline, NSFontAttributeName, [UIColor colorWithHexString:@"3f51b5"], NSForegroundColorAttributeName, nil];
    [segmentControl setTitleTextAttributes:titleAttrSelected forState:UIControlStateSelected];

    - (void)switchAnalysis:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {

    }
    
    if (segment.selectedSegmentIndex == 1) {

    }
    
    if (segment.selectedSegmentIndex == 2) {
        
    }
    
    if (segment.selectedSegmentIndex == 3) {
        
    }
}
