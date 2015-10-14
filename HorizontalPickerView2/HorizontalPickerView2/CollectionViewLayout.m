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
        self.minimumLineSpacing = 20.0;//cell offset  useless here...
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


static CGFloat const ActiveDistance = 50;
static CGFloat const ScaleFactor = 0.2;

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
            
//            attributes.alpha = 0.5;
            if (ABS(distance) < ActiveDistance) {
                CGFloat zoom = 1 + ScaleFactor * (1 - ABS(normalizedDistance)); //放大渐变
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
//                attributes.alpha = 1.0;
            }
            
        }
    }
    
    return array;

    
}

@end
