//
//  EBSignupTermsViewController.h
//  Isegoria
//
//  Created by Alan Gao on 5/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EBSignupTermsDelegate <NSObject>

@required
- (void)signupTermsAgreed:(BOOL)agreed;

@end

@interface EBSignupTermsViewController : UIViewController

@property (weak, nonatomic) id<EBSignupTermsDelegate> termsDelegate;

@end
