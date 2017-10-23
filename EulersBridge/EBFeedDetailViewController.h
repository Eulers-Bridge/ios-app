//
//  EBNewsDetailViewController.h
//  EulersBridge
//
//  Created by Alan Gao on 26/04/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConstants.h"

@interface EBFeedDetailViewController : UIViewController

@property EBFeedDetail feedDetailType;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDictionary *data;
@property int likes;

@end
