//
//  HPickerView.m
//  HPickerView
//
//  Created by mythware on 10/27/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#define MARGIN_CELL 40.0
#define CELL_ID     @"MyCell"
#define ITEM_WIDTH  102

#import "HPickerView.h"
#import "Masonry/Masonry.h"

@interface CollectionViewLayout : UICollectionViewFlowLayout //layout主要处理中间item放大和滑动范围

@property (nonatomic) BOOL selectEnable;

@end


@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel   *name;

@end




@interface HPickerView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSInteger centerIndex;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CollectionViewLayout *layout;


@end

@implementation HPickerView

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

//- (id)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initData];
//        [self initView];
//    }
//    return self;
//}

- (void)initData {
    

    self.layout = [[CollectionViewLayout alloc] init];
    self.collectionView = nil;
    
}

- (void)initView {
//    self.backgroundColor = [UIColor orangeColor];
    
    CGRect rct = self.bounds;
//    rct.size.height = 150;
//    rct.origin.y = [[UIScreen mainScreen] bounds].size.height / 2.0 - rct.size.height;
    //    NSLog(@"y : %f", rct.origin.y);
    
    if (self.collectionView) {
        return;
    }
    self.collectionView = [[UICollectionView alloc] initWithFrame:rct collectionViewLayout:self.layout];
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];

    [self addSubview:self.collectionView];
//    [self addSubview:self.itemName];

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

- (void)scrollToCenter {
    //默认选中
    NSLog(@"scroll to center now");
    
    [self.collectionView reloadData];
    NSIndexPath *selection = [NSIndexPath indexPathForItem:(NSInteger)floor([self.itemTitles count] / 2.0) inSection:0];
    
    NSLog(@"indexpath is:%@", selection);
    
//    [self.collectionView selectItemAtIndexPath:selection animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.collectionView scrollToItemAtIndexPath:selection atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    //    [self changeNameAtIndex:selection.row];
//    centerIndex = selection.row;
}

#pragma mark - CollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //    NSLog(@"count: %lu", (unsigned long)[self.itemTitles count]);
    
    return [self.itemTitles count];
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
    cell.image.image = [UIImage imageNamed:[[self.itemTitles objectAtIndex:indexPath.row] stringByAppendingString:@"_selected"]];
    
    NSString *textStr = [self.itemTitles objectAtIndex:indexPath.row];
    cell.name.text = NSLocalizedString(textStr, nil);
    
    if (self.layout.selectEnable) {
//        if (indexPath.row == centerIndex) {
//            cell.name.hidden = NO;
//        }else
            cell.name.hidden = YES;
        
    } else {
        cell.name.hidden = NO;
    }

    return cell;
}

#pragma mark - CollectionViewDelegate
//选中item
- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (!self.layout.selectEnable) {
        self.layout.selectEnable = YES;
        [self.collectionView reloadData];
        
        if (self.delegate && centerIndex == indexPath.row) {
            [delegate itemSelected:(int)indexPath.row];
        }

    }
    //    else if (centerIndex == indexPath.row) {
    //        self.layout.selectEnable = NO;
    //        [self.collectionView reloadData];
    //    }
    
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    //滚动到中间
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
//    [self changeNameAtIndex:indexPath.row];
    
    
}


#pragma mark - CollectionViewFlowLayoutDelegate
- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(ITEM_WIDTH, collectionView.bounds.size.height); //返回height占据全部 才会水平显示
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
    
//    centerIndex = [self getCenterCellIndex];
//    NSLog(@"now center index is: %ld", (long)centerIndex);
//    
//    if (centerIndex < 0) {
//        return;
//    }
//
    
    if ([self getCenterCellIndex] < 0) {
        return;
    }
    
    if (centerIndex == [self getCenterCellIndex]) { //减少刷新次数
        return;
    }
    
    centerIndex = [self getCenterCellIndex];
    NSLog(@"now center index is: %ld", (long)centerIndex);
    
    
    
    if (self.layout.selectEnable) {
        if (self.delegate ) {
            [delegate itemSelected:(int)centerIndex];
        }
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:centerIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}








@end


#pragma mark - CollectionViewLayout
@implementation CollectionViewLayout

- (id)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = MARGIN_CELL;
        self.selectEnable = NO;
    }
    return self;
}

// return YES to cause the collection view to requery the layout for geometry information
/**
 *  只要显示的边界发生改变就重新布局:
 内部会重新调用prepareLayout和layoutAttributesForElementsInRect方法获得所有cell的布局属性
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

static CGFloat const ActiveDistance = 80;
static CGFloat const ScaleFactor = 0.2;
//这里设置放大范围
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        //如果cell在屏幕上则进行缩放
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            
            attributes.alpha = 0.5;
            
            if (self.selectEnable) {
                
                CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;//距离中点的距离
                CGFloat normalizedDistance = distance / ActiveDistance;
                
                if (ABS(distance) < ActiveDistance) {
                    CGFloat zoom = 1 + ScaleFactor * (1 - ABS(normalizedDistance)); //放大渐变
                    attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                    attributes.zIndex = 1;
                    attributes.alpha = 1.0;
                }
            }
        }
    }
    
    return array;
}

//scroll 停止对中间位置进行偏移量校正
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat offsetAdjustment = MAXFLOAT;
    ////  |-------[-------]-------|
    ////  |滑动偏移|可视区域 |剩余区域|
    //是整个collectionView在滑动偏移后的当前可见区域的中点
    CGFloat centerX = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    //    CGFloat centerX = self.collectionView.center.x; //这个中点始终是屏幕中点
    //所以这里对collectionView的具体尺寸不太理解，输出的是屏幕大小，但实际上宽度肯定超出屏幕的
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes *layoutAttr in array) {
        CGFloat itemCenterX = layoutAttr.center.x;
        
        if (ABS(itemCenterX - centerX) < ABS(offsetAdjustment)) { // 找出最小的offset 也就是最中间的item 偏移量
            offsetAdjustment = itemCenterX - centerX;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end


#pragma mark - CollectionViewCell
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
    NSLog(@"cell inited");
    
    self.layer.doubleSided = NO;
    
    self.image = [[UIImageView alloc] init];
    self.image.backgroundColor = [UIColor clearColor];
    self.image.contentMode = UIViewContentModeCenter;
    self.image.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.name = [[UILabel alloc] init];
    self.name.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.name.textColor = [UIColor whiteColor];
    self.name.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.image];
    [self.contentView addSubview:self.name];
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(30);
        make.bottom.equalTo(_name.mas_top).offset(-10);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(_image.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    
}

//
//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//
//    self.name.hidden = !selected;
//}


@end