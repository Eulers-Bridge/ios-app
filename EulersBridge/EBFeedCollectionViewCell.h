//
//  EBFeedCollectionViewCell.h
//  EulersBridge
//
//  Created by Alan Gao on 24/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConstants.h"
#import "EBBlurImageView.h"

@interface EBFeedCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet EBBlurImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDictionary *data;
@property NSUInteger index;
@property EBFeedCellType feedCellType;
- (void)setup;


@end
