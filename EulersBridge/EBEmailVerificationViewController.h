//
//  EBEmailVerificationViewController.h
//  Isegoria
//
//  Created by Alan Gao on 7/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBUser.h"

@interface EBEmailVerificationViewController : UIViewController

@property (strong, nonatomic) EBUser *user;
@property BOOL userVerified;

@end
