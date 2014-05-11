//
//  EBStackLayout.m
//  EulersBridge
//
//  Created by Alan Gao on 8/05/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBStackLayout.h"

@interface EBStackLayout ()

@property NSInteger totalItems;

@end

@implementation EBStackLayout

- (CGSize)collectionViewContentSize
{
    CGSize size = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height + 300);
    return size;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{

    NSInteger total = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:total];
    self.totalItems = total;
    
    int i = 0;
    for (i = 0; i < total; i += 1) {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat x = 20 + indexPath.item * 280/self.totalItems;
    attributes.frame = CGRectMake(x, CGRectGetMidY(screen), self.cellSize.width, self.cellSize.height);
    attributes.zIndex = indexPath.item;
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

@end
