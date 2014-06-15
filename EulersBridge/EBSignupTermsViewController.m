//
//  EBSignupTermsViewController.m
//  Isegoria
//
//  Created by Alan Gao on 5/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import "EBSignupTermsViewController.h"

@interface EBSignupTermsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;

@end

@implementation EBSignupTermsViewController

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
    // Font setup
    self.acceptButton.titleLabel.font = [UIFont fontWithName:@"MuseoSansRounded-700" size:self.acceptButton.titleLabel.font.pointSize];
    
    // Navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    

    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma button action
- (IBAction)accept:(UIButton *)sender
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
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    

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
