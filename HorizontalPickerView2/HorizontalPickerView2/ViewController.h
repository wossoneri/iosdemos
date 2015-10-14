//
//  ViewController.h
//  HorizontalPickerView2
//
//  Created by mythware on 10/14/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) UILabel *itemName;

@end

