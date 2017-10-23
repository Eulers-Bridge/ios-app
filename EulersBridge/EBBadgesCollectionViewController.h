//
//  EBBadgesCollectionViewController.h
//  Isegoria
//
//  Created by Alan Gao on 26/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConstants.h"
@interface EBBadgesCollectionViewController : UICollectionViewController

@property EBBadgesViewType badgesViewType;

@property (strong, nonatomic) NSArray *completedBadges;
@property (strong, nonatomic) NSArray *remainingBadges;

@end
