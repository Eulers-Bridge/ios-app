//
//  EBPhotosCollectionViewController.h
//  Isegoria
//
//  Created by Alan Gao on 31/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConstants.h"

@interface EBPhotosCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSDictionary *data;
@property EBFeedDetail feedDetailType;
@property NSUInteger index;

@end
