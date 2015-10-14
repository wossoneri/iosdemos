//
//  HPickerView.m
//  HorizontalPickerView
//
//  Created by mythware on 10/12/15.
//  Copyright © 2015 magewell. All rights reserved.
//

#import "HPickerView.h"

#import <Availability.h>

#pragma mark - interfaces
@interface HPickerViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *name; //选中才显示
@property (nonatomic, strong) UIImageView *image;
@end

@interface HPickerViewLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat midX;
@property (nonatomic, assign) CGFloat maxAngle;
@end

@interface HPickerViewDelegateIntercepter : NSObject <UICollectionViewDelegate>
@property (nonatomic, weak) HPickerView *pickerView;
@property (nonatomic, weak) id<UIScrollViewDelegate> delegate;
@end


@interface HPickerView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger selectedItem;
@property (nonatomic, strong) HPickerViewDelegateIntercepter *intercepter;

//- (CGFloat)offsetForItem:(NSUInteger)item;
- (void)didEndScrolling;
//- (CGSize)sizeForString:(NSString *)string;
@end

@implementation HPickerView

- (void)initialize {
    
//    self.maskDisabled = self.maskDisabled;
    
    [self.collectionView removeFromSuperview];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[self collectionViewLayout]];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HPickerViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HPickerViewCell class])];
    
    [self addSubview:self.collectionView];
    
    self.intercepter = [HPickerViewDelegateIntercepter new];
    self.intercepter.pickerView = self;
    self.intercepter.delegate = self.delegate;
    
    self.collectionView.delegate = self.intercepter;
    
    
}

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

- (void)dealloc {
    self.collectionView.delegate = nil;
}

#pragma mark - override
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.collectionViewLayout = [self collectionViewLayout];
    if ([self.dataSource numberOfItemsInPickerView:self]) {
        [self scrollToItem:self.selectedItem animated:NO];
    }
    self.collectionView.layer.mask.frame = self.collectionView.bounds;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric); //尺寸再看下
}

- (CGPoint)contentOffset {
    return self.collectionView.contentOffset;
}

#pragma mark - private funcs

- (void)setDelegate:(id<HPickerViewDelegate> __nullable)delegate {
    if (![_delegate isEqual:delegate]) {
        _delegate = delegate;
        self.intercepter.delegate = delegate;
    }
}

//- (void)setFisheyeFactor:(CGFloat)fisheyeFactor
//{
//    _fisheyeFactor = fisheyeFactor;
//    
//    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = -MAX(MIN(self.fisheyeFactor, 1.0), 0.0);
//    self.collectionView.layer.sublayerTransform = transform;
//}

- (void)setMaskDisabled:(BOOL)maskDisabled
{
    _maskDisabled = maskDisabled;
    
    self.collectionView.layer.mask = maskDisabled ? nil : ({
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        maskLayer.frame = self.collectionView.bounds;
        maskLayer.colors = @[(id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor clearColor] CGColor],];
        maskLayer.locations = @[@0.0, @0.33, @0.66, @1.0];
        maskLayer.startPoint = CGPointMake(0.0, 0.0);
        maskLayer.endPoint = CGPointMake(1.0, 0.0);
        maskLayer;
    });
}


- (HPickerViewLayout *)collectionViewLayout {
    return [HPickerViewLayout new];
}
                           
- (void)reloadData
{
    [self invalidateIntrinsicContentSize];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
    if ([self.dataSource numberOfItemsInPickerView:self]) {
        [self selectItem:self.selectedItem animated:NO notifySelection:NO];
    }
}

- (void)scrollToItem:(NSUInteger)item animated:(BOOL)animated {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:animated];
}

- (void)selectItem:(NSUInteger)item animated:(BOOL)animated {
    [self selectItem:item animated:animated notifySelection:YES];
}

- (void)selectItem:(NSUInteger)item animated:(BOOL)animated notifySelection:(BOOL)notifySelection
{
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]
                                      animated:animated
                                scrollPosition:UICollectionViewScrollPositionNone];
    [self scrollToItem:item animated:animated];
    
    self.selectedItem = item;
    
    if (notifySelection &&
        [self.delegate respondsToSelector:@selector(pickerView:didSelectItem:)])
        [self.delegate pickerView:self didSelectItem:item];
}

- (void)didEndScrolling
{
    CGPoint center = [self convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:center];
    [self selectItem:indexPath.item animated:YES];
}



#pragma mark - override
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return ([self.dataSource numberOfItemsInPickerView:self] > 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfItemsInPickerView:self];
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HPickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HPickerViewCell class]) forIndexPath:indexPath];
    
