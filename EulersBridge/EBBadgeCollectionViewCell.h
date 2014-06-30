//
//  EBBadgeCollectionViewCell.h
//  Isegoria
//
//  Created by Alan Gao on 30/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBBadgeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *badgeNameLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *badgeDescriptionLabel;

@end
