//
//  EBContentViewController.h
//  Isegoria
//
//  Created by Alan Gao on 27/07/2015.
//  Copyright (c) 2015 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyConstants.h"
#import "EBBlurImageView.h"

@interface EBContentViewController : UIViewController

@property EBContentViewType contentViewType;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDictionary *data;

@end
