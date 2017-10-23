//
//  EBEmailVerificationViewController.m
//  Isegoria
//
//  Created by Alan Gao on 7/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBEmailVerificationViewController.h"
#import "EBNetworkService.h"
#import "EBWelcomeViewController.h"

@interface EBEmailVerificationViewController () <EBUserServiceDelegate>

@end

@implementation EBEmailVerificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;

    if (self.user.emailVerified) {
        // open the app.
    }
}

#pragma mark button actions
- (IBAction)resendEmail:(EBButton *)sender
{
    EBNetworkService *networkService = [[EBNetworkService alloc] init];
    networkService.userDelegate = self;
}

- (IBAction)doneAction:(UIBarButtonItem *)sender
{

}
- (IBAction)verifiedAction:(EBButton *)sender
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *welcomeView = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    window.rootViewController = welcomeView;
}

#pragma mark signup delegate
- (void)resendEmailFinishedWithSuccess:(BOOL)success withUser:(EBUser *)user failureReason:(NSString *)reason
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
