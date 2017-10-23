//
//  EBProfileSettingsViewController.h
//  Isegoria
//
//  Created by Alan Gao on 30/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBBlurImageView.h"

@interface EBProfileSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet EBBlurImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end
