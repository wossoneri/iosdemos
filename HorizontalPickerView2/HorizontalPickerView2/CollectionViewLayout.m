//
//  CollectionViewLayout.m
//  HorizontalPickerView2
//
//  Created by mythware on 10/14/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "CollectionViewLayout.h"

@implementation CollectionViewLayout


- (id)init {
    self = [super init];
    if (self) {
//        self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 40.0;//cell offset  useless here...
    }
    return self;
}

// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
// Subclasses should always call super if they override.
- (void)prepareLayout
{
    [super prepareLayout];
}

// return YES to cause the collection view to requery the layout for geometry information
/**
 *  只要显示的边界发生改变就重新布局:
 内部会重新调用prepareLayout和layoutAttributesForElementsInRect方法获得所有cell的布局属性
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}



//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
//    
//    //默认平的
//    return attributes;
//
//    
//}


static CGFloat const ActiveDistance = 52;
static CGFloat const ScaleFactor = 0.5;

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//    CGRect visibleRect;     //屏幕可见的整行距离
//    visibleRect.origin = self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.bounds.size;
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        //如果cell在屏幕上则进行缩放
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;//距离中点的距离
            CGFloat normalizedDistance = distance / ActiveDistance;
            
            attributes.alpha = 0.5;
            if (ABS(distance) < ActiveDistance) {
                CGFloat zoom = 1 + ScaleFactor * (1 - ABS(normalizedDistance)); //放大渐变
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
                attributes.alpha = 1.0;
            }
            
//            NSLog(@"origin.x: %f", attributes.frame.origin.x);
//            NSLog(@"origin.y: %f", attributes.frame.origin.y);
//            NSLog(@"size.width: %f", attributes.frame.size.width);
//            NSLog(@"size.height: %f", attributes.frame.size.height);
            
        }
    }
    
    return array;
}

//scroll 停止的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat offsetAdjustment = MAXFLOAT; //初始无限大
    
//    NSLog(@"proposedContentOffsetX: %f", proposedContentOffset.x);
//    NSLog(@"proposedContentOffsetY: %f", proposedContentOffset.y);
//    
//    NSLog(@"collectionView.center.x: %f", self.collectionView.center.x);
//    
//    NSLog(@"collectionView.bounds.size.width: %f", self.collectionView.bounds.size.width);
//    NSLog(@"collectionView.bounds.size.height: %f", self.collectionView.bounds.size.height);
    
    //collectionView 的 bound 始终是屏幕大小，proposedContentOffset.x 是滑动后距0,0的偏移量
    
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
