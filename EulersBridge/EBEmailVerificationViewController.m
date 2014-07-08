//
//  EBEmailVerificationViewController.m
//  Isegoria
//
//  Created by Alan Gao on 7/07/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBEmailVerificationViewController.h"
#import "EBNetworkService.h"

@interface EBEmailVerificationViewController () <EBSignupServiceDelegate>

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
    networkService.signupDelegate = self;
}

- (IBAction)doneAction:(UIBarButtonItem *)sender
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarView"];
    
    // Tabbar custom image
    UITabBarController *tabBarController = (UITabBarController *)window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    tabBarItem1.selectedImage = [UIImage imageNamed:@"Feed Higlighted"];
    tabBarItem2.selectedImage = [UIImage imageNamed:@"Election Higlighted"];
    tabBarItem3.selectedImage = [UIImage imageNamed:@"Poll Higlighted"];
    tabBarItem4.selectedImage = [UIImage imageNamed:@"Vote Higlighted"];
    tabBarItem5.selectedImage = [UIImage imageNamed:@"Profile Higlighted"];

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
