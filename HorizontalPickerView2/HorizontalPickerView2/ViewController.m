//
//  ViewController.m
//  HorizontalPickerView2
//
//  Created by mythware on 10/14/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"


@interface ViewController ()
{
    NSInteger centerIndex;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"titles" ofType:@"plist"];
    NSDictionary *rootDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.itemTitles = [rootDictionary objectForKey:@"heros"];
//    NSLog(@"%@", self.itemTitles);
    
//    CollectionViewLayout *layout = [[CollectionViewLayout alloc] init];
//    self.collectionView.collectionViewLayout = layout;
    
    self.layout = [[CollectionViewLayout alloc] init];
    
    CGRect rct = self.view.bounds;
    rct.size.height = 150;
    rct.origin.y = [[UIScreen mainScreen] bounds].size.height / 2.0 - rct.size.height;
//    NSLog(@"y : %f", rct.origin.y);
    self.collectionView = [[UICollectionView alloc] initWithFrame:rct collectionViewLayout:self.layout];
//    self.collectionView = [[UICollectionView alloc] init];
//    self.collectionView.collectionViewLayout = [[CollectionViewLayout alloc] init];
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    
    
    self.itemName = [[UILabel alloc] initWithFrame:CGRectMake(rct.origin.x, rct.origin.y + rct.size.height, rct.size.width, 50)];
    self.itemName.textAlignment = NSTextAlignmentCenter;
//    self.itemName.backgroundColor = [UIColor clearColor];
    self.itemName.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
//    NSLog(@"width : %f", self.view.bounds.size.width);
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.itemName];

    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
    NSIndexPath *selection = [NSIndexPath indexPathForItem:(NSInteger)([self.itemTitles count] / 2.0) inSection:0];
    [self.collectionView selectItemAtIndexPath:selection animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.collectionView scrollToItemAtIndexPath:selection atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self changeNameAtIndex:selection.row];

    centerIndex = selection.row;
}


//- (void)didEndScrolling
//{
//    CGPoint center = [self.view convertPoint:self.collectionView.center toView:self.collectionView];
//    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:center];
//    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//}

- (void)changeNameAtIndex:(NSInteger)row {

    if (row >= 0)
        self.itemName.text = self.itemTitles[row];
    
}

- (NSInteger)getCenterCellIndex {

//    NSLog(@"self.collectionView.contentOffset.x: %f", self.collectionView.contentOffset.x);
//    NSLog(@"half of bounds: %f", (CGRectGetWidth(self.collectionView.bounds) / 2.0));
    
    
    CGFloat x =(CGRectGetWidth(self.collectionView.bounds) / 2.0)+ self.collectionView.contentOffset.x;
    CGFloat y = 0 + 50;//self.collectionView.center.y;
    CGPoint point = CGPointMake(x, y);
    
//    NSLog(@"PointX:%f", point.x);
//    NSLog(@"PointY:%f", point.y);
    
    NSIndexPath *index = [self.collectionView indexPathForItemAtPoint:point];
    if (index != nil) {
//        NSLog(@"row: %ld", (long)index.row);
        return index.row;
    }else
        return -1;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    NSLog(@"count: %lu", (unsigned long)[self.itemTitles count]);
    
    return [self.itemTitles count];
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];

    cell.image.image = [UIImage imageNamed:[self.itemTitles objectAtIndex:indexPath.row]];
    cell.name.text = [self.itemTitles objectAtIndex:indexPath.row];
    if (self.layout.selectEnable) {
        if (indexPath.row == centerIndex) {
            cell.name.hidden = NO;
        }else
            cell.name.hidden = YES;
        
    } else {
        cell.name.hidden = NO;
    }
    
    
//    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - CollectionViewDelegate
//选中item  不完善
- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (!self.layout.selectEnable) {
        self.layout.selectEnable = YES;
        [self.collectionView reloadData];
    }
//    else if (centerIndex == indexPath.row) {
//        self.layout.selectEnable = NO;
//        [self.collectionView reloadData];
//    }
    
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    //滚动到中间
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    [self changeNameAtIndex:indexPath.row];
    

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

#pragma mark scrollView Delegate
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [CATransaction begin];
//    [CATransaction setValue:(id)kCFBooleanTrue
//                     forKey:kCATransactionDisableActions];
//    self.collectionView.layer.mask.frame = self.collectionView.bounds;
//    [CATransaction commit];

    centerIndex = [self getCenterCellIndex];
    [self changeNameAtIndex:centerIndex];
    if (self.layout.selectEnable) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:centerIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

@end