//    if ([self.dataSource respondsToSelector:@selector(pickerView:titleForItem:)]) {
    NSString *name = [self.dataSource pickerView:self titleForItem:indexPath.item];
    cell.name.text = name;
    cell.image.image = [UIImage imageNamed:name];
//    }
    cell.selected = (indexPath.item == self.selectedItem);
    
    cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(self.interitemSpacing, collectionView.bounds.size.height);
    
    size.width += 100;

    return size;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 20.0;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0.0;
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger number = [self collectionView:collectionView numberOfItemsInSection:section];
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:number - 1 inSection:section];
    CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
    return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                            0, (collectionView.bounds.size.width - lastSize.width) / 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectItem:indexPath.item animated:YES];
}

#pragma mark -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    
    if (!scrollView.isTracking) [self didEndScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    if (!decelerate) [self didEndScrolling];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.delegate scrollViewDidScroll:scrollView];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    self.collectionView.layer.mask.frame = self.collectionView.bounds;
    [CATransaction commit];
}

@end










#pragma mark - HPickerViewCell functions


@implementation HPickerViewCell

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
    self.name = [[UILabel alloc] init];
    self.name.backgroundColor = [UIColor clearColor];
    self.name.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                   UIViewAutoresizingFlexibleLeftMargin |
                                   UIViewAutoresizingFlexibleBottomMargin |
                                   UIViewAutoresizingFlexibleRightMargin);
    
    
    self.image = [[UIImageView alloc] init];
    self.image.backgroundColor = [UIColor clearColor];
    self.image.contentMode = UIViewContentModeCenter;
    self.image.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.contentView addSubview:self.image];
    [self.contentView addSubview:self.name];
    
    [self.image setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.name setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIView *tmpView = self.contentView;
    UIImageView *imageView = self.image;
    UILabel *label = self.name;
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[tmpView]-(<=1)-[imageView]"]
                                                                             options:NSLayoutFormatAlignAllCenterX
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(tmpView, imageView)]];
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[tmpView]-(<=1)-[label]"]
                                                                             options:NSLayoutFormatAlignAllCenterX
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(tmpView, label)]];
    
    [tmpView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:tmpView
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0]];
    [tmpView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:tmpView
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:50]];

    
    
    [self.name setHidden:YES];
    
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
////动画效果
//    CATransition *transition = [CATransition animation];
//    [transition setType:kCATransition];
//    [transition setDuration:0.15];
//    [self.image.layer addAnimation:transition forKey:nil];

    
    self.name.font = [UIFont fontWithName:@"Helvetica Neue" size:20];

}


@end

#pragma mark - HPickerViewLayout

@implementation HPickerViewLayout

- (id)init {
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        self.minimumLineSpacing = 20.0;//cell offset  useless here...
    }
    return self;
}

// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
// Subclasses should always call super if they override.
- (void)prepareLayout
{
    [super prepareLayout];
    
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    self.midX = CGRectGetMidX(visibleRect);
    self.width = CGRectGetWidth(visibleRect) / 2;
    self.maxAngle = M_PI_2;
}

// return YES to cause the collection view to requery the layout for geometry information
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    //默认平的
    return attributes;
// 圆弧形
//CGFloat distance = CGRectGetMidX(attributes.frame) - self.midX;
//CGFloat currentAngle = self.maxAngle * distance / self.width / M_PI_2;
//CATransform3D transform = CATransform3DIdentity;
//transform = CATransform3DTranslate(transform, -distance, 0, -self.width);
//transform = CATransform3DRotate(transform, currentAngle, 0, 1, 0);
//transform = CATransform3DTranslate(transform, 0, 0, self.width);
//attributes.transform3D = transform;
//attributes.alpha = (ABS(currentAngle) < self.maxAngle);
//return attributes; break;

}


static CGFloat const ActiveDistance = 50;
static CGFloat const ScaleFactor = 0.2;

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;     //屏幕可见的整行距离
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    
    
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
            
        }
    }
    
    return array;
// 圆形
//    NSMutableArray *attributes = [NSMutableArray array];
//    if ([self.collectionView numberOfSections]) {
//        for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//        }
//    }
//    return attributes;

}

@end

#pragma mark - HPickerViewDelegateIntercepter


@implementation HPickerViewDelegateIntercepter

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.pickerView respondsToSelector:aSelector])
        return self.pickerView;
    
    if ([self.delegate respondsToSelector:aSelector])
        return self.delegate;
    
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.pickerView respondsToSelector:aSelector])
        return YES;
    
    if ([self.delegate respondsToSelector:aSelector])
        return YES;
    
    return [super respondsToSelector:aSelector];
}

@end



