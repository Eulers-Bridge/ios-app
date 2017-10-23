//
//  EBBadgeCollectionViewCell.h
//  Isegoria
//
//  Created by Alan Gao on 30/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBNetworkService.h"

@interface EBBadgeCollectionViewCell : UICollectionViewCell <EBContentServiceDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *badgeNameLabel;
@property (weak, nonatomic) IBOutlet EBLabelHeavy *badgeDescriptionLabel;
@property (strong, nonatomic) NSDictionary *info;
@property (strong, nonatomic) NSString *iconUrl;
@property BOOL completed;

@property (strong, nonatomic) EBNetworkService *service;

- (void)setup;

@end
