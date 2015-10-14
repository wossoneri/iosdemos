//
//  ViewController.m
//  HorizontalPickerView2
//
//  Created by mythware on 10/14/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "CollectionViewLayout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"titles" ofType:@"plist"];
    NSDictionary *rootDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.itemTitles = [rootDictionary objectForKey:@"heros"];
    NSLog(@"%@", self.itemTitles);
    
//    CollectionViewLayout *layout = [[CollectionViewLayout alloc] init];
//    self.collectionView.collectionViewLayout = layout;
    
    self.itemName = [[UILabel alloc] init];
    self.itemName.text = @"DOTA";
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[CollectionViewLayout alloc] init]];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
    [self.collectionView setBackgroundColor:[UIColor blueColor]];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    
    NSLog(@"width : %f", self.view.bounds.size.width);
    
    [self.view addSubview:self.collectionView];
//    [self.view addSubview:self.itemName];
//    
//    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.itemName setTranslatesAutoresizingMaskIntoConstraints:NO];
//    
//    UIView *tmpView = self.view;
////    UICollectionView *view1 = self.collectionView;
////    UILabel *view2 = self.itemName;
//    
//    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[tmpView]-(<=1)-[_collectionView]"]
//                                                                    options:NSLayoutFormatAlignAllCenterX
//                                                                    metrics:nil
//                                                                      views:NSDictionaryOfVariableBindings(tmpView, _collectionView)]];
//    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[tmpView]-(<=1)-[_itemName]"]
//                                                                    options:NSLayoutFormatAlignAllCenterX
//                                                                    metrics:nil
//                                                                      views:NSDictionaryOfVariableBindings(tmpView, _itemName)]];
//    
//    [tmpView addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView
//                                                        attribute:NSLayoutAttributeCenterY
//                                                        relatedBy:NSLayoutRelationEqual
//                                                           toItem:tmpView
//                                                        attribute:NSLayoutAttributeCenterY
//                                                       multiplier:1.0
//                                                         constant:0]];
//    [tmpView addConstraint:[NSLayoutConstraint constraintWithItem:_itemName
//                                                        attribute:NSLayoutAttributeCenterY
//                                                        relatedBy:NSLayoutRelationEqual
//                                                           toItem:tmpView
//                                                        attribute:NSLayoutAttributeCenterY
//                                                       multiplier:1.0
//                                                         constant:100]];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"count: %lu", (unsigned long)[self.itemTitles count]);
    
    return [self.itemTitles count];
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];
    
    cell.image.image = [UIImage imageNamed:[self.itemTitles objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


#pragma mark - CollectionViewFlowLayoutDelegate
- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(64, collectionView.bounds.size.height); //返回height占据全部 才会水平显示
}

//Asks the delegate for the margins to apply to content in the specified section.安排初始位置
//使前后项都能居中显示
- (UIEdgeInsets)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    NSInteger itemCount = [self collectionView:collectionView numberOfItemsInSection:section];

    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:itemCount - 1 inSection:section];
    CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
    
//    NSLog(@"width: %f", collectionView.bounds.size.width);
//    NSLog(@"width: %f", firstSize.width);
    
    return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                            0, (collectionView.bounds.size.width - lastSize.width) / 2);
    
    
    
    
}


@end
